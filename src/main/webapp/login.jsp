<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    //? por si alguien llega directo a login.jsp
    String error = request.getParameter("error");
    String redirect = "index.jsp";
    if ("1".equals(error)) redirect = "index.jsp?error=1";
    response.sendRedirect(redirect);
%>
