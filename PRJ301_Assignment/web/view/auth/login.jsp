<%@ page contentType="text/html;charset=UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
<jsp:include page="../layout/header.jsp" />
<div style="padding:90px 20px;">
    <div style="max-width:420px;margin:30px auto;">
        <div class="card" style="text-align:center">
            <h2>Đăng nhập</h2>
            <form action="${pageContext.request.contextPath}/login" method="post" style="margin-top:14px">
                <div class="form-row">
                    <label>Username</label>
                    <input type="text" name="username" required />
                </div>
                <div class="form-row">
                    <label>Password</label>
                    <input type="password" name="password" required />
                </div>
                <div style="display:flex;gap:12px;justify-content:center;margin-top:12px">
                    <button class="btn" type="submit">Đăng nhập</button>
                </div>
                <c:if test="${not empty requestScope.message}">
                    <p style="color:#e53935;margin-top:12px;text-align:center">${requestScope.message}</p>
                </c:if>
            </form>
        </div>
    </div>
</div>
<jsp:include page="../layout/footer.jsp" />
