package controller.division;

import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import model.Employee;
import model.RequestForLeave;
import model.iam.User;

@WebServlet(urlPatterns = "/division/agenda")
public class ViewAgendaController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ✅ Lấy thông tin user đăng nhập
        HttpSession session = req.getSession(false);
        Employee emp = null;

        if (session != null) {
            Object o = session.getAttribute("account");
            if (o == null) {
                o = session.getAttribute("auth");
            }

            if (o instanceof Employee) {
                emp = (Employee) o;
            } else if (o instanceof User) {
                emp = ((User) o).getEmployee();
            }
        }

        // ❌ Nếu chưa đăng nhập → quay lại login
        if (emp == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // ✅ Lấy khoảng thời gian từ request
        String fromStr = req.getParameter("from");
        String toStr = req.getParameter("to");

        Date fromDate;
        Date toDate;
        if (fromStr == null || toStr == null || fromStr.isEmpty() || toStr.isEmpty()) {
            fromDate = Date.valueOf("2025-10-20");
            toDate = Date.valueOf("2025-10-26");
        } else {
            fromDate = Date.valueOf(fromStr);
            toDate = Date.valueOf(toStr);
        }

        // ✅ Lấy danh sách đơn nghỉ phép
        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        ArrayList<RequestForLeave> rfls = db.getByEmployeeAndSubodiaries(emp.getId());

        // ✅ Lọc theo khoảng thời gian
        rfls.removeIf(r -> r.getTo().before(fromDate) || r.getFrom().after(toDate));

        // ✅ Truyền sang JSP
        req.setAttribute("rfls", rfls);
        req.setAttribute("fromDate", fromDate);
        req.setAttribute("toDate", toDate);
        req.setAttribute("employee", emp);

        // ✅ Forward đúng đường dẫn
        req.getRequestDispatcher("/view/division/agenda.jsp").forward(req, resp);
    }
}
