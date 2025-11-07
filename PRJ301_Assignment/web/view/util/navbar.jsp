<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- Tính c? hasAgenda t? danh sách roles -> features trong session --%>
<c:set var="hasAgenda" value="false" scope="page"/>
<c:forEach var="r" items="${sessionScope.auth.roles}">
  <c:forEach var="f" items="${r.features}">
    <c:if test="${f.url == '/division/agenda' 
                 || f.url == '/agenda'
                 || fn:startsWith('/division/agenda', f.url)}">
      <c:set var="hasAgenda" value="true" scope="page"/>
    </c:if>
  </c:forEach>
</c:forEach>

<nav class="navbar">
  <div class="container">
    <a href="${pageContext.request.contextPath}/home" class="logo">LMS</a>
    <ul class="menu">
      <li><a href="${pageContext.request.contextPath}/request/list">My Requests</a></li>

      <c:if test="${hasAgenda}">
        <li><a href="${pageContext.request.contextPath}/division/agenda">Agenda</a></li>
      </c:if>

      <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
    </ul>
  </div>
</nav>
