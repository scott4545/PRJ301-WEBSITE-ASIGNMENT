package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {
    private static final String USER_CONTROLLER = "/UserController";
    private static final String PRODUCT_CONTROLLER = "/ProductController";
    private static final String HOME_PAGE = "/home.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = HOME_PAGE;
        try {
            String action = request.getParameter("action");
            if (action == null) {
                url = HOME_PAGE;
            } else {
                switch (action) {
                    case "login":
                    case "register":
                    case "logout":
                    case "changePassword":
                    case "editProfile":
                        url = USER_CONTROLLER;
                        break;
                    case "listProducts":
                    case "search":
                    case "productDetail":
                        url = PRODUCT_CONTROLLER;
                        break;
                    default:
                        request.setAttribute("ERROR", "Invalid action!");
                        url = HOME_PAGE;
                        break;
                }
            }
        } catch (Exception e) {
            log("Error at MainController: " + e.toString(), e);
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