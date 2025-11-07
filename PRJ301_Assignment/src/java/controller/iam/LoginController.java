package controller.iam;

import dal.UserDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.iam.User;

@WebServlet(urlPatterns = "/login")
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("view/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        UserDBContext db = new UserDBContext();
        User user = db.get(username, password);

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("auth", user);
            resp.sendRedirect(req.getContextPath() + "/home");
        } else {
            req.setAttribute("error", "Invalid username or password!");
            req.getRequestDispatcher("view/auth/login.jsp").forward(req, resp);
        }
    }
}
