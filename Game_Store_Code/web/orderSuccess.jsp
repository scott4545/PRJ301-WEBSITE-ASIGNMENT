<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Success - Gaming Gear</title>
    <link rel="stylesheet" href="css/orderSuccess.css">
    <meta http-equiv="refresh" content="3;url=MainController?action=productDetail&productId=${PRODUCT_ID}">
</head>
<body>
    <div class="success-container">
        <div class="success-content">
            <i class="fas fa-check-circle" style="font-size: 50px; color: #4CAF50;"></i>
            <h2>Order Placed Successfully!</h2>
            <p>Your order ID: ${ORDER_ID}</p>
            <p>Time: ${CURRENT_TIME} +07</p>
            <p>You will be redirected to the product page in <span id="countdown">3</span> seconds...</p>
        </div>
    </div>

    <script>
        let timeLeft = 3;
        const countdown = document.getElementById('countdown');
        const timer = setInterval(() => {
            timeLeft--;
            countdown.textContent = timeLeft;
            if (timeLeft <= 0) {
                clearInterval(timer);
            }
        }, 1000);
    </script>
</body>
</html>