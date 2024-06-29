<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Guest Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 0;
        }
        
        h1 {
            text-align: center;
            color: #333;
        }
        
        .container {
            max-width: 400px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center; /* Center align the content */
        }
        
        button {
            padding: 10px 20px;
            margin: 5px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        button:hover {
            background-color: #ddd;
        }
        
        form {
            text-align: center;
            display: none;
        }
        
        form.active {
            display: block;
        }
        
        input[type="text"],
        input[type="password"],
        input[type="submit"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }
        
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        
        .login-image,
        .register-image {
            display: block;
            margin: auto;
            width: 300px;
            height: auto;
            border-radius: 10px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.2);
            margin-bottom: 20px;
        }
        .logout-container {
            text-align: right;
            margin-right: 20px;
            margin-top: 10px;
        }
        .button-container {
            display: flex;
            justify-content: center; /* Center align the buttons horizontally */
            margin-bottom: 20px; /* Add space below the buttons */
        }
    </style>
    <script>
        function showLoginForm() {
            document.getElementById("loginForm").classList.add("active");
            document.getElementById("registerForm").classList.remove("active");
        }
        
        function showRegisterForm() {
            document.getElementById("registerForm").classList.add("active");
            document.getElementById("loginForm").classList.remove("active");
        }
    </script>
</head>
<body>
<div class="logout-container">
        <a href="index.jsp">HOME</a>
    </div>
    <div class="container">
        <h1>Guest Login</h1>
        <div class="button-container">
            <button onclick="showLoginForm()">Login</button>
            <button onclick="showRegisterForm()">Register</button>
        </div>

        <form id="loginForm" action="LoginServlet" method="post">
            <input type="hidden" name="userType" value="guest">
            <img src="https://media.istockphoto.com/id/1200560730/vector/hotel-reception-lobby-cartoon-people-with-luggage-checking-in-with-staff.jpg?s=612x612&w=0&k=20&c=DjcXK-7-uj0MUmBD2bEeU6ijv03g_RbCnP8tMyDwYJ0=" alt="Guest Login" class="login-image">
            Email: <input type="text" name="email"><br>
            Password: <input type="password" name="password"><br>
            <input type="submit" value="Login">
        </form>
        
        <form id="registerForm" action="RegisterServlet" method="post">
            <input type="hidden" name="userType" value="guest">
            <img src="https://media.istockphoto.com/id/1200560730/vector/hotel-reception-lobby-cartoon-people-with-luggage-checking-in-with-staff.jpg?s=612x612&w=0&k=20&c=DjcXK-7-uj0MUmBD2bEeU6ijv03g_RbCnP8tMyDwYJ0=" alt="Guest Registration" class="register-image">
            Email: <input type="text" name="email"><br>
            Password: <input type="password" name="password"><br>
            Name: <input type="text" name="name"><br>
            Contact: <input type="text" name="contact"><br>
            <input type="submit" value="Register">
        </form>
    </div>
    <%-- Retrieve success message --%>
    <%
        String successMessage = (String) request.getAttribute("successMessage");
        if (successMessage != null && !successMessage.isEmpty()) {
    %>
    <script>
        alert('<%= successMessage %>');
    </script>
    <% } %>
</body>
</html>
