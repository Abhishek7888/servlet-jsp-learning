<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- Compiled and minified CSS -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">

<!-- Compiled and minified JavaScript -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>

</head>

<body
	style="background: url('images/pexels-eberhardgross-12486830.jpg'); background-size: cover; background-attachment: fixed;">
	<div class="container">
		<div class="row">
			<div class="col m6 offset-m3">
				<div class="card-content">
					<h1>Register here !!</h1>
					<h5 id="msg" class="center-align"></h5>
					<div class="form">
						<form action="Register" method="post" id="myform">
							<input type="text" name="user_name" placeholder="Enter user name">
							<input type="password" name="user_password"
								placeholder="Enter password"> <input type="email"
								name="user_email" placeholder="Enter user email">
							<button type="submit" class="btn #ab47bc purple lighten-	">Submit</button>
						</form>
					</div>
					<div class="loader center align"
						style="margin-top: 10px; display: none">
						<div class="preloader-wrapper small active">
							<div class="spinner-layer spinner-green-only">
								<div class="circle-clipper left">
									<div class="circle"></div>
								</div>
								<div class="gap-patch">
									<div class="circle"></div>
								</div>
								<div class="circle-clipper right">
									<div class="circle"></div>
								</div>
							</div>
						</div>
						<h5>Please wait..</h5>
					</div>
				</div>
			</div>
		</div>
	</div>
<!-- jQuery FIRST -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Materialize JS AFTER jQuery -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>

<script>
$(document).ready(function() {

    console.log("Page Loaded");

    $("#myform").submit(function(event) {

        console.log("Submit Clicked");

        event.preventDefault();

        var formData = $(this).serialize();

        console.log("Form Data = " + formData);
        $(".loader").show();
        $(".form").hide();
 
        $.ajax({
            url: "Register",
            type: "POST", 
            data: formData,

            success: function(response) {
                console.log("Success");
                console.log(response);

                $(".loader").hide();
                $(".form").show();

                if(response.trim() === 'done') {
                    $('#msg').html("Successfully Registered !!");
                    $('#msg').addClass("green-text");
                } else {
                    $('#msg').html("Something went wrong on server !!");
                    $('#msg').addClass("red-text");
                }
            },

            error: function(xhr, status, error) {
                console.log("Error");
                console.log(status);
                console.log(error);

                $(".loader").hide();
                $(".form").show();

                $('#msg').html("Server Error !!");
                $('#msg').addClass("red-text");
            }
        });

    });

});
</script>

</body>

</html>