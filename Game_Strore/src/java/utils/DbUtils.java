package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DbUtils {
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=PRJ301_WEB_BAN_HANG";
    private static final String USER = "sa";
    private static final String PASS = "12345";

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(DB_URL, USER, PASS);
    }

    public static void closeConnection(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        Connection conn = null;
        try {
            conn = getConnection();
            if (conn != null) {
                System.out.println("Connection to SQL Server database PRJ301_WEB_BAN_HANG successful!");
            } else {
                System.out.println("Failed to establish connection!");
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Connection failed: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeConnection(conn, null, null);
        }
    }
}