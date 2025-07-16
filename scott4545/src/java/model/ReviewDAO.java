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
 * Data Access Object for managing review-related database operations.
 * @author scott
 */
public class ReviewDAO {

    // SQL Queries
    private static final String GET_REVIEWS_BY_PRODUCT_ID = "SELECT ReviewID, ProductID, Username, Rating, Comment, ReviewDate FROM Review WHERE ProductID = ?";

    /**
     * Retrieves all reviews for a specific product by its ID.
     * @param productId the ID of the product to retrieve reviews for
     * @return a list of ReviewDTO objects
     */
    public List<ReviewDTO> getReviewsByProductId(String productId) {
        List<ReviewDTO> reviews = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_REVIEWS_BY_PRODUCT_ID);
            ps.setInt(1, Integer.parseInt(productId));
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
        } catch (Exception e) {
            System.err.println("Error in getReviewsByProductId(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResource(conn, ps, rs);
        }

        return reviews;
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