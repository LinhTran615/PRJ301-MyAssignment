<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- Tính quyền agenda từ roles -> features trong session --%>
<c:set var="hasAgenda" value="false" />
<c:forEach var="r" items="${sessionScope.auth.roles}">
  <c:forEach var="f" items="${r.features}">
    <c:if test="${f.url == '/division/agenda' || f.url == '/agenda' || fn:startsWith('/division/agenda', f.url)}">
      <c:set var="hasAgenda" value="true" />
    </c:if>
  </c:forEach>
</c:forEach>

<div class="home-hero">
  <div class="home-hero__greet">
    <div class="home-hero__hello">Xin chào,</div>
    <h2 class="home-hero__name">${sessionScope.auth.displayname}</h2>
    <div class="home-hero__meta">
      Employee: <strong>${sessionScope.auth.employee.id}</strong> — ${sessionScope.auth.employee.name}
    </div>
  </div>
</div>

<div class="cards">
  <div class="card kpi kpi-pending">
    <div class="kpi-title">Đang chờ duyệt</div>
    <div class="kpi-value">${myPending}</div>
  </div>
  <div class="card kpi kpi-approved">
    <div class="kpi-title">Đã duyệt</div>
    <div class="kpi-value">${myApproved}</div>
  </div>
  <div class="card kpi kpi-rejected">
    <div class="kpi-title">Bị từ chối</div>
    <div class="kpi-value">${myRejected}</div>
  </div>
  <c:if test="${hasAgenda}">
    <div class="card kpi kpi-team">
      <div class="kpi-title">Team pending</div>
      <div class="kpi-value">${teamPending}</div>
    </div>
  </c:if>
</div>

<div class="home-actions">
  <a class="btn" href="${pageContext.request.contextPath}/request/list">Danh sách đơn</a>
  <a class="btn btn-outline" href="${pageContext.request.contextPath}/request/create">Tạo đơn mới</a>
  <c:if test="${hasAgenda}">
    <a class="btn btn-ghost" href="${pageContext.request.contextPath}/division/agenda">Agenda phòng ban</a>
  </c:if>
</div>

<c:if test="${not empty recentMine}">
  <div class="panel">
    <div class="panel-title">Đơn gần đây của tôi</div>
    <table class="table">
      <thead>
        <tr>
          <th>#</th>
          <th>From</th>
          <th>To</th>
          <th>Reason</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
      <c:forEach var="r" items="${recentMine}">
        <tr>
          <td>${r.id}</td>
          <td>${r.from}</td>
          <td>${r.to}</td>
          <td>${r.reason}</td>
          <td>
            <c:choose>
              <c:when test="${r.status eq 0}"><span class="badge badge-warn">Processing</span></c:when>
              <c:when test="${r.status eq 1}"><span class="badge badge-ok">Approved</span></c:when>
              <c:otherwise><span class="badge badge-bad">Rejected</span></c:otherwise>
            </c:choose>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</c:if>

<style>
  /* hero */
  .home-hero{
    background: linear-gradient(135deg,#e7f1ff,#f6f9ff);
    border: 1px solid #e5e7eb; border-radius: 14px; padding: 18px 18px; margin-bottom: 16px;
  }
  .home-hero__hello{color:#64748b;font-weight:600}
  .home-hero__name{margin:4px 0 6px;color:#0f172a}
  .home-hero__meta{color:#475569;font-size:14px}

  /* kpi cards */
  .cards{display:grid; gap:12px; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); margin: 10px 0 18px;}
  .card{border:1px solid #e5e7eb; border-radius:12px; background:#fff; padding:14px 16px;}
  .kpi-title{font-size:13px; color:#64748b}
  .kpi-value{font-size:28px; font-weight:800; margin-top:2px}
  .kpi-pending .kpi-value{color:#f59e0b}
  .kpi-approved .kpi-value{color:#10b981}
  .kpi-rejected .kpi-value{color:#ef4444}
  .kpi-team .kpi-value{color:#6366f1}

  /* actions */
  .home-actions{display:flex; gap:10px; flex-wrap:wrap; margin-bottom: 8px;}
  .btn{background:#3b82f6;color:#fff;text-decoration:none;border-radius:8px;
       padding:10px 14px;display:inline-block;font-weight:600;border:1px solid transparent}
  .btn:hover{background:#2563eb}
  .btn-outline{background:#fff;color:#0f172a;border-color:#e5e7eb}
  .btn-outline:hover{background:#f8fafc}
  .btn-ghost{background:#fff;color:#1e293b;border-color:#e5e7eb}
  .btn-ghost:hover{background:#f8fafc}

  /* panel + table */
  .panel{border:1px solid #e5e7eb; border-radius:12px; background:#fff;}
  .panel-title{padding:12px 14px; border-bottom:1px solid #e5e7eb; font-weight:700; color:#0f172a}
  .table{width:100%; border-collapse:collapse}
  .table th,.table td{padding:10px 12px; border-bottom:1px solid #eef2f7; text-align:left; font-size:14px}
  .table thead th{background:#f8fafc; color:#475569; font-weight:700}
  .badge{padding:4px 8px; border-radius:999px; font-size:12px; font-weight:700}
  .badge-warn{background:#fff7ed; color:#f59e0b; border:1px solid #fde68a}
  .badge-ok{background:#ecfdf5; color:#10b981; border:1px solid #a7f3d0}
  .badge-bad{background:#fef2f2; color:#ef4444; border:1px solid #fecaca}
</style>
