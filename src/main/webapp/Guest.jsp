<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter" %>

<%!
    public static boolean isCheckedOut(String checkOutDate) {
        if (checkOutDate == null) {
            return false; // If check-out date is null, the guest hasn't checked out yet
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate checkOutLocalDate = LocalDate.parse(checkOutDate, formatter);
        LocalDate currentDate = LocalDate.now();

        return checkOutLocalDate.isBefore(currentDate) || checkOutLocalDate.isEqual(currentDate); // Return true if check-out date is before or equal to the current date
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Guest Room Booking</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 800px;
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

        form {
            display: inline;
        }

        input[type="submit"],
        button {
            padding: 8px 16px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover,
        button:hover {
            background-color: #45a049;
        }

        input[type="date"] {
            padding: 6px;
            border-radius: 5px;
            border: 1px solid #ccc;
            width: 150px;
        }

        input:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }

        .logout-container {
            text-align: right;
            margin-right: 20px;
            margin-top: 10px;
        }

        .tab {
            overflow: hidden;
            border: 1px solid #ccc;
            background-color: #f1f1f1;
            margin-bottom: 20px;
        }

        .tab button {
            background-color: inherit;
            float: left;
            border: none;
            outline: none;
            cursor: pointer;
            padding: 14px 16px;
            transition: 0.3s;
        }

        .tab button:hover {
            background-color: #ddd;
        }

        .tab button.active {
            background-color: #ccc;
        }

        .tabcontent {
            display: none;
            padding: 6px 12px;
            border: 1px solid #ccc;
            border-top: none;
        }

        .room-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
        }

        .room {
            width: calc(33.33% - 20px);
            margin-bottom: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
        }

        .room img {
            width: 100%;
            border-radius: 10px;
            margin-bottom: 10px;
            flex-grow: 1;
        }

        .about-us-container {
            margin-bottom: 20px;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .about-us {
            text-align: center;
            margin-bottom: 20px;
        }

        .about-us p {
            color: #555;
            line-height: 1.6;
        }

        .map-container {
            margin-bottom: 20px;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .map {
            text-align: center;
        }

        .contact-details {
            text-align: center;
            margin-bottom: 20px;
        }

        .contact-details p {
            color: #555;
            line-height: 1.6;
        }

    </style>
</head>
<script>
  
function showAlert(message) {
    alert(message);
}

function openTab(tabName) {
    var tabcontent = document.getElementsByClassName("tabcontent");
    for (var i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }

    var tablinks = document.getElementsByClassName("tablinks");
    for (var i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }

    document.getElementById(tabName).style.display = "block";
    event.currentTarget.className += " active";
}

function disablePastDates() {
    var checkInDateInput = document.querySelectorAll('input[name="checkInDate"]');
    var checkOutDateInput = document.querySelectorAll('input[name="checkOutDate"]');
    var today = new Date().toISOString().split('T')[0];

    checkInDateInput.forEach(function(input) {
        input.min = today;
    });

    checkOutDateInput.forEach(function(input) {
        input.min = today;
    });
}

function updateCheckOutDateRange(roomId) {
    var checkInDateInput = document.querySelector(`form input[name="checkInDate"][value="${roomId}"]`);
    var checkOutDateInput = document.querySelector(`form input[name="checkOutDate"][value="${roomId}"]`);

    var checkInDate = new Date(checkInDateInput.value);
    var checkOutDate = new Date(checkOutDateInput.value);
    var today = new Date();

    
    if (checkInDate <= today) {
        var minCheckOutDate = new Date(today.getTime() + (1000 * 3600 * 24));
        checkOutDateInput.min = minCheckOutDate.toISOString().split('T')[0];
    } else {
        checkOutDateInput.min = checkInDateInput.value;
    }
    if (checkOutDate < checkInDate) {
        checkOutDateInput.value = checkInDateInput.value;
    }
}

document.querySelectorAll('input[name="checkInDate"]').forEach(function(checkInDateInput) {
    checkInDateInput.addEventListener('change', function() {
       
        var roomId = this.value;

        updateCheckOutDateRange(roomId);
    });
});

document.querySelectorAll('input[name="checkOutDate"]').forEach(function(checkOutDateInput) {
    checkOutDateInput.addEventListener('change', function() {
        var roomId = this.value;

        updateCheckOutDateRange(roomId);
    });
});

function displayTotalPrice(totalPrice, discount) {
    var message;
    if (discount > 0) {
        message = "Room booked successfully! Total Price: Rs " + totalPrice + " (Discount Applied: Rs " + discount + ")";
    } else {
        message = "Room booked successfully! Total Price: Rs " + totalPrice;
    }
    showAlert(message);
}

window.onload = disablePastDates;
</script>
<body>
<div class="logout-container">
    <a href="index.jsp">Logout</a>
</div>
<div class="container">
    <div class="tab">
        <button class="tablinks active" onclick="openTab('AboutUsTab')">About Us</button>
        <button class="tablinks" onclick="openTab('AllRoomsTab')">All Rooms</button>
        <button class="tablinks" onclick="openTab('MyBookingsTab')">My Bookings</button>
    </div>

    <!-- About Us Tab -->
    <div id="AboutUsTab" class="tabcontent" style="display: block;">
        <div class="about-us-container">
            <h2 class="about-us">About Us</h2>
            <p>Welcome to our Hotel Management System! We are dedicated to providing exceptional service and ensuring that your stay with us is comfortable and memorable. Our team is committed to meeting your needs and exceeding your expectations. Whether you're here for business or leisure, we strive to create a welcoming environment where you can relax and enjoy your time. We look forward to serving you and making your stay unforgettable.</p>
        </div>

        <!-- Map and Contact Details -->
        <div class="map-container">
            <h2 class="map">Our Location</h2>
            <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d30154.333632829483!2d72.80480730668847!3d19.138704396878857!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3be7b618b6d891dd%3A0x91f8a857c731d132!2sAndheri%20West%2C%20Mumbai%2C%20Maharashtra%20400047!5e0!3m2!1sen!2sin!4v1695268561134!5m2!1sen!2sin" width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
        </div>

        <div class="contact-details">
            <h2>Contact Details</h2>
            <p>Munshi Nagar, Andheri (West)<br>Mumbai, Maharashtra, India</p>
            <p>Phone: +91 9876543210<br>Monday to Saturday 10AM to 8PM</p>
            <p>Email: info@hotelmanagement.com</p>
        </div>
    </div>

    <div id="AllRoomsTab" class="tabcontent">
        <h2>Available Rooms</h2>
        <form action="BookRoomServlet" method="get">
            <button type="submit">Check Availability</button>
        </form>
       <div class="room-container">
    <div class="room">
        <img src="https://www.riversidehotel.com.au/wp-content/uploads/2016/01/RH-12.jpg" alt="Room 101">
        <h3>Room ID: 101</h3>
        <p>Type: Standard</p>
        <p>Price: Rs 5000</p>
        <p>Status: ${empty roomStatus101 ? "Not booked" : roomStatus101}</p>
       
        <form action="BookRoomServlet" method="post">
            <input type="hidden" name="roomId" value="101">
            Check-in: <input type="date" name="checkInDate" required ${(empty roomStatus101 || roomStatus101 == 'Not booked') ? '' : 'disabled'} onchange="calculateTotal(101, 5000); updateCheckOutDateRange(101)">
            Check-out: <input type="date" name="checkOutDate" required ${(empty roomStatus101 || roomStatus101 == 'Not booked') ? '' : 'disabled'} onchange="calculateTotal(101, 5000)">
            <input type="submit" value="Book" ${(empty roomStatus101 || roomStatus101 == 'Not booked') ? '' : 'disabled'}>
        </form>
    </div>
    <div class="room">
        <img src="https://image-tc.galaxy.tf/wijpeg-afu0zj5rhmyyirzditj3g96mk/deluxe-room-king-1-2000px.jpg" alt="Room 102">
        <h3>Room ID: 102</h3>
        <p>Type: Deluxe</p>
        <p>Price: Rs 7000</p>
        <p>Status: ${empty roomStatus102 ? "Not booked" : roomStatus102}</p>
        
        <form action="BookRoomServlet" method="post">
            <input type="hidden" name="roomId" value="102">
            Check-in: <input type="date" name="checkInDate" required ${(empty roomStatus102 || roomStatus102 == 'Not booked') ? '' : 'disabled'} onchange="calculateTotal(102, 7000); updateCheckOutDateRange(102)">
            Check-out: <input type="date" name="checkOutDate" required ${(empty roomStatus102 || roomStatus102 == 'Not booked') ? '' : 'disabled'} onchange="calculateTotal(102, 7000)">
            <input type="submit" value="Book" ${(empty roomStatus102 || roomStatus102 == 'Not booked') ? '' : 'disabled'}>
        </form>
    </div>
    <div class="room">
        <img src="https://www.whitepearlnepal.com/images/subpackage/zIkJs-sdlx3.jpg" alt="Room 103">
        <h3>Room ID: 103</h3>
        <p>Type: Super Deluxe</p>
        <p>Price: Rs 10000</p>
        <p>Status: ${empty roomStatus103 ? "Not booked" : roomStatus103}</p>
        
        <form action="BookRoomServlet" method="post">
            <input type="hidden" name="roomId" value="103">
            Check-in: <input type="date" name="checkInDate" required ${(empty roomStatus103 || roomStatus103 == 'Not booked') ? '' : 'disabled'} onchange="calculateTotal(103, 10000); updateCheckOutDateRange(103)">
            Check-out: <input type="date" name="checkOutDate" required ${(empty roomStatus103 || roomStatus103 == 'Not booked') ? '' : 'disabled'} onchange="calculateTotal(103, 10000)">
            <input type="submit" value="Book" ${(empty roomStatus103 || roomStatus103 == 'Not booked') ? '' : 'disabled'}>
        </form>
    </div>
</div>
<%
    Boolean bookingSuccess = (Boolean) request.getAttribute("bookingSuccess");
    if (bookingSuccess != null && bookingSuccess) {
        
%>
<script>
    showAlert("Room booked successfully!");
    <% Integer totalPrice = (Integer) request.getAttribute("totalPrice"); %>
    <% Double discount = (Double) request.getAttribute("discount"); %>
    <% if (totalPrice != null && discount != null) { %>
        displayTotalPrice(<%= totalPrice %>, <%= discount %>);
    <% } %>
</script>
<%
    } else if (bookingSuccess != null && !bookingSuccess) {
        
%>
<script>showAlert("Failed to book the room.");</script>
<%
    }
%>
<%
Boolean bookingSuccess1 = (Boolean) request.getAttribute("bookingSuccess");
if (bookingSuccess1 != null && !bookingSuccess1) {
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage != null && !errorMessage.isEmpty()) {
%>
<script>showAlert("<%= errorMessage %>");</script>
<%
    } else {
%>
<script>showAlert("Failed to book the room.");</script>
<%
    }
}
%>

</div>

    <div id="MyBookingsTab" class="tabcontent">
        <h2>My Bookings</h2>
        <table>
            <tr>
                <th>Booking ID</th>
                <th>Room ID</th>
                <th>Check-in Date</th>
                <th>Check-out Date</th>
                <th>Action</th>
            </tr>
             <%
                 try {
                    String userEmail = (String) session.getAttribute("userEmail");
                    String url = "jdbc:mysql://localhost:3306/hotel_management";
                    String dbUsername = "root";
                    String dbPassword = "root";

                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);

                    String selectQuery = "SELECT * FROM roombooking WHERE user_email = ?";
                    PreparedStatement selectPs = con.prepareStatement(selectQuery);
                    selectPs.setString(1, userEmail);
                    ResultSet rs = selectPs.executeQuery();

                    while (rs.next()) {
                        int bookingId = rs.getInt("booking_id");
                        int roomId = rs.getInt("room_id");
                        String checkInDate = rs.getString("check_in_date");
                        String checkOutDate = rs.getString("check_out_date");

                        boolean enableCheckOut = !isCheckedOut(checkOutDate); // Call the isCheckedOut method
            %>
            <tr>
                <td><%= bookingId %></td>
                <td><%= roomId %></td>
                <td><%= checkInDate %></td>
                <td><%= checkOutDate != null ? checkOutDate : "Not checked out yet" %></td>
                <td>
                    <% if (enableCheckOut) { %>
                    <!-- Show the Check Out button only if not checked out -->
                    <form action="CheckOutServlet" method="post">
                        <input type="hidden" name="bookingId" value="<%= bookingId %>">
                        <input type="submit" value="Check Out">
                    </form>
                    <% } else { %>
                    <!-- Show a message if already checked out -->
                    Already checked out
                    <% } %>
                </td>
            </tr>
            <%
                        Boolean checkOutSuccess = (Boolean) request.getAttribute("checkOutSuccess");
                        if (checkOutSuccess != null && checkOutSuccess) {
              
            %>
            <script>showAlert("Checked out successfully!");</script>
            <%
                            enableCheckOut = false;
                        } else if (checkOutSuccess != null && !checkOutSuccess) {
             
            %>
            <script>showAlert("Failed to check out.");</script>
            <%
                        }
                    }
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </table>
    </div>
</div>
</body>
</html>
