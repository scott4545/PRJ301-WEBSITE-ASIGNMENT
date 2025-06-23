<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.UserDTO"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <%
        // Check if user is already logged in
        UserDTO user = (UserDTO) session.getAttribute("USER");
        if (user != null) {
            response.sendRedirect("home.jsp");
            return;
        }
    %>
    <h2>Login</h2>
    <% if (request.getAttribute("ERROR") != null) { %>
        <p style="color: red;"><%= request.getAttribute("ERROR") %></p>
    <% } %>
    <% if (request.getAttribute("SUCCESS") != null) { %>
        <p style="color: green;"><%= request.getAttribute("SUCCESS") %></p>
    <% } %>
    <form action="MainController" method="POST">
        <input type="hidden" name="action" value="login">
        <label>Username:</label>
        <input type="text" name="username" required><br>
        <label>Password:</label>
        <input type="password" name="password" required><br>
        <input type="submit" value="Login">
        <a href="register.jsp">Register</a>
    </form>
</body>
</html>