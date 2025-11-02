package controller.division;

import controller.iam.BaseRequiredAuthorizationController;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.*;
import model.Employee;
import model.RequestForLeave;
import model.iam.User;

@WebServlet(urlPatterns = "/division/agenda")
public class ViewAgendaController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String fromStr = req.getParameter("from");
        String toStr = req.getParameter("to");

        if (fromStr != null && toStr != null) {
            LocalDate from = LocalDate.parse(fromStr);
            LocalDate to = LocalDate.parse(toStr);

            RequestForLeaveDBContext db = new RequestForLeaveDBContext();

            // ✅ Gọi đúng hàm gốc mà bạn đã có
            ArrayList<RequestForLeave> allLeaves = db.getByEmployeeAndSubodiaries(user.getId());

            // ✅ Lọc trong Java (chỉ lấy status = 1, tức là đã duyệt)
            ArrayList<RequestForLeave> leaves = new ArrayList<>();
            for (RequestForLeave r : allLeaves) {
                if (r.getStatus() == 1) {
                    leaves.add(r);
                }
            }

            // ✅ Nếu chưa có đơn nào duyệt, ta vẫn hiển thị trống hợp lý
            if (leaves.isEmpty()) {
                req.setAttribute("message", "No approved leaves found in the selected range.");
            }

            // Tập hợp nhân viên duy nhất
            Map<Integer, Employee> employees = new LinkedHashMap<>();
            for (RequestForLeave r : leaves) {
                employees.putIfAbsent(r.getCreated_by().getId(), r.getCreated_by());
            }

            // Danh sách ngày trong khoảng
            List<LocalDate> dates = new ArrayList<>();
            LocalDate temp = from;
            while (!temp.isAfter(to)) {
                dates.add(temp);
                temp = temp.plusDays(1);
            }

            // Lập lịch từng nhân viên
            List<Map<String, Object>> agenda = new ArrayList<>();
            for (Employee e : employees.values()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("employee", e);

                List<String> statuses = new ArrayList<>();
                int totalOff = 0;

                for (LocalDate d : dates) {
                    boolean isOff = false;
                    for (RequestForLeave r : leaves) {
                        if (r.getCreated_by().getId() == e.getId()) {
                            LocalDate f = r.getFrom().toLocalDate();
                            LocalDate t = r.getTo().toLocalDate();
                            if ((d.isEqual(f) || d.isAfter(f)) && (d.isEqual(t) || d.isBefore(t))) {
                                isOff = true;
                                break;
                            }
                        }
                    }
                    if (isOff) {
                        totalOff++;
                    }
                    statuses.add(isOff ? "OFF" : "ON");
                }

                row.put("statuses", statuses);
                row.put("totalOff", totalOff);
                agenda.add(row);
            }

            req.setAttribute("dates", dates);
            req.setAttribute("agenda", agenda);
        }

        req.getRequestDispatcher("/view/division/agenda.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        processGet(req, resp, user);
    }
}
