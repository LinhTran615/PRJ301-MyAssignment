package controller.home;

import controller.iam.BaseRequiredAuthenticationController;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import model.RequestForLeave;
import model.iam.Feature;
import model.iam.Role;
import model.iam.User;

@WebServlet(urlPatterns = "/home")
public class HomeController extends BaseRequiredAuthenticationController {

    private static boolean allow(Set<String> urls, String... targets) {
        for (String t : targets) {
            for (String have : urls) {
                if (have == null || t == null) {
                    continue;
                }
                // Cho phép linh hoạt: bằng nhau hoặc bắt đầu bằng nhau (hai chiều để hỗ trợ prefix)
                if (t.equalsIgnoreCase(have)
                        || t.startsWith(have)
                        || have.startsWith(t)) {
                    return true;
                }
            }
        }
        return false;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        // ====== 1) TÍNH QUYỀN THEO ROLE -> FEATURE.URL ======
        Set<String> featureUrls = new HashSet<>();
        if (user != null && user.getRoles() != null) {
            for (Role r : user.getRoles()) {
                if (r == null || r.getFeatures() == null) {
                    continue;
                }
                for (Feature f : r.getFeatures()) {
                    if (f != null && f.getUrl() != null) {
                        featureUrls.add(f.getUrl());
                    }
                }
            }
        }

        boolean canViewRequests = allow(featureUrls, "/request/list", "/request");      // xem danh sách
        boolean canCreateRequest = allow(featureUrls, "/request/create");                // tạo đơn
        boolean canViewAgenda = allow(featureUrls, "/division/agenda", "/agenda");    // xem agenda
        boolean canEditRequest = allow(featureUrls, "/request/edit");

        // Đẩy cờ quyền cho JSP
        req.setAttribute("canViewRequests", canViewRequests);
        req.setAttribute("canCreateRequest", canCreateRequest);
        req.setAttribute("canViewAgenda", canViewAgenda);
        req.setAttribute("canEditRequest", canEditRequest);

        // ====== 2) DỮ LIỆU KPI VÀ DANH SÁCH GẦN ĐÂY ======
        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        ArrayList<RequestForLeave> all = db.getByEmployeeAndSubodiaries(user.getEmployee().getId());

        int myId = user.getEmployee().getId();
        List<RequestForLeave> myRequests = all.stream()
                .filter(r -> r.getCreated_by() != null && r.getCreated_by().getId() == myId)
                .collect(Collectors.toList());

        long myPending = myRequests.stream().filter(r -> r.getStatus() == 0).count();
        long myApproved = myRequests.stream().filter(r -> r.getStatus() == 1).count();
        long myRejected = myRequests.stream().filter(r -> r.getStatus() == 2).count();

        long teamPending = all.stream()
                .filter(r -> r.getCreated_by() != null && r.getCreated_by().getId() != myId)
                .filter(r -> r.getStatus() == 0)
                .count();

        List<RequestForLeave> recentMine = myRequests.stream()
                .sorted(Comparator.comparingInt(RequestForLeave::getId).reversed())
                .limit(5)
                .collect(Collectors.toList());

        req.setAttribute("myPending", myPending);
        req.setAttribute("myApproved", myApproved);
        req.setAttribute("myRejected", myRejected);
        req.setAttribute("teamPending", teamPending);
        req.setAttribute("recentMine", recentMine);

        req.setAttribute("user", user);
        req.setAttribute("pageTitle", "Home");
        req.setAttribute("content", "/view/home/home_content.jsp");
        req.getRequestDispatcher("/view/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        doGet(req, resp, user);
    }
}
