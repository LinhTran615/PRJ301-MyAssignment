package controller.iam;

import dal.RoleDBContext;
import dal.UserDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.iam.Role;
import model.iam.User;

@WebServlet(urlPatterns = "/login")
public class LoginController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        UserDBContext db = new UserDBContext();
        User user = db.get(username, password);

        if (user != null) {
            // Lấy role & feature
            RoleDBContext dbRole = new RoleDBContext();
            ArrayList<Role> roles = dbRole.getByUserId(user.getId());
            user.setRoles(roles);

            // Lưu vào session
            req.getSession().setAttribute("auth", user);

            // Điều hướng về trang chủ
            resp.sendRedirect("home");
        } else {
            req.setAttribute("message", "Sai tên đăng nhập hoặc mật khẩu!");
            req.getRequestDispatcher("view/auth/message.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("view/auth/login.jsp").forward(req, resp);
    }
}
