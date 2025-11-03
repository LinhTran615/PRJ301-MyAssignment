<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thông báo</title>
        <script>
            window.onload = function () {
                alert("${requestScope.message}");
                window.location.href = "list";
            };
        </script>
    </head>
    <body></body>
</html>
