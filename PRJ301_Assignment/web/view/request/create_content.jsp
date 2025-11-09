<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="panel">
  <div class="panel-head">Tạo đơn nghỉ phép</div>
  <form action="<c:url value='/request/create'/>" method="post" id="createForm" class="form">
    <div class="grid-2">
      <div class="form-group">
        <label for="from">Từ ngày</label>
        <input id="from" type="date" name="from"
               class="input"
               value="${fromVal}" min="${todayStr}" required>
        <c:if test="${not empty err_from}">
          <div class="help error">${err_from}</div>
        </c:if>
      </div>
      <div class="form-group">
        <label for="to">Đến ngày</label>
        <input id="to" type="date" name="to"
               class="input"
               value="${toVal}" min="${todayStr}" required>
        <c:if test="${not empty err_to}">
          <div class="help error">${err_to}</div>
        </c:if>
      </div>
    </div>

    <div class="form-group">
      <label for="reason">Lý do</label>
      <textarea id="reason" name="reason" rows="4" class="input" placeholder="Nhập lý do..." required>${reasonVal}</textarea>
      <c:if test="${not empty err_reason}">
        <div class="help error">${err_reason}</div>
      </c:if>
    </div>

    <div style="display:flex; gap:10px;">
      <button class="btn btn-primary" type="submit">Gửi đơn</button>
      <a class="btn btn-outline" href="<c:url value='/request/list'/>">Hủy</a>
    </div>
  </form>
</div>

<style>
.form .form-group{margin:12px 0}
.form .form-group label{font-weight:700; color:#334155; display:block; margin-bottom:6px}

/* FIX hiển thị input date không cắt chữ */
.input{
  width:100%; box-sizing:border-box;
  border:1px solid #cbd5e1; border-radius:8px;
  padding:10px 12px; line-height:1.4; height:42px;
  background:#fff; color:#0f172a; outline:none;
}
textarea.input{height:auto; min-height:96px; resize:vertical}

.input:focus{border-color:#6366f1; box-shadow:0 0 0 3px rgba(99,102,241,.12)}
.grid-2{display:grid; grid-template-columns: repeat(auto-fit,minmax(220px,1fr)); gap:12px;}
.help{font-size:12px; color:#64748b; margin-top:6px}
.help.error{color:#dc2626}
.btn{background:#3b82f6;color:#fff;border:1px solid transparent;border-radius:8px;padding:10px 14px;font-weight:600;text-decoration:none}
.btn:hover{background:#2563eb}
.btn-outline{background:#fff;color:#0f172a;border:1px solid #cbd5e1}
.btn-outline:hover{background:#f8fafc}
</style>

<script>
  // Đồng bộ: 'to' luôn >= 'from' + min = hôm nay
  (function(){
    const from = document.getElementById('from');
    const to   = document.getElementById('to');

    function syncToMin(){
      if (from.value){
        to.min = from.value;
        if (to.value && to.value < from.value) to.value = from.value;
      }
    }
    from.addEventListener('change', syncToMin);
    // chạy lúc đầu để chỉnh min của 'to'
    syncToMin();
  })();
</script>
