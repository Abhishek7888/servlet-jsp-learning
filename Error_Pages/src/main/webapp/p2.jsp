<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body style="background: lightgreen">
	<h1>This is Page 2</h1>
	<% 
		response.sendRedirect("https://www.google.com/");
		
	%>
</body>
</html>