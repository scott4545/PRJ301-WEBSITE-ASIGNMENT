/*
 * Click //nbfs://SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click //nbproject//Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author scott
 */
@WebServlet(name = "MainController", urlPatterns = {"/MainController", "/mainController", "/maincontroller", "/Maincontroller"})
public class MainController extends HttpServlet {
    private static final String HOME_PAGE = "/home.jsp";
   
    private boolean isUserAction(String action) {
        return "login".equals(action)
                || "register".equals(action)
                || "logout".equals(action)
                || "changePassword".equals(action)
                || "editProfile".equals(action);
    }

    private boolean isProductAction(String action) {
        return "listProducts".equals(action)
                || "search".equals(action)
                || "productDetail".equals(action)
                || "placeOrder".equals(action)
                || "confirmOrder".equals(action)
                || "trackOrder".equals(action)
                || "addReview".equals(action);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = HOME_PAGE;
        try {
            String action = request.getParameter("action");
            System.out.println("Processing action: " + action + ", URI: " + request.getRequestURI());
            if (isUserAction(action)) {
                url = "/UserController";
            } else if (isProductAction(action)) {
                url = "/ProductController";
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
}