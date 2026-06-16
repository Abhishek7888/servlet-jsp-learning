<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	X
	<h1>This is Function JSTL Tags Demo</h1>
	<c:set var="name" value="JSTL"></c:set>
	<c:out value="${name}"></c:out>
	<h1>
		The Length of name is
		<c:out value="${fn:length(name)}"></c:out>
		<br>
		<c:out value="${fn:toLowerCase(name)}"></c:out>
	</h1>
</body>
</html>