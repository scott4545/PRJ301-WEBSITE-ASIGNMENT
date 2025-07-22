<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.UserDTO"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Gaming Portal</title>
    <link rel="stylesheet" href="css/login.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <%
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user != null) {
            response.sendRedirect("home.jsp");
            return;
        }
    %>
    
    <div class="background-effects">
        <div class="grid-overlay"></div>
        <div class="glow-effect glow-1"></div>
        <div class="glow-effect glow-2"></div>
        <div class="glow-effect glow-3"></div>
    </div>

    <div class="login-container">
        <div class="login-header">
            <div class="logo">
                <i class="fas fa-gamepad"></i>
                <span>GAMING PORTAL</span>
            </div>
        </div>

        <div class="login-box">
            <div class="login-form-header">
                <h2>LOGIN</h2>
                <p>Access your gaming world</p>
            </div>

            <% if (request.getAttribute("ERROR") != null) { %>
                <div class="message error-message">
                    <i class="fas fa-exclamation-triangle"></i>
                    <%= request.getAttribute("ERROR") %>
                </div>
            <% } %>
            
            <% if (request.getAttribute("SUCCESS") != null) { %>
                <div class="message success-message">
                    <i class="fas fa-check-circle"></i>
                    <%= request.getAttribute("SUCCESS") %>
                </div>
            <% } %>

            <form action="MainController" method="POST" class="login-form">
                <input type="hidden" name="action" value="login">
                
                <div class="input-group">
                    <div class="input-wrapper">
                        <i class="fas fa-user input-icon"></i>
                        <input type="text" name="username" id="username" placeholder="Username" required>
                        <div class="input-border"></div>
                    </div>
                </div>

                <div class="input-group">
                    <div class="input-wrapper">
                        <i class="fas fa-lock input-icon"></i>
                        <input type="password" name="password" id="password" placeholder="Password" required>
                        <button type="button" class="toggle-password" onclick="togglePassword()">
                            <i class="fas fa-eye" id="toggle-icon"></i>
                        </button>
                        <div class="input-border"></div>
                    </div>
                </div>

                <div class="form-options">
                    <label class="checkbox-container">
                        <input type="checkbox" id="remember">
                        <span class="checkmark"></span>
                        Remember me
                    </label>
                    <a href="#" class="forgot-link">Forgot password?</a>
                </div>

                <button type="submit" class="login-btn">
                    <span>LOGIN</span>
                    <div class="btn-glow"></div>
                </button>

                <div class="register-link">
                    <span>Don't have an account? </span>
                    <a href="register.jsp">Register now</a>
                </div>
            </form>
        </div>
    </div>

    <script src="js/login.js"></script>
</body>
</html>