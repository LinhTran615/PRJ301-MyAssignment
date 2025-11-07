<%
    request.setAttribute("pageTitle", "Home");
    request.setAttribute("content", "../home/home_content.jsp");
%>
<jsp:forward page="../layout/layout.jsp" />
