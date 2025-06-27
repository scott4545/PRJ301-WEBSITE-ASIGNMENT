<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.UserDTO"%>
<!DOCTYPE html>
<html>
<head>
    <title>Change Password</title>
</head>
<body>
    <%
        UserDTO user = (UserDTO) session.getAttribute("USER");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>
    <h2>Change Password</h2>
    <% if (request.getAttribute("ERROR") != null) { %>
        <p style="color: red;"><%= request.getAttribute("ERROR") %></p>
    <% } %>
    <% if (request.getAttribute("SUCCESS") != null) { %>
        <p style="color: green;"><%= request.getAttribute("SUCCESS") %></p>
    <% } %>
    <form action="MainController" method="POST">
        <input type="hidden" name="action" value="changePassword">
        <label>Current Password:</label>
        <input type="password" name="currentPassword" required><br>
        <label>New Password:</label>
        <input type="password" name="newPassword" required><br>
        <label>Confirm New Password:</label>
        <input type="password" name="confirmPassword" required><br>
        <input type="submit" value="Change Password">
        <a href="home.jsp">Back to Home</a>
    </form>
</body>
</html>