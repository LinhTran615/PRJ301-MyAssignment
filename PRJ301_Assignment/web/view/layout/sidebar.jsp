<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="sidebar">
    <nav class="nav">
        <a href="${pageContext.request.contextPath}/home" class="${pageContext.request.requestURI.endsWith('/home') ? 'active' : ''}">🏠 Home</a>
        <a href="${pageContext.request.contextPath}/request/list" class="${pageContext.request.requestURI.contains('/request/list') ? 'active' : ''}">📋 Requests</a>
        <a href="${pageContext.request.contextPath}/request/create" class="${pageContext.request.requestURI.contains('/request/create') ? 'active' : ''}">📝 Create</a>
        <a href="${pageContext.request.contextPath}/division/agenda" class="${pageContext.request.requestURI.contains('/division/agenda') ? 'active' : ''}">📅 Agenda</a>
        <a href="${pageContext.request.contextPath}/logout">🚪 Logout</a>
    </nav>
</div>
