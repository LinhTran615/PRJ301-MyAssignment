<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đơn xin nghỉ phép</title>
        <style>
            body {
                font-family: "Segoe UI", sans-serif;
                background-color: #f5f5f5;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }
            .leave-form {
                background-color: #fde5d2;
                border: 1px solid #ccc;
                border-radius: 8px;
                padding: 24px 32px;
                width: 420px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }
            h2 {
                text-align: center;
                margin-top: 0;
                color: #333;
            }
            .info {
                font-size: 15px;
                margin-bottom: 16px;
            }
            label {
                display: block;
                margin-top: 8px;
                font-weight: 500;
            }
            input[type="date"] {
                width: 100%;
                padding: 6px;
                margin-top: 4px;
                box-sizing: border-box;
            }
            textarea {
                width: 100%;
                height: 100px;
                padding: 8px;
                resize: none;
                box-sizing: border-box;
                margin-top: 4px;
            }
            .submit-btn {
                display: block;
                background-color: #4A7BFE;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                margin: 20px auto 0;
                font-size: 16px;
                cursor: pointer;
            }
            .submit-btn:hover {
                background-color: #3c68dc;
            }
        </style>
    </head>
    <body>

        <div class="leave-form">
            <h2>Đơn xin nghỉ phép</h2>

            <div class="info">
                <c:if test="${sessionScope.auth ne null}">
                    User: <b>${sessionScope.auth.displayname}</b>,
                    Role: 
                    <c:choose>
                        <c:when test="${!empty sessionScope.auth.roles}">
                            ${sessionScope.auth.roles[0].name}
                        </c:when>
                        <c:otherwise>Chưa có</c:otherwise>
                    </c:choose>,
                    Dep: 
                    <c:choose>
                        <c:when test="${sessionScope.auth.employee.dept ne null}">
                            ${sessionScope.auth.employee.dept.name}
                        </c:when>
                        <c:otherwise>Chưa rõ</c:otherwise>
                    </c:choose>
                </c:if>
            </div>

            <form action="create" method="post">
                <label for="from">Từ ngày:</label>
                <input type="date" name="from" id="from" required>

                <label for="to">Tới ngày:</label>
                <input type="date" name="to" id="to" required>

                <label for="reason">Lý do:</label>
                <textarea name="reason" id="reason" placeholder="Nhập lý do xin nghỉ..." required></textarea>

                <input type="submit" value="Gửi" class="submit-btn">
            </form>
        </div>

    </body>
</html>
