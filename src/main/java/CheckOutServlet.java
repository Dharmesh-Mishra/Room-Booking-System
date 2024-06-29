import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CheckOutServlet")
public class CheckOutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));

        String url = "jdbc:mysql://localhost:3306/hotel_management";
        String dbUsername = "root";
        String dbPassword = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);

            String updateBookingQuery = "UPDATE roombooking SET check_out_date = CURRENT_DATE() WHERE booking_id = ?";
            PreparedStatement updateBookingPs = con.prepareStatement(updateBookingQuery);
            updateBookingPs.setInt(1, bookingId);
            int rowsUpdatedBooking = updateBookingPs.executeUpdate();

            if (rowsUpdatedBooking > 0) {
               
                String updateRoomQuery = "UPDATE room SET status = 'Not booked' WHERE room_id = (SELECT room_id FROM roombooking WHERE booking_id = ?)";
                PreparedStatement updateRoomPs = con.prepareStatement(updateRoomQuery);
                updateRoomPs.setInt(1, bookingId);
                int rowsUpdatedRoom = updateRoomPs.executeUpdate();

                if (rowsUpdatedRoom > 0) {
                    request.setAttribute("checkOutSuccess", true); 
                } else {
                    request.setAttribute("checkOutSuccess", false); 
                    response.getWriter().println("Failed to update room status.");
                }
            } else {
                request.setAttribute("checkOutSuccess", false); 
                response.getWriter().println("Failed to check out.");
            }

            request.getRequestDispatcher("Guest.jsp").forward(request, response); // Forward to Guest.jsp
            con.close();
        } catch (ClassNotFoundException | SQLException e) {
            response.getWriter().println(e);
            e.printStackTrace();
        }
    }
}