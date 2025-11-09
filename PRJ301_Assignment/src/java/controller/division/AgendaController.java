package controller.division;

import controller.iam.BaseRequiredAuthorizationController;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import model.RequestForLeave;
import model.iam.User;

@WebServlet(urlPatterns = "/division/agenda")
public class AgendaController extends BaseRequiredAuthorizationController {

    private static final SimpleDateFormat ISO = new SimpleDateFormat("yyyy-MM-dd");

    private Date parseDate(String v) {
        if (v == null || v.isBlank()) {
            return null;
        }
        try {
            return Date.valueOf(v);
        } catch (Exception e) {
            try {
                return new Date(ISO.parse(v).getTime());
            } catch (ParseException ex) {
                return null;
            }
        }
    }

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        // Lấy filter
        String name = req.getParameter("name");
        Date from = parseDate(req.getParameter("from"));
        Date to = parseDate(req.getParameter("to"));
        String format = req.getParameter("format");

        int managerEmpId = user.getEmployee().getId(); // FIX: dùng employee id

        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        ArrayList<RequestForLeave> list = db.getAgendaForManager(managerEmpId, from, to, name);

        if ("json".equalsIgnoreCase(format)) {
            resp.setContentType("application/json;charset=UTF-8");
            StringBuilder sb = new StringBuilder();
            sb.append('[');
            for (int i = 0; i < list.size(); i++) {
                RequestForLeave r = list.get(i);
                String title = (r.getCreated_by() != null ? r.getCreated_by().getName() : ("#" + r.getId()));
                title += " (" + (r.getStatus() == 1 ? "Approved" : r.getStatus() == 2 ? "Rejected" : "Processing") + ")";

                java.util.Date endPlus = new java.util.Date(r.getTo().getTime() + 24L * 3600L * 1000L);
                String start = ISO.format(r.getFrom());
                String end = ISO.format(endPlus);
                String color = (r.getStatus() == 1) ? "#10b981" : (r.getStatus() == 2) ? "#ef4444" : "#f59e0b";
                String url = req.getContextPath() + "/request/review?rid=" + r.getId();

                sb.append('{')
                        .append("\"id\":").append(r.getId()).append(',')
                        .append("\"title\":\"").append(jsonEscape(title)).append("\",")
                        .append("\"start\":\"").append(start).append("\",")
                        .append("\"end\":\"").append(end).append("\",")
                        .append("\"url\":\"").append(jsonEscape(url)).append("\",")
                        .append("\"color\":\"").append(color).append("\"")
                        .append('}');
                if (i < list.size() - 1) {
                    sb.append(',');
                }
            }
            sb.append(']');

            try (PrintWriter out = resp.getWriter()) {
                out.print(sb.toString());
            }
            return;
        }

        // render JSP
        req.setAttribute("requests", list);
        req.setAttribute("pageTitle", "Agenda phòng ban");
        req.setAttribute("content", "/view/division/agenda_content.jsp");
        req.getRequestDispatcher("/view/layout/layout.jsp").forward(req, resp);
    }

    private static String jsonEscape(String s) {
        if (s == null) {
            return "";
        }
        StringBuilder r = new StringBuilder(s.length() + 16);
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '"':
                    r.append("\\\"");
                    break;
                case '\\':
                    r.append("\\\\");
                    break;
                case '\b':
                    r.append("\\b");
                    break;
                case '\f':
                    r.append("\\f");
                    break;
                case '\n':
                    r.append("\\n");
                    break;
                case '\r':
                    r.append("\\r");
                    break;
                case '\t':
                    r.append("\\t");
                    break;
                default:
                    if (c < 0x20) {
                        r.append(String.format("\\u%04x", (int) c));
                    } else {
                        r.append(c);
                    }
            }
        }
        return r.toString();
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        processGet(req, resp, user);
    }
}
