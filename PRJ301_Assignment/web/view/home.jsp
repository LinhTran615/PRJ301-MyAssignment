<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
<jsp:include page="layout/header.jsp" />
<div class="app">
    <jsp:include page="layout/sidebar.jsp" />
    <div class="main">
        <div class="hero card">
            <h1>Leave System Management</h1>
            <h3>Xin chào, <c:out value="${sessionScope.auth.displayname}" />!</h3>

            <div class="actions">
                <a class="btn" href="${pageContext.request.contextPath}/request/create">📝 Tạo đơn nghỉ</a>
                <a class="btn" href="${pageContext.request.contextPath}/request/list">📋 Xem danh sách</a>
                <a class="btn" href="${pageContext.request.contextPath}/division/agenda">📅 Lịch nghỉ</a>
            </div>
        </div>

        <div class="grid">
            <div class="card">
                <h3>Thông tin nhân viên</h3>
                <table style="width:100%;margin-top:12px">
                    <tr><td style="width:180px"><b>Tên hiển thị:</b></td><td>${sessionScope.auth.displayname}</td></tr>
                    <tr><td><b>Tên đăng nhập:</b></td><td>${sessionScope.auth.username}</td></tr>
                    <tr><td><b>Mã nhân viên:</b></td><td>${sessionScope.auth.employee.id}</td></tr>
                    <tr><td><b>Họ tên nhân viên:</b></td><td>${sessionScope.auth.employee.name}</td></tr>
                    <tr><td><b>Vai trò:</b></td><td>
                            <c:forEach var="r" items="${sessionScope.auth.roles}" varStatus="st">
                                ${r.name}<c:if test="${!st.last}">, </c:if>
                            </c:forEach>
                        </td></tr>
                </table>
            </div>

            <div class="card" style="text-align:center">
                <h3>Thống kê nhanh</h3>
                <div style="font-size:40px;color:var(--primary);margin:18px 0">●</div>
                <div style="font-weight:700;font-size:18px">Tổng số ngày nghỉ</div>
                <div style="font-size:28px;margin-top:8px">${totalDays}</div>
            </div>
        </div>

        <jsp:include page="layout/footer.jsp" />
    </div>
</div>
