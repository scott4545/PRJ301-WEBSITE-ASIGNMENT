<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.UserDTO"%>
<!DOCTYPE html>
<html>
<head>
    <title>Home</title>
</head>
<body>
    <%
        UserDTO user = (UserDTO) session.getAttribute("USER");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>
    <h2>Welcome, <%= user.getUsername() %></h2>
    <a href="MainController?action=logout">Logout</a><br>
    <a href="changePassword.jsp">Change Password</a><br>
    <a href="editProfile.jsp">Edit Profile</a><br>
    <a href="MainController?action=listProducts">Browse Products</a>
</body>
</html>