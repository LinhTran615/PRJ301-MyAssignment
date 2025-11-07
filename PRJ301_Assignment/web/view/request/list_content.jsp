<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3 class="mb-3"><i class="bi bi-list-check"></i> Request List</h3>

<div class="table-responsive">
  <table class="table table-hover table-bordered align-middle">
    <thead class="table-light">
      <tr>
        <th style="width:70px;">ID</th>
        <th>Created By</th>
        <th>From</th>
        <th>To</th>
        <th>Reason</th>
        <th>Status</th>
        <th>Reject Reason</th> <!-- NEW -->
        <th>Processed By</th>
        <th style="width:90px;">Action</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="r" items="${rfls}">
        <tr>
          <td>${r.id}</td>
          <td>${r.created_by.name}</td>
          <td>${r.from}</td>
          <td>${r.to}</td>
          <td class="text-truncate" style="max-width:200px;" title="${r.reason}">${r.reason}</td>
          <td>
            <c:choose>
              <c:when test="${r.status eq 0}"><span class="badge bg-warning text-dark">Processing</span></c:when>
              <c:when test="${r.status eq 1}"><span class="badge bg-success">Approved</span></c:when>
              <c:otherwise><span class="badge bg-danger">Rejected</span></c:otherwise>
            </c:choose>
          </td>
          <!-- Hiển thị lý do nếu bị từ chối; dùng cả 2 tên field để tương thích (rejectReason hoặc reject_reason) -->
          <td class="text-danger">
            <c:if test="${r.status eq 2}">
              ${ not empty r.rejectReason ? r.rejectReason : r.reject_reason }
            </c:if>
          </td>
          <td>${r.processed_by.name}</td>
          <td>
            <a href="${pageContext.request.contextPath}/request/review?rid=${r.id}"
               class="btn btn-sm btn-outline-primary">Review</a>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>
