<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 1) Tính quyền Agenda --%>
<c:set var="hasAgenda" value="false" />
<c:forEach var="r" items="${sessionScope.auth.roles}">
  <c:forEach var="f" items="${r.features}">
    <c:if test="${f.url == '/division/agenda' || f.url == '/agenda' || fn:startsWith('/division/agenda', f.url)}">
      <c:set var="hasAgenda" value="true" />
    </c:if>
  </c:forEach>
</c:forEach>

<%-- 2) Tính trạng thái active theo URL hiện tại --%>
<c:set var="uri" value="${pageContext.request.requestURI}" />
<c:set var="isHome"    value="${fn:endsWith(uri, '/home')}" />
<c:set var="isRequest" value="${fn:contains(uri, '/request')}" />
<c:set var="isCreate"  value="${fn:contains(uri, '/create')}" />
<c:set var="isAgenda"  value="${fn:contains(uri, '/agenda')}" />

<div class="sidebar">
  <div class="sidebar-header">
    <i class="bi bi-building"></i> LMS
  </div>

  <div class="sidebar-menu">
    <a href="${pageContext.request.contextPath}/home"
       class="sidebar-link${isHome ? ' active' : ''}">
      <i class="bi bi-house"></i> Trang chủ
    </a>

    <a href="${pageContext.request.contextPath}/request/list"
       class="sidebar-link${isRequest ? ' active' : ''}">
      <i class="bi bi-card-list"></i> Danh sách đơn
    </a>

    <a href="${pageContext.request.contextPath}/request/create"
       class="sidebar-link${isCreate ? ' active' : ''}">
      <i class="bi bi-pencil-square"></i> Tạo đơn mới
    </a>

    <c:if test="${hasAgenda}">
      <a href="${pageContext.request.contextPath}/division/agenda"
         class="sidebar-link${isAgenda ? ' active' : ''}">
        <i class="bi bi-calendar3"></i> Agenda phòng ban
      </a>
    </c:if>
  </div>

  <div class="sidebar-footer">
    <div class="user-info">
      <i class="bi bi-person-circle"></i> ${sessionScope.auth.displayname}
    </div>
    <a href="${pageContext.request.contextPath}/logout" class="logout">
      <i class="bi bi-box-arrow-right"></i> Đăng xuất
    </a>
  </div>
</div>

<style>
.sidebar {
  position: fixed; top: 0; left: 0; height: 100vh; width: 230px;
  background: #0f172a; color: #f1f5f9; display:flex; flex-direction:column;
}
.sidebar-header { padding:18px 20px; font-weight:700; font-size:18px; border-bottom:1px solid #1e293b; }
.sidebar-header i { margin-right:8px; color:#60a5fa; }
.sidebar-menu { flex-grow:1; padding-top:12px; display:flex; flex-direction:column; }
.sidebar-link { display:flex; align-items:center; color:#cbd5e1; text-decoration:none;
  padding:10px 20px; font-weight:500; transition:.2s; }
.sidebar-link i { margin-right:10px; font-size:16px; }
.sidebar-link:hover, .sidebar-link.active { background:#1e293b; color:#fff; }
.sidebar-footer { border-top:1px solid #1e293b; padding:16px 20px; }
.user-info { font-size:14px; color:#94a3b8; margin-bottom:8px; }
.logout { color:#fca5a5; text-decoration:none; font-weight:600; font-size:14px; }
.logout:hover { color:#fecaca; }
</style>
