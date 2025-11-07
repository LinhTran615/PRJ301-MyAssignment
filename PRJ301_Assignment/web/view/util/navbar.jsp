<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-building"></i> LMS
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link ${pageTitle eq 'Home' ? 'active' : ''}" href="${pageContext.request.contextPath}/home"><i class="bi bi-house-door"></i> Home</a></li>
                <li class="nav-item"><a class="nav-link ${pageTitle eq 'Request List' ? 'active' : ''}" href="${pageContext.request.contextPath}/request/list"><i class="bi bi-list-check"></i> Requests</a></li>
                <li class="nav-item"><a class="nav-link ${pageTitle eq 'Create Request' ? 'active' : ''}" href="${pageContext.request.contextPath}/request/create"><i class="bi bi-plus-circle"></i> Create</a></li>
                <li class="nav-item"><a class="nav-link ${pageTitle eq 'Agenda' ? 'active' : ''}" href="${pageContext.request.contextPath}/division/agenda"><i class="bi bi-calendar3"></i> Agenda</a></li>
            </ul>
            <ul class="navbar-nav">
                <c:if test="${not empty sessionScope.auth}">
                    <li class="nav-item me-2 text-white mt-1"><i class="bi bi-person-circle"></i> ${sessionScope.auth.displayname}</li>
                </c:if>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
            </ul>
        </div>
    </div>
</nav>
