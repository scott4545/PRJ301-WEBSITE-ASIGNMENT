<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Place Order - Game Store</title>
</head>
<body>
    <h1>Place Your Order</h1>

    <c:if test="${not empty ERROR}">
        <p style="color: red;">${ERROR}</p>
    </c:if>

    <c:if test="${not empty MESSAGE}">
        <p style="color: green;">${MESSAGE}</p>
    </c:if>

    <c:if test="${empty sessionScope.user}">
        <p>You must be logged in to place an order. <a href="${pageContext.request.contextPath}/MainController?action=login">Login here</a>.</p>
    </c:if>

    <c:if test="${not empty sessionScope.user}">
        <c:if test="${sessionScope.user.userRole eq 'K'}">
            <form action="${pageContext.request.contextPath}/MainController" method="POST" id="orderForm">
                <input type="hidden" name="action" value="placeOrder">

                <p>Select Products:</p>
                <c:forEach var="product" items="${PRODUCTS}">
                    <div>
                        <label>
                            <input type="checkbox" name="productId" value="${product.productId}" 
                                   data-price="${product.productPrice}" 
                                   <c:if test="${product.stockQuantity <= 0}">disabled</c:if>>
                            ${product.productName} - <fmt:formatNumber value="${product.productPrice}" type="number" pattern="#,##0"/> VND
                            <c:choose>
                                <c:when test="${product.stockQuantity > 0}">
                                    (In Stock: ${product.stockQuantity})
                                </c:when>
                                <c:otherwise>
                                    (Out of Stock)
                                </c:otherwise>
                            </c:choose>
                        </label>
                        <input type="number" name="quantity" min="1" max="${product.stockQuantity}" 
                               placeholder="Quantity" disabled>
                    </div>
                </c:forEach>

                <p>
                    <label for="addressDelivery">Delivery Address:</label>
                    <input type="text" id="addressDelivery" name="addressDelivery" required placeholder="Enter delivery address">
                </p>

                <p>
                    <strong>Total Price: </strong>
                    <span id="totalPrice">0 VND</span>
                </p>

                <input type="submit" value="Place Order">
            </form>

            <h2>Your Order History</h2>
            <c:if test="${empty ORDERS}">
                <p>No orders found.</p>
            </c:if>
            <c:forEach var="order" items="${ORDERS}">
                <h3>Order #${order.orderId}</h3>
                <p><strong>Date:</strong> ${order.orderDate}</p>
                <p><strong>Total Amount:</strong> <fmt:formatNumber value="${order.totalAmount}" type="number" pattern="#,##0"/> VND</p>
                <p><strong>Payment Status:</strong> ${order.paymentStatus}</p>
                <p><strong>Delivery Address:</strong> ${order.addressDelivery}</p>
                <p><strong>Products:</strong></p>
                <ul>
                    <c:forEach var="detail" items="${order.orderDetails}">
                        <li>${detail.productName} - Quantity: ${detail.quantity}, Unit Price: <fmt:formatNumber value="${detail.unitPrice}" type="number" pattern="#,##0"/> VND</li>
                    </c:forEach>
                </ul>
            </c:forEach>
        </c:if>
        <c:if test="${sessionScope.user.userRole ne 'K'}">
            <p>Only customers can place or view orders. <a href="${pageContext.request.contextPath}/MainController?action=logout">Logout</a> and login as a customer.</p>
        </c:if>
    </c:if>

    <p><a href="${pageContext.request.contextPath}/MainController?action=listProducts">Continue Shopping</a></p>

    <script>
        // Enable quantity input and update total price
        const checkboxes = document.querySelectorAll('input[name="productId"]');
        const totalPriceElement = document.getElementById('totalPrice');
        
        function updateTotalPrice() {
            let total = 0;
            checkboxes.forEach(checkbox => {
                if (checkbox.checked) {
                    const price = parseFloat(checkbox.getAttribute('data-price'));
                    const quantityInput = checkbox.parentElement.nextElementSibling;
                    const quantity = parseInt(quantityInput.value) || 0;
                    total += price * quantity;
                }
            });
            totalPriceElement.textContent = total.toLocaleString('vi-VN') + ' VND';
        }

        checkboxes.forEach(checkbox => {
            const quantityInput = checkbox.parentElement.nextElementSibling;
            checkbox.addEventListener('change', () => {
                quantityInput.disabled = !checkbox.checked;
                if (!checkbox.checked) {
                    quantityInput.value = '';
                }
                updateTotalPrice();
            });
            quantityInput.addEventListener('input', updateTotalPrice);
        });
    </script>
</body>
</html>