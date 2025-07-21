<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation</title>

</head>
<body>
    <div class="form-container">
        <h2>Confirm Your Order</h2>
        <p>Product: ${PRODUCT_NAME}</p>
        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="confirmOrder">
            <input type="hidden" name="productId" value="${PRODUCT_ID}">
            <div class="form-group">
                <label for="quantity">Quantity:</label>
                <input type="number" id="quantity" name="quantity" min="1" value="1" required>
            </div>
            <div class="form-group">
                <label for="addressDelivery">Delivery Address:</label>
                <input type="text" id="addressDelivery" name="addressDelivery" required>
            </div>
            <button type="submit">Place Order</button>
        </form>
        <c:if test="${not empty ERROR}"><p style="color:red">${ERROR}</p></c:if>
    </div>
</body>
</html>