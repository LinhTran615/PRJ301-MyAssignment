<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Duyệt đơn xin nghỉ phép</title>
        <style>
            body {
                background-color: #e9f5ff;
                font-family: sans-serif;
                margin: 40px;
            }
            .form-container {
                background-color: #dbefff;
                padding: 20px;
                width: 400px;
                border-radius: 10px;
                border: 1px solid #a0c4ff;
            }
            textarea {
                width: 100%;
                height: 100px;
                margin-top: 10px;
                resize: none;
                font-size: 14px;
            }
            button {
                margin-top: 15px;
                width: 120px;
                padding: 10px;
                border-radius: 8px;
                font-weight: bold;
                border: none;
                cursor: pointer;
            }
            .approve {
                background-color: #4caf50;
                color: white;
            }
            .reject {
                background-color: #f44336;
                color: white;
                margin-left: 10px;
            }
        </style>
    </head>
    <body>
        <div class="form-container">
            <h3>Duyệt đơn xin nghỉ phép</h3>
            <p>Duyệt bởi User: <b>${sessionScope.auth.displayname}</b>,
                Role: <b>${sessionScope.auth.roles[0].name}</b></p>

            <p>Tạo bởi: <b>${requestLeave.created_by.name}</b></p>
            <p>Từ ngày: <b>${requestLeave.from}</b></p>
            <p>Tới ngày: <b>${requestLeave.to}</b></p>
            <p>Lý do:</p>
            <textarea readonly>${requestLeave.reason}</textarea>

            <form action="review" method="POST">
                <input type="hidden" name="rid" value="${requestLeave.id}" />
                <button type="submit" name="action" value="approve" class="approve">Approve</button>
                <button type="submit" name="action" value="reject" class="reject">Reject</button>
            </form>
        </div>
    </body>
</html>
