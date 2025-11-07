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

@WebServlet(urlPatterns = "/request/review")
public class ReviewController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        String ridRaw = req.getParameter("rid");
        if (ridRaw == null) {
            resp.sendRedirect(req.getContextPath() + "/request/list");
            return;
        }
        int rid = Integer.parseInt(ridRaw);
        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        RequestForLeave r = db.get(rid);
        if (r == null) {
            resp.sendRedirect(req.getContextPath() + "/request/list");
            return;
        }
        req.setAttribute("r", r);
        req.setAttribute("pageTitle", "Duyệt đơn #" + rid);
        req.setAttribute("content", "/view/request/review_content.jsp");
        req.getRequestDispatcher("/view/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        String ridRaw = req.getParameter("rid");
        String action = req.getParameter("action"); // approve | reject
        if (ridRaw == null || action == null) {
            resp.sendRedirect(req.getContextPath() + "/request/list");
            return;
        }
        int rid = Integer.parseInt(ridRaw);
        int processedByEid = user.getEmployee().getId();
        int newStatus = "approve".equalsIgnoreCase(action) ? 1 : 2;

        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        db.updateStatus(rid, newStatus, processedByEid);

        resp.sendRedirect(req.getContextPath() + "/request/list");
    }
}
