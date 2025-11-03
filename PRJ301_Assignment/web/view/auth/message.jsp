<%@ page contentType="text/html;charset=UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
<jsp:include page="../layout/header.jsp" />
<div style="padding:90px 20px;">
    <div style="max-width:620px;margin:30px auto;">
        <div class="card" style="text-align:center">
            <h3>Thông báo</h3>
            <p style="color:#333">${requestScope.message}</p>
            <div style="margin-top:12px">
                <a class="btn" href="${pageContext.request.contextPath}/login">Quay về đăng nhập</a>
            </div>
        </div>
    </div>
</div>
<jsp:include page="../layout/footer.jsp" />
