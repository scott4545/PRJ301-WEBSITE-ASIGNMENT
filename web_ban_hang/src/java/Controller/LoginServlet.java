
package Controller;

import java.io.IOException;
import java.io.PrintWriter;
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
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
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

        // Kiểm tra dữ liệu bắt buộc
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            out.println("<h3>Lỗi: Vui lòng điền đầy đủ thông tin!</h3>");
            return;
        }

        // Cắt ngắn mật khẩu nếu cần (vì cột Password chỉ dài 50 ký tự)
        if (password.length() > 50) {
            password = password.substring(0, 50);
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            // Kết nối SQL Server
            conn = getConnection();

            // Kiểm tra thông tin đăng nhập
            String sql = "SELECT * FROM [dbo].[User] WHERE Username = ? AND Password = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            rs = stmt.executeQuery();

            if (rs.next()) {
                // Đăng nhập thành công, tạo session
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else {
                out.println("<h3>Lỗi: Tên người dùng hoặc mật khẩu không đúng!</h3>");
            }
        } catch (SQLException e) {
            out.println("<h3>Lỗi: " + e.getMessage() + "</h3>");
            if (e.getMessage().contains("Cannot open database")) {
                out.println("<p>Lỗi: Tên database không đúng hoặc database không tồn tại!</p>");
            }
        } catch (ClassNotFoundException e) {
            out.println("<h3>Lỗi: Không tìm thấy driver JDBC!</h3>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                out.println("<h3>Lỗi khi đóng kết nối: " + e.getMessage() + "</h3>");
            }
        }
    }
}