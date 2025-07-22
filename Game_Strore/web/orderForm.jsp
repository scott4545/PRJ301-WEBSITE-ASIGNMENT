<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation - Gaming Gear</title>
    <link href="https://fonts.googleapis.com/css2?family=Titillium+Web:wght@300;400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Titillium Web', sans-serif;
            background: linear-gradient(135deg, #0a0a0a, #1a1a2e);
            color: #ffffff;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .form-container {
            background: rgba(0, 0, 0, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid #00ff41;
            border-radius: 15px;
            padding: 40px;
            max-width: 600px;
            width: 100%;
            box-shadow: 0 0 30px rgba(0, 255, 65, 0.3);
        }
        h2 {
            text-align: center;
            color: #00ff41;
            font-size: 2.5rem;
            margin-bottom: 30px;
            text-shadow: 0 0 10px rgba(0, 255, 65, 0.5);
        }
        .product-info {
            background: rgba(0, 255, 65, 0.1);
            border: 1px solid rgba(0, 255, 65, 0.3);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
        }
        .product-info p {
            font-size: 1.2rem;
            margin-bottom: 10px;
        }
        .form-group {
            margin-bottom: 25px;
        }
        label {
            display: block;
            color: #00ff41;
            font-size: 1.1rem;
            margin-bottom: 8px;
            font-weight: 600;
        }
        input, textarea, select {
            width: 100%;
            padding: 15px;
            background: rgba(0, 0, 0, 0.6);
            border: 1px solid #00ff41;
            border-radius: 8px;
            color: #ffffff;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: #00ff41;
            box-shadow: 0 0 15px rgba(0, 255, 65, 0.3);
            background: rgba(0, 255, 65, 0.1);
        }
        .btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(45deg, #00ff41, #00cc33);
            border: none;
            border-radius: 8px;
            color: #000;
            font-size: 1.2rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
        }
        .btn:hover {
            background: linear-gradient(45deg, #00cc33, #00ff41);
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(0, 255, 65, 0.4);
        }
        .nav-links {
            text-align: center;
            margin-top: 20px;
        }
        .nav-links a {
            color: #00ff41;
            text-decoration: none;
            margin: 0 15px;
            padding: 10px 20px;
            border: 1px solid #00ff41;
            border-radius: 5px;
            transition: all 0.3s ease;
        }
        .nav-links a:hover {
            background: rgba(0, 255, 65, 0.1);
            transform: translateY(-2px);
        }
        .error-message {
            color: #ff4444;
            text-align: center;
            padding: 10px;
            background: rgba(255, 68, 68, 0.1);
            border: 1px solid #ff4444;
            border-radius: 5px;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2><i class="fas fa-shopping-cart"></i> Order Confirmation</h2>
        
        <div class="product-info">
            <p><i class="fas fa-gamepad"></i> <strong>Product:</strong> ${PRODUCT_NAME}</p>
            <c:if test="${not empty PRODUCT_PRICE}">
                <p><i class="fas fa-tag"></i> <strong>Price:</strong> <fmt:formatNumber value="${PRODUCT_PRICE}" type="number" pattern="#,##0"/> VND</p>
            </c:if>
        </div>
        
        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="confirmOrder">
            <input type="hidden" name="productId" value="${PRODUCT_ID}">
            
            <div class="form-group">
                <label for="quantity"><i class="fas fa-sort-numeric-up"></i> Quantity:</label>
                <input type="number" id="quantity" name="quantity" min="1" value="1" required>
            </div>
            
            <div class="form-group">
                <label for="addressDelivery"><i class="fas fa-map-marker-alt"></i> Delivery Address:</label>
                <textarea id="addressDelivery" name="addressDelivery" rows="3" placeholder="Enter your full delivery address..." required></textarea>
            </div>
            
            <button type="submit" class="btn">
                <i class="fas fa-check-circle"></i> Place Order
            </button>
        </form>
        
        <c:if test="${not empty ERROR}">
            <div class="error-message">
                <i class="fas fa-exclamation-triangle"></i> ${ERROR}
            </div>
        </c:if>
        
        <div class="nav-links">
            <a href="MainController?action=productDetail&productId=${PRODUCT_ID}">
                <i class="fas fa-arrow-left"></i> Back to Product
            </a>
            <a href="MainController?action=trackOrder">
                <i class="fas fa-list-alt"></i> View Orders
            </a>
        </div>
    </div>
</body>
</html>