package controller.home;

import controller.iam.BaseRequiredAuthenticationController;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.iam.User;

@WebServlet(urlPatterns = "/home")
public class HomeController extends BaseRequiredAuthenticationController {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        req.setAttribute("user", user);
        req.setAttribute("pageTitle", "Home");
        req.setAttribute("content", "/view/home/home_content.jsp");
        req.getRequestDispatcher("/view/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        doGet(req, resp, user);
    }
}
