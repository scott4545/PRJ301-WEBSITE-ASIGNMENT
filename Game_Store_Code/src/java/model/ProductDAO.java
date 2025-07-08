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
 * Data Access Object for managing product-related database operations.
 * @author scott
 */
public class ProductDAO {

    // SQL Queries
    private static final String GET_FILTERED_PRODUCTS = "SELECT ProductID, ProductName, ProductDescription, ProductPrice, ProductImage, CategoryID, BrandID FROM Product WHERE 1=1";
    private static final String SEARCH_PRODUCTS = "SELECT ProductID, ProductName, ProductDescription, ProductPrice, ProductImage, CategoryID, BrandID FROM Product WHERE 1=1";
    private static final String GET_SEARCH_SUGGESTIONS = "SELECT DISTINCT TOP (5) ProductName FROM Product WHERE LOWER(ProductName) LIKE ? ORDER BY ProductName";
    private static final String GET_PRODUCT_BY_ID = "SELECT ProductID, ProductName, ProductDescription, ProductPrice, ProductImage, CategoryID, BrandID FROM Product WHERE ProductID = ?";

    /**
     * Retrieves a list of products filtered by category, brand, and price range.
     * @param categoryId the category ID to filter by (optional)
     * @param brandId the brand ID to filter by (optional)
     * @param minPrice the minimum price to filter by (optional)
     * @param maxPrice the maximum price to filter by (optional)
     * @return a list of ProductDTO objects matching the filters
     */
    public List<ProductDTO> getFilteredProducts(String categoryId, String brandId, String minPrice, String maxPrice) {
        List<ProductDTO> products = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            StringBuilder sql = new StringBuilder(GET_FILTERED_PRODUCTS);
            List<Object> params = new ArrayList<>();

            if (categoryId != null && !categoryId.isEmpty()) {
                sql.append(" AND CategoryID = ?");
                params.add(Integer.parseInt(categoryId));
            }
            if (brandId != null && !brandId.isEmpty()) {
                sql.append(" AND BrandID = ?");
                params.add(Integer.parseInt(brandId));
            }
            if (minPrice != null && !minPrice.isEmpty()) {
                sql.append(" AND ProductPrice >= ?");
                params.add(Double.parseDouble(minPrice));
            }
            if (maxPrice != null && !maxPrice.isEmpty()) {
                sql.append(" AND ProductPrice <= ?");
                params.add(Double.parseDouble(maxPrice));
            }

            ps = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            rs = ps.executeQuery();

            while (rs.next()) {
                ProductDTO product = new ProductDTO();
                product.setProductId(rs.getInt("ProductID"));
                product.setProductName(rs.getString("ProductName"));
                product.setProductDescription(rs.getString("ProductDescription"));
                product.setProductPrice(rs.getDouble("ProductPrice"));
                product.setProductImage(rs.getString("ProductImage"));
                product.setCategoryId(rs.getInt("CategoryID"));
                product.setBrandId(rs.getInt("BrandID"));
                products.add(product);
            }
        } catch (Exception e) {
            System.err.println("Error in getFilteredProducts(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResource(conn, ps, rs);
        }

        return products;
    }

    /**
     * Searches for products based on a query string and optional filters.
     * @param query the search query for product names (optional)
     * @param categoryId the category ID to filter by (optional)
     * @param brandId the brand ID to filter by (optional)
     * @param minPrice the minimum price to filter by (optional)
     * @param maxPrice the maximum price to filter by (optional)
     * @return a list of ProductDTO objects matching the search criteria
     */
    public List<ProductDTO> searchProducts(String query, String categoryId, String brandId, String minPrice, String maxPrice) {
    List<ProductDTO> products = new ArrayList<>();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DbUtils.getConnection();
        String sql = "SELECT * FROM Product WHERE 1=1";
        if (query != null && !query.trim().isEmpty()) {
            sql += " AND ProductName LIKE ?";
        }
        if (categoryId != null && !categoryId.isEmpty()) {
            sql += " AND CategoryID = ?";
        }
        if (brandId != null && !brandId.isEmpty()) {
            sql += " AND BrandID = ?";
        }
        if (minPrice != null && !minPrice.isEmpty()) {
            sql += " AND ProductPrice >= ?";
        }
        if (maxPrice != null && !maxPrice.isEmpty()) {
            sql += " AND ProductPrice <= ?";
        }

        ps = conn.prepareStatement(sql);
        int paramIndex = 1;
        if (query != null && !query.trim().isEmpty()) {
            ps.setString(paramIndex++, "%" + query + "%");
        }
        if (categoryId != null && !categoryId.isEmpty()) {
            ps.setString(paramIndex++, categoryId);
        }
        if (brandId != null && !brandId.isEmpty()) {
            ps.setString(paramIndex++, brandId);
        }
        if (minPrice != null && !minPrice.isEmpty()) {
            ps.setDouble(paramIndex++, Double.parseDouble(minPrice));
        }
        if (maxPrice != null && !maxPrice.isEmpty()) {
            ps.setDouble(paramIndex++, Double.parseDouble(maxPrice));
        }

        rs = ps.executeQuery();
        while (rs.next()) {
            ProductDTO product = new ProductDTO();
            product.setProductId(rs.getInt("ProductID"));
            product.setProductName(rs.getString("ProductName"));
            product.setProductPrice(rs.getDouble("ProductPrice"));
            products.add(product);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Đóng kết nối
    }
    return products;
}

    /**
     * Retrieves search suggestions for product names based on a query.
     * @param query the search query to generate suggestions
     * @return a list of product names as suggestions
     */
    public List<String> getSearchSuggestions(String query) {
        List<String> suggestions = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_SEARCH_SUGGESTIONS);
            ps.setString(1, "%" + (query != null ? query.trim().toLowerCase() : "") + "%");
            rs = ps.executeQuery();

            while (rs.next()) {
                suggestions.add(rs.getString("ProductName"));
            }
        } catch (Exception e) {
            System.err.println("Error in getSearchSuggestions(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResource(conn, ps, rs);
        }

        return suggestions;
    }

    /**
     * Retrieves a product by its ID.
     * @param productId the ID of the product to retrieve
     * @return a ProductDTO object if found, null otherwise
     */
    public ProductDTO getProductById(String productId) {
        ProductDTO product = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_PRODUCT_BY_ID);
            ps.setInt(1, Integer.parseInt(productId));
            rs = ps.executeQuery();

            if (rs.next()) {
                product = new ProductDTO();
                product.setProductId(rs.getInt("ProductID"));
                product.setProductName(rs.getString("ProductName"));
                product.setProductDescription(rs.getString("ProductDescription"));
                product.setProductPrice(rs.getDouble("ProductPrice"));
                product.setProductImage(rs.getString("ProductImage"));
                product.setCategoryId(rs.getInt("CategoryID"));
                product.setBrandId(rs.getInt("BrandID"));
            }
        } catch (Exception e) {
            System.err.println("Error in getProductById(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResource(conn, ps, rs);
        }

        return product;
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