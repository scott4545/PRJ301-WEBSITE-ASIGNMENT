package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "MainController", urlPatterns = {"/MainController", "/mainController", "/maincontroller", "/Maincontroller"})
public class MainController extends HttpServlet {

    private static final String USER_CONTROLLER = "/UserController";
    private static final String PRODUCT_CONTROLLER = "/ProductController";
    private static final String ERROR_PAGE = "/error.jsp";

    private boolean isUserAction(String action) {
        return "login".equals(action)
                || "register".equals(action)
                || "logout".equals(action)
                || "editProfile".equals(action)
                || "changePassword".equals(action);
    }

    private boolean isProductAction(String action) {
        return "listProducts".equals(action)
                || "search".equals(action)
                || "productDetail".equals(action)
                || "addProduct".equals(action)
                || "changeProductStatus".equals(action)
                || "updateProductQuantity".equals(action)
                || "deleteProduct".equals(action)
                || "editProduct".equals(action)
                || "placeOrder".equals(action)
                || "confirmOrder".equals(action)
                || "trackOrder".equals(action)
                || "addReview".equals(action);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR_PAGE;
        try {
            String action = request.getParameter("action");
            System.out.println("MainController received action: " + action); // Debug
            if (action == null) {
                url = ERROR_PAGE;
                request.setAttribute("ERROR", "No action specified!");
            } else if (isUserAction(action)) {
                url = USER_CONTROLLER;
            } else if (isProductAction(action)) {
                url = PRODUCT_CONTROLLER;
            } else {
                request.setAttribute("ERROR", "Invalid action!");
            }
        } catch (Exception e) {
            request.setAttribute("ERROR", "An error occurred: " + e.getMessage());
            e.printStackTrace();
        } finally {
            System.out.println("MainController forwarding to: " + url); // Debug
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