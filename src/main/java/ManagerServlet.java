import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ManagerServlet")
public class ManagerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Object[] room101 = getRoomAvailabilityFromDatabase(101);
        Object[] room102 = getRoomAvailabilityFromDatabase(102);
        Object[] room103 = getRoomAvailabilityFromDatabase(103);


        request.setAttribute("room101", room101);
        request.setAttribute("room102", room102);
        request.setAttribute("room103", room103);
        request.getRequestDispatcher("/BookingServlet").include(request, response);

        request.getRequestDispatcher("Manager.jsp").forward(request, response);
    }

    private Object[] getRoomAvailabilityFromDatabase(int roomId) {
        Object[] roomInfo = new Object[2]; 
        String url = "jdbc:mysql://localhost:3306/hotel_management";
        String dbUsername = "root";
        String dbPassword = "root";
        String query = "SELECT status FROM room WHERE room_id = ?";

        try (Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    roomInfo[0] = roomId;
                    roomInfo[1] = rs.getString("status");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return roomInfo;
    }
}
