<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Tracking - Gaming Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Titillium+Web:wght@300;400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/orderTracking.css">
</head>
<body>
    <div class="razer-bg"></div>
    
    <div class="container">
        <!-- Header -->
        <header class="razer-header">
            <div class="header-content">
                <div class="logo-section">
                    <i class="fas fa-shipping-fast"></i>
                    <h1>ORDER TRACKING</h1>
                </div>
                <div class="header-glow"></div>
            </div>
        </header>

        <!-- Navigation -->
        <nav class="razer-nav">
            <div class="nav-content">
                <a href="${pageContext.request.contextPath}/home.jsp" class="nav-btn">
                    <i class="fas fa-home"></i>
                    <span>HOME</span>
                </a>
                <a href="${pageContext.request.contextPath}/MainController?action=listProducts" class="nav-btn">
                    <i class="fas fa-gamepad"></i>
                    <span>BROWSE PRODUCTS</span>
                </a>
            </div>
        </nav>

        <!-- Success Message -->
        <c:if test="${not empty SUCCESS}">
            <div class="razer-success">
                <div class="success-content">
                    <i class="fas fa-check-circle"></i>
                    <div class="success-text">
                        <h3>ORDER SUCCESS</h3>
                        <p>${SUCCESS}</p>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Error Message -->
        <c:if test="${not empty ERROR}">
            <div class="razer-error">
                <div class="error-content">
                    <i class="fas fa-exclamation-triangle"></i>
                    <div class="error-text">
                        <h3>ACCESS DENIED</h3>
                        <p>${ERROR}</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/MainController?action=login" class="razer-btn">
                        <i class="fas fa-sign-in-alt"></i>
                        <span>LOG IN</span>
                    </a>
                </div>
            </div>
        </c:if>

        <!-- Orders Section -->
        <section class="orders-section">
            <c:choose>
                <c:when test="${not empty ORDERS}">
                    <div class="section-header">
                        <h2><i class="fas fa-list-alt"></i> YOUR ORDERS</h2>
                        <div class="section-line"></div>
                        <div class="order-stats">
                            <div class="stat-item">
                                <span class="stat-number">${ORDERS.size()}</span>
                                <span class="stat-label">Total Orders</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="table-container">
                        <table class="razer-table">
                            <thead>
                                <tr>
                                    <th><i class="fas fa-hashtag"></i> ORDER ID</th>
                                    <th><i class="fas fa-box"></i> PRODUCT</th>
                                    <th><i class="fas fa-sort-numeric-up"></i> QTY</th>
                                    <th><i class="fas fa-tag"></i> UNIT PRICE</th>
                                    <th><i class="fas fa-calculator"></i> TOTAL</th>
                                    <th><i class="fas fa-calendar"></i> DATE</th>
                                    <th><i class="fas fa-info-circle"></i> STATUS</th>
                                    <th><i class="fas fa-map-marker-alt"></i> DELIVERY</th>
                                    <th><i class="fas fa-cogs"></i> ACTIONS</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${ORDERS}">
                                    <tr class="order-row">
                                        <td>
                                            <span class="order-id">#${order.orderId}</span>
                                        </td>
                                        <td>
                                            <div class="product-info">
                                                <i class="fas fa-gamepad product-icon"></i>
                                                <span>${order.productName}</span>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="quantity-badge">${order.quantity}</span>
                                        </td>
                                        <td>
                                            <span class="price"><fmt:formatNumber value="${order.unitPrice}" type="number" pattern="#,##0"/> VND</span>
                                        </td>
                                        <td>
                                            <span class="total-amount"><fmt:formatNumber value="${order.totalAmount}" type="number" pattern="#,##0"/> VND</span>
                                        </td>
                                        <td>
                                            <span class="order-date"><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/></span>
                                        </td>
                                        <td>
                                            <span class="status-badge status-${order.paymentStatus.toLowerCase().replace(' ', '-')}">${order.paymentStatus}</span>
                                        </td>
                                        <td>
                                            <div class="address-info">
                                                <i class="fas fa-location-dot"></i>
                                                <span>${order.addressDelivery}</span>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="MainController?action=productDetail&productId=${order.productId}" class="action-btn view-product">
                                                    <i class="fas fa-eye"></i>
                                                    <span>View Product</span>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                    <div class="order-summary">
                        <div class="summary-card">
                            <h3><i class="fas fa-chart-bar"></i> Order Summary</h3>
                            <div class="summary-stats">
                                <div class="summary-item">
                                    <span class="summary-label">Pending Orders:</span>
                                    <span class="summary-value pending-count">0</span>
                                </div>
                                <div class="summary-item">
                                    <span class="summary-label">Completed Orders:</span>
                                    <span class="summary-value completed-count">0</span>
                                </div>
                                <div class="summary-item">
                                    <span class="summary-label">Total Spent:</span>
                                    <span class="summary-value total-spent">0 VND</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-orders">
                        <div class="no-orders-content">
                            <div class="no-orders-icon">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                            <h3>NO ORDERS FOUND</h3>
                            <p>Your gaming arsenal is empty. Time to gear up!</p>
                            <div class="no-orders-actions">
                                <a href="${pageContext.request.contextPath}/MainController?action=listProducts" class="razer-btn primary">
                                    <i class="fas fa-gamepad"></i>
                                    <span>EXPLORE GAMING GEAR</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </div>

    <!-- Particle effects -->
    <div class="particles">
        <div class="particle"></div>
        <div class="particle"></div>
        <div class="particle"></div>
        <div class="particle"></div>
        <div class="particle"></div>
    </div>

    <script>
        // Calculate order statistics
        document.addEventListener('DOMContentLoaded', function() {
            const orders = document.querySelectorAll('.order-row');
            let pendingCount = 0;
            let completedCount = 0;
            let totalSpent = 0;

            orders.forEach(row => {
                const status = row.querySelector('.status-badge').textContent.trim();
                const totalAmount = parseFloat(row.querySelector('.total-amount').textContent.replace(/[^\d]/g, ''));
                
                if (status.toLowerCase().includes('pending')) {
                    pendingCount++;
                } else if (status.toLowerCase().includes('completed') || status.toLowerCase().includes('paid')) {
                    completedCount++;
                }
                
                totalSpent += totalAmount;
            });

            // Update summary
            const pendingElement = document.querySelector('.pending-count');
            const completedElement = document.querySelector('.completed-count');
            const totalSpentElement = document.querySelector('.total-spent');

            if (pendingElement) pendingElement.textContent = pendingCount;
            if (completedElement) completedElement.textContent = completedCount;
            if (totalSpentElement) {
                totalSpentElement.textContent = new Intl.NumberFormat('vi-VN').format(totalSpent) + ' VND';
            }
        });

        // Add hover effects
        document.querySelectorAll('.action-btn').forEach(btn => {
            btn.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-2px)';
            });
            btn.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });
    </script>
</body>
</html>