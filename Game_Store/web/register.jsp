<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
</head>
<body>
    <h2>Register</h2>
    <% if (request.getAttribute("ERROR") != null) { %>
        <p style="color: red;"><%= request.getAttribute("ERROR") %></p>
    <% } %>
    <form action="MainController" method="POST">
        <input type="hidden" name="action" value="register">
        <label>Username:</label>
        <input type="text" name="username" required><br>
        <label>Password:</label>
        <input type="password" name="password" required><br>
        <label>Customer Name:</label>
        <input type="text" name="customerName" required><br>
        <label>Phone:</label>
        <input type="text" name="customerPhone" required><br>
        <label>Email:</label>
        <input type="email" name="customerEmail"><br>
        <label>Address:</label>
        <input type="text" name="customerAddress"><br>
        <input type="submit" value="Register">
        <a href="login.jsp">Back to Login</a>
    </form>
</body>
</html>