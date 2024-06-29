import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	PrintWriter out = response.getWriter();
    	out.println("RegisterServlet called");
        String userType = request.getParameter("userType");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String contact = request.getParameter("contact");

        String url = "jdbc:mysql://localhost:3306/hotel_management";
        String dbUsername = "root";
        String dbPassword = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);

            String query = "INSERT INTO users (email, password, name, contact, is_manager) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, name);
            ps.setString(4, contact);
            ps.setBoolean(5, userType.equals("manager") ? true : false);
            int rowsInserted = ps.executeUpdate();

            if (rowsInserted > 0) {
               
                request.setAttribute("successMessage", "Registration successful!");
                request.getRequestDispatcher("GuestLogin.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Registration Failed!");
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }
            con.close();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            out.println("ERROR"+ e);
        }
    }
}
