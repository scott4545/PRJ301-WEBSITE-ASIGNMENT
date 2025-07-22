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
 * Data Access Object for managing brand-related database operations.
 * @author scott
 */
public class BrandDAO {

    // SQL Queries
    private static final String GET_ALL_BRANDS = "SELECT BrandID, BrandName FROM Brand";

    /**
     * Retrieves all brands from the database.
     * @return a list of BrandDTO objects
     */
    public List<BrandDTO> getAllBrands() {
        List<BrandDTO> brands = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_ALL_BRANDS);
            rs = ps.executeQuery();

            while (rs.next()) {
                BrandDTO brand = new BrandDTO();
                brand.setBrandId(rs.getInt("BrandID"));
                brand.setBrandName(rs.getString("BrandName"));
                brands.add(brand);
            }
        } catch (Exception e) {
            System.err.println("Error in getAllBrands(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResource(conn, ps, rs);
        }

        return brands;
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