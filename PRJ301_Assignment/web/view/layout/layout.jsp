<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8"/>
  <title>${pageTitle}</title>
  <link rel="stylesheet" href="<c:url value='/css/custom.css'/>">
  <!-- (tuỳ chọn) Bootstrap Icons -->
  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body class="app">
  <jsp:include page="/view/layout/sidebar.jsp"/>

  <main class="main-content">
    <div class="container">
      <h2 class="page-title">${pageTitle}</h2>
      <jsp:include page="${content}"/>
    </div>
  </main>
</body>
</html>
