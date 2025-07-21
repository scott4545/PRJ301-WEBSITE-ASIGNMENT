<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.UserDTO"%>
<%@page import="java.util.List"%>
<%@page import="model.ProductDTO"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GameZone - Premium Gaming Store</title>
    <link rel="stylesheet" href="css/home.css">
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="nav-container">
            <a href="#" class="logo">🎮 GameZone</a>
            
            <nav class="nav-menu" id="navMenu">
                <div class="search-container">
                    <form class="search-form" action="MainController" method="GET">
                        <input type="hidden" name="action" value="search">
                        <input type="text" name="query" class="search-input" placeholder="Search gaming gear...">
                        <button type="submit" class="search-btn">🔍</button>
                    </form>
                </div>
                
                <a href="MainController?action=listProducts" class="nav-link">Products</a>
                <a href="home.jsp"></a>
                <%
                    UserDTO user = (UserDTO) session.getAttribute("user");
                    if (user != null) {
                %>
                    <a href="MainController?action=trackOrder" class="nav-link">My Orders</a>
                <% } %>
            </nav>

            <div class="user-section">
                <%
                    if (user != null) {
                %>
                    <div class="user-menu">
                        <a href="#" class="nav-link" onclick="toggleDropdown()">
                            👤 <%= user.getUsername() %> ▼
                        </a>
                        <div class="dropdown" id="userDropdown">
                            <a href="MainController?action=editProfile">✏️ Edit Profile</a>
                            <a href="MainController?action=changePassword">🔒 Change Password</a>
                            <a href="MainController?action=trackOrder">🛒 My Orders</a>
                            <a href="MainController?action=logout">🚪 Logout</a>
                        </div>
                    </div>
                <% } else { %>
                    <div class="auth-buttons">
                        <a href="login.jsp" class="auth-btn">Login</a>
                        <a href="register.jsp" class="auth-btn primary">Register</a>
                    </div>
                <% } %>
            </div>

            <button class="mobile-menu-btn" onclick="toggleMobileMenu()">☰</button>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h1>Level Up Your Game</h1>
            <p>Discover premium gaming gear for ultimate performance</p>
            <a href="MainController?action=listProducts" class="cta-button">Shop Now</a>
        </div>
    </section>

    

    <script src="js/home.js"></script>
</body>
</html>