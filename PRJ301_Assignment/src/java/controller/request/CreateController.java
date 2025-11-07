package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import model.RequestForLeave;
import model.iam.User;

@WebServlet(urlPatterns = "/request/create")
public class CreateController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        req.setAttribute("pageTitle", "Create Request");
        req.setAttribute("content", "/view/request/create_content.jsp");
        req.getRequestDispatcher("/view/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        String reason = req.getParameter("reason");
        Date from = Date.valueOf(req.getParameter("from"));
        Date to = Date.valueOf(req.getParameter("to"));

        RequestForLeave reqLeave = new RequestForLeave();
        reqLeave.setCreated_by(user.getEmployee());
        reqLeave.setReason(reason);
        reqLeave.setFrom(from);
        reqLeave.setTo(to);

        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        db.insert(reqLeave);

        resp.sendRedirect(req.getContextPath() + "/request/list");
    }
}
