package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.BrandDAO;
import model.BrandDTO;
import model.CategoryDAO;
import model.CategoryDTO;
import model.ProductDAO;
import model.ProductDTO;
import model.ReviewDAO;
import model.ReviewDTO;
import utils.AuthUtils;

@WebServlet(name = "ProductController", urlPatterns = {"/ProductController"})
public class ProductController extends HttpServlet {

    private static final String PRODUCTS_PAGE = "/products.jsp";
    private static final String PRODUCT_DETAIL_PAGE = "/productDetail.jsp";
    private static final String ADD_PRODUCT_PAGE = "/addProduct.jsp";
    private static final String LOGIN_PAGE = "/login.jsp";
    private static final String ERROR_PAGE = "/error.jsp";

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final BrandDAO brandDAO = new BrandDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR_PAGE;
        try {
            String action = request.getParameter("action");
            System.out.println("ProductController received action: " + action); // Debug
            if (action == null || action.isEmpty()) {
                request.setAttribute("ERROR", "No action specified!");
            } else if ("listProducts".equals(action)) {
                url = handleProductListing(request, response);
            } else if ("search".equals(action)) {
                url = handleProductSearch(request, response);
            } else if ("productDetail".equals(action)) {
                url = handleProductDetail(request, response);
            } else if ("addProduct".equals(action)) {
                url = handleAddProduct(request, response);
            } else if ("changeProductStatus".equals(action)) {
                url = handleChangeProductStatus(request, response);
            } else if ("updateProductQuantity".equals(action)) {
                url = handleUpdateProductQuantity(request, response);
            } else if ("deleteProduct".equals(action)) {
                url = handleDeleteProduct(request, response);
            } else if ("editProduct".equals(action)) {
                url = handleEditProduct(request, response);
            } else {
                request.setAttribute("ERROR", "Invalid action!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR", "An error occurred: " + e.getMessage());
        } finally {
            System.out.println("ProductController forwarding to: " + url);
            if (url != null) {
                request.getRequestDispatcher(url).forward(request, response);
            }
        }
    }

    private String handleProductListing(HttpServletRequest request, HttpServletResponse response) {
        String categoryId = request.getParameter("categoryId");
        String brandId = request.getParameter("brandId");
        String minPrice = request.getParameter("minPrice");
        String maxPrice = request.getParameter("maxPrice");

        List<ProductDTO> products = productDAO.getFilteredProducts(categoryId, brandId, minPrice, maxPrice);
        List<CategoryDTO> categories = categoryDAO.getAllCategories();
        List<BrandDTO> brands = brandDAO.getAllBrands();

        request.setAttribute("PRODUCTS", products);
        request.setAttribute("CATEGORIES", categories);
        request.setAttribute("BRANDS", brands);
        return PRODUCTS_PAGE;
    }

    private String handleProductSearch(HttpServletRequest request, HttpServletResponse response) {
        String query = request.getParameter("query") != null ? request.getParameter("query").trim() : "";
        String categoryId = request.getParameter("categoryId");
        String brandId = request.getParameter("brandId");
        String minPrice = request.getParameter("minPrice");
        String maxPrice = request.getParameter("maxPrice");

        List<ProductDTO> products = productDAO.searchProducts(query, categoryId, brandId, minPrice, maxPrice);
        List<CategoryDTO> categories = categoryDAO.getAllCategories();
        List<BrandDTO> brands = brandDAO.getAllBrands();
        List<String> suggestions = productDAO.getSearchSuggestions(query);

        request.setAttribute("PRODUCTS", products);
        request.setAttribute("CATEGORIES", categories);
        request.setAttribute("BRANDS", brands);
        request.setAttribute("SUGGESTIONS", suggestions);
        request.setAttribute("QUERY", query);
        return PRODUCTS_PAGE;
    }

    private String handleProductDetail(HttpServletRequest request, HttpServletResponse response) {
        String productId = request.getParameter("productId");
        ProductDTO product = productDAO.getProductById(productId);
        if (product != null) {
            List<ReviewDTO> reviews = reviewDAO.getReviewsByProductId(productId);
            List<CategoryDTO> categories = categoryDAO.getAllCategories();
            List<BrandDTO> brands = brandDAO.getAllBrands();
            request.setAttribute("PRODUCT", product);
            request.setAttribute("REVIEWS", reviews);
            request.setAttribute("CATEGORIES", categories);
            request.setAttribute("BRANDS", brands);
            return PRODUCT_DETAIL_PAGE;
        } else {
            request.setAttribute("ERROR", "Product not found!");
            return ERROR_PAGE;
        }
    }

    private String handleAddProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String url = ADD_PRODUCT_PAGE;
        try {
            if (!AuthUtils.isAdmin(request)) {
                request.setAttribute("ERROR", AuthUtils.getAccessDeniedMessage("add product"));
                return LOGIN_PAGE;
            }
            List<CategoryDTO> categories = categoryDAO.getAllCategories();
            List<BrandDTO> brands = brandDAO.getAllBrands();
            request.setAttribute("CATEGORIES", categories);
            request.setAttribute("BRANDS", brands);
            String productName = request.getParameter("productName");
            String productDescription = request.getParameter("productDescription");
            String productPrice = request.getParameter("productPrice");
            String productImage = request.getParameter("productImage");
            String categoryId = request.getParameter("categoryId");
            String brandId = request.getParameter("brandId");
            String quantity = request.getParameter("quantity");
            if (productName == null || productPrice == null || categoryId == null || brandId == null || quantity == null) {
                return url;
            }
            double price = Double.parseDouble(productPrice);
            int catId = Integer.parseInt(categoryId);
            int brId = Integer.parseInt(brandId);
            int qty = Integer.parseInt(quantity);
            if (price <= 0) {
                request.setAttribute("ERROR", "Price must be greater than 0!");
                return url;
            }
            if (qty < 0) {
                request.setAttribute("ERROR", "Quantity must be non-negative!");
                return url;
            }
            ProductDTO product = new ProductDTO(productName, productDescription, price, productImage, catId, brId, qty > 0, qty);
            int newProductId = productDAO.createProduct(product);
            if (newProductId > 0) {
                request.setAttribute("SUCCESS", "Product added successfully with ID: " + newProductId);
                url = PRODUCTS_PAGE;
                List<ProductDTO> products = productDAO.getAllProducts();
                request.setAttribute("PRODUCTS", products);
                request.setAttribute("CATEGORIES", categories);
                request.setAttribute("BRANDS", brands);
            } else {
                request.setAttribute("ERROR", "Failed to add product!");
            }
        } catch (Exception e) {
            request.setAttribute("ERROR", "Error adding product: " + e.getMessage());
            e.printStackTrace();
        }
        return url;
    }

    private String handleChangeProductStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String url = PRODUCTS_PAGE;
        try {
            if (!AuthUtils.isAdmin(request)) {
                request.setAttribute("ERROR", AuthUtils.getAccessDeniedMessage("change product status"));
                return LOGIN_PAGE;
            }
            String productId = request.getParameter("productId");
            String status = request.getParameter("status");
            if (productId == null || status == null) {
                request.setAttribute("ERROR", "Product ID and status are required!");
            } else {
                int id = Integer.parseInt(productId);
                boolean newStatus = Boolean.parseBoolean(status);
                if (productDAO.updateProductStatus(id, newStatus)) {
                    request.setAttribute("SUCCESS", "Product status updated successfully!");
                } else {
                    request.setAttribute("ERROR", "Failed to update product status!");
                }
            }
            List<ProductDTO> products = productDAO.getAllProducts();
            List<CategoryDTO> categories = categoryDAO.getAllCategories();
            List<BrandDTO> brands = brandDAO.getAllBrands();
            request.setAttribute("PRODUCTS", products);
            request.setAttribute("CATEGORIES", categories);
            request.setAttribute("BRANDS", brands);
        } catch (Exception e) {
            request.setAttribute("ERROR", "Error updating product status: " + e.getMessage());
            e.printStackTrace();
        }
        return url;
    }

    private String handleUpdateProductQuantity(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String url = PRODUCTS_PAGE;
        try {
            if (!AuthUtils.isAdmin(request)) {
                request.setAttribute("ERROR", AuthUtils.getAccessDeniedMessage("update product quantity"));
                return LOGIN_PAGE;
            }
            String productId = request.getParameter("productId");
            String quantity = request.getParameter("quantity");
            if (productId == null || quantity == null) {
                request.setAttribute("ERROR", "Product ID and quantity are required!");
            } else {
                int id = Integer.parseInt(productId);
                int qty = Integer.parseInt(quantity);
                if (qty < 0) {
                    request.setAttribute("ERROR", "Quantity must be non-negative!");
                } else if (productDAO.updateProductQuantity(id, qty)) {
                    request.setAttribute("SUCCESS", "Product quantity updated successfully!");
                } else {
                    request.setAttribute("ERROR", "Failed to update product quantity! Quantity may be less than ordered amount.");
                }
            }
            List<ProductDTO> products = productDAO.getAllProducts();
            List<CategoryDTO> categories = categoryDAO.getAllCategories();
            List<BrandDTO> brands = brandDAO.getAllBrands();
            request.setAttribute("PRODUCTS", products);
            request.setAttribute("CATEGORIES", categories);
            request.setAttribute("BRANDS", brands);
        } catch (Exception e) {
            request.setAttribute("ERROR", "Error updating product quantity: " + e.getMessage());
            e.printStackTrace();
        }
        return url;
    }

    private String handleDeleteProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String url = PRODUCTS_PAGE;
        try {
            if (!AuthUtils.isAdmin(request)) {
                request.setAttribute("ERROR", AuthUtils.getAccessDeniedMessage("delete product"));
                return LOGIN_PAGE;
            }
            String productId = request.getParameter("productId");
            if (productId == null) {
                request.setAttribute("ERROR", "Product ID is required!");
            } else {
                int id = Integer.parseInt(productId);
                if (productDAO.deleteProduct(id)) {
                    request.setAttribute("SUCCESS", "Product deleted successfully!");
                } else {
                    request.setAttribute("ERROR", "Failed to delete product! It may be referenced in orders.");
                }
            }
            List<ProductDTO> products = productDAO.getAllProducts();
            List<CategoryDTO> categories = categoryDAO.getAllCategories();
            List<BrandDTO> brands = brandDAO.getAllBrands();
            request.setAttribute("PRODUCTS", products);
            request.setAttribute("CATEGORIES", categories);
            request.setAttribute("BRANDS", brands);
        } catch (Exception e) {
            request.setAttribute("ERROR", "Error deleting product: " + e.getMessage());
            e.printStackTrace();
        }
        return url;
    }

    private String handleEditProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String url = PRODUCTS_PAGE;
        try {
            if (!AuthUtils.isAdmin(request)) {
                request.setAttribute("ERROR", AuthUtils.getAccessDeniedMessage("edit product"));
                return LOGIN_PAGE;
            }
            String productId = request.getParameter("productId");
            String productName = request.getParameter("productName");
            String productDescription = request.getParameter("productDescription");
            String productPrice = request.getParameter("productPrice");
            String productImage = request.getParameter("productImage");
            String categoryId = request.getParameter("categoryId");
            String brandId = request.getParameter("brandId");
            String status = request.getParameter("status");
            String quantity = request.getParameter("quantity");

            if (productId == null || productName == null || productPrice == null || categoryId == null || brandId == null || status == null || quantity == null) {
                request.setAttribute("ERROR", "All fields are required!");
                ProductDTO product = productDAO.getProductById(productId);
                List<ReviewDTO> reviews = reviewDAO.getReviewsByProductId(productId);
                List<CategoryDTO> categories = categoryDAO.getAllCategories();
                List<BrandDTO> brands = brandDAO.getAllBrands();
                request.setAttribute("PRODUCT", product);
                request.setAttribute("REVIEWS", reviews);
                request.setAttribute("CATEGORIES", categories);
                request.setAttribute("BRANDS", brands);
                return PRODUCT_DETAIL_PAGE;
            }

            int id = Integer.parseInt(productId);
            double price = Double.parseDouble(productPrice);
            int catId = Integer.parseInt(categoryId);
            int brId = Integer.parseInt(brandId);
            boolean stat = Boolean.parseBoolean(status);
            int qty = Integer.parseInt(quantity);

            if (price <= 0) {
                request.setAttribute("ERROR", "Price must be greater than 0!");
                ProductDTO product = productDAO.getProductById(productId);
                List<ReviewDTO> reviews = reviewDAO.getReviewsByProductId(productId);
                List<CategoryDTO> categories = categoryDAO.getAllCategories();
                List<BrandDTO> brands = brandDAO.getAllBrands();
                request.setAttribute("PRODUCT", product);
                request.setAttribute("REVIEWS", reviews);
                request.setAttribute("CATEGORIES", categories);
                request.setAttribute("BRANDS", brands);
                return PRODUCT_DETAIL_PAGE;
            }
            if (qty < 0) {
                request.setAttribute("ERROR", "Quantity must be non-negative!");
                ProductDTO product = productDAO.getProductById(productId);
                List<ReviewDTO> reviews = reviewDAO.getReviewsByProductId(productId);
                List<CategoryDTO> categories = categoryDAO.getAllCategories();
                List<BrandDTO> brands = brandDAO.getAllBrands();
                request.setAttribute("PRODUCT", product);
                request.setAttribute("REVIEWS", reviews);
                request.setAttribute("CATEGORIES", categories);
                request.setAttribute("BRANDS", brands);
                return PRODUCT_DETAIL_PAGE;
            }

            ProductDTO product = new ProductDTO(productName, productDescription, price, productImage, catId, brId, stat, qty);
            product.setProductId(id); // Gán productId bằng setter để sử dụng trong updateProduct
            if (productDAO.updateProduct(product)) {
                request.setAttribute("SUCCESS", "Product updated successfully!");
                List<ProductDTO> products = productDAO.getAllProducts();
                List<CategoryDTO> categories = categoryDAO.getAllCategories();
                List<BrandDTO> brands = brandDAO.getAllBrands();
                request.setAttribute("PRODUCTS", products);
                request.setAttribute("CATEGORIES", categories);
                request.setAttribute("BRANDS", brands);
            } else {
                request.setAttribute("ERROR", "Failed to update product!");
                ProductDTO existingProduct = productDAO.getProductById(productId);
                List<ReviewDTO> reviews = reviewDAO.getReviewsByProductId(productId);
                List<CategoryDTO> categories = categoryDAO.getAllCategories();
                List<BrandDTO> brands = brandDAO.getAllBrands();
                request.setAttribute("PRODUCT", existingProduct);
                request.setAttribute("REVIEWS", reviews);
                request.setAttribute("CATEGORIES", categories);
                request.setAttribute("BRANDS", brands);
                url = PRODUCT_DETAIL_PAGE;
            }
        } catch (Exception e) {
            request.setAttribute("ERROR", "Error updating product: " + e.getMessage());
            e.printStackTrace();
            String productId = request.getParameter("productId");
            ProductDTO product = productDAO.getProductById(productId);
            List<ReviewDTO> reviews = reviewDAO.getReviewsByProductId(productId);
            List<CategoryDTO> categories = categoryDAO.getAllCategories();
            List<BrandDTO> brands = brandDAO.getAllBrands();
            request.setAttribute("PRODUCT", product);
            request.setAttribute("REVIEWS", reviews);
            request.setAttribute("CATEGORIES", categories);
            request.setAttribute("BRANDS", brands);
            url = PRODUCT_DETAIL_PAGE;
        }
        return url;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Handles product-related operations including listing, searching, viewing details, and admin functions.";
    }
}