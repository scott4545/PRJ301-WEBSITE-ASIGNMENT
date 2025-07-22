
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click //nbproject//Templates/Classes/Class.java to edit this template
 */
package utils;

import model.UserDTO;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;

/**
 * Utility class for handling authentication and authorization in the Game Store application.
 * Provides methods to manage user sessions, check login status, verify roles, and handle access control.
 *
 * @author scott
 */
public class AuthUtils {


    public static UserDTO getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false); // Use false to avoid creating a new session
        if (session != null) {
            return (UserDTO) session.getAttribute("user");
        }
        return null;
    }


    public static boolean isLoggedIn(HttpServletRequest request) {
        return getCurrentUser(request) != null;
    }


    public static boolean hasRole(HttpServletRequest request, String role) {
        UserDTO user = getCurrentUser(request);
        if (user != null && user.getUserRole() != null) {
            return user.getUserRole().equals(role);
        }
        return false;
    }
    
    public static boolean isAdmin(HttpServletRequest request) {
        return hasRole(request, "A");
    }


    public static boolean isCustomer(HttpServletRequest request) {
        return hasRole(request, "K");
    }


    public static void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }


    public static String getLoginURL(HttpServletRequest request) {
        return request.getContextPath() + "/MainController?action=login";
    }


    public static String getAccessDeniedMessage(String action) {
        return "You don't have permission to " + action + ". Please contact administrator.";
    }
}
