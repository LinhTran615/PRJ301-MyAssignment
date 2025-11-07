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
import java.util.List;
import java.util.stream.Collectors;
import model.RequestForLeave;
import model.iam.User;

@WebServlet(urlPatterns = "/home")
public class HomeController extends BaseRequiredAuthenticationController {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        // Lấy tất cả request của mình + cấp dưới
        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        ArrayList<RequestForLeave> all = db.getByEmployeeAndSubodiaries(user.getEmployee().getId());

        // Danh sách đơn của chính tôi
        int myId = user.getEmployee().getId();
        List<RequestForLeave> myRequests = all.stream()
                .filter(r -> r.getCreated_by() != null && r.getCreated_by().getId() == myId)
                .collect(Collectors.toList());

        // Đếm trạng thái của chính tôi
        long myPending = myRequests.stream().filter(r -> r.getStatus() == 0).count();
        long myApproved = myRequests.stream().filter(r -> r.getStatus() == 1).count();
        long myRejected = myRequests.stream().filter(r -> r.getStatus() == 2).count();

        // Đếm pending của team (cấp dưới), hữu ích cho trưởng phòng
        long teamPending = all.stream()
                .filter(r -> r.getCreated_by() != null && r.getCreated_by().getId() != myId)
                .filter(r -> r.getStatus() == 0)
                .count();

        // “Đơn gần đây của tôi”: lấy 5 đơn mới nhất (ưu tiên rid giảm dần)
        List<RequestForLeave> recentMine = myRequests.stream()
                .sorted(Comparator.comparingInt(RequestForLeave::getId).reversed())
                .limit(5)
                .collect(Collectors.toList());

        // set attributes cho JSP
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
