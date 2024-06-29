<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hotel Management System</title>
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
            max-width: 800px;
            margin: 0 auto;
            padding: 40px 20px; /* Increased top and bottom padding */
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        
        form {
            text-align: center;
            margin-top: 20px; /* Added margin to the top of forms */
        }
        
        input[type="submit"] {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        
        .hotel-image {
            display: block;
            margin: auto;
            width: 300px; /* Fixed width */
            height: 200px; /* Fixed height */
            border-radius: 10px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.2);
            margin-bottom: 20px; /* Added margin to the bottom of images */
        }
        
        .login-container {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap; /* Allow items to wrap if container width is not enough */
        }

        .login-section {
            flex: 1;
            padding: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
   <div class="container">
      <h1>Room Booking System</h1>

      <div class="login-container">
         <div class="login-section">
            <img src="https://e7.pngegg.com/pngimages/905/89/png-clipart-project-management-body-of-knowledge-project-manager-executive-manager-businessmanatdesk-angle-business.png" alt="Hotel Manager" class="hotel-image">
            <form action="RedirectServlet" method="post">
               <input type="hidden" name="userType" value="manager">
               <input type="submit" value="I am Manager">
            </form>
         </div>

         <div class="login-section">
            <img src="https://media.istockphoto.com/id/1200560730/vector/hotel-reception-lobby-cartoon-people-with-luggage-checking-in-with-staff.jpg?s=612x612&w=0&k=20&c=DjcXK-7-uj0MUmBD2bEeU6ijv03g_RbCnP8tMyDwYJ0=" alt="Hotel Guest" class="hotel-image">
            <form action="RedirectServlet" method="post">
               <input type="hidden" name="userType" value="guest">
               <input type="submit" value="I am a Guest">
            </form>
         </div>
      </div>
   </div>
</body>
</html>
