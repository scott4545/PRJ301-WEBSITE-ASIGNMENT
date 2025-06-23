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
            ps.setString(2, password);
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

            String sqlUser = "INSERT INTO [User] (Username, Password, UserRole) VALUES (?, ?, ?)";
            psUser = conn.prepareStatement(sqlUser);
            psUser.setString(1, user.getUsername());
            psUser.setString(2, user.getPassword());
            psUser.setString(3, user.getUserRole());
            psUser.executeUpdate();

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

    public boolean updatePassword(String username, String newPassword) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE [User] SET Password = ? WHERE Username = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setString(2, username);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } finally {
            DbUtils.closeConnection(conn, ps, null);
        }
    }

    public boolean updateProfile(String username, String customerName, String customerPhone, String customerEmail, String customerAddress) 
            throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DbUtils.getConnection();
            String[] currentInfo = getCustomerInfo(username);
            String finalName = customerName.isEmpty() ? currentInfo[0] : customerName;
            String finalPhone = customerPhone.isEmpty() ? currentInfo[1] : customerPhone;
            String finalEmail = customerEmail.isEmpty() ? currentInfo[2] : customerEmail;
            String finalAddress = customerAddress.isEmpty() ? currentInfo[3] : customerAddress;

            String sql = "UPDATE Customer SET CustomerName = ?, CustomerPhone = ?, CustomerEmail = ?, CustomerAddress = ? WHERE Username = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, finalName);
            ps.setString(2, finalPhone);
            ps.setString(3, finalEmail == null ? null : finalEmail);
            ps.setString(4, finalAddress == null ? null : finalAddress);
            ps.setString(5, username);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } finally {
            DbUtils.closeConnection(conn, ps, null);
        }
    }

    public String[] getCustomerInfo(String username) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String[] info = new String[4];
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT CustomerName, CustomerPhone, CustomerEmail, CustomerAddress FROM Customer WHERE Username = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                info[0] = rs.getString("CustomerName");
                info[1] = rs.getString("CustomerPhone");
                info[2] = rs.getString("CustomerEmail");
                info[3] = rs.getString("CustomerAddress");
            }
        } finally {
            DbUtils.closeConnection(conn, ps, rs);
        }
        return info;
    }
}