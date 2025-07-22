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
    private static final String CHANGE_PASSWORD_PAGE = "/changePassword.jsp";
    private static final String EDIT_PROFILE_PAGE = "/editProfile.jsp";
    private static final String ERROR_PAGE = "/error.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR_PAGE;
        try {
            String action = request.getParameter("action");
            log("UserController: Received action = " + action);
            UserDAO userDAO = new UserDAO();

            if ("login".equals(action)) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
                    request.setAttribute("ERROR", "Username and password are required!");
                    url = LOGIN_PAGE;
                } else {
                    UserDTO user = userDAO.checkLogin(username, password);
                    if (user != null) {
                        HttpSession session = request.getSession();
                        session.setAttribute("user", user);
                        url = HOME_PAGE;
                    } else {
                        request.setAttribute("ERROR", "Invalid username or password!");
                        url = LOGIN_PAGE;
                    }
                }
            } else if ("register".equals(action)) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String customerName = request.getParameter("customerName");
                String customerPhone = request.getParameter("customerPhone");
                String customerEmail = request.getParameter("customerEmail");
                String customerAddress = request.getParameter("customerAddress");

                if (username == null || username.isEmpty() || password == null || password.isEmpty()
                        || customerName == null || customerName.isEmpty() || customerPhone == null || customerPhone.isEmpty()) {
                    request.setAttribute("ERROR", "Username, password, name, and phone are required!");
                    url = REGISTER_PAGE;
                } else {
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
                }
            } else if ("logout".equals(action)) {
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                url = HOME_PAGE;
            } else if ("changePassword".equals(action)) {
                HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("user") == null) {
                    request.setAttribute("ERROR", "Please login to change your password!");
                    url = LOGIN_PAGE;
                } else if ("POST".equals(request.getMethod())) {
                    UserDTO user = (UserDTO) session.getAttribute("user");
                    String currentPassword = request.getParameter("currentPassword");
                    String newPassword = request.getParameter("newPassword");
                    String confirmPassword = request.getParameter("confirmPassword");

                    if (currentPassword == null || currentPassword.isEmpty()
                            || newPassword == null || newPassword.isEmpty()
                            || confirmPassword == null || confirmPassword.isEmpty()) {
                        request.setAttribute("ERROR", "All password fields are required!");
                        url = CHANGE_PASSWORD_PAGE;
                    } else if (!newPassword.equals(confirmPassword)) {
                        request.setAttribute("ERROR", "New password and confirm password do not match!");
                        url = CHANGE_PASSWORD_PAGE;
                    } else if (userDAO.checkLogin(user.getUsername(), currentPassword) == null) {
                        request.setAttribute("ERROR", "Current password is incorrect!");
                        url = CHANGE_PASSWORD_PAGE;
                    } else {
                        boolean updated = userDAO.updatePassword(user.getUsername(), newPassword);
                        if (updated) {
                            request.setAttribute("SUCCESS", "Password changed successfully!");
                            url = CHANGE_PASSWORD_PAGE;
                        } else {
                            request.setAttribute("ERROR", "Failed to change password!");
                            url = CHANGE_PASSWORD_PAGE;
                        }
                    }
                } else {
                    // GET request: Simply display the change password page
                    url = CHANGE_PASSWORD_PAGE;
                }
            } else if ("editProfile".equals(action)) {
                HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("user") == null) {
                    request.setAttribute("ERROR", "Please login to edit your profile!");
                    url = LOGIN_PAGE;
                } else {
                    UserDTO user = (UserDTO) session.getAttribute("user");
                    String username = request.getParameter("username");
                    String customerName = request.getParameter("customerName") != null ? request.getParameter("customerName") : "";
                    String customerPhone = request.getParameter("customerPhone") != null ? request.getParameter("customerPhone") : "";
                    String customerEmail = request.getParameter("customerEmail") != null ? request.getParameter("customerEmail") : "";
                    String customerAddress = request.getParameter("customerAddress") != null ? request.getParameter("customerAddress") : "";

                    boolean updated = userDAO.updateProfile(username, customerName, customerPhone, customerEmail, customerAddress);
                    if (updated) {
                        request.setAttribute("SUCCESS", "Profile updated successfully!");
                        url = EDIT_PROFILE_PAGE;
                    } else {
                        request.setAttribute("ERROR", "Failed to update profile!");
                        url = EDIT_PROFILE_PAGE;
                    }
                }
            }
        } catch (Exception e) {
            log("Error at UserController: " + e.toString(), e);
            request.setAttribute("ERROR", "An error occurred: " + e.getMessage());
        } finally {
            log("UserController: Forwarding to " + url);
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
        return "Handles user login, registration, logout, change password, and edit profile";
    }
}
