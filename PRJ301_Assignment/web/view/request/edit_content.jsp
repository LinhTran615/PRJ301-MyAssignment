<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="panel">
    <div class="panel-head">Sửa &amp; Gửi lại đơn #${r.id}</div>
    <form action="<c:url value='/request/edit'/>" method="post" class="form" style="padding:14px;">
        <input type="hidden" name="rid" value="${r.id}" />

        <div class="grid-2">
            <div><strong>Người tạo:</strong> ${r.created_by.name}</div>
            <div>
                <strong>Trạng thái hiện tại:</strong>
                <span class="badge badge-bad">Rejected</span>
            </div>
        </div>

        <div class="form-group" style="margin-top:12px;">
            <label for="reason" class="required"><strong>Lý do</strong></label>
            <textarea id="reason" name="reason" rows="4" class="input" required>${r.reason}</textarea>
            <c:if test="${not empty error}">
                <div class="help" style="color:#dc2626;">${error}</div>
            </c:if>
        </div>

        <div style="display:flex; gap:10px;">
            <button class="btn btn-primary" type="submit">Gửi lại</button>
            <a class="btn btn-ghost" href="<c:url value='/request/list'/>">Quay lại</a>
        </div>
    </form>
</div>

<style>
    .form .form-group{
        margin:12px 0
    }
    .input{
        width:100%;
        padding:10px;
        border:1px solid #e5e7eb;
        border-radius:8px;
    }
    .required:after{
        content:" *";
        color:#dc2626
    }
    .badge{
        padding:4px 8px;
        border-radius:999px;
        font-size:12px;
        font-weight:700
    }
    .badge-bad{
        background:#FEE2E2;
        color:#991B1B;
        border:1px solid #EF4444
    }
    .btn{
        background:#3b82f6;
        color:#fff;
        border:1px solid transparent;
        border-radius:8px;
        padding:10px 14px;
        font-weight:600
    }
    .btn:hover{
        background:#2563eb
    }
    .btn-ghost{
        background:#fff;
        color:#1e293b;
        border:1px solid #e5e7eb
    }
    .btn-ghost:hover{
        background:#f8fafc
    }
    .grid-2{
        display:grid;
        grid-template-columns: repeat(auto-fit,minmax(240px,1fr));
        gap:12px;
    }
</style>
