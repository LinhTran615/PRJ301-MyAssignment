<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3 class="mb-3"><i class="bi bi-calendar3"></i> Agenda</h3>
<table class="table table-bordered table-hover align-middle">
    <thead class="table-light">
        <tr>
            <th>Employee</th>
            <th>From</th>
            <th>To</th>
            <th>Reason</th>
            <th>Status</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="r" items="${requests}">
            <tr>
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
            </tr>
        </c:forEach>
    </tbody>
</table>
