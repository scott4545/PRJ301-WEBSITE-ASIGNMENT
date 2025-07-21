/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click //nbproject//Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.BrandDAO;
import model.BrandDTO;
import model.CategoryDAO;
import model.CategoryDTO;
import model.OrderDAO;
import model.OrderDTO;
import model.ProductDAO;
import model.ProductDTO;
import model.ReviewDAO;
import model.ReviewDTO;
import model.UserDAO;
import model.UserDTO;

/**
 * Handles product-related requests such as listing, searching, viewing product details,
 * placing orders, tracking orders, and adding reviews.
 *
 * @author scott
 */
@WebServlet(name = "ProductController", urlPatterns = {"/ProductController"})
public class ProductController extends HttpServlet {

    private static final String PRODUCTS_PAGE = "/products.jsp";
    private static final String PRODUCT_DETAIL_PAGE = "/productDetail.jsp";
    private static final String ERROR_PAGE = "/error.jsp";
    private static final String ORDER_TRACKING_PAGE = "/orderTracking.jsp";

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final BrandDAO brandDAO = new BrandDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final UserDAO userDAO = new UserDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR_PAGE;
        try {
            String action = request.getParameter("action");
            if ("listProducts".equals(action)) {
                url = handleProductListing(request, response);
            } else if ("search".equals(action)) {
                url = handleProductSearch(request, response);
            } else if ("productDetail".equals(action)) {
                url = handleProductDetail(request, response);
            } else if ("placeOrder".equals(action)) {
                url = handlePlaceOrder(request, response);
            } else if ("confirmOrder".equals(action)) {
                url = handleConfirmOrder(request, response);
            } else if ("trackOrder".equals(action)) {
                url = handleTrackOrder(request, response);
            } else if ("addReview".equals(action)) {
                url = handleAddReview(request, response);
            } else {
                request.setAttribute("ERROR", "Invalid action!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR", "An error occurred: " + e.getMessage());
        } finally {
            if (url != null) {
                System.out.println("Forwarding to: " + url);
                request.getRequestDispatcher(url).forward(request, response);
            }
        }
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
        return "Handles product-related operations including listing, searching, viewing details, placing orders, tracking orders, and adding reviews.";
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
            request.setAttribute("PRODUCT", product);
            request.setAttribute("REVIEWS", reviews);
            return PRODUCT_DETAIL_PAGE;
        } else {
            request.setAttribute("ERROR", "Product not found!");
            return ERROR_PAGE;
        }
    }

    private String handlePlaceOrder(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("USER");
        System.out.println("User in session: " + (user != null ? user.getUsername() : "null"));

        if (user == null) {
            request.setAttribute("ERROR", "Please log in to place an order!");
            System.out.println("Error: User not logged in");
            return ERROR_PAGE;
        }

        String productId = request.getParameter("productId");
        System.out.println("Received productId: " + productId);

        if (productId == null) {
            request.setAttribute("ERROR", "Missing product information!");
            System.out.println("Error: Missing productId");
            return ERROR_PAGE;
        }

        ProductDTO product = productDAO.getProductById(productId);
        System.out.println("Product found: " + (product != null ? product.getProductName() : "null"));
        if (product == null) {
            request.setAttribute("ERROR", "Product not found for ID: " + productId);
            System.out.println("Error: Product not found for ID: " + productId);
            return ERROR_PAGE;
        }

        // Pass product data to order form
        request.setAttribute("PRODUCT_ID", productId);
        request.setAttribute("PRODUCT_NAME", product.getProductName());
        return "/orderForm.jsp";
    }

  private String handleConfirmOrder(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("USER");
        System.out.println("User in session: " + (user != null ? user.getUsername() : "null"));

        if (user == null) {
            request.setAttribute("ERROR", "Please log in to confirm order!");
            System.out.println("Error: User not logged in");
            return ERROR_PAGE;
        }

        String productId = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");
        String addressDelivery = request.getParameter("addressDelivery");
        System.out.println("Confirming order - productId: " + productId + ", quantityStr: " + quantityStr + ", addressDelivery: " + addressDelivery);

        if (productId == null || quantityStr == null || addressDelivery == null || addressDelivery.trim().isEmpty()) {
            request.setAttribute("ERROR", "Missing required order information! (productId=" + productId + ", quantity=" + quantityStr + ", address=" + addressDelivery + ")");
            System.out.println("Error: Missing required order information");
            return ERROR_PAGE;
        }

        try {
            int quantity = Integer.parseInt(quantityStr);
            System.out.println("Parsed quantity for order: " + quantity);
            if (quantity <= 0) {
                request.setAttribute("ERROR", "Invalid quantity! (quantity=" + quantity + ")");
                System.out.println("Error: Invalid quantity: " + quantity);
                return ERROR_PAGE;
            }

            ProductDTO product = productDAO.getProductById(productId);
            System.out.println("Product for order: " + (product != null ? product.getProductName() : "null"));
            if (product == null) {
                request.setAttribute("ERROR", "Product not found for ID: " + productId);
                System.out.println("Error: Product not found for ID: " + productId);
                return ERROR_PAGE;
            }

            String[] customerInfo = userDAO.getCustomerInfo(user.getUsername());
            System.out.println("Customer info: " + (customerInfo != null && customerInfo.length > 0 ? customerInfo[0] : "null"));
            if (customerInfo == null || customerInfo.length == 0) {
                request.setAttribute("ERROR", "Customer information not found for username: " + user.getUsername());
                System.out.println("Error: Customer info not found for username: " + user.getUsername());
                return ERROR_PAGE;
            }

            double totalAmount = product.getProductPrice() * quantity;
            OrderDTO order = new OrderDTO();
            order.setCustomerId(user.getUserID());
            order.setCustomerUsername(user.getUsername());
            order.setTotalAmount(totalAmount);
            order.setAddressDelivery(addressDelivery);
            order.setPaymentStatus("Pending");

            int orderId = orderDAO.createOrder(order, productId, quantity, product.getProductPrice());
            System.out.println("Order creation attempt completed, orderId: " + orderId);
            if (orderId > 0) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
                String currentTime = sdf.format(new java.util.Date());
                request.setAttribute("ORDER_ID", orderId);
                request.setAttribute("PRODUCT_ID", productId);
                request.setAttribute("CURRENT_TIME", currentTime);
                System.out.println("Forwarding to: /orderSuccess.jsp");
                return "/orderSuccess.jsp";
            } else {
                request.setAttribute("ERROR", "Failed to place order! Check database logs. (orderId=" + orderId + ")");
                System.out.println("Error: Failed to create order, orderId: " + orderId);
                return ERROR_PAGE;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("ERROR", "Invalid quantity format! " + e.getMessage());
            System.out.println("Error: Invalid quantity format: " + e.getMessage());
            return ERROR_PAGE;
        } catch (Exception e) {
            request.setAttribute("ERROR", "Unexpected error: " + e.getMessage());
            System.out.println("Error: Unexpected exception: " + e.getMessage());
            e.printStackTrace();
            return ERROR_PAGE;
        }
    }
    
    private String handleTrackOrder(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("USER");
        if (user == null) {
            request.setAttribute("ERROR", "Please log in to track your orders!");
            return ERROR_PAGE;
        }

        List<OrderDTO> orders = orderDAO.getOrdersByCustomerId(user.getUserID());
        request.setAttribute("ORDERS", orders);
        return ORDER_TRACKING_PAGE;
    }

    private String handleAddReview(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("USER");
        if (user == null) {
            request.setAttribute("ERROR", "Please log in to submit a review!");
            return ERROR_PAGE;
        }

        String productId = request.getParameter("productId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (productId == null || ratingStr == null) {
            request.setAttribute("ERROR", "Missing required review information!");
            return ERROR_PAGE;
        }

        try {
            int rating = Integer.parseInt(ratingStr);
            if (rating < 1 || rating > 5) {
                request.setAttribute("ERROR", "Rating must be between 1 and 5!");
                return ERROR_PAGE;
            }

            ProductDTO product = productDAO.getProductById(productId);
            if (product == null) {
                request.setAttribute("ERROR", "Product not found!");
                return ERROR_PAGE;
            }

            ReviewDTO review = new ReviewDTO();
            review.setProductId(Integer.parseInt(productId));
            review.setUsername(user.getUsername());
            review.setRating(rating);
            review.setComment(comment != null ? comment.trim() : "");

            boolean success = reviewDAO.addReview(review);
            if (success) {
                request.setAttribute("SUCCESS", "Review submitted successfully!");
            } else {
                request.setAttribute("ERROR", "Failed to submit review!");
            }
            return handleProductDetail(request, response); // Reload product detail page
        } catch (NumberFormatException e) {
            request.setAttribute("ERROR", "Invalid rating format!");
            return ERROR_PAGE;
        }
    }
}