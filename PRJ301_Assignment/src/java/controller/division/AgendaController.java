package controller.division;

import controller.iam.BaseRequiredAuthorizationController;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import model.RequestForLeave;
import model.iam.User;

@WebServlet(urlPatterns = "/division/agenda")
public class AgendaController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        ArrayList<RequestForLeave> list = db.getByEmployeeAndSubodiaries(user.getId());
        req.setAttribute("requests", list);
        req.setAttribute("pageTitle", "Agenda");
        req.setAttribute("content", "/view/division/agenda_content.jsp");
        req.getRequestDispatcher("/view/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        processGet(req, resp, user);
    }
}
