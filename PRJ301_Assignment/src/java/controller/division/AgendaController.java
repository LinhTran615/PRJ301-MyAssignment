package controller.division;

import controller.iam.BaseRequiredAuthorizationController;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Employee;
import model.RequestForLeave;
import model.iam.Role;
import model.iam.User;

@WebServlet(urlPatterns = "/division/agenda")
public class AgendaController extends BaseRequiredAuthorizationController {

    private boolean isAllowedHead(User user) {
        if (user == null || user.getRoles() == null) {
            return false;
        }
        for (Role r : user.getRoles()) {
            if (r == null || r.getName() == null) {
                continue;
            }
            String nm = r.getName().trim().toLowerCase(); // "it head", "qa head", "sale head"
            if (nm.equals("it head") || nm.equals("qa head") || nm.equals("sale head")) {
                return true;
            }
        }
        return false;
    }

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        // 0) Quyền
        if (!isAllowedHead(user)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Chỉ IT Head / QA Head / SALE Head được xem Agenda.");
            return;
        }

        // 1) Filter: month (yyyy-MM) + name
        String monthStr = req.getParameter("month");   // ví dụ "2025-10"
        String nameLike = req.getParameter("name");
        YearMonth ym;
        try {
            ym = (monthStr == null || monthStr.isBlank())
                    ? YearMonth.now()
                    : YearMonth.parse(monthStr);
        } catch (Exception ignore) {
            ym = YearMonth.now();
        }

        LocalDate d1 = ym.atDay(1);
        LocalDate d2 = ym.atEndOfMonth();
        Date from = Date.valueOf(d1);
        Date to = Date.valueOf(d2);

        // 2) Danh sách ngày trong tháng
        List<Date> days = new ArrayList<>();
        for (LocalDate d = d1; !d.isAfter(d2); d = d.plusDays(1)) {
            days.add(Date.valueOf(d));
        }

        int managerEid = user.getEmployee().getId();

        // 3) Lấy toàn bộ nhân viên dưới quyền (kể cả không có đơn)
        RequestForLeaveDBContext empDb = new RequestForLeaveDBContext();
        List<Employee> emps = empDb.listEmployeesUnder(managerEid, nameLike);

        // 4) Lấy các đơn trong tháng (chỉ subordinates)
        RequestForLeaveDBContext rdb = new RequestForLeaveDBContext();
        List<RequestForLeave> rfls = rdb.getAgendaForManager(managerEid, from, to, nameLike);

        // 5) Dàn bảng: mỗi nhân viên 1 row -> cells default 0 (Working)
        // Dùng Map<String,Object> để JSP đọc được qua EL
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<Integer, Integer> indexByEmpId = new LinkedHashMap<>();

        for (int i = 0; i < emps.size(); i++) {
            Employee e = emps.get(i);
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("emp", e);
            List<Integer> cells = new ArrayList<>();
            for (int k = 0; k < days.size(); k++) {
                cells.add(0); // 0 = Working
            }
            row.put("cells", cells);
            rows.add(row);
            indexByEmpId.put(e.getId(), i);
        }

        // 6) Tô màu theo đơn: 1 = OFF (Approved). (Nếu muốn Processing = 2, mở comment)
        for (RequestForLeave r : rfls) {
            Integer idx = indexByEmpId.get(r.getCreated_by().getId());
            if (idx == null) {
                continue; // bảo vệ
            }
            @SuppressWarnings("unchecked")
            List<Integer> cells = (List<Integer>) rows.get(idx).get("cells");
            for (int i = 0; i < days.size(); i++) {
                Date d = days.get(i);
                if (!d.before(r.getFrom()) && !d.after(r.getTo())) {
                    if (r.getStatus() == 1) {
                        cells.set(i, 1); // OFF
                    }
                    // else if (r.getStatus() == 0) { cells.set(i, 2); } // PROCESSING
                }
            }
        }

        // 7) Đẩy ra view
        req.setAttribute("month", ym.toString());
        req.setAttribute("name", nameLike == null ? "" : nameLike);
        req.setAttribute("days", days);
        req.setAttribute("rows", rows);
        req.setAttribute("pageTitle", "Agenda phòng ban");
        req.setAttribute("content", "/view/division/agenda_content.jsp");
        req.getRequestDispatcher("/view/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        processGet(req, resp, user);
    }
}
