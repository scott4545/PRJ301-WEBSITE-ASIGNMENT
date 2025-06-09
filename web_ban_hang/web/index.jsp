<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="header">
        <% 
            String username = (session != null) ? (String) session.getAttribute("username") : null;
        %>
        <h2>Chào mừng đến với Trang Chủ</h2>
        <div class="auth-links">
            <% if (username == null) { %>
                <a href="<%= request.getContextPath() %>/login.jsp">Đăng nhập</a>
            <% } else { %>
                <span>Xin chào, <%= username %>!</span>
                <a href="<%= request.getContextPath() %>/LogoutServlet">Đăng xuất</a>
            <% } %>
        </div>
    </div>
</body>
</html>

