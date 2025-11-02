<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Division Agenda</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                padding: 20px;
            }
            table {
                border-collapse: collapse;
                width: 100%;
                margin-top: 20px;
            }
            th, td {
                border: 1px solid #aaa;
                padding: 8px;
                text-align: center;
            }
            th {
                background-color: #f4f4f4;
            }
            .off {
                background-color: #f8d7da;
                color: #a94442;
            }
            .work {
                background-color: #d4edda;
                color: #155724;
            }
            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            .header form {
                display: flex;
                gap: 10px;
                align-items: center;
            }
            .header h2 {
                margin: 0;
            }
            tfoot td {
                font-weight: bold;
                background-color: #eee;
            }
        </style>
    </head>
    <body>
        <div class="header">
            <h2>Division Agenda</h2>
            <form method="GET" action="agenda">
                <label for="from">From:</label>
                <input type="date" name="from" id="from" value="${param.from}">
                <label for="to">To:</label>
                <input type="date" name="to" id="to" value="${param.to}">
                <button type="submit">View</button>
            </form>
        </div>

        <jsp:include page="../util/greeting.jsp"></jsp:include>

        <c:if test="${not empty dates}">
        <table>
            <thead>
                <tr>
                    <th>Employee</th>
            <c:forEach items="${dates}" var="d">
                <th>${d}</th>
            </c:forEach>
            <th>Total OFF Days</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${agenda}" var="row">
                <tr>
                    <td>${row.employee.name}</td>
                <c:forEach items="${row.statuses}" var="s">
                    <td class="${s eq 'OFF' ? 'off' : 'work'}">${s}</td>
                </c:forEach>
                <td>${row.totalOff}</td>
                </tr>
            </c:forEach>
            </tbody>

            <!-- ✅ Dòng tổng kết toàn phòng -->
            <tfoot>
                <tr>
                    <td colspan="${fn:length(dates) + 1}">Total OFF (All Employees)</td>
                    <td>
            <c:set var="totalSum" value="0" />
            <c:forEach items="${agenda}" var="row">
                <c:set var="totalSum" value="${totalSum + row.totalOff}" />
            </c:forEach>
            ${totalSum}
            </td>
            </tr>
            </tfoot>
        </table>
    </c:if>

    <c:if test="${empty dates}">
        <p>Please select a date range to view division agenda.</p>
    </c:if>
</body>
</html>
