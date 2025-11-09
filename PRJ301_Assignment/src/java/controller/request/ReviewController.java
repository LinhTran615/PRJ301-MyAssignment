package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;
import model.RequestForLeave;
import model.iam.Role;
import model.iam.User;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = "/request/review")
public class ReviewController extends BaseRequiredAuthorizationController {

    // Head = role name "Head" (không phân biệt hoa/thường)
    private boolean isHead(User user) {
        if (user == null || user.getRoles() == null) {
            return false;
        }
        for (Role role : user.getRoles()) {
            if (role == null) {
                continue;
            }
            String name = role.getName();
            if (name == null) {
                continue;
            }

            String nm = name.trim().toLowerCase(); // ví dụ: "it head"
            if (nm.equals("head") || nm.endsWith(" head")) {
                return true; // "Head", "IT Head", "QA Head", "SALE Head", ...
            }
        }
        return false;
    }

    // Chỉ hỏi DB để kiểm tra quan hệ cấp dưới (không dùng getManager())
    private boolean isMySubordinate(RequestForLeave r, int managerEmpId) {
        if (r == null || r.getCreated_by() == null) {
            return false;
        }
        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        return db.isSubordinate(managerEmpId, r.getCreated_by().getId());
    }

    // Gom rule nghiệp vụ: cấm tự review (trừ Head) & chỉ review cấp dưới
    private boolean violatesBusinessRule(User user, RequestForLeave r) {
        if (user == null || user.getEmployee() == null || r == null || r.getCreated_by() == null) {
            return true;
        }

        int me = user.getEmployee().getId();
        int owner = r.getCreated_by().getId();
        boolean head = isHead(user);

        if (!head && me == owner) {
            return true;             // cấm tự review
        }
        if (!head && !isMySubordinate(r, me)) {
            return true; // phải là cấp trên
        }
        return false;
    }

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String ridRaw = req.getParameter("rid");
        if (ridRaw == null) {
            resp.sendRedirect(req.getContextPath() + "/request/list");
            return;
        }

        int rid;
        try {
            rid = Integer.parseInt(ridRaw);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/request/list");
            return;
        }

        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        RequestForLeave r = db.get(rid);
        if (r == null) {
            resp.sendRedirect(req.getContextPath() + "/request/list");
            return;
        }

        if (violatesBusinessRule(user, r)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không thể duyệt đơn này.");
            return;
        }

        req.setAttribute("r", r);
        req.setAttribute("history", new RequestForLeaveDBContext().listHistory(rid));
        req.setAttribute("pageTitle", "Duyệt đơn #" + rid);
        req.setAttribute("content", "/view/request/review_content.jsp");
        req.getRequestDispatcher("/view/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String ridRaw = req.getParameter("rid");
        String action = req.getParameter("action"); // approve | reject
        String rejectReason = req.getParameter("rejectReason");
        if (ridRaw == null || action == null) {
            resp.sendRedirect(req.getContextPath() + "/request/list");
            return;
        }

        int rid;
        try {
            rid = Integer.parseInt(ridRaw);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/request/list");
            return;
        }

        RequestForLeaveDBContext dbCheck = new RequestForLeaveDBContext();
        RequestForLeave rCheck = dbCheck.get(rid);
        if (rCheck == null) {
            resp.sendRedirect(req.getContextPath() + "/request/list");
            return;
        }

        if (violatesBusinessRule(user, rCheck)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không thể duyệt đơn này.");
            return;
        }

        int processedByEid = user.getEmployee().getId();
        int newStatus = "approve".equalsIgnoreCase(action) ? 1 : 2;

        if (newStatus == 2 && (rejectReason == null || rejectReason.trim().isEmpty())) {
            req.setAttribute("r", rCheck);
            req.setAttribute("errorRejectReason", "Vui lòng nhập lý do từ chối.");
            req.setAttribute("pageTitle", "Duyệt đơn #" + rid);
            req.setAttribute("content", "/view/request/review_content.jsp");
            req.getRequestDispatcher("/view/layout/layout.jsp").forward(req, resp);
            return;
        }

        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        db.updateStatus(rid, newStatus, processedByEid, newStatus == 2 ? rejectReason.trim() : null);

        String note = (newStatus == 1) ? "approved" : ("rejected: " + rejectReason.trim());
        db.insertHistory(rid, processedByEid, (newStatus == 1 ? "approve" : "reject"), note);

        resp.sendRedirect(req.getContextPath() + "/request/list");
    }

}
