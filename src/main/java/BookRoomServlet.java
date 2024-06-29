import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/BookRoomServlet")
public class BookRoomServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String url = "jdbc:mysql://localhost:3306/hotel_management";
            String dbUsername = "root";
            String dbPassword = "root";

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);

            request.setAttribute("roomStatus101", getRoomStatus(con, 101));
            request.setAttribute("roomStatus102", getRoomStatus(con, 102));
            request.setAttribute("roomStatus103", getRoomStatus(con, 103));

            request.getRequestDispatcher("Guest.jsp").forward(request, response);
            con.close();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String roomIdString = request.getParameter("roomId");
        int roomId = Integer.parseInt(roomIdString);
        String checkInDate = request.getParameter("checkInDate");
        String checkOutDate = request.getParameter("checkOutDate");
        
        if (checkOutDate.compareTo(checkInDate) <= 0) {
            // Set error message and return
            request.setAttribute("bookingSuccess", false);
            request.setAttribute("errorMessage", "Check-out date must be after check-in date.");
            request.getRequestDispatcher("Guest.jsp").forward(request, response);
            return;
        }
        
        String url = "jdbc:mysql://localhost:3306/hotel_management";
        String dbUsername = "root";
        String dbPassword = "root";

        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);

            String currentStatus = getRoomStatus(con, roomId);

            if (!currentStatus.equals("Booked")) {
                String updateQuery = "UPDATE ROOM SET status = 'Booked' WHERE room_id = ?";
                PreparedStatement updatePs = con.prepareStatement(updateQuery);
                updatePs.setInt(1, roomId);
                int rowsUpdated = updatePs.executeUpdate();

                if (rowsUpdated > 0) {
                    String insertQuery = "INSERT INTO roombooking (user_email, room_id, check_in_date, check_out_date) VALUES (?, ?, ?, ?)";
                    PreparedStatement insertPs = con.prepareStatement(insertQuery);
                    insertPs.setString(1, userEmail);
                    insertPs.setInt(2, roomId);
                    insertPs.setString(3, checkInDate);
                    insertPs.setString(4, checkOutDate);
                    int rowsInserted = insertPs.executeUpdate();
 
                    if (rowsInserted > 0) {
                        request.setAttribute("bookingSuccess", true);

                        int roomPrice = getRoomPrice(con, roomId);
                        long numberOfDays = calculateNumberOfDays(checkInDate, checkOutDate);
                        double discount = calculateDiscount(numberOfDays, roomPrice);
                        int totalPrice = (int) (roomPrice * numberOfDays - discount  );

                        request.setAttribute("totalPrice", totalPrice);
                        request.setAttribute("discount", discount);
                    }
                    else {
                        request.setAttribute("bookingSuccess", false);
                        response.getWriter().println("Failed to book the room.");
                    }
                } else {
                    request.setAttribute("bookingSuccess", false);
                    response.getWriter().println("Failed to book the room.");
                }
            } else {
                request.setAttribute("bookingSuccess", false);
                response.getWriter().println("The room is already booked.");
            }

            request.setAttribute("roomStatus101", getRoomStatus(con, 101));
            request.setAttribute("roomStatus102", getRoomStatus(con, 102));
            request.setAttribute("roomStatus103", getRoomStatus(con, 103));

            request.getRequestDispatcher("Guest.jsp").forward(request, response);
            con.close();
        } catch (ClassNotFoundException | SQLException e) {
            response.getWriter().println(e);
            e.printStackTrace();
        }
    }

    private int getRoomPrice(Connection con, int roomId) throws SQLException {
        String selectQuery = "SELECT price FROM ROOM WHERE room_id = ?";
        PreparedStatement selectPs = con.prepareStatement(selectQuery);
        selectPs.setInt(1, roomId);
        ResultSet rs = selectPs.executeQuery();
        if (rs.next()) {
            return rs.getInt("price");
        }
        return 0; 
    }

    private long calculateNumberOfDays(String checkInDate, String checkOutDate) {
     
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate checkInLocalDate = LocalDate.parse(checkInDate, formatter);
        LocalDate checkOutLocalDate = LocalDate.parse(checkOutDate, formatter);

        return ChronoUnit.DAYS.between(checkInLocalDate, checkOutLocalDate);
    }
    private double calculateDiscount(long numberOfDays, int roomPrice) {
        double discount = 0.0;

        if (numberOfDays >= 7 && numberOfDays <= 14) {
            discount = 0.1; // 10% discount
        } else if (numberOfDays > 14) {
            discount = 0.2; // 20% discount
        }

        return discount * roomPrice * numberOfDays;
    }
    private String getRoomStatus(Connection con, int roomId) throws SQLException {
        String selectQuery = "SELECT status FROM ROOM WHERE room_id = ?";
        PreparedStatement selectPs = con.prepareStatement(selectQuery);
        selectPs.setInt(1, roomId);
        ResultSet rs = selectPs.executeQuery();
        if (rs.next()) {
            return rs.getString("status");
        }
        return "Not booked"; 
    }
}
