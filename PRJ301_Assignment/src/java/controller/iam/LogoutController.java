package controller.iam;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = "/logout")
public class LogoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Xoá toàn bộ session (đăng xuất thật)
        req.getSession().invalidate();

        // Gửi thông báo đăng xuất thành công
        req.setAttribute("message", "Bạn đã đăng xuất thành công!");

        // Quay lại trang login (hiển thị message.jsp)
        req.getRequestDispatcher("view/auth/message.jsp").forward(req, resp);
    }
}
