<%@page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Login | LMS</title>
  <link rel="stylesheet" href="<c:url value='/css/custom.css'/>">
</head>
<body class="login-body">
  <div class="login-card">
    <h2>Đăng nhập</h2>
    <form action="<c:url value='/login'/>" method="POST">
      <div class="form-group">
        <label>Username</label>
        <input name="username" required placeholder="VD: mra"/>
      </div>
      <div class="form-group">
        <label>Password</label>
        <input name="password" type="password" required placeholder="•••"/>
      </div>
      <c:if test="${not empty requestScope.message}">
        <div class="alert">${requestScope.message}</div>
      </c:if>
      <button class="btn btn-primary" type="submit">Login</button>
    </form>
    <div class="footer-text">Leave Management System © 2025</div>
  </div>
</body>
</html>
