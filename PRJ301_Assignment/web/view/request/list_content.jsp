<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<h3 class="mb-3"><i class="bi bi-list-check"></i> Request List</h3>
<table class="table table-hover table-bordered align-middle">
    <thead class="table-light">
        <tr>
            <th>ID</th>
            <th>Created By</th>
            <th>From</th>
            <th>To</th>
            <th>Reason</th>
            <th>Status</th>
            <th>Processed By</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="r" items="${rfls}">
            <tr>
                <td>${r.id}</td>
                <td>${r.created_by.name}</td>
                <td>${r.from}</td>
                <td>${r.to}</td>
                <td>${r.reason}</td>
                <td>
                    <c:choose>
                        <c:when test="${r.status eq 0}"><span class="badge bg-warning">Processing</span></c:when>
                        <c:when test="${r.status eq 1}"><span class="badge bg-success">Approved</span></c:when>
                        <c:otherwise><span class="badge bg-danger">Rejected</span></c:otherwise>
                    </c:choose>
                </td>
                <td>${r.processed_by.name}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/request/review?rid=${r.id}" class="btn btn-sm btn-outline-primary">Review</a>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>
