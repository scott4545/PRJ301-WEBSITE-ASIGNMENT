package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

public class ProductDAO {

    private static final String GET_ALL_PRODUCTS = "SELECT ProductID, ProductName, ProductDescription, ProductPrice, ProductImage, CategoryID, BrandID, Status, Quantity FROM Product";
    private static final String GET_FILTERED_PRODUCTS = "SELECT ProductID, ProductName, ProductDescription, ProductPrice, ProductImage, CategoryID, BrandID, Status, Quantity FROM Product WHERE 1=1";
    private static final String SEARCH_PRODUCTS = "SELECT ProductID, ProductName, ProductDescription, ProductPrice, ProductImage, CategoryID, BrandID, Status, Quantity FROM Product WHERE 1=1";
    private static final String GET_SEARCH_SUGGESTIONS = "SELECT DISTINCT ProductName FROM Product WHERE LOWER(ProductName) LIKE ? ORDER BY ProductName";
    private static final String GET_PRODUCT_BY_ID = "SELECT ProductID, ProductName, ProductDescription, ProductPrice, ProductImage, CategoryID, BrandID, Status, Quantity FROM Product WHERE ProductID = ?";
    private static final String CREATE_PRODUCT = "INSERT INTO Product (ProductName, ProductDescription, ProductPrice, ProductImage, CategoryID, BrandID, Status, Quantity) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_PRODUCT_STATUS = "UPDATE Product SET Status = ? WHERE ProductID = ?";
    private static final String UPDATE_PRODUCT_QUANTITY = "UPDATE Product SET Quantity = ? WHERE ProductID = ?";
    private static final String DELETE_PRODUCT = "DELETE FROM Product WHERE ProductID = ?";
    private static final String UPDATE_PRODUCT = "UPDATE Product SET ProductName = ?, ProductDescription = ?, ProductPrice = ?, ProductImage = ?, CategoryID = ?, BrandID = ?, Status = ?, Quantity = ? WHERE ProductID = ?";

    public List<ProductDTO> getAllProducts() {
        List<ProductDTO> products = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_ALL_PRODUCTS);
            rs = ps.executeQuery();

            while (rs.next()) {
                ProductDTO product = mapResultSetToProductDTO(rs);
                products.add(product);
            }
        } catch (Exception e) {
            System.err.println("Error in getAllProducts(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResource(conn, ps, rs);
        }

        return products;
    }

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
                ProductDTO product = mapResultSetToProductDTO(rs);
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

    public List<ProductDTO> searchProducts(String query, String categoryId, String brandId, String minPrice, String maxPrice) {
        List<ProductDTO> products = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            StringBuilder sql = new StringBuilder(SEARCH_PRODUCTS);
            List<Object> params = new ArrayList<>();

            if (query != null && !query.trim().isEmpty()) {
                sql.append(" AND ProductName LIKE ?");
                params.add("%" + query.trim() + "%");
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
                ProductDTO product = mapResultSetToProductDTO(rs);
                products.add(product);
            }
        } catch (Exception e) {
            System.err.println("Error in searchProducts(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResource(conn, ps, rs);
        }

        return products;
    }

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
                product = mapResultSetToProductDTO(rs);
            }
        } catch (Exception e) {
            System.err.println("Error in getProductById(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResource(conn, ps, rs);
        }

        return product;
    }

    public int createProduct(ProductDTO product) {
        int newProductId = -1;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(CREATE_PRODUCT, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getProductDescription());
            ps.setDouble(3, product.getProductPrice());
            ps.setString(4, product.getProductImage());
            ps.setInt(5, product.getCategoryId());
            ps.setInt(6, product.getBrandId());
            ps.setBoolean(7, product.isStatus());
            ps.setInt(8, product.getQuantity());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    newProductId = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.err.println("Error in createProduct(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResource(conn, ps, rs);
        }

        return newProductId;
    }

    public boolean updateProductStatus(int productId, boolean status) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(UPDATE_PRODUCT_STATUS);
            ps.setBoolean(1, status);
            ps.setInt(2, productId);

            int rowsAffected = ps.executeUpdate();
            success = rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("Error in updateProductStatus(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResource(conn, ps, null);
        }

        return success;
    }

    public boolean updateProductQuantity(int productId, int quantity) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(UPDATE_PRODUCT_QUANTITY);
            ps.setInt(1, quantity);
            ps.setInt(2, productId);

            int rowsAffected = ps.executeUpdate();
            success = rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("Error in updateProductQuantity(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResource(conn, ps, null);
        }

        return success;
    }

    public boolean deleteProduct(int productId) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(DELETE_PRODUCT);
            ps.setInt(1, productId);

            int rowsAffected = ps.executeUpdate();
            success = rowsAffected > 0;
            if (!success) {
                System.err.println("No product found with ID: " + productId);
            }
        } catch (SQLException e) {
            System.err.println("Error in deleteProduct(): SQL Error - " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error in deleteProduct(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResource(conn, ps, null);
        }

        return success;
    }

    public boolean updateProduct(ProductDTO product) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(UPDATE_PRODUCT);
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getProductDescription());
            ps.setDouble(3, product.getProductPrice());
            ps.setString(4, product.getProductImage());
            ps.setInt(5, product.getCategoryId());
            ps.setInt(6, product.getBrandId());
            ps.setBoolean(7, product.isStatus());
            ps.setInt(8, product.getQuantity());
            ps.setInt(9, product.getProductId());

            int rowsAffected = ps.executeUpdate();
            success = rowsAffected > 0;
            if (!success) {
                System.err.println("No product found with ID: " + product.getProductId());
            }
        } catch (SQLException e) {
            System.err.println("Error in updateProduct(): SQL Error - " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error in updateProduct(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResource(conn, ps, null);
        }

        return success;
    }

    private ProductDTO mapResultSetToProductDTO(ResultSet rs) throws Exception {
        ProductDTO product = new ProductDTO();
        product.setProductId(rs.getInt("ProductID"));
        product.setProductName(rs.getString("ProductName"));
        product.setProductDescription(rs.getString("ProductDescription"));
        product.setProductPrice(rs.getDouble("ProductPrice"));
        product.setProductImage(rs.getString("ProductImage"));
        product.setCategoryId(rs.getInt("CategoryID"));
        product.setBrandId(rs.getInt("BrandID"));
        product.setStatus(rs.getBoolean("Status"));
        product.setQuantity(rs.getInt("Quantity"));
        return product;
    }

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