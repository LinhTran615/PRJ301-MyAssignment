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

        String rid_raw = req.getParameter("rid");
        if (rid_raw == null) {
            req.setAttribute("message", "Không xác định được đơn cần duyệt!");
            req.getRequestDispatcher("../view/auth/message.jsp").forward(req, resp);
            return;
        }

        int rid = Integer.parseInt(rid_raw);
        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        RequestForLeave r = db.get(rid);

        if (r == null) {
            req.setAttribute("message", "Đơn xin nghỉ phép không tồn tại!");
            req.getRequestDispatcher("../view/auth/message.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("requestLeave", r);
        req.getRequestDispatcher("../view/request/review.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String rid_raw = req.getParameter("rid");
        String action = req.getParameter("action");

        if (rid_raw == null || action == null) {
            req.setAttribute("message", "Thiếu dữ liệu để xử lý duyệt đơn!");
            req.getRequestDispatcher("../view/auth/message.jsp").forward(req, resp);
            return;
        }

        int rid = Integer.parseInt(rid_raw);
        int status = action.equals("approve") ? 1 : 2; // 1=approved, 2=rejected

        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        db.updateStatus(rid, status, user.getEmployee().getId());

        // Sau khi duyệt, quay lại danh sách
        resp.sendRedirect("list");
    }
}
