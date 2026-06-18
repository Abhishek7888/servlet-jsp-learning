<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register Page</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"
	integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N"
	crossorigin="anonymous">
<link href="css/mystyle.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
	<%@include file="normal_navbar.jsp"%>
	<main class="primary-background">
		<div class="container">
			<div class="col-md-6 offset-md-3">
				<div class="card">
					<div class="card-header text-center">
						<span class="fa fa-user-circle"></span> <br> Register Here..
					</div>
					<div class="card-body">
						<form action="RegisterServlet" method="POST" id="reg">
							<div class="form-group">
								<label for="exampleInputEmail1">User Name</label> <input
									type="text" class="form-control" id="user_name"
									name="user_name" placeholder="Enter User Name">
								<div class="form-group">
									<label for="exampleInputEmail1">Email address</label> <input
										type="email" class="form-control" id="exampleInputEmail1"
										name="user_email" aria-describedby="emailHelp"> <small
										id="emailHelp" class="form-text text-muted">We'll
										never share your email with anyone else.</small>
								</div>
								<div class="form-group">
									<label for="exampleInputPassword1">Password</label> <input
										type="password" class="form-control"
										id="exampleInputPassword1" name="user_password">
								</div>
								<div class="form-group">
									<label for="gender">Gender</label> <br> <input
										type="radio" id="gender" name="user_gender">Male <input
										type="radio" id="gender" name="user_gender">Female
								</div>
								<div class="form-group">
									<textarea class="form-control" name="about" id="" rows="5"
										placeholder="Enter something about yourself"></textarea>
								</div>
								<div class="form-group form-check">
									<input type="checkbox" class="form-check-input"
										id="exampleCheck1" name="check"> <label
										class="form-check-label" for="exampleCheck1">Agree
										terms and conditions</label>
								</div>
								<br>
								<div class="container text-center" id="loader"
									style="display: none">
									<span class="fa fa-refresh fa-spin fa-2x"></span>
									<h4>Please wait..</h4>
								</div>
								<button id="sumbmit-btn" type="submit" class="btn btn-primary">Submit</button>
						</form>
					</div>
					<div class="card-footer"></div>
				</div>
			</div>
		</div>
	</main>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-Fy6S3B9q64WdZWQUiU+q4/2Lc9npb8tCaSX9FK7E8HnRr0Jz8D6OP9dO5Vg3Q9ct"
		crossorigin="anonymous"></script>
	<script src="https://code.jquery.com/jquery-4.0.0.min.js"
		integrity="sha256-OaVG6prZf4v69dPg6PhVattBXkcOWQB62pdZ3ORyrao="
		crossorigin="anonymous"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert2/11.23.0/sweetalert2.min.js"
		integrity="sha512-pnPZhx5S+z5FSVwy62gcyG2Mun8h6R+PG01MidzU+NGF06/ytcm2r6+AaWMBXAnDHsdHWtsxS0dH8FBKA84FlQ=="
		crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<script>
$(document).ready(function() {
    console.log("loaded.");

    $('#reg').on('submit', function(event) {
        event.preventDefault();

        let form = new FormData(this);

        $("#submit").hide();
        $("#loader").show();

        $.ajax({
            url: "RegisterServlet",
            type: "POST",
            data: form,
            processData: false,
            contentType: false,
            success: function(data, textStatus, jqXHR) {
                console.log("Response:", data);
                $("#submit").show();
                $("#loader").hide();

                if (data.trim() === 'done') {
                	  Swal.fire({
                	    title: "Registered Successfully!",
                	    text: "We are redirecting to login page",
                	    icon: "success",
                	    position: "center",
                	    showConfirmButton: true,
                	    confirmButtonText: "Go to Login",
                	    allowOutsideClick: false
                	  }).then(() => {
                	    window.location.href = "login_page.jsp";
                	  });
                	} else {
                	  Swal.fire({
                	    title: "Error",
                	    text: "Box not checked!",
                	    icon: "error",
                	    position: "center",
                	    confirmButtonText: "OK"
                	  });
                	}
            },   // ✅ comma here
            error: function(jqXHR, textStatus, errorThrown) {
                console.log("AJAX error:", textStatus, errorThrown);
                $("#submit").show();
                $("#loader").hide();
                Swal.fire({
                    title: "Error",
                    text: "Something went wrong",
                    icon: "error"
                });
            }
        });
    });
});
</script>
</body>
</html>