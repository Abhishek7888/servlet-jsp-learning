<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page errorPage="error.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>Taglib Directives</h1>
	<br>
	<!-- Set a variable -->
	<c:set var="name" value="ABHI" />

	<!-- Output the variable -->
	<c:out value="${name}" />

	<%!
    int n1 = 20 ;
    int n2 = 0;
    %>
	<%
    int division = n1 / n2;
    %>
	<%=division %>
</body>
</html>
