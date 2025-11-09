package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.RequestForLeave;
import model.iam.User;

@WebServlet(urlPatterns = "/request/edit")
public class EditController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String ridRaw = req.getParameter("rid");
        if (ridRaw == null) {
            resp.sendRedirect(req.getContextPath() + "/request/list");
            return;
        }

        int rid;
        try {
            rid = Integer.parseInt(ridRaw);
        } catch (NumberFormatException e) {
            resp.sendError(400, "Invalid rid");
            return;
        }

        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        RequestForLeave r = db.get(rid);

        // chỉ chính chủ + trạng thái Rejected mới được sửa
        int myEid = user.getEmployee().getId();
        if (r == null || r.getCreated_by() == null || r.getCreated_by().getId() != myEid || r.getStatus() != 2) {
            resp.sendError(403); // access denied
            return;
        }

        req.setAttribute("r", r);
        req.setAttribute("pageTitle", "Sửa & Gửi lại đơn #" + rid);
        req.setAttribute("content", "/view/request/edit_content.jsp");
        req.getRequestDispatcher("/view/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String ridRaw = req.getParameter("rid");
        if (ridRaw == null) {
            resp.sendRedirect(req.getContextPath() + "/request/list");
            return;
        }

        int rid;
        try {
            rid = Integer.parseInt(ridRaw);
        } catch (NumberFormatException e) {
            resp.sendError(400, "Invalid rid");
            return;
        }

        String reason = req.getParameter("reason");
        if (reason != null) {
            reason = reason.trim();
        }

        if (reason == null || reason.isEmpty() || reason.length() > 500) {
            RequestForLeaveDBContext db = new RequestForLeaveDBContext();
            RequestForLeave r = db.get(rid);
            req.setAttribute("r", r);
            req.setAttribute("error", "Lý do không hợp lệ (không rỗng, tối đa 500 ký tự).");
            req.setAttribute("pageTitle", "Sửa & Gửi lại đơn #" + rid);
            req.setAttribute("content", "/view/request/edit_content.jsp");
            req.getRequestDispatcher("/view/layout/layout.jsp").forward(req, resp);
            return;
        }

        RequestForLeaveDBContext db = new RequestForLeaveDBContext();

        // Chỉ cho chính chủ resubmit & đơn phải đang Rejected
        boolean ok = db.resubmitByOwner(rid, user.getEmployee().getId(), reason);
        if (ok) {
            db.insertHistory(rid, user.getEmployee().getId(), "resubmit", "update reason and resubmit");
        }

        resp.sendRedirect(req.getContextPath() + "/request/list");
    }
}
