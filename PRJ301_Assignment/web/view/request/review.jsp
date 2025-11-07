<%@ page contentType="text/html; charset=UTF-8" %>
<%
  request.setAttribute("pageTitle", "Duyệt đơn");
  request.setAttribute("content", "/view/request/review_content.jsp");
%>
<jsp:forward page="/view/layout/layout.jsp"/>
