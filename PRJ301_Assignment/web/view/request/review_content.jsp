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
                        <strong>Trạng thái hiện tại:</strong>
                        <c:choose>
                            <c:when test="${r.status eq 0}"><span class="badge badge-warn">Processing</span></c:when>
                            <c:when test="${r.status eq 1}"><span class="badge badge-ok">Approved</span></c:when>
                            <c:otherwise><span class="badge badge-bad">Rejected</span></c:otherwise>
                        </c:choose>
                    </div>
                    <c:if test="${r.processed_by ne null}">
                        <div><strong>Xử lý lần gần nhất:</strong> ${r.processed_by.name}</div>
                    </c:if>
                </div>
            </div>

            <div class="form-group" style="margin-top:12px;">
                <label><strong>Lý do xin nghỉ</strong></label>
                <div class="note">${r.reason}</div>
            </div>

            <c:if test="${r.status eq 2 && not empty r.reject_reason}">
                <div class="form-group" style="margin-top:12px;">
                    <label><strong>Lý do từ chối lần trước</strong></label>
                    <div class="note" style="color:#dc2626;">${r.reject_reason}</div>
                </div>
            </c:if>

            <!-- FORM: luôn cho phép cập nhật quyết định -->
            <form id="reviewForm" action="<c:url value='/request/review'/>" method="post"
                  style="margin-top:16px; display:flex; gap:10px; flex-wrap:wrap;">
                <input type="hidden" name="rid" value="${r.id}">

                <div style="flex:1 1 100%; display:grid; grid-template-columns: 150px 1fr; gap:10px; align-items:start;">
                    <div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="action" id="approve" value="approve"
                                   <c:if test="${r.status ne 2}">checked</c:if>>
                                   <label class="form-check-label" for="approve">Approve</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="action" id="reject" value="reject"
                                <c:if test="${r.status eq 2}">checked</c:if>>
                                <label class="form-check-label" for="reject">Reject</label>
                            </div>
                        </div>

                        <div id="rejectArea" class="form-group" style="display:<c:out value='${r.status eq 2 ? "block" : "none"}'/>;">
                        <label class="required"><strong>Lý do từ chối</strong></label>
                        <textarea class="input" name="rejectReason" rows="3"
                                  placeholder="Nhập lý do từ chối..."><c:out value="${r.reject_reason}"/></textarea>
                        <c:if test="${not empty errorRejectReason}">
                            <div class="help" style="color:#dc2626;">${errorRejectReason}</div>
                        </c:if>
                    </div>
                </div>

                <div style="display:flex; gap:10px; align-items:center;">
                    <button class="btn btn-primary" type="submit">
                        <i class="bi bi-save"></i> Lưu quyết định
                    </button>
                    <a class="btn btn-ghost" href="<c:url value='/request/list'/>">Quay lại</a>
                </div>

            </form>
        </div>
    </div>
</c:if>

<style>
    .grid-2{
        display:grid;
        grid-template-columns: repeat(auto-fit,minmax(240px,1fr));
        gap:12px;
    }
    .note{
        background:#f8fafc;
        border:1px solid #e5e7eb;
        border-radius:8px;
        padding:10px;
    }
    .required:after{
        content:" *";
        color:#dc2626;
    }
    .input{
        width:100%;
        padding:8px 10px;
        border:1px solid #e5e7eb;
        border-radius:8px;
        background:#fff;
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
    .btn-outline{
        background:#fff;
        color:#0f172a;
        border-color:#e5e7eb
    }
    .btn-outline:hover{
        background:#f8fafc
    }
    .btn-ghost{
        background:#fff;
        color:#1e293b;
        border-color:#e5e7eb
    }
    .btn-ghost:hover{
        background:#f8fafc
    }
</style>

<script>
    const approve = document.getElementById('approve');
    const reject = document.getElementById('reject');
    const rejectArea = document.getElementById('rejectArea');
    function toggleReject() {
        rejectArea.style.display = reject.checked ? 'block' : 'none';
    }
    if (approve && reject) {
        approve.addEventListener('change', toggleReject);
        reject.addEventListener('change', toggleReject);
    }

    document.getElementById('reviewForm').addEventListener('submit', function (e) {
        const action = document.querySelector('input[name="action"]:checked').value;
        if (action === 'reject') {
            const val = (rejectArea.querySelector('textarea').value || '').trim();
            if (!val) {
                e.preventDefault();
                alert('Vui lòng nhập lý do từ chối.');
                rejectArea.querySelector('textarea').focus();
            }
        }
    });
</script>
