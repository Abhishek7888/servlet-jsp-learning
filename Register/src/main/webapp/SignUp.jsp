<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>

    <!-- Compiled and minified CSS -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">

    <!-- jQuery FIRST -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Materialize JS AFTER jQuery -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
</head>

<body style="background: url('images/pexels-eberhardgross-12486830.jpg'); 
             background-size: cover; 
             background-attachment: fixed;">

    <div class="container">
        <div class="row">
            <div class="col m6 offset-m3">
                <div class="card-content">
                    <h1>Register here !!</h1>
                    <h5 id="msg" class="center-align"></h5>

                    <div class="form">
                        <!-- IMPORTANT: enctype added -->
                        <form action="Register" method="post" id="myform" enctype="multipart/form-data">
                            <input type="text" name="user_name" placeholder="Enter user name">
                            <input type="password" name="user_password" placeholder="Enter password" autocomplete="current-password">
                            <input type="email" name="user_email" placeholder="Enter user email">

                            <div class="file-field input-field">
                                <div class="btn">
                                    <span>File</span>
                                    <input type="file" name="image">
                                </div>
                                <div class="file-path-wrapper">
                                    <input class="file-path validate" type="text">
                                </div>
                            </div>

                            <button type="submit" class="btn purple lighten-2">Submit</button>
                        </form>
                    </div>

                    <!-- FIXED: center-align class -->
                    <div class="loader center-align" style="margin-top: 10px; display: none;">
                        <div class="preloader-wrapper small active">
                            <div class="spinner-layer spinner-green-only">
                                <div class="circle-clipper left"><div class="circle"></div></div>
                                <div class="gap-patch"><div class="circle"></div></div>
                                <div class="circle-clipper right"><div class="circle"></div></div>
                            </div>
                        </div>
                        <h5>Please wait..</h5>
                    </div>
                </div>
            </div>
        </div>
    </div>

   <script>
    $(document).ready(function () {
        console.log("Page Loaded");

        $("#myform").submit(function (event) {
            console.log("Submit Clicked");
            event.preventDefault();

            let formData = new FormData();

            // Append text fields
            formData.append("user_name", $("input[name='user_name']").val());
            formData.append("user_password", $("input[name='user_password']").val());
            formData.append("user_email", $("input[name='user_email']").val());

            // Append file explicitly
            let fileInput = $("input[name='image']")[0];
            if (fileInput.files.length > 0) {
                formData.append("image", fileInput.files[0]);
                console.log("File selected:", fileInput.files[0].name);
            } else {
                console.log("No file selected!");
            }

            $(".loader").show();
            $(".form").hide();

            $.ajax({
                url: "Register",
                type: "POST",
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    console.log("Success", response);

                    $(".loader").hide();
                    $(".form").show();

                    if (response.trim() === 'done') {
                        $('#msg').html("Successfully Registered !!")
                                 .removeClass("red-text")
                                 .addClass("green-text");
                    } else {
                        $('#msg').html("Something went wrong on server !!")
                                 .removeClass("green-text")
                                 .addClass("red-text");
                    }
                },
                error: function (xhr, status, error) {
                    console.log("Error", status, error);

                    $(".loader").hide();
                    $(".form").show();
                    $('#msg').html("Server Error !!")
                             .removeClass("green-text")
                             .addClass("red-text");
                }
            });
        });
    });
</script>

</body>
</html>
