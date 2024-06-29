import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<BookingData> bookingDataList = fetchBookingData();
        request.setAttribute("bookingDataList", bookingDataList);
        request.getRequestDispatcher("Manager.jsp").forward(request, response);
    }

    private List<BookingData> fetchBookingData() {
        List<BookingData> bookingDataList = new ArrayList<>();
        String url = "jdbc:mysql://localhost:3306/hotel_management";
        String dbUsername = "root";
        String dbPassword = "root";
        String query = "SELECT rb.booking_id, u.email AS user_email, rb.room_id, rb.check_in_date, rb.check_out_date " +
                "FROM roombooking rb " +
                "JOIN users u ON rb.user_email = u.email " +
                "ORDER BY rb.booking_id DESC " +
                "LIMIT 50"; 

        try (Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int bookingId = rs.getInt("booking_id");
                String userEmail = rs.getString("user_email");
                int roomId = rs.getInt("room_id");
                Date checkInDate = rs.getDate("check_in_date");
                Date checkOutDate = rs.getDate("check_out_date");
                BookingData bookingData = new BookingData(bookingId, userEmail, roomId, checkInDate, checkOutDate);
                bookingDataList.add(bookingData);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookingDataList;
    }

    private static class BookingData {
        private int bookingId;
        private String userEmail;
        private int roomId;
        private Date checkInDate;
        private Date checkOutDate;

        public BookingData(int bookingId, String userEmail, int roomId, Date checkInDate, Date checkOutDate) {
            this.bookingId = bookingId;
            this.userEmail = userEmail;
            this.roomId = roomId;
            this.checkInDate = checkInDate;
            this.checkOutDate = checkOutDate;
        }

       
    }
}