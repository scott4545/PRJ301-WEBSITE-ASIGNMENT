<!-- File: Web Pages/login.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="login-container">
        <% 
            // Sử dụng session ngầm định mà không khai báo lại
            String username = (session != null) ? (String) session.getAttribute("username") : null;
            if (username != null) {
                response.sendRedirect(request.getContextPath() + "/index.jsp"); // Chuyển hướng nếu đã đăng nhập
                return;
            }
        %>
        <h2>Đăng Nhập Tài Khoản</h2>
        <form action="<%= request.getContextPath() %>/LoginServlet" method="POST">
            <label for="username">Tên người dùng:</label>
            <input type="text" id="username" name="username" placeholder="Nhập tên người dùng" required>
            <label for="password">Mật khẩu:</label>
            <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
            <button type="submit">Đăng nhập</button>
            <p>Chưa có tài khoản? <a href="<%= request.getContextPath() %>/register.jsp">Đăng ký</a></p>
        </form>
    </div>
</body>
</html>