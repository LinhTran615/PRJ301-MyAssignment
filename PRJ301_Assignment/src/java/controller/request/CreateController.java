package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import model.Employee;
import model.RequestForLeave;
import model.iam.User;

@WebServlet(urlPatterns = "/request/create")
public class CreateController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        LocalDate today = LocalDate.now();
        // giá trị mặc định
        req.setAttribute("todayStr", today.toString());
        req.setAttribute("fromVal", "");
        req.setAttribute("toVal", "");
        req.setAttribute("reasonVal", "");
        req.setAttribute("pageTitle", "Tạo đơn nghỉ phép");
        req.setAttribute("content", "/view/request/create_content.jsp");
        req.getRequestDispatcher("/view/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String reason = trimOrNull(req.getParameter("reason"));
        String fromStr = trimOrNull(req.getParameter("from"));
        String toStr = trimOrNull(req.getParameter("to"));

        LocalDate today = LocalDate.now();
        LocalDate from = null, to = null;
        boolean ok = true;

        // giữ lại giá trị để render lại khi lỗi
        req.setAttribute("todayStr", today.toString());
        req.setAttribute("fromVal", fromStr != null ? fromStr : "");
        req.setAttribute("toVal", toStr != null ? toStr : "");
        req.setAttribute("reasonVal", reason != null ? reason : "");

        // parse
        try {
            from = LocalDate.parse(fromStr);
        } catch (Exception e) {
            ok = false;
            req.setAttribute("err_from", "Vui lòng chọn ngày bắt đầu hợp lệ.");
        }
        try {
            to = LocalDate.parse(toStr);
        } catch (Exception e) {
            ok = false;
            req.setAttribute("err_to", "Vui lòng chọn ngày kết thúc hợp lệ.");
        }

        // validate nghiệp vụ
        if (ok) {
            if (from.isBefore(today)) {
                ok = false;
                req.setAttribute("err_from", "Không được chọn ngày trong quá khứ.");
            }
            if (to.isBefore(from)) {
                ok = false;
                req.setAttribute("err_to", "Ngày kết thúc phải ≥ ngày bắt đầu.");
            }
        }

        if (reason == null || reason.isEmpty()) {
            ok = false;
            req.setAttribute("err_reason", "Vui lòng nhập lý do.");
        } else if (reason.length() > 500) {
            ok = false;
            req.setAttribute("err_reason", "Lý do quá dài (tối đa 500 ký tự).");
        }

        if (!ok) {
            req.setAttribute("pageTitle", "Tạo đơn nghỉ phép");
            req.setAttribute("content", "/view/request/create_content.jsp");
            req.getRequestDispatcher("/view/layout/layout.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra trùng khoảng ngày
        RequestForLeaveDBContext dbCheck = new RequestForLeaveDBContext();
        var conflicts = dbCheck.findOverlaps(
                user.getEmployee().getId(),
                Date.valueOf(from),
                Date.valueOf(to)
        );
        if (!conflicts.isEmpty()) {
            req.setAttribute("conflicts", conflicts);
            req.setAttribute("pageTitle", "Tạo đơn nghỉ phép");
            req.setAttribute("content", "/view/request/create_content.jsp");
            req.getRequestDispatcher("/view/layout/layout.jsp").forward(req, resp);
            return;
        }

// Tạo mới
        RequestForLeave r = new RequestForLeave();
        Employee e = new Employee();
        e.setId(user.getEmployee().getId());
        r.setCreated_by(e);
        r.setFrom(Date.valueOf(from));
        r.setTo(Date.valueOf(to));
        r.setReason(reason);
        r.setStatus(0);

        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        int newRid = db.insertReturningId(r);
        if (newRid > 0) {
            new RequestForLeaveDBContext().insertHistory(
                    newRid,
                    user.getEmployee().getId(),
                    "create",
                    "create request"
            );
        }
        resp.sendRedirect(req.getContextPath() + "/request/list");

    }

    private static String trimOrNull(String s) {
        if (s == null) {
            return null;
        }
        s = s.trim();
        return s.isEmpty() ? null : s;
    }
}
