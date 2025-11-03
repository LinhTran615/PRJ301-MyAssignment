<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chọn đơn để duyệt</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                padding: 20px;
            }
            table {
                border-collapse: collapse;
                width: 100%;
                margin-top: 10px;
            }
            th, td {
                border: 1px solid #ccc;
                padding: 8px;
                text-align: left;
            }
            th {
                background: #f2f2f2;
            }
            a {
                margin-right: 8px;
                text-decoration: none;
                color: #0077cc;
            }
            a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <jsp:include page="../util/greeting.jsp"></jsp:include>

            <h2>Chọn đơn để duyệt</h2>
            <p>Bạn vừa truy cập trang review mà không có ID đơn. Hãy chọn một đơn bên dưới để xem chi tiết.</p>

        <c:if test="${empty rfls}">
        <p><i>Không có đơn nào thuộc quyền của bạn.</i></p>
        <a href="list">Trở về danh sách</a>
    </c:if>

    <c:if test="${not empty rfls}">
        <table>
            <tr>
                <th>Request ID</th>
                <th>Created by</th>
                <th>Reason</th>
                <th>From</th>
                <th>To</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            <c:forEach items="${rfls}" var="r">
                <tr>
                    <td>${r.id}</td>
                    <td>${r.created_by.name}</td>
                    <td>${r.reason}</td>
                    <td>${r.from}</td>
                    <td>${r.to}</td>
                    <td>
                        ${r.status eq 0 ? "processing" :
                          (r.status eq 1 ? "approved" : "rejected")}
                    </td>
                    <td>
                        <a href="review?rid=${r.id}&action=approve">Approve</a>
                        <a href="review?rid=${r.id}&action=reject">Reject</a>
                        <a href="review?rid=${r.id}">View</a>
                    </td>
                </tr>
            </c:forEach>
        </table>
        <br/>
        <a href="list">⬅ Quay lại danh sách</a>
    </c:if>
</body>
</html>
