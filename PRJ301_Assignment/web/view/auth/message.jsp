<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="../util/imports.jsp"/>
    <title>Thông báo - LMS</title>
</head>
<body>
<jsp:include page="../layout/header.jsp"/>

<main class="page-wrapper">
    <div class="lms-container">
        <div class="card" style="max-width:520px;margin:0 auto;">
            <h2 style="font-size:18px;font-weight:600;margin-bottom:6px;">Thông báo</h2>
            <p style="font-size:14px;color:#4b5563;">
                <c:out value="${requestScope.message != null ? requestScope.message : 'Access denied!'}"/>
            </p>
            <div style="margin-top:16px;">
                <a href="${pageContext.request.contextPath}/home"
                   class="lms-nav-link"
                   style="padding:8px 16px;border-radius:999px;background:#4f46e5;color:white;display:inline-block;text-decoration:none;">
                    Về trang chủ
                </a>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../layout/footer.jsp"/>
</body>
</html>
