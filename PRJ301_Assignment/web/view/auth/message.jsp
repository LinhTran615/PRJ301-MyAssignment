<%@page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Message</title>
  <link rel="stylesheet" href="<c:url value='/css/custom.css'/>">
</head>
<body class="login-body">
  <div class="login-card">
    <h2>Thông báo</h2>
    <div class="alert">${requestScope.message}</div>
    <div style="margin-top:10px">
      <a class="btn btn-primary" href="<c:url value='/home'/>">Về trang chủ</a>
    </div>
  </div>
</body>
</html>
