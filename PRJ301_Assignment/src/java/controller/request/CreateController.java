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
        // show form
        req.setAttribute("pageTitle", "Tạo đơn nghỉ phép");
        req.setAttribute("content", "/view/request/create_content.jsp");
        req.getRequestDispatcher("/view/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        // handle submit
        String reason = req.getParameter("reason");
        String fromStr = req.getParameter("from");
        String toStr = req.getParameter("to");

        // NOTE: employee id (không phải user id)
        int createdByEid = user.getEmployee().getId();

        RequestForLeave r = new RequestForLeave();
        r.setReason(reason);
        r.setFrom(Date.valueOf(fromStr));
        r.setTo(Date.valueOf(toStr));
        r.setStatus(0); // processing
        // set created_by id thôi (DAL lấy từ id)
        r.getCreated_by(); // may be null
        // dùng model nhẹ: set employee id vào created_by
        model.Employee e = new model.Employee();
        e.setId(createdByEid);
        r.setCreated_by(e);

        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        db.insert(r);

        // quay về list
        resp.sendRedirect(req.getContextPath() + "/request/list");
    }
}
