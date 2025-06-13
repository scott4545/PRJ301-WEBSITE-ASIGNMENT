package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {
    private static final String LOGIN = "/UserController?action=login";
    private static final String REGISTER = "/UserController?action=register";
    private static final String LOGOUT = "/UserController?action=logout";
    private static final String CHANGE_PASSWORD = "/UserController?action=changePassword";
    private static final String EDIT_PROFILE = "/UserController?action=editProfile";
    private static final String PRODUCTS = "/ProductController?action=listProducts";
    private static final String SEARCH = "/ProductController?action=search";
    private static final String PRODUCT_DETAIL = "/ProductController?action=productDetail";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "/error.jsp";
        try {
            String action = request.getParameter("action");
            log("MainController: Received action = " + action);
            if ("login".equals(action)) {
                url = LOGIN;
            } else if ("register".equals(action)) {
                url = REGISTER;
            } else if ("logout".equals(action)) {
                url = LOGOUT;
            } else if ("changePassword".equals(action)) {
                url = CHANGE_PASSWORD;
            } else if ("editProfile".equals(action)) {
                url = EDIT_PROFILE;
            } else if ("listProducts".equals(action)) {
                url = PRODUCTS;
            } else if ("search".equals(action)) {
                url = SEARCH;
            } else if ("productDetail".equals(action)) {
                url = PRODUCT_DETAIL;
            }
            log("MainController: Forwarding to " + url);
            getServletContext().getRequestDispatcher(url).forward(request, response);
        } catch (Exception e) {
            log("Error at MainController: " + e.toString(), e);
            request.setAttribute("ERROR", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
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
        return "Main Controller for routing user actions";
    }
}