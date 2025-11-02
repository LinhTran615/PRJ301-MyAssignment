package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import model.RequestForLeave;
import model.iam.User;

@WebServlet(urlPatterns = "/request/create")
public class CreateController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        req.getRequestDispatcher("../view/request/create.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        String from_raw = req.getParameter("from");
        String to_raw = req.getParameter("to");
        String reason = req.getParameter("reason");

        try {
            java.sql.Date from = java.sql.Date.valueOf(from_raw);
            java.sql.Date to = java.sql.Date.valueOf(to_raw);

            RequestForLeave r = new RequestForLeave();
            r.setFrom(from);
            r.setTo(to);
            r.setReason(reason);
            r.setStatus(0); // processing
            r.setCreated_by(user.getEmployee());

            RequestForLeaveDBContext db = new RequestForLeaveDBContext();
            db.insert(r);

            // ✅ Gửi thông điệp xác nhận để JSP hiển thị popup
            req.setAttribute("message", "Đã gửi đơn xin nghỉ phép thành công!");
            req.getRequestDispatcher("../view/request/create_success.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("message", "Lỗi khi gửi đơn: " + e.getMessage());
            req.getRequestDispatcher("../view/auth/message.jsp").forward(req, resp);
        }
    }
}
