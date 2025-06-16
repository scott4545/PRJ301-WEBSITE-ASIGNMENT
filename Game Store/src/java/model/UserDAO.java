package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import utils.DbUtils;

public class UserDAO {
    public UserDTO checkLogin(String username, String password) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT UserID, Username, Password, UserRole FROM [User] WHERE Username = ? AND Password = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password); // Use plain-text password
            rs = ps.executeQuery();
            if (rs.next()) {
                return new UserDTO(
                    rs.getInt("UserID"),
                    rs.getString("Username"),
                    rs.getString("Password"),
                    rs.getString("UserRole")
                );
            }
        } finally {
            DbUtils.closeConnection(conn, ps, rs);
        }
        return null;
    }

    public boolean checkUsernameExists(String username) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT Username FROM [User] WHERE Username = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            return rs.next();
        } finally {
            DbUtils.closeConnection(conn, ps, rs);
        }
    }

    public boolean registerUser(UserDTO user, String customerName, String customerPhone, String customerEmail, String customerAddress) 
            throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psCustomer = null;
        boolean success = false;
        try {
            conn = DbUtils.getConnection();
            conn.setAutoCommit(false);

            // Insert into User table
            String sqlUser = "INSERT INTO [User] (Username, Password, UserRole) VALUES (?, ?, ?)";
            psUser = conn.prepareStatement(sqlUser);
            psUser.setString(1, user.getUsername());
            psUser.setString(2, user.getPassword()); // Store plain-text password
            psUser.setString(3, user.getUserRole());
            psUser.executeUpdate();

            // Insert into Customer table
            String sqlCustomer = "INSERT INTO Customer (CustomerName, CustomerPhone, CustomerEmail, CustomerAddress, Username) " +
                                "VALUES (?, ?, ?, ?, ?)";
            psCustomer = conn.prepareStatement(sqlCustomer);
            psCustomer.setString(1, customerName);
            psCustomer.setString(2, customerPhone);
            psCustomer.setString(3, customerEmail);
            psCustomer.setString(4, customerAddress);
            psCustomer.setString(5, user.getUsername());
            psCustomer.executeUpdate();

            conn.commit();
            success = true;
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            DbUtils.closeConnection(conn, psUser, null);
            DbUtils.closeConnection(null, psCustomer, null);
        }
        return success;
    }
}