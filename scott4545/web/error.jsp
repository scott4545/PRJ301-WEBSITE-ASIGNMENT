<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
</head>
<body>
    <h2>Error</h2>
    <p style="color: red;"><%= request.getAttribute("ERROR") %></p>
    <a href="login.jsp">Back to Login</a>
</body>
</html>