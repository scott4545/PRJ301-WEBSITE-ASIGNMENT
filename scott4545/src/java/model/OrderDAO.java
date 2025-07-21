package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import utils.DbUtils;

/**
 * Data Access Object for managing order-related database operations.
 */
public class OrderDAO {

    private static final String CREATE_ORDER = "INSERT INTO [Order] (CustomerID, OrderDate, TotalAmount, PaymentStatus, AddressDelivery) VALUES (?, GETDATE(), ?, ?, ?)";
    private static final String CREATE_ORDER_DETAIL = "INSERT INTO OrderDetail (ProductID, OrderID, Quantity, UnitPrice) VALUES (?, ?, ?, ?)";
    private static final String GET_ORDERS_BY_CUSTOMER = "SELECT o.OrderID, o.OrderDate, o.TotalAmount, o.PaymentStatus, o.AddressDelivery, od.ProductID, od.Quantity, od.UnitPrice, p.ProductName " +
                                                        "FROM [Order] o JOIN OrderDetail od ON o.OrderID = od.OrderID JOIN Product p ON od.ProductID = p.ProductID " +
                                                        "WHERE o.CustomerID = ?";
    private static final String GET_CUSTOMER_ID = "SELECT CustomerID FROM Customer WHERE Username = ?";

    public int createOrder(OrderDTO order, String productId, int quantity, double unitPrice) {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psOrderDetail = null;
        PreparedStatement psCustomer = null;
        ResultSet rs = null;
        int orderId = -1;

        try {
            conn = DbUtils.getConnection();
            System.out.println("Database connection established: " + (conn != null));
            if (conn == null) {
                System.err.println("Error: Database connection failed");
                return -1;
            }
            conn.setAutoCommit(false);

            // Fetch CustomerID from Customer table using Username
            psCustomer = conn.prepareStatement("SELECT CustomerID FROM Customer WHERE Username = ?");
            psCustomer.setString(1, order.getCustomerUsername());
            System.out.println("Querying CustomerID for username: " + order.getCustomerUsername());
            rs = psCustomer.executeQuery();
            int customerId = -1;
            if (rs.next()) {
                customerId = rs.getInt("CustomerID");
                System.out.println("Found CustomerID: " + customerId);
            } else {
                throw new SQLException("Customer not found for username: " + order.getCustomerUsername());
            }

            // Insert into Order table
            psOrder = conn.prepareStatement(CREATE_ORDER, PreparedStatement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, customerId);
            psOrder.setDouble(2, order.getTotalAmount());
            psOrder.setString(3, order.getPaymentStatus());
            psOrder.setString(4, order.getAddressDelivery());
            System.out.println("Executing Order insert with CustomerID: " + customerId + ", TotalAmount: " + order.getTotalAmount() + ", Address: " + order.getAddressDelivery());
            int rowsAffected = psOrder.executeUpdate();
            System.out.println("Rows affected in Order table: " + rowsAffected);

            // Get generated OrderID
            rs = psOrder.getGeneratedKeys();
            if (rs.next()) {
                orderId = rs.getInt(1);
                System.out.println("Generated OrderID: " + orderId);
            } else {
                System.err.println("Error: No OrderID generated");
                throw new SQLException("Failed to retrieve generated OrderID");
            }

            // Insert into OrderDetail table
            psOrderDetail = conn.prepareStatement(CREATE_ORDER_DETAIL);
            psOrderDetail.setInt(1, Integer.parseInt(productId));
            psOrderDetail.setInt(2, orderId);
            psOrderDetail.setInt(3, quantity);
            psOrderDetail.setDouble(4, unitPrice);
            System.out.println("Executing OrderDetail insert with ProductID: " + productId + ", OrderID: " + orderId + ", Quantity: " + quantity + ", UnitPrice: " + unitPrice);
            rowsAffected = psOrderDetail.executeUpdate();
            System.out.println("Rows affected in OrderDetail table: " + rowsAffected);

            conn.commit();
            System.out.println("Transaction committed successfully, orderId: " + orderId);
            return orderId;
        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback();
                    System.err.println("Transaction rolled back due to: " + e.getMessage());
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            System.err.println("Error in createOrder(): " + e.getMessage());
            e.printStackTrace();
            return -1;
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, "JDBC Driver not found: " + ex.getMessage(), ex);
            return -1;
        } finally {
            closeResource(conn, psOrder, psOrderDetail, psCustomer, rs);
        }
    }

  



    public List<OrderDTO> getOrdersByCustomerId(int customerId) {
        List<OrderDTO> orders = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_ORDERS_BY_CUSTOMER);
            ps.setInt(1, customerId);
            rs = ps.executeQuery();

            while (rs.next()) {
                OrderDTO order = new OrderDTO();
                order.setOrderId(rs.getInt("OrderID"));
                order.setOrderDate(rs.getDate("OrderDate"));
                order.setTotalAmount(rs.getDouble("TotalAmount"));
                order.setPaymentStatus(rs.getString("PaymentStatus"));
                order.setAddressDelivery(rs.getString("AddressDelivery"));
                order.setProductId(rs.getInt("ProductID"));
                order.setQuantity(rs.getInt("Quantity"));
                order.setUnitPrice(rs.getDouble("UnitPrice"));
                order.setProductName(rs.getString("ProductName"));
                orders.add(order);
            }
        } catch (SQLException e) {
            System.err.println("Error in getOrdersByCustomerId(): " + e.getMessage());
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, "JDBC Driver not found: " + e.getMessage(), e);
            return new ArrayList<>(); // Return empty list if driver not found
        } finally {
            closeResource(conn, ps, null, rs);
        }

        return orders;
    }

    private void closeResource(Connection conn, PreparedStatement ps, PreparedStatement ps2, PreparedStatement ps3, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (ps2 != null) ps2.close();
            if (ps3 != null) ps3.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.err.println("Error closing resources: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void closeResource(Connection conn, PreparedStatement ps, PreparedStatement ps2, ResultSet rs) {
        closeResource(conn, ps, ps2, null, rs);
    }

    private void closeResource(Connection conn, PreparedStatement ps, ResultSet rs) {
        closeResource(conn, ps, null, null, rs);
    }
}