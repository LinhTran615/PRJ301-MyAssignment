<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
<jsp:include page="../layout/header.jsp" />
<div class="app">
    <jsp:include page="../layout/sidebar.jsp" />
    <div class="main">
        <div class="card" style="max-width:760px; margin:0 auto;">
            <h2>Duyệt đơn xin nghỉ phép</h2>
            <c:set var="r" value="${requestScope.rfl != null ? requestScope.rfl : requestScope.request}" />
            <p><b>Tạo bởi:</b> ${r.created_by.name}</p>
            <p><b>Từ → Tới:</b> ${r.from} → ${r.to}</p>
            <p><b>Lý do:</b></p>
            <textarea readonly rows="5" style="width:100%;border-radius:8px;border:1px solid #eef2f6;padding:10px">${r.reason}</textarea>

            <form method="post" action="${pageContext.request.contextPath}/request/review" style="margin-top:18px; text-align:right">
                <input type="hidden" name="rid" value="${r.id}" />
                <div style="display:flex; gap:12px; justify-content:flex-end">
                    <button class="btn btn-danger" name="action" value="reject" type="button" onclick="showReject()">Từ chối</button>
                    <button class="btn" name="action" value="approve">Phê duyệt</button>
                </div>

                <div id="rejectArea" style="display:none; margin-top:12px">
                    <label for="reject_reason">Lý do từ chối (bắt buộc)</label>
                    <textarea id="reject_reason" name="reject_reason" rows="3" required style="width:100%;"></textarea>
                    <div style="text-align:right; margin-top:8px">
                        <button type="submit" class="btn btn-danger" name="action" value="reject">Xác nhận từ chối</button>
                    </div>
                </div>
            </form>
        </div>

        <jsp:include page="../layout/footer.jsp" />
    </div>
</div>

<script>
    function showReject() {
        document.getElementById('rejectArea').style.display = 'block';
        window.scrollTo({top: document.body.scrollHeight, behavior: 'smooth'});
    }
</script>
