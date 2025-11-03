<%@ page contentType="text/html;charset=UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
<jsp:include page="../layout/header.jsp" />
<div class="app">
    <jsp:include page="../layout/sidebar.jsp" />
    <div class="main">
        <div class="card" style="max-width:760px; margin:0 auto;">
            <h2>Tạo đơn xin nghỉ phép</h2>
            <p style="color:#666">Hãy nhập ngày bắt đầu, ngày kết thúc và lý do. Ví dụ: nghỉ cưới, nghỉ ốm, việc gia đình...</p>
            <form action="${pageContext.request.contextPath}/request/create" method="post">
                <div class="form-row">
                    <label for="from">Từ ngày</label>
                    <input type="date" id="from" name="from" required />
                </div>
                <div class="form-row">
                    <label for="to">Tới ngày</label>
                    <input type="date" id="to" name="to" required />
                </div>
                <div class="form-row">
                    <label for="reason">Lý do</label>
                    <textarea id="reason" name="reason" rows="5" required placeholder="Ghi cụ thể lý do nghỉ..."></textarea>
                </div>
                <div style="display:flex; gap:12px; justify-content:flex-end; margin-top:10px">
                    <a class="btn btn-outline" href="${pageContext.request.contextPath}/request/list">Quay lại</a>
                    <button type="submit" class="btn">Gửi đơn</button>
                </div>
            </form>
        </div>

        <jsp:include page="../layout/footer.jsp" />
    </div>
</div>
