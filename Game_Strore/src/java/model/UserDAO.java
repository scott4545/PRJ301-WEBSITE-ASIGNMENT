/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click //nbproject//Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

/**
 * Data Access Object for managing user-related database operations.
 * @author scott
 */
public class UserDAO {

    // SQL Queries
    private static final String CHECK_LOGIN = "SELECT UserID, Username, Password, UserRole FROM [User] WHERE Username = ? AND Password = ?";
    private static final String CHECK_USERNAME_EXISTS = "SELECT Username FROM [User] WHERE Username = ?";
    private static final String INSERT_USER = "INSERT INTO [User] (Username, Password, UserRole) VALUES (?, ?, ?)";
    private static final String INSERT_CUSTOMER = "INSERT INTO Customer (CustomerName, CustomerPhone, CustomerEmail, CustomerAddress, Username) VALUES (?, ?, ?, ?, ?)";
    private static final String UPDATE_PASSWORD = "UPDATE [User] SET Password = ? WHERE Username = ?";
    private static final String UPDATE_PROFILE = "UPDATE Customer SET CustomerName = ?, CustomerPhone = ?, CustomerEmail = ?, CustomerAddress = ? WHERE Username = ?";
    private static final String GET_CUSTOMER_INFO = "SELECT CustomerName, CustomerPhone, CustomerEmail, CustomerAddress FROM Customer WHERE Username = ?";

    /**
     * Verifies user login credentials and retrieves user details.
     * @param username the username to check
     * @param password the password to verify
     * @return a UserDTO object if credentials are valid, null otherwise
     */
    public UserDTO checkLogin(String username, String password) {
        UserDTO user = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(CHECK_LOGIN);
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                user = new UserDTO();
                user.setUserID(rs.getInt("userID"));
                user.setUsername(rs.getString("Username"));
                user.setPassword(rs.getString("Password"));
                user.setUserRole(rs.getString("UserRole"));
            }
        } catch (Exception e) {
            System.err.println("Error in checkLogin(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResource(conn, ps, rs);
        }

        return user;
    }

    /**
     * Checks if a username already exists in the database.
     * @param username the username to check
     * @return true if the username exists, false otherwise
     */
    public boolean checkUsernameExists(String username) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(CHECK_USERNAME_EXISTS);
            ps.setString(1, username);
            rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            System.err.println("Error in checkUsernameExists(): " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResource(conn, ps, rs);
        }
    }

    /**
     * Registers a new user and associated customer information.
     * @param user the UserDTO containing user details
     * @param customerName the customer's full name
     * @param customerPhone the customer's phone number
     * @param customerEmail the customer's email (can be null)
     * @param customerAddress the customer's address (can be null)
     * @return true if registration is successful, false otherwise
     */
    public boolean registerUser(UserDTO user, String customerName, String customerPhone, String customerEmail, String customerAddress) {
        Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psCustomer = null;
        boolean success = false;

        try {
            conn = DbUtils.getConnection();
            conn.setAutoCommit(false);

            psUser = conn.prepareStatement(INSERT_USER);
            psUser.setString(1, user.getUsername());
            psUser.setString(2, user.getPassword());
            psUser.setString(3, user.getUserRole());
            psUser.executeUpdate();

            psCustomer = conn.prepareStatement(INSERT_CUSTOMER);
            psCustomer.setString(1, customerName);
            psCustomer.setString(2, customerPhone);
            psCustomer.setString(3, customerEmail == null ? null : customerEmail);
            psCustomer.setString(4, customerAddress == null ? null : customerAddress);
            psCustomer.setString(5, user.getUsername());
            psCustomer.executeUpdate();

            conn.commit();
            success = true;
        } catch (Exception e) {
            System.err.println("Error in registerUser(): " + e.getMessage());
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception rollbackEx) {
                System.err.println("Error during rollback in registerUser(): " + rollbackEx.getMessage());
                rollbackEx.printStackTrace();
            }
        } finally {
            closeResource(conn, psUser, null);
            closeResource(null, psCustomer, null);
        }
        return success;
    }

    /**
     * Updates the password for a user.
     * @param username the username of the user
     * @param newPassword the new password to set
     * @return true if the update is successful, false otherwise
     */
    public boolean updatePassword(String username, String newPassword) {
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(UPDATE_PASSWORD);
            ps.setString(1, newPassword);
            ps.setString(2, username);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("Error in updatePassword(): " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResource(conn, ps, null);
        }
    }

    /**
     * Updates the customer profile information for a user.
     * @param username the username of the user
     * @param customerName the customer's full name (optional)
     * @param customerPhone the customer's phone number (optional)
     * @param customerEmail the customer's email (optional)
     * @param customerAddress the customer's address (optional)
     * @return true if the update is successful, false otherwise
     */
    public boolean updateProfile(String username, String customerName, String customerPhone, String customerEmail, String customerAddress) {
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DbUtils.getConnection();
            String[] currentInfo = getCustomerInfo(username);
            String finalName = customerName.isEmpty() ? currentInfo[0] : customerName;
            String finalPhone = customerPhone.isEmpty() ? currentInfo[1] : customerPhone;
            String finalEmail = customerEmail.isEmpty() ? currentInfo[2] : customerEmail;
            String finalAddress = customerAddress.isEmpty() ? currentInfo[3] : customerAddress;

            ps = conn.prepareStatement(UPDATE_PROFILE);
            ps.setString(1, finalName);
            ps.setString(2, finalPhone);
            ps.setString(3, finalEmail == null ? null : finalEmail);
            ps.setString(4, finalAddress == null ? null : finalAddress);
            ps.setString(5, username);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("Error in updateProfile(): " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResource(conn, ps, null);
        }
    }

    /**
     * Retrieves customer information for a user.
     * @param username the username of the user
     * @return an array containing customer name, phone, email, and address
     */
    public String[] getCustomerInfo(String username) {
        String[] info = new String[4];
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_CUSTOMER_INFO);
            ps.setString(1, username);
            rs = ps.executeQuery();

            if (rs.next()) {
                info[0] = rs.getString("CustomerName");
                info[1] = rs.getString("CustomerPhone");
                info[2] = rs.getString("CustomerEmail");
                info[3] = rs.getString("CustomerAddress");
            }
        } catch (Exception e) {
            System.err.println("Error in getCustomerInfo(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResource(conn, ps, rs);
        }

        return info;
    }

    /**
     * Closes database resources (Connection, PreparedStatement, ResultSet).
     * @param conn the database connection
     * @param ps   the prepared statement
     * @param rs   the result set
     */
    private void closeResource(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (Exception e) {
            System.err.println("Error closing resources: " + e.getMessage());
            e.printStackTrace();
        }
    }
}