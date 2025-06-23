package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

public class ProductDAO {
    public List<ProductDTO> getFilteredProducts(String categoryId, String brandId, String minPrice, String maxPrice) 
            throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<ProductDTO> products = new ArrayList<>();
        try {
            conn = DbUtils.getConnection();
            StringBuilder sql = new StringBuilder("SELECT ProductID, ProductName, ProductDescription, ProductPrice, ProductImage, CategoryID, BrandID " +
                                                 "FROM Product WHERE 1=1");
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
                products.add(new ProductDTO(
                    rs.getInt("ProductID"),
                    rs.getString("ProductName"),
                    rs.getString("ProductDescription"),
                    rs.getDouble("ProductPrice"),
                    rs.getString("ProductImage"),
                    rs.getInt("CategoryID"),
                    rs.getInt("BrandID")
                ));
            }
        } finally {
            DbUtils.closeConnection(conn, ps, rs);
        }
        return products;
    }

    public List<ProductDTO> searchProducts(String query, String categoryId, String brandId, String minPrice, String maxPrice) 
            throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<ProductDTO> products = new ArrayList<>();
        try {
            conn = DbUtils.getConnection();
            StringBuilder sql = new StringBuilder("SELECT ProductID, ProductName, ProductDescription, ProductPrice, ProductImage, CategoryID, BrandID " +
                                                 "FROM Product WHERE 1=1");
            List<Object> params = new ArrayList<>();
            
            if (query != null && !query.trim().isEmpty()) {
                sql.append(" AND LOWER(ProductName) LIKE ?");
                params.add("%" + query.trim().toLowerCase() + "%");
            }
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
                products.add(new ProductDTO(
                    rs.getInt("ProductID"),
                    rs.getString("ProductName"),
                    rs.getString("ProductDescription"),
                    rs.getDouble("ProductPrice"),
                    rs.getString("ProductImage"),
                    rs.getInt("CategoryID"),
                    rs.getInt("BrandID")
                ));
            }
        } finally {
            DbUtils.closeConnection(conn, ps, rs);
        }
        return products;
    }

    public List<String> getSearchSuggestions(String query) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<String> suggestions = new ArrayList<>();
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT DISTINCT TOP 5 ProductName FROM Product WHERE LOWER(ProductName) LIKE ? ORDER BY ProductName";
            ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + (query != null ? query.trim().toLowerCase() : "") + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                suggestions.add(rs.getString("ProductName"));
            }
        } finally {
            DbUtils.closeConnection(conn, ps, rs);
        }
        return suggestions;
    }

    public ProductDTO getProductById(String productId) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT ProductID, ProductName, ProductDescription, ProductPrice, ProductImage, CategoryID, BrandID " +
                         "FROM Product WHERE ProductID = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(productId));
            rs = ps.executeQuery();
            if (rs.next()) {
                return new ProductDTO(
                    rs.getInt("ProductID"),
                    rs.getString("ProductName"),
                    rs.getString("ProductDescription"),
                    rs.getDouble("ProductPrice"),
                    rs.getString("ProductImage"),
                    rs.getInt("CategoryID"),
                    rs.getInt("BrandID")
                );
            }
        } finally {
            DbUtils.closeConnection(conn, ps, rs);
        }
        return null;
    }
}