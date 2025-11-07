<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="p-5 mb-4 bg-light rounded-3 shadow-sm">
    <div class="container-fluid py-5">
        <h1 class="display-6 fw-bold text-primary"><i class="bi bi-house-door"></i> Welcome, ${user.displayname}!</h1>
        <p class="col-md-8 fs-5 text-muted">This is your dashboard. From here, you can manage leave requests, review team submissions, and view the organization’s agenda.</p>
        <a href="${pageContext.request.contextPath}/request/list" class="btn btn-primary btn-lg me-2"><i class="bi bi-list-check"></i> View Requests</a>
        <a href="${pageContext.request.contextPath}/request/create" class="btn btn-outline-primary btn-lg"><i class="bi bi-plus-circle"></i> Create New Request</a>
    </div>
</div>
