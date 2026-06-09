<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Erro page Module</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"
	integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N"
	crossorigin="anonymous">
</head>
<body>
	<form action="op.jsp">
		<div class="container"></div>
		<div class="row">
			<div class="col-md-6 offset-md-3">
				<div class="card">
					<div class="card-header bg-dark text-white">
						<h3>Enter numbers to add</h3>
					</div>
					<div class="card-body bg-secondary">
						<div class="form-group">
							<input type="number" class="form-control" placeholder="Enter n1" name="n1">
						</div>
						<div class="form-group">
							<input type="number" class="form-control" placeholder="Enter n2"  name="n2">
						</div>

					</div>
					<div class="card-footer text-center bg-dark text-white">
						<button type="submit" class="btn btn-outline-light">Divide</button>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>