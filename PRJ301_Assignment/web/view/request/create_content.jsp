<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="panel">
  <div class="panel-head">Tạo đơn nghỉ phép</div>
  <form action="<c:url value='/request/create'/>" method="post" class="form">
    <div class="grid-2">
      <div class="form-group">
        <label>Từ ngày</label>
        <input type="date" name="from" required>
      </div>
      <div class="form-group">
        <label>Đến ngày</label>
        <input type="date" name="to" required>
      </div>
    </div>

    <div class="form-group">
      <label>Lý do</label>
      <textarea name="reason" rows="4" placeholder="Nhập lý do..." required></textarea>
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
.form .form-group input,.form .form-group textarea{
  width:100%; border:1px solid #cbd5e1; border-radius:8px; padding:10px; outline:none;
}
.form .form-group input:focus,.form .form-group textarea:focus{
  border-color:#6366f1; box-shadow:0 0 0 3px rgba(99,102,241,.12);
}
.grid-2{display:grid; grid-template-columns: repeat(auto-fit,minmax(220px,1fr)); gap:12px;}
</style>
