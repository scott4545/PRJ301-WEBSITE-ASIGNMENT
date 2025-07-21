<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Success - Gaming Gear</title>
    <link href="https://fonts.googleapis.com/css2?family=Titillium+Web:wght@300;400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <meta http-equiv="refresh" content="5;url=MainController?action=orderTracking">
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
            overflow: hidden;
        }
        .success-container {
            text-align: center;
            background: rgba(0, 0, 0, 0.9);
            backdrop-filter: blur(15px);
            border: 2px solid #00ff41;
            border-radius: 20px;
            padding: 60px 40px;
            max-width: 600px;
            width: 100%;
            box-shadow: 0 0 50px rgba(0, 255, 65, 0.4);
            position: relative;
        }
        .success-content {
            position: relative;
            z-index: 2;
        }
        .success-icon {
            font-size: 100px;
            color: #00ff41;
            margin-bottom: 30px;
            animation: pulse 2s infinite;
            filter: drop-shadow(0 0 20px rgba(0, 255, 65, 0.6));
        }
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }
        h2 {
            color: #00ff41;
            font-size: 3rem;
            margin-bottom: 30px;
            text-shadow: 0 0 15px rgba(0, 255, 65, 0.8);
            animation: glow 3s ease-in-out infinite alternate;
        }
        @keyframes glow {
            from { text-shadow: 0 0 15px rgba(0, 255, 65, 0.8); }
            to { text-shadow: 0 0 25px rgba(0, 255, 65, 1), 0 0 35px rgba(0, 255, 65, 0.8); }
        }
        .order-details {
            background: rgba(0, 255, 65, 0.1);
            border: 1px solid rgba(0, 255, 65, 0.3);
            border-radius: 15px;
            padding: 25px;
            margin: 30px 0;
        }
        .order-details p {
            font-size: 1.3rem;
            margin: 15px 0;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        .order-id {
            color: #00ff41;
            font-weight: 700;
            font-size: 1.5rem;
        }
        .countdown-text {
            font-size: 1.2rem;
            margin-top: 30px;
            color: #cccccc;
        }
        #countdown {
            color: #00ff41;
            font-weight: 700;
            font-size: 2rem;
            text-shadow: 0 0 10px rgba(0, 255, 65, 0.8);
        }
        .navigation-buttons {
            margin-top: 30px;
            display: flex;
            gap: 20px;
            justify-content: center;
        }
        .nav-btn {
            padding: 12px 25px;
            background: linear-gradient(45deg, transparent, rgba(0, 255, 65, 0.2));
            border: 1px solid #00ff41;
            border-radius: 8px;
            color: #00ff41;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .nav-btn:hover {
            background: linear-gradient(45deg, rgba(0, 255, 65, 0.2), rgba(0, 255, 65, 0.3));
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 255, 65, 0.3);
        }
        .particles {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
        }
        .particle {
            position: absolute;
            width: 4px;
            height: 4px;
            background: #00ff41;
            border-radius: 50%;
            animation: float 6s infinite linear;
        }
        .particle:nth-child(1) { left: 10%; animation-delay: 0s; }
        .particle:nth-child(2) { left: 30%; animation-delay: 1s; }
        .particle:nth-child(3) { left: 50%; animation-delay: 2s; }
        .particle:nth-child(4) { left: 70%; animation-delay: 3s; }
        .particle:nth-child(5) { left: 90%; animation-delay: 4s; }
        @keyframes float {
            0% { 
                transform: translateY(100vh) rotate(0deg);
                opacity: 0;
            }
            10% { opacity: 1; }
            90% { opacity: 1; }
            100% { 
                transform: translateY(-100vh) rotate(360deg);
                opacity: 0;
            }
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="particles">
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
        </div>
        
        <div class="success-content">
            <div class="success-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            
            <h2>ORDER CONFIRMED!</h2>
            
            <div class="order-details">
                <p>
                    <i class="fas fa-hashtag"></i>
                    <strong>Order ID:</strong> 
                    <span class="order-id">#${ORDER_ID}</span>
                </p>
                <p>
                    <i class="fas fa-clock"></i>
                    <strong>Time:</strong> ${CURRENT_TIME} +07
                </p>
                <p>
                    <i class="fas fa-truck"></i>
                    <strong>Status:</strong> Processing
                </p>
            </div>
            
            <p class="countdown-text">
                Redirecting to Order Tracking in <span id="countdown">5</span> seconds...
            </p>
            
            <div class="navigation-buttons">
                <a href="MainController?action=trackOrder" class="nav-btn">
                    <i class="fas fa-list-alt"></i>
                    View All Orders
                </a>
                <a href="MainController?action=listProducts" class="nav-btn">
                    <i class="fas fa-gamepad"></i>
                    Continue Shopping
                </a>
            </div>
        </div>
    </div>
    
    <script>
        let timeLeft = 5;
        const countdown = document.getElementById('countdown');
        const timer = setInterval(() => {
            timeLeft--;
            countdown.textContent = timeLeft;
            if (timeLeft <= 0) {
                clearInterval(timer);
                window.location.href = 'MainController?action=trackOrder';
            }
        }, 1000);
    </script>
</body>
</html>