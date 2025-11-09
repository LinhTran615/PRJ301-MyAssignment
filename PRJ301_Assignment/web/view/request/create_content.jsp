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
            <div id="dayCounter" class="help">
                Số ngày nghỉ phép (trừ T7, CN): <strong id="workdays">0</strong>
            </div>

            <c:if test="${not empty conflicts}">
                <div class="help error" style="margin-top:6px">
                    Cảnh báo: Khoảng ngày chọn đang trùng với các đơn:
                    <ul>
                        <c:forEach var="c" items="${conflicts}">
                            <li>#${c.id}: ${c.from} → ${c.to}
                                (<c:choose>
                                    <c:when test="${c.status==0}">Processing</c:when>
                                    <c:when test="${c.status==1}">Approved</c:when>
                                    <c:otherwise>Rejected</c:otherwise>
                                </c:choose>)
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>
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
    .form .form-group{
        margin:12px 0
    }
    .form .form-group label{
        font-weight:700;
        color:#334155;
        display:block;
        margin-bottom:6px
    }

    /* FIX hiển thị input date không cắt chữ */
    .input{
        width:100%;
        box-sizing:border-box;
        border:1px solid #cbd5e1;
        border-radius:8px;
        padding:10px 12px;
        line-height:1.4;
        height:42px;
        background:#fff;
        color:#0f172a;
        outline:none;
    }
    textarea.input{
        height:auto;
        min-height:96px;
        resize:vertical
    }

    .input:focus{
        border-color:#6366f1;
        box-shadow:0 0 0 3px rgba(99,102,241,.12)
    }
    .grid-2{
        display:grid;
        grid-template-columns: repeat(auto-fit,minmax(220px,1fr));
        gap:12px;
    }
    .help{
        font-size:12px;
        color:#64748b;
        margin-top:6px
    }
    .help.error{
        color:#dc2626
    }
    .btn{
        background:#3b82f6;
        color:#fff;
        border:1px solid transparent;
        border-radius:8px;
        padding:10px 14px;
        font-weight:600;
        text-decoration:none
    }
    .btn:hover{
        background:#2563eb
    }
    .btn-outline{
        background:#fff;
        color:#0f172a;
        border:1px solid #cbd5e1
    }
    .btn-outline:hover{
        background:#f8fafc
    }
</style>

<script>
    // Đồng bộ: 'to' luôn > 'from' (ít nhất +1 day) và >= hôm nay
    (function () {
        const from = document.getElementById('from');
        const to = document.getElementById('to');
        const out = document.getElementById('workdays');
        const fromI = from, toI = to;

        function iso(d) {
            return d.toISOString().slice(0, 10);
        }
        function plus1(dateStr) {
            const d = new Date(dateStr);
            d.setDate(d.getDate() + 1);
            return iso(d);
        }

        function syncToMin() {
            if (!from.value)
                return;
            // min của 'to' = from + 1 day
            const minTo = plus1(from.value);
            to.min = minTo;
            if (to.value && to.value < minTo)
                to.value = minTo;
        }

        from.addEventListener('change', () => {
            syncToMin();
            recalc();
        });
        to.addEventListener('change', recalc);

        // Đếm số ngày làm việc (T2–T6, inclusive)
        function businessDays(fromStr, toStr) {
            if (!fromStr || !toStr)
                return 0;
            const a = new Date(fromStr), b = new Date(toStr);
            if (b <= a)
                return 0;
            let days = 0;
            for (let d = new Date(a); d <= b; d.setDate(d.getDate() + 1)) {
                const w = d.getDay();
                if (w !== 0 && w !== 6)
                    days++;
            }
            return days;
        }
        function recalc() {
            out.textContent = businessDays(fromI.value, toI.value);
        }

        // khởi tạo
        syncToMin();
        recalc();
    })();
</script>

