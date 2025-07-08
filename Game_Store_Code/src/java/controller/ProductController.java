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
import model.BrandDAO;
import model.BrandDTO;
import model.CategoryDAO;
import model.CategoryDTO;
import model.ProductDAO;
import model.ProductDTO;
import model.ReviewDAO;
import model.ReviewDTO;

/**
 * Handles product-related requests such as listing, searching, and viewing
 * product details.
 *
 * @author scott
 */
@WebServlet(name = "ProductController", urlPatterns = {"/ProductController"})
public class ProductController extends HttpServlet {

    private static final String PRODUCTS_PAGE = "/products.jsp";
    private static final String PRODUCT_DETAIL_PAGE = "/productDetail.jsp";
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
            if ("listProducts".equals(action)) {
                url = handleProductListing(request, response);
            } else if ("search".equals(action)) {
                url = handleProductSearch(request, response);
            } else if ("productDetail".equals(action)) {
                url = handleProductDetail(request, response);
            } else {
                request.setAttribute("ERROR", "Invalid action!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR", "An error occurred: " + e.getMessage());
        } finally {
            System.out.println("Forwarding to: " + url);
            request.getRequestDispatcher(url).forward(request, response);
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
        return "Handles product-related operations including listing, searching, and viewing details.";
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

    /**
     * Handles product search with query and optional filters.
     *
     * @param request the HttpServletRequest object
     * @param response the HttpServletResponse object
     * @return the URL to forward to
     */
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

    /**
     * Handles displaying details of a specific product, including its reviews.
     *
     * @param request the HttpServletRequest object
     * @param response the HttpServletResponse object
     * @return the URL to forward to
     */
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
}