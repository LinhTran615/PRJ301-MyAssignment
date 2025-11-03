<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Division Agenda - LSM</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>

        <style>
            /* ====== RESET ====== */
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
                font-family: "Segoe UI", sans-serif;
            }

            body {
                display: flex;
                height: 100vh;
                background-color: #f5f7fa;
            }

            /* ====== SIDEBAR ====== */
            .sidebar {
                width: 240px;
                background-color: #ffffff;
                border-right: 1px solid #e0e0e0;
                padding: 20px;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .sidebar h2 {
                color: #1e88e5;
                font-weight: bold;
                margin-bottom: 40px;
                text-align: center;
            }

            .nav-link {
                display: block;
                text-decoration: none;
                color: #333;
                font-size: 16px;
                padding: 10px 15px;
                border-radius: 8px;
                transition: all 0.2s ease-in-out;
                margin-bottom: 10px;
            }

            .nav-link:hover,
            .nav-link.active {
                background-color: #1e88e5;
                color: #fff;
            }

            .logout-btn {
                margin-top: 30px;
                background-color: #e53935;
                color: #fff;
                text-align: center;
                padding: 10px;
                border-radius: 8px;
                text-decoration: none;
                transition: 0.2s;
            }

            .logout-btn:hover {
                background-color: #c62828;
            }

            /* ====== MAIN CONTENT ====== */
            .main {
                flex: 1;
                padding: 30px;
                overflow-y: auto;
            }

            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
            }

            .header h1 {
                color: #1e88e5;
                font-size: 26px;
            }

            .filter {
                background-color: #fff;
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                display: flex;
                align-items: center;
                gap: 20px;
                margin-bottom: 20px;
            }

            .filter input[type="date"] {
                border: 1px solid #ccc;
                border-radius: 6px;
                padding: 6px 10px;
            }

            .filter button {
                background-color: #1e88e5;
                color: #fff;
                border: none;
                padding: 8px 18px;
                border-radius: 6px;
                cursor: pointer;
                transition: 0.2s;
            }

            .filter button:hover {
                background-color: #1565c0;
            }

            /* ====== TABLE ====== */
            table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }

            thead {
                background-color: #1e88e5;
                color: white;
            }

            th, td {
                padding: 12px 16px;
                text-align: center;
                border-bottom: 1px solid #eee;
            }

            tbody tr:hover {
                background-color: #f1f9ff;
            }

            .summary {
                margin-top: 20px;
                font-weight: bold;
                color: #1e88e5;
            }
        </style>
    </head>
    <body>

        <!-- SIDEBAR -->
        <div class="sidebar">
            <div>
                <h2>LSM</h2>
                <a href="${pageContext.request.contextPath}/request/list" class="nav-link">Leave Requests</a>
                <a href="${pageContext.request.contextPath}/division/agenda" class="nav-link active">Division Agenda</a>
                <a href="${pageContext.request.contextPath}/request/create" class="nav-link">Create Request</a>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
        </div>

        <!-- MAIN CONTENT -->
        <div class="main">
            <div class="header">
                <h1>Division Agenda</h1>
                <div class="user-info">
                    <strong>${sessionScope.auth.displayname}</strong> 
                    (<span>${sessionScope.auth.employee.name}</span>)
                </div>
            </div>

            <!-- FILTER FORM -->
            <form class="filter" method="get" action="${pageContext.request.contextPath}/division/agenda">
                <label>From:</label>
                <input type="date" name="from" value="${fromDate}"/>

                <label>To:</label>
                <input type="date" name="to" value="${toDate}"/>

                <button type="submit">View</button>
            </form>

            <!-- TABLE -->
            <table>
                <thead>
                    <tr>
                        <th>Employee</th>
                        <th>From</th>
                        <th>To</th>
                        <th>Reason</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${rfls}" var="r">
                        <tr>
                            <td>${r.created_by.name}</td>
                            <td>${r.from}</td>
                            <td>${r.to}</td>
                            <td>${r.reason}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${r.status == 0}"><span style="color:#fb8c00;">Processing</span></c:when>
                                    <c:when test="${r.status == 1}"><span style="color:#43a047;">Approved</span></c:when>
                                    <c:when test="${r.status == 2}"><span style="color:#e53935;">Rejected</span></c:when>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="summary">
                Total requests: <c:out value="${fn:length(rfls)}"/>
            </div>
        </div>

    </body>
</html>
