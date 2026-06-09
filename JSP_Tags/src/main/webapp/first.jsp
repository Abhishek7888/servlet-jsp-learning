<%@page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/tlds/mytags.tld" prefix="t"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP Tags</title>
<style type="text/css">
* {
	margin: 0px;
	padding: 0px;
}
</style>
</head>
<body>
	<h1>First JSP Page!!</h1>
	<%-- JSP tags --%>
	<%!int a = 10;
	int b = 20;
	String name = "ABHI";

	public int doSum() {
		return a + b;
	}

	public String reverse() {
		StringBuffer br = new StringBuffer(name);
		return br.reverse().toString();
	}%>
	<%
	out.println(a);
	out.println("<br>");
	out.println(b);
	out.println("<br>");
	out.println("Sum is : " + doSum());
	%>

	<h1 style="color: blue;">
		Sum is :
		<%=doSum()%></h1>

	<h3 style="color: red;">
		Name is :
		<%=name%></h3>

	<%@include file="Header.jsp"%>
	<h1>
		Random Number :
		<%
	Random r = new Random();
	int n = r.nextInt(10);
	%>
		<%=n%>
	</h1>
	<a href="jstl.jsp">GO for Taglib Directive</a>

	<t:hello />
	<t:printTable number="5"/>
</body>
</html>