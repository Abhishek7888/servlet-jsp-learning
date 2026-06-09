<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isErrorPage="true"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sorry Something Went Wrong</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"
	integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N"
	crossorigin="anonymous">
</head>
<body>
	<div class="container p-3">
		<img src="<%=request.getContextPath()%>/image/404.jpg"
			class="img-fluid" width="500" height="300" />

		<h1 class="display-3">Sorry Something Went Wrong 404</h1>
		<a class="btn btn-outline-primary" href="index.jsp">Home Page</a>
	</div>
</body>
</html>