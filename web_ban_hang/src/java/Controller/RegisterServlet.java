package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    // Do not change this code
    private static final String DB_NAME = "PRJ301_WEB_BAN_HANG";
    private static final String DB_USER_NAME = "SA";
    private static final String DB_PASSWORD = "12345";

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Connection conn = null;
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://localhost:1433;databaseName=" + DB_NAME;
        conn = DriverManager.getConnection(url, DB_USER_NAME, DB_PASSWORD);
        return conn;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String customerName = request.getParameter("customerName");
        String customerPhone = request.getParameter("customerPhone");
        String customerEmail = request.getParameter("customerEmail");
        String customerAddress = request.getParameter("customerAddress");

        // Kiểm tra dữ liệu bắt buộc
        if (username == null || password == null || customerName == null || customerPhone == null ||
            username.trim().isEmpty() || password.trim().isEmpty() || 
            customerName.trim().isEmpty() || customerPhone.trim().isEmpty()) {
            out.println("<h3>Lỗi: Vui lòng điền đầy đủ thông tin bắt buộc!</h3>");
            return;
        }

        // Cắt ngắn mật khẩu nếu cần (vì cột Password chỉ dài 50 ký tự)
        if (password.length() > 50) {
            password = password.substring(0, 50);
        }

        Connection conn = null;
        PreparedStatement stmtUser = null;
        PreparedStatement stmtCustomer = null;
        try {
            // Kết nối SQL Server
            conn = getConnection();

            // Thêm vào bảng User (sử dụng customerEmail làm UserEmail nếu có, nếu không dùng giá trị mặc định)
            String sqlUser = "INSERT INTO [dbo].[User] (Username, UserEmail, Password, UserRole) VALUES (?, ?, ?, ?)";
            stmtUser = conn.prepareStatement(sqlUser);
            stmtUser.setString(1, username);
            stmtUser.setString(2, customerEmail != null && !customerEmail.trim().isEmpty() ? customerEmail : "noemail@default.com");
            stmtUser.setString(3, password);
            stmtUser.setString(4, "C"); // 'C' cho khách hàng
            stmtUser.executeUpdate();

            // Thêm vào bảng Customer
            String sqlCustomer = "INSERT INTO [dbo].[Customer] (CustomerName, CustomerPhone, CustomerEmail, CustomerAddress, Username) VALUES (?, ?, ?, ?, ?)";
            stmtCustomer = conn.prepareStatement(sqlCustomer);
            stmtCustomer.setString(1, customerName);
            stmtCustomer.setString(2, customerPhone);
            stmtCustomer.setString(3, customerEmail != null && !customerEmail.trim().isEmpty() ? customerEmail : null);
            stmtCustomer.setString(4, customerAddress != null && !customerAddress.trim().isEmpty() ? customerAddress : null);
            stmtCustomer.setString(5, username);
            stmtCustomer.executeUpdate();

            // Tạo session sau khi đăng ký thành công
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } catch (SQLException e) {
            out.println("<h3>Lỗi: " + e.getMessage() + "</h3>");
            if (e.getErrorCode() == 2627) { // Lỗi vi phạm UNIQUE (Username)
                out.println("<p>Tên người dùng đã được sử dụng!</p>");
            } else if (e.getMessage().contains("Cannot open database")) {
                out.println("<p>Lỗi: Tên database không đúng hoặc database không tồn tại!</p>");
            }
        } catch (ClassNotFoundException e) {
            out.println("<h3>Lỗi: Không tìm thấy driver JDBC!</h3>");
        } finally {
            try {
                if (stmtUser != null) stmtUser.close();
                if (stmtCustomer != null) stmtCustomer.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                out.println("<h3>Lỗi khi đóng kết nối: " + e.getMessage() + "</h3>");
            }
        }
    }
}