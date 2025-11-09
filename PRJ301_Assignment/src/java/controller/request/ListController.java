package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import model.RequestForLeave;
import model.iam.User;

@WebServlet(urlPatterns = "/request/list")
public class ListController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        // Lấy filter từ query
        String q = req.getParameter("q");                 // tên người tạo
        String fromStr = req.getParameter("from");        // yyyy-MM-dd
        String toStr = req.getParameter("to");          // yyyy-MM-dd
        String statusStr = req.getParameter("status");    // "", "0","1","2"

        java.sql.Date from = null, to = null;
        try {
            if (fromStr != null && !fromStr.isBlank()) {
                from = java.sql.Date.valueOf(fromStr);
            }
        } catch (Exception ignored) {
        }
        try {
            if (toStr != null && !toStr.isBlank()) {
                to = java.sql.Date.valueOf(toStr);
            }
        } catch (Exception ignored) {
        }

        Integer status = null;
        if (statusStr != null && !statusStr.isBlank()) {
            try {
                status = Integer.parseInt(statusStr);
            } catch (Exception ignored) {
            }
        }

        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        // ManagerEid = employee id của user hiện tại (đang dùng mô hình “cấp dưới”)
        int managerEid = user.getEmployee().getId();
        ArrayList<RequestForLeave> list = db.listForManagerWithFilters(managerEid, q, from, to, status);

        // đẩy ngược filter ra form
        req.setAttribute("q", q == null ? "" : q);
        req.setAttribute("from", fromStr == null ? "" : fromStr);
        req.setAttribute("to", toStr == null ? "" : toStr);
        req.setAttribute("status", statusStr == null ? "" : statusStr);

        req.setAttribute("rfls", list);
        req.setAttribute("pageTitle", "Request List");
        req.setAttribute("content", "/view/request/list_content.jsp");
        req.getRequestDispatcher("/view/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        processGet(req, resp, user);
    }
}
