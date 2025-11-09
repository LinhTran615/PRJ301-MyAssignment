<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="panel">
    <div class="panel-head">
        <div><strong>
                <c:choose>
                    <c:when test="${isRejected}">Sửa &amp; Gửi lại đơn #${r.id}</c:when>
                    <c:otherwise>Sửa đơn #${r.id}</c:otherwise>
                </c:choose>
            </strong></div>
        <div>
            <c:choose>
                <c:when test="${r.status eq 0}"><span class="badge badge-warn">Processing</span></c:when>
                <c:when test="${r.status eq 1}"><span class="badge badge-ok">Approved</span></c:when>
                <c:otherwise><span class="badge badge-bad">Rejected</span></c:otherwise>
            </c:choose>
        </div>
    </div>

    <form action="<c:url value='/request/edit'/>" method="post" class="form" style="padding:14px;" id="editForm">
        <input type="hidden" name="rid" value="${r.id}" />

        <div class="grid-2">
            <div class="form-group">
                <label for="from"><strong>Từ ngày</strong></label>
                <input id="from" type="date" name="from" class="input" value="${r.from}" min="${todayStr}" required />
                <c:if test="${not empty err_from}"><div class="help error">${err_from}</div></c:if>
                </div>
                <div class="form-group">
                    <label for="to"><strong>Đến ngày</strong></label>
                    <input id="to" type="date" name="to" class="input" value="${r.to}" min="${todayStr}" required />
                <c:if test="${not empty err_to}"><div class="help error">${err_to}</div></c:if>
                </div>
            </div>

            <div class="form-group" style="margin-top:12px;">
                <label for="reason" class="required"><strong>Lý do</strong></label>
                <textarea id="reason" name="reason" rows="4" class="input" required>${r.reason}</textarea>
            <c:if test="${not empty err_reason}"><div class="help error">${err_reason}</div></c:if>
            </div>

        <c:if test="${isRejected && not empty r.reject_reason}">
            <div class="form-group" style="margin-top:8px;">
                <label><strong>Lý do bị từ chối lần trước</strong></label>
                <div class="note" style="color:#dc2626;">${r.reject_reason}</div>
            </div>
        </c:if>

        <div style="display:flex;gap:10px;">
            <button class="btn btn-primary" type="submit">
                <i class="bi bi-save"></i>
                <c:choose>
                    <c:when test="${isRejected}">Gửi lại (Resubmit)</c:when>
                    <c:otherwise>Lưu thay đổi</c:otherwise>
                </c:choose>
            </button>
            <a class="btn btn-ghost" href="<c:url value='/request/list'/>">Quay lại</a>
        </div>
    </form>
</div>

<style>
    .grid-2{
        display:grid;
        grid-template-columns:repeat(auto-fit,minmax(240px,1fr));
        gap:12px
    }
    .form-group{
        margin:12px 0
    }
    .input{
        width:100%;
        padding:10px;
        border:1px solid #e5e7eb;
        border-radius:8px
    }
    .required:after{
        content:" *";
        color:#dc2626
    }
    .help.error{
        color:#dc2626;
        font-size:12px;
        margin-top:6px
    }
    .badge{
        padding:4px 8px;
        border-radius:999px;
        font-size:12px;
        font-weight:700
    }
    .badge-warn{
        background:#FEF3C7;
        color:#92400E;
        border:1px solid #F59E0B
    }
    .badge-ok{
        background:#D1FAE5;
        color:#065F46;
        border:1px solid #10B981
    }
    .badge-bad{
        background:#FEE2E2;
        color:#991B1B;
        border:1px solid #EF4444
    }
    .note{
        background:#f8fafc;
        border:1px solid #e5e7eb;
        border-radius:8px;
        padding:10px
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
</style>

<script>
    (function () {
        const from = document.getElementById('from');
        const to = document.getElementById('to');

        function iso(d) {
            return d.toISOString().slice(0, 10);
        }
        function plus1(dateStr) {
            const d = new Date(dateStr);
            d.setDate(d.getDate() + 1);
            return iso(d);
        }
        function sync() {
            if (!from.value)
                return;
            const minTo = plus1(from.value);
            to.min = minTo;
            if (to.value && to.value < minTo)
                to.value = minTo;
        }
        from.addEventListener('change', sync);
        sync(); // init
    })();
</script>

