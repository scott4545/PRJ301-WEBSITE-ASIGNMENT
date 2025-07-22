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
 * Data Access Object for managing category-related database operations.
 * @author scott
 */
public class CategoryDAO {

    // SQL Queries
    private static final String GET_ALL_CATEGORIES = "SELECT CategoryID, CategoryName FROM Category";

    /**
     * Retrieves all categories from the database.
     * @return a list of CategoryDTO objects
     */
    public List<CategoryDTO> getAllCategories() {
        List<CategoryDTO> categories = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_ALL_CATEGORIES);
            rs = ps.executeQuery();

            while (rs.next()) {
                CategoryDTO category = new CategoryDTO();
                category.setCategoryId(rs.getInt("CategoryID"));
                category.setCategoryName(rs.getString("CategoryName"));
                categories.add(category);
            }
        } catch (Exception e) {
            System.err.println("Error in getAllCategories(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResource(conn, ps, rs);
        }

        return categories;
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