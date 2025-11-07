<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("pageTitle", "Danh sách đơn");
    request.setAttribute("content", "/view/request/list_content.jsp");
%>
<jsp:forward page="/view/layout/layout.jsp"/>
