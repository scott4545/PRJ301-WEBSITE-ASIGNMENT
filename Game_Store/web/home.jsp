<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.UserDTO"%>
<!DOCTYPE html>
<html>
<head>
    <title>Game Store - Home</title>
</head>
<body>
    <h2>Welcome to Game Store</h2>
    <%
        UserDTO user = (UserDTO) session.getAttribute("USER");
        if (user != null) {
    %>
        <p>Welcome, <%= user.getUsername() %>!</p>
        <a href="MainController?action=editProfile">Edit Profile</a><br>
        <a href="MainController?action=changePassword">Change Password</a><br>
        <a href="MainController?action=logout">Logout</a><br>
    <% } else { %>
        <a href="login.jsp">Login</a><br>
        <a href="register.jsp">Register</a><br>
    <% } %>
    <a href="MainController?action=listProducts">View Products</a><br>
    <form action="MainController" method="GET">
        <input type="hidden" name="action" value="search">
        <input type="text" name="query" placeholder="Search products...">
        <input type="submit" value="Search">
    </form>
</body>
</html>