<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="register-container">
        <% 
            String username = (session != null) ? (String) session.getAttribute("username") : null;
            if (username != null) {
                response.sendRedirect(request.getContextPath() + "/index.jsp"); // Chuyển hướng nếu đã đăng nhập
                return;
            }
        %>
        <h2>Đăng Ký Tài Khoản</h2>
        <form action="<%= request.getContextPath() %>/RegisterServlet" method="POST">
            <label for="username">Tên người dùng:</label>
            <input type="text" id="username" name="username" placeholder="Nhập tên người dùng" required>
            <label for="password">Mật khẩu:</label>
            <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
            <label for="customerName">Họ và tên:</label>
            <input type="text" id="customerName" name="customerName" placeholder="Nhập họ và tên" required>
            <label for="customerPhone">Số điện thoại:</label>
            <input type="text" id="customerPhone" name="customerPhone" placeholder="Nhập số điện thoại" required>
            <label for="customerEmail">Email khách hàng:</label>
            <input type="email" id="customerEmail" name="customerEmail" placeholder="Nhập email (tùy chọn)">
            <label for="customerAddress">Địa chỉ:</label>
            <input type="text" id="customerAddress" name="customerAddress" placeholder="Nhập địa chỉ (tùy chọn)">
            <button type="submit">Đăng ký</button>
            <p>Đã có tài khoản? <a href="<%= request.getContextPath() %>/login.jsp">Đăng nhập</a></p>
        </form>
    </div>
</body>
</html>