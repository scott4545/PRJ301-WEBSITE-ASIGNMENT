<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Tracking - Gaming Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/products.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .orders-section { padding: 20px; }
        .orders-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .orders-table th, .orders-table td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        .orders-table th { background-color: #f4f4f4; font-weight: 600; }
        .orders-table tr:nth-child(even) { background-color: #f9f9f9; }
        .orders-table tr:hover { background-color: #f1f1f1; }
        .no-orders { text-align: center; padding: 40px; }
        .no-orders i { font-size: 48px; color: #888; }
        .no-orders h3 { margin: 20px 0; font-size: 24px; }
    </style>
</head>
<body>
    <div class="container">
        <!-- Error Message -->
        <c:if test="${not empty ERROR}">
            <div class="error-message">
                <i class="fas fa-exclamation-triangle"></i>
                <p>${ERROR}</p>
                <a href="${pageContext.request.contextPath}/MainController?action=login" class="browse-btn">
                    <i class="fas fa-sign-in-alt"></i>
                    Log In
                </a>
            </div>
        </c:if>

        <!-- Navigation -->
        <nav class="navigation">
            <a href="${pageContext.request.contextPath}/home.jsp" class="back-btn">
                <i class="fas fa-arrow-left"></i>
                Back to Home
            </a>
            <a href="${pageContext.request.contextPath}/MainController?action=listProducts" class="back-btn">
                <i class="fas fa-gamepad"></i>
                Browse Products
            </a>
        </nav>

        <!-- Header -->
        <header class="header">
            <div class="header-content">
                <h1 class="page-title">
                    <i class="fas fa-shipping-fast"></i>
                    Order Tracking
                </h1>
                <div class="header-accent"></div>
            </div>
        </header>

        <!-- Orders Section -->
        <section class="orders-section">
            <c:choose>
                <c:when test="${not empty ORDERS}">
                    <table class="orders-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Product</th>
                                <th>Quantity</th>
                                <th>Unit Price</th>
                                <th>Total Amount</th>
                                <th>Order Date</th>
                                <th>Status</th>
                                <th>Delivery Address</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${ORDERS}">
                                <tr>
                                    <td>${order.orderId}</td>
                                    <td>${order.productName}</td>
                                    <td>${order.quantity}</td>
                                    <td><fmt:formatNumber value="${order.unitPrice}" type="number" pattern="#,##0"/> VND</td>
                                    <td><fmt:formatNumber value="${order.totalAmount}" type="number" pattern="#,##0"/> VND</td>
                                    <td><fmt:formatDate value="${order.orderDate}" pattern="dd-MM-yyyy"/></td>
                                    <td>${order.paymentStatus}</td>
                                    <td>${order.addressDelivery}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-orders">
                        <i class="fas fa-shopping-cart"></i>
                        <h3>No Orders Found</h3>
                        <p>You haven't placed any orders yet. Start shopping now!</p>
                        <a href="${pageContext.request.contextPath}/MainController?action=listProducts" class="browse-btn">
                            <i class="fas fa-gamepad"></i>
                            Browse Products
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </div>
</body>
</html>