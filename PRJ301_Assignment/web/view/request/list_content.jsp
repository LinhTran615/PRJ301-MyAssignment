<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="canEditRequest" value="false" />
<c:forEach var="role" items="${sessionScope.auth.roles}">
    <c:forEach var="f" items="${role.features}">
        <c:if test="${f.url == '/request/edit'}">
            <c:set var="canEditRequest" value="true" />
        </c:if>
    </c:forEach>
</c:forEach>
<c:set var="isHead" value="false" />
<c:forEach var="role" items="${sessionScope.auth.roles}">
    <c:set var="nm" value="${fn:toLowerCase(fn:trim(role.name))}" />
    <c:if test="${nm == 'head' || fn:endsWith(nm, ' head')}">
        <c:set var="isHead" value="true" />
    </c:if>
</c:forEach>


<h3 class="mb-3"><i class="bi bi-list-check"></i> Request List</h3>
<!-- FILTER BAR (đồng bộ UI) -->
<form method="get" action="${pageContext.request.contextPath}/request/list" class="filter">
    <div class="filter-grid">
        <div class="form-group">
            <label class="label">Tên người tạo</label>
            <input type="text" name="q" value="${q}" class="input" placeholder="Nhập tên…">
        </div>

        <div class="form-group">
            <label class="label">Từ ngày</label>
            <input type="date" name="from" value="${from}" class="input">
        </div>

        <div class="form-group">
            <label class="label">Đến ngày</label>
            <input type="date" name="to" value="${to}" class="input">
        </div>

        <div class="form-group">
            <label class="label">Trạng thái</label>
            <select name="status" class="input">
                <option value=""  <c:if test="${empty status}">selected</c:if> >Tất cả</option>
                <option value="0" <c:if test="${status == '0'}">selected</c:if> >Processing</option>
                <option value="1" <c:if test="${status == '1'}">selected</c:if> >Approved</option>
                <option value="2" <c:if test="${status == '2'}">selected</c:if> >Rejected</option>
                </select>
            </div>

            <div class="filter-actions">
                <button class="btn" type="submit">Lọc</button>
                <a class="btn btn-outline" href="${pageContext.request.contextPath}/request/list">Reset</a>
        </div>
    </div>
</form>


<div class="table-responsive">
    <table class="table table-hover table-bordered align-middle">
        <thead class="table-light">
            <tr>
                <th style="width:70px;">ID</th>
                <th>Created By</th>
                <th>From</th>
                <th>To</th>
                <th>Reason</th>
                <th>Status</th>
                <th>Reject Reason</th> <!-- NEW -->
                <th>Processed By</th>
                <th style="width:90px;">Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="r" items="${rfls}">
                <tr>
                    <td>${r.id}</td>
                    <td>${r.created_by.name}</td>
                    <td>${r.from}</td>
                    <td>${r.to}</td>
                    <td class="text-truncate" style="max-width:200px;" title="${r.reason}">${r.reason}</td>
                    <td>
                        <c:choose>
                            <c:when test="${r.status eq 0}"><span class="badge badge-warn">Processing</span></c:when>
                            <c:when test="${r.status eq 1}"><span class="badge badge-ok">Approved</span></c:when>
                            <c:otherwise><span class="badge badge-bad">Rejected</span></c:otherwise>
                        </c:choose>
                    </td>

                    <!-- Hiển thị lý do nếu bị từ chối; dùng cả 2 tên field để tương thích (rejectReason hoặc reject_reason) -->
                    <td class="text-danger">
                        <c:if test="${r.status eq 2}">
                            ${ r.reject_reason }
                        </c:if>
                    </td>
                    <td><c:out value="${r.processed_by != null ? r.processed_by.name : ''}"/></td>

                    <td>
                        <!-- Chỉ hiện Review nếu là Head hoặc không phải đơn của chính mình -->
                        <c:if test="${isHead || r.created_by.id != sessionScope.auth.employee.id}">
                            <a href="${pageContext.request.contextPath}/request/review?rid=${r.id}"
                               class="btn btn-sm btn-outline-primary">Review</a>
                        </c:if>

                        <c:if test="${canEditRequest 
                                      and r.status == 2 
                                      and r.created_by.id == sessionScope.auth.employee.id}">
                              <!-- Edit & Resubmit -->
                        </c:if>

                    </td>


                </tr>
            </c:forEach>
        </tbody>
    </table>

</div>
