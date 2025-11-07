<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty r}">
  <div class="panel"><div class="panel-head">Không tìm thấy đơn</div></div>
</c:if>

<c:if test="${not empty r}">
<div class="panel">
  <div class="panel-head">Duyệt đơn #${r.id}</div>
  <div style="padding:14px;">
    <div class="grid-2">
      <div>
        <div><strong>Người tạo:</strong> ${r.created_by.name}</div>
        <div><strong>Từ ngày:</strong> ${r.from}</div>
        <div><strong>Đến ngày:</strong> ${r.to}</div>
      </div>
      <div>
        <div>
          <strong>Trạng thái:</strong>
          <c:choose>
            <c:when test="${r.status eq 0}"><span class="badge badge-warn">Processing</span></c:when>
            <c:when test="${r.status eq 1}"><span class="badge badge-ok">Approved</span></c:when>
            <c:otherwise><span class="badge badge-bad">Rejected</span></c:otherwise>
          </c:choose>
        </div>
        <c:if test="${r.processed_by ne null}">
          <div><strong>Xử lý bởi:</strong> ${r.processed_by.name}</div>
        </c:if>
      </div>
    </div>

    <div class="form-group" style="margin-top:12px;">
      <label><strong>Lý do</strong></label>
      <div class="note">${r.reason}</div>
    </div>

    <c:if test="${r.status eq 0}">
      <form action="<c:url value='/request/review'/>" method="post" style="margin-top:14px; display:flex; gap:10px;">
        <input type="hidden" name="rid" value="${r.id}">
        <button class="btn btn-primary" name="action" value="approve" type="submit">
          <i class="bi bi-check2"></i> Approve
        </button>
        <button class="btn btn-outline" name="action" value="reject" type="submit">
          <i class="bi bi-x"></i> Reject
        </button>
        <a class="btn btn-ghost" href="<c:url value='/request/list'/>">Quay lại</a>
      </form>
    </c:if>

    <c:if test="${r.status ne 0}">
      <div style="margin-top:12px;">
        <a class="btn btn-ghost" href="<c:url value='/request/list'/>">Quay lại</a>
      </div>
    </c:if>
  </div>
</div>
</c:if>

<style>
.grid-2{display:grid; grid-template-columns: repeat(auto-fit,minmax(240px,1fr)); gap:12px;}
.note{background:#f8fafc; border:1px solid #e5e7eb; border-radius:8px; padding:10px;}
</style>
