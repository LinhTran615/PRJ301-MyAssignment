<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div class="header">
    <div class="brand">
        <div class="logo">LSM</div>
        <div class="title">Leave System Management</div>
    </div>
    <div class="top-actions">
        <div style="color:#fff; font-weight:600; margin-right:8px;">
            <c:if test="${not empty sessionScope.auth}">
                ${sessionScope.auth.displayname}
            </c:if>
        </div>
        <div class="user-avatar">
            <c:choose>
                <c:when test="${not empty sessionScope.auth}">
                    ${fn:substring(sessionScope.auth.displayname,0,1)}
                </c:when>
                <c:otherwise>U</c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
