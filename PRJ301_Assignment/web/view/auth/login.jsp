<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Login | Leave Management System</title>
  <!-- ĐƯỜNG DẪN CSS CHUẨN -->
  <link rel="stylesheet" href="<c:url value='/css/custom.css'/>">
</head>
<body class="login-body">
  <div class="login-card">
    <h2>Login</h2>
    <form action="<c:url value='/login'/>" method="POST">
      <div class="form-group">
        <label>Username</label>
        <input type="text" name="username" placeholder="Enter username" required />
      </div>
      <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" placeholder="Enter password" required />
      </div>

      <c:if test="${not empty error}">
        <div class="alert">${error}</div>
      </c:if>
      <c:if test="${not empty requestScope.message}">
        <div class="alert">${requestScope.message}</div>
      </c:if>

      <button type="submit" class="btn btn-login">Login</button>
    </form>
    <p class="footer-text">Leave Management System © 2025</p>
  </div>
</body>
</html>
