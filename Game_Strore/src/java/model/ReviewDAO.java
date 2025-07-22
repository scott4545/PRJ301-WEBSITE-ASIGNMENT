package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

/**
 * Data Access Object for managing review-related database operations.
 */
public class ReviewDAO {

    private static final String GET_REVIEWS_BY_PRODUCT_ID = "SELECT ReviewID, ProductID, Username, Rating, Comment, ReviewDate FROM Review WHERE ProductID = ?";
    private static final String ADD_REVIEW = "INSERT INTO Review (ProductID, Username, Rating, Comment, ReviewDate) VALUES (?, ?, ?, ?, GETDATE())";

    /**
     * Retrieves all reviews for a given product ID.
     * @param productId the ID of the product
     * @return a list of ReviewDTO objects
     */
    public List<ReviewDTO> getReviewsByProductId(String productId) {
        List<ReviewDTO> reviews = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        if (productId == null || productId.trim().isEmpty()) {
            System.err.println("Invalid productId: " + productId + " at " + new java.util.Date());
            return reviews;
        }

        try {
            conn = DbUtils.getConnection();
            if (conn == null) {
                System.err.println("Database connection failed at " + new java.util.Date());
                return reviews;
            }
            ps = conn.prepareStatement(GET_REVIEWS_BY_PRODUCT_ID); // Initialize PreparedStatement
            try {
                ps.setInt(1, Integer.parseInt(productId)); // Set parameter after initialization
            } catch (NumberFormatException e) {
                System.err.println("Invalid productId format: " + productId + " at " + new java.util.Date());
                return reviews;
            }
            rs = ps.executeQuery();

            while (rs.next()) {
                ReviewDTO review = new ReviewDTO();
                review.setReviewId(rs.getInt("ReviewID"));
                review.setProductId(rs.getInt("ProductID"));
                review.setUsername(rs.getString("Username"));
                review.setRating(rs.getInt("Rating"));
                review.setComment(rs.getString("Comment"));
                review.setReviewDate(rs.getDate("ReviewDate"));
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.err.println("Error in getReviewsByProductId(): " + e.getMessage() + " at " + new java.util.Date());
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage() + " at " + new java.util.Date());
            e.printStackTrace();
        } finally {
            closeResource(conn, ps, rs);
        }

        return reviews;
    }

    /**
     * Adds a new review for a product.
     * @param review the ReviewDTO object containing review details
     * @return true if the review was added successfully, false otherwise
     */
    public boolean addReview(ReviewDTO review) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;

        if (review == null || review.getProductId() <= 0 || review.getRating() < 1 || review.getRating() > 5) {
            System.err.println("Invalid review data: " + review + " at " + new java.util.Date());
            return false;
        }

        try {
            conn = DbUtils.getConnection();
            if (conn == null) {
                System.err.println("Database connection failed at " + new java.util.Date());
                return false;
            }
            conn.setAutoCommit(false);
            ps = conn.prepareStatement(ADD_REVIEW);
            ps.setInt(1, review.getProductId());
            ps.setString(2, review.getUsername());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            int rowsAffected = ps.executeUpdate();
            conn.commit();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error in addReview(): " + e.getMessage() + " for productId: " + review.getProductId() + " at " + new java.util.Date());
            e.printStackTrace();
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage() + " at " + new java.util.Date());
            e.printStackTrace();
        } finally {
            closeResource(conn, ps, null);
        }

        return success;
    }

    /**
     * Closes database resources.
     * @param conn the database connection
     * @param ps   the prepared statement
     * @param rs   the result set
     */
    private void closeResource(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.err.println("Error closing resources: " + e.getMessage() + " at " + new java.util.Date());
            e.printStackTrace();
        }
    }
}