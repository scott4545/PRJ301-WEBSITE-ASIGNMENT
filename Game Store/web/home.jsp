<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Home</title>
</head>
<body>
    <h2>Welcome, <%= ((model.UserDTO) session.getAttribute("USER")).getUsername() %></h2>
    <a href="MainController?action=logout">Logout</a>
</body>
</html>