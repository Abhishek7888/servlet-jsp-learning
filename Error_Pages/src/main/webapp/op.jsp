<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page errorPage="error.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Success Page</title>
</head>
<body>
	<%
	//fetach Two numbers
	String n1 = request.getParameter("n1");
	String n2 = request.getParameter("n2");

	//Converting String to Interger

	int a = Integer.parseInt(n1);
	int b = Integer.parseInt(n2);
	int c = a / b;
	%>
	<h2>
		Result is :
		<%=c%></h2>

</body>
</html>