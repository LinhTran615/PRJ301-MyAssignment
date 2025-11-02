<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gửi thành công</title>
        <script>
            // Hiện popup xác nhận, sau đó chuyển hướng
            window.onload = function () {
                alert("${requestScope.message}");
                window.location.href = "list"; // tự động quay lại danh sách
            }
        </script>
    </head>
    <body>
    </body>
</html>
