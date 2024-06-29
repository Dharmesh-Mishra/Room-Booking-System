<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manager Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h1, h2 {
            text-align: center;
            color: #333;
        }

        .tabs {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }

        .tabs button {
            padding: 10px 20px;
            margin: 0 10px;
            border: none;
            background-color: transparent;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .tabs button:hover {
            background-color: #ddd;
        }

        .content {
            display: none;
        }

        .active {
            display: block;
        }

        .room-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between; /* Add space between rooms */
        }

        .room {
            width: calc(30% - 20px);
            margin-bottom: 20px;
            padding: 10px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.2);
            text-align: center;
        }

        .room img {
            width: 100%;
            height: 200px; /* Set a fixed height for all images */
            border-radius: 10px;
            margin-bottom: 10px;
        }

        .room h3 {
            margin-top: 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

.check-availability {
            text-align: center;
            margin-top: 20px;
            margin-bottom: 20px; /* Add space between button and rooms section */
        }

        .check-availability button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            background-color: #4CAF50;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .check-availability button:hover {
            background-color: #45a049;
        }        .logout-container {
            text-align: right;
            margin-right: 20px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="logout-container">
        <a href="index.jsp">Logout</a>
    </div>
    <h1>Manager Dashboard</h1>

    <div class="tabs">
        <button onclick="openTab('roomsTab')">Rooms</button>
        <button onclick="openTab('bookingsTab')">Bookings</button>
    </div>

    <div id="roomsTab" class="content active">
        <h2>Rooms</h2>
        <div class="check-availability">
            <form action="ManagerServlet" method="get">
                <button type="submit">Check Room Availability</button>
            </form>
        </div>
        <div class="room-container">
            <%-- Room 101 --%>
            <div class="room">
                <h3>Room 101</h3>
                <img src="https://www.riversidehotel.com.au/wp-content/uploads/2016/01/RH-12.jpg" alt="Room 101">
                <p>Type: Standard</p>
                <p>Price: Rs 5000</p>
                <p>Status: ${room101[1]}</p>
            </div>
            <%-- Room 102 --%>
            <div class="room">
                <h3>Room 102</h3>
                <img src="https://image-tc.galaxy.tf/wijpeg-afu0zj5rhmyyirzditj3g96mk/deluxe-room-king-1-2000px.jpg" alt="Room 102">
                <p>Type: Deluxe</p>
                <p>Price: Rs 7000</p>
                <p>Status: ${room102[1]}</p>
            </div>
            <%-- Room 103 --%>
            <div class="room">
                <h3>Room 103</h3>
                <img src="https://www.whitepearlnepal.com/images/subpackage/zIkJs-sdlx3.jpg" alt="Room 103">
                <p>Type: Super Deluxe</p>
                <p>Price: Rs 10000</p>
                <p>Status: ${room103[1]}</p>
            </div>
        </div>
        
    </div>

    <div id="bookingsTab" class="content">
        <h2>Bookings</h2>
        <table>
            <tr>
                <th>Booking ID</th>
                <th>User Email</th>
                <th>Room ID</th>
                <th>Check-in Date</th>
                <th>Check-out Date</th>
            </tr>
             <%
            String url = "jdbc:mysql://localhost:3306/hotel_management";
            String dbUsername = "root";
            String dbPassword = "root";
            String query = "SELECT rb.booking_id, u.email AS user_email, rb.room_id, rb.check_in_date, rb.check_out_date " +
                    "FROM roombooking rb " +
                    "JOIN users u ON rb.user_email = u.email " +
                    "ORDER BY rb.booking_id DESC " +
                    "LIMIT 10";

            try (Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);
                 PreparedStatement ps = con.prepareStatement(query);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    int bookingId = rs.getInt("booking_id");
                    String userEmail = rs.getString("user_email");
                    int roomId = rs.getInt("room_id");
                    Date checkInDate = rs.getDate("check_in_date");
                    Date checkOutDate = rs.getDate("check_out_date");
        %>
        <tr>
            <td><%= bookingId %></td>
            <td><%= userEmail %></td>
            <td><%= roomId %></td>
            <td><%= checkInDate %></td>
            <td><%= checkOutDate %></td>
        </tr>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        %>
        </table>
    </div>
</div>

<script>
    function openTab(tabName) {
        var i, x;
        x = document.getElementsByClassName("content");
        for (i = 0; i < x.length; i++) {
            x[i].style.display = "none";
        }
        document.getElementById(tabName).style.display = "block";
    }
</script>
</body>
</html>
