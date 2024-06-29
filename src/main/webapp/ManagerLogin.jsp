<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manager Login</title>
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
        }
        
        form {
            text-align: center;
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
        
        .logout-container {
            text-align: right;
            margin-right: 20px;
            margin-top: 10px;
        }

        .login-image {
            display: block;
            margin: auto;
            width: 300px; /* Set fixed width for the image */
            height: auto;
            border-radius: 10px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.2);
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="logout-container">
        <a href="index.jsp">HOME</a>
    </div>
    <div class="container">
        <h1>Manager Login</h1>
        <img src="https://e7.pngegg.com/pngimages/905/89/png-clipart-project-management-body-of-knowledge-project-manager-executive-manager-businessmanatdesk-angle-business.png" alt="Manager Login" class="login-image">
        <form action="LoginServlet" method="post">
            <input type="hidden" name="userType" value="manager">
            Email: <input type="text" name="email"><br>
            Password: <input type="password" name="password"><br>
            <input type="submit" value="Login">
        </form>
    </div>
</body>
</html>
