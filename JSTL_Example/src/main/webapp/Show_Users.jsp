<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSTL SQL Tags</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"
	integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N"
	crossorigin="anonymous">
</head>
<body>
	<h1>All users are:</h1>
	<sql:setDataSource driver="com.mysql.jdbc.Driver"
		url="jdbc:mysql://localhost:3306/abhi" user="root" password="root"
		var="ds" />
	<sql:query dataSource="${ds }" var="rs">select * from user;</sql:query>
	<div class="container">
		<table class="table">
			<tr>
				<td>Id</td>
				<td>Name</td>
				<td>Email</td>
			</tr>
			<c:forEach items="${rs.rows }" var="row">
				<tr>
					<td><c:out value="${ row.id}"></c:out></td>
					<td><c:out value="${ row.name}"></c:out></td>
					<td><c:out value="${ row.email}"></c:out></td>

				</tr>
			</c:forEach>
		</table>
	</div>

</body>
</html>