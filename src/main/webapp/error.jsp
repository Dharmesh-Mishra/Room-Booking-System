<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        h1 {
            text-align: center;
            color: #333;
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .logout-container {
            text-align: right;
            margin-right: 20px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div class="logout-container">
        <a href="index.jsp">Logout</a>
    </div>
    <h1>${errorMessage}</h1>
</body>
</html>
