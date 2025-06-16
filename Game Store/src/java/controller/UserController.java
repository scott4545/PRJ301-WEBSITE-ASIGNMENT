package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.UserDAO;
import model.UserDTO;

@WebServlet(name = "UserController", urlPatterns = {"/UserController"})
public class UserController extends HttpServlet {
    private static final String LOGIN_PAGE = "/login.jsp";
    private static final String REGISTER_PAGE = "/register.jsp";
    private static final String HOME_PAGE = "/home.jsp";
    private static final String ERROR_PAGE = "/error.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR_PAGE;
        try {
            String action = request.getParameter("action");
            log("UserController: Received action = " + action); // Debug log
            UserDAO userDAO = new UserDAO();

            if ("login".equals(action)) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                UserDTO user = userDAO.checkLogin(username, password);
                if (user != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("USER", user);
                    url = HOME_PAGE;
                } else {
                    request.setAttribute("ERROR", "Invalid username or password!");
                    url = LOGIN_PAGE;
                }
            } else if ("register".equals(action)) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String customerName = request.getParameter("customerName");
                String customerPhone = request.getParameter("customerPhone");
                String customerEmail = request.getParameter("customerEmail");
                String customerAddress = request.getParameter("customerAddress");
                
                if (!userDAO.checkUsernameExists(username)) {
                    UserDTO user = new UserDTO(0, username, password, "K");
                    boolean registered = userDAO.registerUser(user, customerName, customerPhone, customerEmail, customerAddress);
                    if (registered) {
                        url = LOGIN_PAGE;
                        request.setAttribute("SUCCESS", "Registration successful! Please login.");
                    } else {
                        request.setAttribute("ERROR", "Registration failed!");
                        url = REGISTER_PAGE;
                    }
                } else {
                    request.setAttribute("ERROR", "Username already exists!");
                    url = REGISTER_PAGE;
                }
            } else if ("logout".equals(action)) {
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                url = LOGIN_PAGE;
            }
        } catch (Exception e) {
            log("Error at UserController: " + e.toString(), e);
            request.setAttribute("ERROR", "An error occurred: " + e.getMessage());
        } finally {
            log("UserController: Forwarding to " + url); // Debug log
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
        return "Handles user login, registration, and logout";
    }
}