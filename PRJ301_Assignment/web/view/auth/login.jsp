<%@ page contentType="text/html;charset=UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
<jsp:include page="../layout/header.jsp" />

<!-- Vùng chứa riêng cho trang đăng nhập -->
<div class="login-page">
    <div class="login-box">
        <h2>Đăng nhập</h2>
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-row">
                <label for="username">Username</label>
                <input id="username" type="text" name="username" required />
            </div>
            <div class="form-row">
                <label for="password">Password</label>
                <input id="password" type="password" name="password" required />
            </div>
            <button class="btn" type="submit">Đăng nhập</button>

            <c:if test="${not empty requestScope.message}">
                <p style="color:#e53935;margin-top:12px;text-align:center">${requestScope.message}</p>
            </c:if>
        </form>

    </div>
</div>

<jsp:include page="../layout/footer.jsp" />
