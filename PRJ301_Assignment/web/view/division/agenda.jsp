<%@ page contentType="text/html; charset=UTF-8" %>
<%
  request.setAttribute("pageTitle", "Agenda phòng ban");
  request.setAttribute("content", "/view/division/agenda_content.jsp");
%>
<jsp:forward page="/view/layout/layout.jsp"/>
