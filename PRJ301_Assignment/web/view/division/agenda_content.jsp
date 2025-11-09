<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="panel" style="margin-bottom:12px;">
  <div class="panel-head">Bộ lọc</div>
  <div style="padding:12px;">
    <form id="filterForm" class="filters" method="get" action="${pageContext.request.contextPath}/division/agenda">
      <div class="row">
        <div class="col">
          <label>Từ ngày</label>
          <input type="date" name="from" value="${param.from}">
        </div>
        <div class="col">
          <label>Đến ngày</label>
          <input type="date" name="to" value="${param.to}">
        </div>
        <div class="col">
          <label>Tên nhân sự</label>
          <input type="text" name="name" placeholder="Nhập tên..." value="${param.name}">
        </div>
        <div class="col col-btn">
          <button class="btn">Lọc</button>
        </div>
      </div>
    </form>
  </div>
</div>

<div class="grid">
  <div class="panel">
    <div class="panel-head">Lịch nghỉ của phòng</div>
    <div style="padding:12px;">
      <div id="calendar"></div>
    </div>
  </div>

  <div class="panel">
    <div class="panel-head">Danh sách theo bộ lọc</div>
    <div style="padding:0 12px 12px 12px;">
      <div class="table-wrapper">
        <table class="table">
          <thead>
            <tr>
              <th>Nhân sự</th>
              <th>Từ</th>
              <th>Đến</th>
              <th>Lý do</th>
              <th>Trạng thái</th>
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
    </div>
  </div>
</div>

<!-- FullCalendar -->
<link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/main.min.css" rel="stylesheet"/>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/main.min.js"></script>

<script>
  // build URL events (format=json + giữ bộ lọc hiện tại)
  const form = document.getElementById('filterForm');
  const params = new URLSearchParams(new FormData(form));
  const eventsUrl = `${form.action}?format=json&${params.toString()}`;

  document.addEventListener('DOMContentLoaded', function () {
    const calEl = document.getElementById('calendar');
    const calendar = new FullCalendar.Calendar(calEl, {
      initialView: 'dayGridMonth',
      height: 650,
      headerToolbar: { left: 'prev,next today', center: 'title', right: 'dayGridMonth,timeGridWeek,listWeek' },
      events: eventsUrl,
      eventClick: function(info) {
        // mở review trong tab mới nếu có url
        if (info.event.url) {
          // fullcalendar đã handle, chỉ cần cho phép
        }
      },
      displayEventEnd: true
    });
    calendar.render();
  });
</script>

<style>
  .filters .row{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:10px}
  .filters label{display:block;color:#475569;font-size:13px;margin-bottom:6px}
  .filters input{width:100%;padding:8px 10px;border:1px solid #e5e7eb;border-radius:8px}
  .filters .col-btn{display:flex;align-items:end}
  .btn{background:#3b82f6;color:#fff;border:1px solid transparent;border-radius:8px;padding:10px 14px;font-weight:600}
  .btn:hover{background:#2563eb}
  .grid{display:grid;grid-template-columns:2.1fr 1.2fr;gap:12px}
  @media (max-width: 1000px){.grid{grid-template-columns:1fr}}
  .table{width:100%;border-collapse:collapse}
  .table th,.table td{padding:10px 12px;border-bottom:1px solid #eef2f7;text-align:left;font-size:14px}
  .table thead th{background:#f8fafc;color:#475569;font-weight:700}
  .badge{padding:4px 8px;border-radius:999px;font-size:12px;font-weight:700}
  .badge-warn{background:#fff7ed;color:#f59e0b;border:1px solid #fde68a}
  .badge-ok{background:#ecfdf5;color:#10b981;border:1px solid #a7f3d0}
  .badge-bad{background:#fef2f2;color:#ef4444;border:1px solid #fecaca}
  .table-wrapper{max-height:560px;overflow:auto}
</style>
