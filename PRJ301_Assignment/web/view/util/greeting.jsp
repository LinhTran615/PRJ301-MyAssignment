<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div style="margin-bottom:8px; color:#666;">
    <c:if test="${sessionScope.auth ne null}">
        Session of: <strong>${sessionScope.auth.displayname}</strong> ? employee: <strong>${sessionScope.auth.employee.id} - ${sessionScope.auth.employee.name}</strong>
    </c:if>
</div>
