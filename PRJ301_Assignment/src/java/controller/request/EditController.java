package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
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

        int myEid = user.getEmployee().getId();
        // CHO PHÉP: chính chủ & (Processing hoặc Rejected)
        if (r == null || r.getCreated_by() == null || r.getCreated_by().getId() != myEid
                || (r.getStatus() != 0 && r.getStatus() != 2)) {
            resp.sendError(403);
            return;
        }

        req.setAttribute("r", r);
        req.setAttribute("isRejected", r.getStatus() == 2);
        req.setAttribute("todayStr", LocalDate.now().toString());
        req.setAttribute("pageTitle", (r.getStatus() == 2 ? "Sửa & Gửi lại đơn #" : "Sửa đơn #") + rid);
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

        // 1) Đọc bản hiện tại (DB #1)
        RequestForLeaveDBContext dbRead = new RequestForLeaveDBContext();
        RequestForLeave current = dbRead.get(rid);

        int myEid = user.getEmployee().getId();
        if (current == null || current.getCreated_by() == null
                || current.getCreated_by().getId() != myEid
                || (current.getStatus() != 0 && current.getStatus() != 2)) {
            resp.sendError(403);
            return;
        }

        String reason = trimParam(req, "reason");
        String fromStr = trimParam(req, "from");
        String toStr = trimParam(req, "to");

        // validate…
        // (giữ nguyên logic validate của bạn)
        // nếu lỗi -> setAttr + forward layout như hiện tại và return
        boolean success;
        if (current.getStatus() == 2) {
            // 2) Cập nhật/resubmit (DB #2)
            RequestForLeaveDBContext dbUpdate = new RequestForLeaveDBContext();
            success = dbUpdate.resubmitByOwner(
                    rid, myEid,
                    java.sql.Date.valueOf(java.time.LocalDate.parse(fromStr)),
                    java.sql.Date.valueOf(java.time.LocalDate.parse(toStr)),
                    reason
            );
            if (success) {
                // 3) Ghi history (DB #3)
                RequestForLeaveDBContext dbHist = new RequestForLeaveDBContext();
                dbHist.insertHistory(rid, myEid, "resubmit", "owner updated & resubmitted");
            }
        } else {
            // status == 0 (Processing) -> chỉ update nội dung
            RequestForLeaveDBContext dbUpdate = new RequestForLeaveDBContext();
            success = dbUpdate.updateDraftByOwner(
                    rid, myEid,
                    java.sql.Date.valueOf(java.time.LocalDate.parse(fromStr)),
                    java.sql.Date.valueOf(java.time.LocalDate.parse(toStr)),
                    reason
            );
            if (success) {
                RequestForLeaveDBContext dbHist = new RequestForLeaveDBContext();
                dbHist.insertHistory(rid, myEid, "edit", "owner updated while processing");
            }
        }

        resp.sendRedirect(req.getContextPath() + "/request/list");
    }

    private static String trimParam(HttpServletRequest req, String name) {
        String v = req.getParameter(name);
        if (v == null) {
            return null;
        }
        v = v.trim();
        return v.isEmpty() ? null : v;
    }

}
