<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.UserDTO, model.UserDAO"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile</title>
</head>
<body>
    <%
        UserDTO user = (UserDTO) session.getAttribute("USER");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        UserDAO userDAO = new UserDAO();
        String[] customerInfo = userDAO.getCustomerInfo(user.getUsername());
        String customerName = customerInfo[0] != null ? customerInfo[0] : "";
        String customerPhone = customerInfo[1] != null ? customerInfo[1] : "";
        String customerEmail = customerInfo[2] != null ? customerInfo[2] : "";
        String customerAddress = customerInfo[3] != null ? customerInfo[3] : "";
    %>
    <h2>Edit Profile</h2>
    <% if (request.getAttribute("ERROR") != null) { %>
        <p style="color: red;"><%= request.getAttribute("ERROR") %></p>
    <% } %>
    <% if (request.getAttribute("SUCCESS") != null) { %>
        <p style="color: green;"><%= request.getAttribute("SUCCESS") %></p>
    <% } %>
    <form action="MainController" method="POST">
        <input type="hidden" name="action" value="editProfile">
        <input type="hidden" name="username" value="<%= user.getUsername() %>">
        <label>Customer Name:</label>
        <input type="text" name="customerName" value="<%= customerName %>" placeholder="Enter name or leave empty"><br>
        <label>Phone:</label>
        <input type="text" name="customerPhone" value="<%= customerPhone %>" placeholder="Enter phone or leave empty"><br>
        <label>Email:</label>
        <input type="email" name="customerEmail" value="<%= customerEmail %>" placeholder="Enter email or leave empty"><br>
        <label>Address:</label>
        <input type="text" name="customerAddress" value="<%= customerAddress %>" placeholder="Enter address or leave empty"><br>
        <input type="submit" value="Update Profile">
        <a href="home.jsp">Back to Home</a>
    </form>
</body>
</html>