<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSTL Example</title>
</head>
<body>
	<h1>This is JSTL Example</h1>
	<c:set var="i" value="10" scope="application"></c:set>

	<h1>
		<c:out value="${i}"></c:out>
	</h1>
	<c:remove var="i" />
	<h2>
		<c:out value="${i}">This is default Value</c:out>
	</h2>
	<h2>
		<c:if test="${i==10 }">
			<h2>True</h2>
		</c:if>
	</h2>
	<c:set var="i" value="10" scope="application"></c:set>
	<c:choose>
		<c:when test="${i>0 }">
			<h2>Number is Positive</h2>
		</c:when>
		<c:when test="${i<0 }">
			<h2>Number is Negative</h2>
		</c:when>
		<c:otherwise>
			<h3>The Number is 0.</h3>
		</c:otherwise>
	</c:choose>

	<c:forEach var="j" begin="1" end="10">
		<h3>
			<c:out value="${j }"></c:out>
		</h3>
	</c:forEach>

	<!--	<c:redirect url="https://www.google.com"></c:redirect>-->

	<c:url var="myurl" value="www.google.com/search">
		<c:param name="q" value="This is test page"></c:param>
	</c:url>

	<h1>
		<c:out value="${myurl }"></c:out>
	</h1>
</body>
</html>