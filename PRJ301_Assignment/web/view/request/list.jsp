<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
<jsp:include page="../layout/header.jsp" />
<div class="app">
    <jsp:include page="../layout/sidebar.jsp" />
    <div class="main">
        <div class="card">
            <h2>Danh sách đơn xin nghỉ phép</h2>
            <jsp:include page="../util/greeting.jsp" />
            <table class="table">
                <thead>
                    <tr>
                        <th>Request ID</th>
                        <th>Created by</th>
                        <th>Reason</th>
                        <th>From</th>
                        <th>To</th>
                        <th>Status</th>
                        <th>Processed by</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${requestScope.rfls}" var="r">
                        <tr>
                            <td>${r.id}</td>
                            <td>${r.created_by.name}</td>
                            <td>${r.reason}</td>
                            <td>${r.from}</td>
                            <td>${r.to}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${r.status eq 0}">
                                        <span class="badge processing">Processing</span>
                                    </c:when>
                                    <c:when test="${r.status eq 1}">
                                        <span class="badge approved">Approved</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge rejected">Rejected</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${r.processed_by ne null}">
                                        ${r.processed_by.name}
                                        <c:if test="${r.created_by.id ne sessionScope.auth.employee.id}">
                                            , you can change it to
                                            <a href="${pageContext.request.contextPath}/request/review?rid=${r.id}"> 
                                                <c:choose>
                                                    <c:when test="${r.status eq 1}">Rejected</c:when>
                                                    <c:when test="${r.status eq 2}">Approved</c:when>
                                                </c:choose>
                                            </a>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="btn" href="${pageContext.request.contextPath}/request/review?rid=${r.id}&action=approve">Approve</a>
                                        <a class="btn btn-danger" href="${pageContext.request.contextPath}/request/review?rid=${r.id}&action=reject">Reject</a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <jsp:include page="../layout/footer.jsp" />
    </div>
</div>
