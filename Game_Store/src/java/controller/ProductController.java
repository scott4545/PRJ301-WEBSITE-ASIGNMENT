package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.*;

@WebServlet(name = "ProductController", urlPatterns = {"/ProductController"})
public class ProductController extends HttpServlet {
    private static final String PRODUCTS_PAGE = "/products.jsp";
    private static final String SEARCH_PAGE = "/search.jsp";
    private static final String PRODUCT_DETAIL_PAGE = "/productDetail.jsp";
    private static final String ERROR_PAGE = "/error.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR_PAGE;
        try {
            String action = request.getParameter("action");
            ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            BrandDAO brandDAO = new BrandDAO();
            ReviewDAO reviewDAO = new ReviewDAO();

            if ("listProducts".equals(action)) {
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
                url = PRODUCTS_PAGE;
            } else if ("search".equals(action)) {
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
                url = SEARCH_PAGE;
            } else if ("productDetail".equals(action)) {
                String productId = request.getParameter("productId");
                ProductDTO product = productDAO.getProductById(productId);
                List<ReviewDTO> reviews = reviewDAO.getReviewsByProductId(productId);

                if (product != null) {
                    request.setAttribute("PRODUCT", product);
                    request.setAttribute("REVIEWS", reviews);
                    url = PRODUCT_DETAIL_PAGE;
                } else {
                    request.setAttribute("ERROR", "Product not found!");
                }
            }
        } catch (Exception e) {
            log("Error at ProductController: " + e.toString(), e);
            request.setAttribute("ERROR", "An error occurred: " + e.getMessage());
        } finally {
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
}