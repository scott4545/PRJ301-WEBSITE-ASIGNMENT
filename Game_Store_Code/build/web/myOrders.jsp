<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - Razer Gaming Store</title>
    <link rel="stylesheet" href="css/myOrders.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <!-- Header -->
        <header class="header">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-gamepad"></i>
                    <span>RAZER GAMING</span>
                </div>
                <nav class="nav">
                    <a href="#" class="nav-link">Home</a>
                    <a href="#" class="nav-link">Products</a>
                    <a href="#" class="nav-link active">My Orders</a>
                    <a href="#" class="nav-link">Profile</a>
                </nav>
                <div class="header-actions">
                    <button class="cart-btn">
                        <i class="fas fa-shopping-cart"></i>
                        <span class="cart-count">3</span>
                    </button>
                    <button class="user-btn">
                        <i class="fas fa-user"></i>
                    </button>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
            <div class="page-header">
                <h1 class="page-title">My Orders</h1>
                <p class="page-subtitle">Track your gaming gear orders and manage your wishlist</p>
            </div>

            <!-- Tab Navigation -->
            <div class="tab-navigation">
                <button class="tab-btn active" data-tab="orders">
                    <i class="fas fa-box"></i>
                    Order History
                </button>
                <button class="tab-btn" data-tab="wishlist">
                    <i class="fas fa-heart"></i>
                    Wishlist
                </button>
                <button class="tab-btn" data-tab="cart">
                    <i class="fas fa-shopping-cart"></i>
                    Shopping Cart
                </button>
            </div>

            <!-- Orders Tab -->
            <div class="tab-content active" id="orders">
                <div class="orders-section">
                    <div class="section-header">
                        <h2>Recent Orders</h2>
                        <div class="filter-options">
                            <select class="filter-select">
                                <option>All Orders</option>
                                <option>Completed</option>
                                <option>Processing</option>
                                <option>Shipped</option>
                            </select>
                        </div>
                    </div>

                    <div class="orders-list">
                        <!-- Order Item 1 -->
                        <div class="order-item">
                            <div class="order-header">
                                <div class="order-info">
                                    <span class="order-id">#ORD-2024-001</span>
                                    <span class="order-date">March 25, 2024</span>
                                </div>
                                <div class="order-status completed">
                                    <i class="fas fa-check-circle"></i>
                                    Delivered
                                </div>
                            </div>
                            <div class="order-products">
                                <div class="product-item">
                                    <img src="https://via.placeholder.com/80x80/00FF00/000000?text=Mouse" alt="Razer Gaming Mouse" class="product-image">
                                    <div class="product-details">
                                        <h3 class="product-name">Razer DeathAdder V3 Pro</h3>
                                        <p class="product-specs">Wireless Gaming Mouse</p>
                                        <div class="product-price">2,990,000 VND</div>
                                    </div>
                                    <div class="product-quantity">Qty: 1</div>
                                </div>
                                <div class="product-item">
                                    <img src="https://via.placeholder.com/80x80/00FF00/000000?text=KB" alt="Razer Keyboard" class="product-image">
                                    <div class="product-details">
                                        <h3 class="product-name">Razer BlackWidow V4 Pro</h3>
                                        <p class="product-specs">Mechanical Gaming Keyboard</p>
                                        <div class="product-price">5,490,000 VND</div>
                                    </div>
                                    <div class="product-quantity">Qty: 1</div>
                                </div>
                            </div>
                            <div class="order-footer">
                                <div class="order-total">Total: 8,480,000 VND</div>
                                <div class="order-actions">
                                    <button class="btn btn-secondary">
                                        <i class="fas fa-eye"></i>
                                        View Details
                                    </button>
                                    <button class="btn btn-primary">
                                        <i class="fas fa-redo"></i>
                                        Reorder
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Order Item 2 -->
                        <div class="order-item">
                            <div class="order-header">
                                <div class="order-info">
                                    <span class="order-id">#ORD-2024-002</span>
                                    <span class="order-date">March 28, 2024</span>
                                </div>
                                <div class="order-status processing">
                                    <i class="fas fa-clock"></i>
                                    Processing
                                </div>
                            </div>
                            <div class="order-products">
                                <div class="product-item">
                                    <img src="https://via.placeholder.com/80x80/00FF00/000000?text=HS" alt="Razer Headset" class="product-image">
                                    <div class="product-details">
                                        <h3 class="product-name">Razer Kraken V3 Pro</h3>
                                        <p class="product-specs">Wireless Gaming Headset</p>
                                        <div class="product-price">4,990,000 VND</div>
                                    </div>
                                    <div class="product-quantity">Qty: 1</div>
                                </div>
                            </div>
                            <div class="order-footer">
                                <div class="order-total">Total: 4,990,000 VND</div>
                                <div class="order-actions">
                                    <button class="btn btn-secondary">
                                        <i class="fas fa-truck"></i>
                                        Track Order
                                    </button>
                                    <button class="btn btn-danger">
                                        <i class="fas fa-times"></i>
                                        Cancel
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Wishlist Tab -->
            <div class="tab-content" id="wishlist">
                <div class="wishlist-section">
                    <div class="section-header">
                        <h2>My Wishlist</h2>
                        <div class="wishlist-count">5 items</div>
                    </div>
                    
                    <div class="wishlist-grid">
                        <div class="wishlist-item">
                            <div class="wishlist-image">
                                <img src="https://via.placeholder.com/200x200/00FF00/000000?text=Laptop" alt="Razer Laptop">
                                <button class="remove-wishlist">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                            <div class="wishlist-details">
                                <h3 class="wishlist-name">Razer Blade 15 Advanced</h3>
                                <p class="wishlist-specs">Intel i7, RTX 4070, 16GB RAM</p>
                                <div class="wishlist-price">65,990,000 VND</div>
                                <div class="wishlist-actions">
                                    <button class="btn btn-primary">
                                        <i class="fas fa-shopping-cart"></i>
                                        Add to Cart
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="wishlist-item">
                            <div class="wishlist-image">
                                <img src="https://via.placeholder.com/200x200/00FF00/000000?text=Pad" alt="Razer Mouse Pad">
                                <button class="remove-wishlist">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                            <div class="wishlist-details">
                                <h3 class="wishlist-name">Razer Firefly V2</h3>
                                <p class="wishlist-specs">Hard Gaming Mouse Pad</p>
                                <div class="wishlist-price">1,290,000 VND</div>
                                <div class="wishlist-actions">
                                    <button class="btn btn-primary">
                                        <i class="fas fa-shopping-cart"></i>
                                        Add to Cart
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="wishlist-item">
                            <div class="wishlist-image">
                                <img src="https://via.placeholder.com/200x200/00FF00/000000?text=Chair" alt="Razer Chair">
                                <button class="remove-wishlist">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                            <div class="wishlist-details">
                                <h3 class="wishlist-name">Razer Iskur V2</h3>
                                <p class="wishlist-specs">Gaming Chair with Lumbar</p>
                                <div class="wishlist-price">12,990,000 VND</div>
                                <div class="wishlist-actions">
                                    <button class="btn btn-primary">
                                        <i class="fas fa-shopping-cart"></i>
                                        Add to Cart
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Cart Tab -->
            <div class="tab-content" id="cart">
                <div class="cart-section">
                    <div class="section-header">
                        <h2>Shopping Cart</h2>
                        <div class="cart-count">3 items</div>
                    </div>

                    <div class="cart-items">
                        <div class="cart-item">
                            <div class="cart-image">
                                <img src="https://via.placeholder.com/100x100/00FF00/000000?text=Mouse" alt="Gaming Mouse">
                            </div>
                            <div class="cart-details">
                                <h3 class="cart-name">Razer Viper V2 Pro</h3>
                                <p class="cart-specs">Wireless Gaming Mouse</p>
                                <div class="cart-price">3,490,000 VND</div>
                            </div>
                            <div class="cart-quantity">
                                <button class="qty-btn minus">-</button>
                                <input type="number" value="1" class="qty-input">
                                <button class="qty-btn plus">+</button>
                            </div>
                            <div class="cart-total">3,490,000 VND</div>
                            <button class="remove-cart">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>

                        <div class="cart-item">
                            <div class="cart-image">
                                <img src="https://via.placeholder.com/100x100/00FF00/000000?text=KB" alt="Gaming Keyboard">
                            </div>
                            <div class="cart-details">
                                <h3 class="cart-name">Razer Huntsman V2</h3>
                                <p class="cart-specs">Optical Gaming Keyboard</p>
                                <div class="cart-price">4,290,000 VND</div>
                            </div>
                            <div class="cart-quantity">
                                <button class="qty-btn minus">-</button>
                                <input type="number" value="1" class="qty-input">
                                <button class="qty-btn plus">+</button>
                            </div>
                            <div class="cart-total">4,290,000 VND</div>
                            <button class="remove-cart">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>

                        <div class="cart-item">
                            <div class="cart-image">
                                <img src="https://via.placeholder.com/100x100/00FF00/000000?text=HS" alt="Gaming Headset">
                            </div>
                            <div class="cart-details">
                                <h3 class="cart-name">Razer BlackShark V2</h3>
                                <p class="cart-specs">Gaming Headset</p>
                                <div class="cart-price">2,790,000 VND</div>
                            </div>
                            <div class="cart-quantity">
                                <button class="qty-btn minus">-</button>
                                <input type="number" value="2" class="qty-input">
                                <button class="qty-btn plus">+</button>
                            </div>
                            <div class="cart-total">5,580,000 VND</div>
                            <button class="remove-cart">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </div>

                    <div class="cart-summary">
                        <div class="summary-content">
                            <div class="summary-row">
                                <span>Subtotal:</span>
                                <span>13,360,000 VND</span>
                            </div>
                            <div class="summary-row">
                                <span>Shipping:</span>
                                <span>Free</span>
                            </div>
                            <div class="summary-row">
                                <span>Tax:</span>
                                <span>1,336,000 VND</span>
                            </div>
                            <div class="summary-row total">
                                <span>Total:</span>
                                <span>14,696,000 VND</span>
                            </div>
                            <button class="btn btn-primary checkout-btn">
                                <i class="fas fa-credit-card"></i>
                                Proceed to Checkout
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Tab switching functionality
        const tabBtns = document.querySelectorAll('.tab-btn');
        const tabContents = document.querySelectorAll('.tab-content');

        tabBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const targetTab = btn.getAttribute('data-tab');
                
                // Remove active class from all tabs and contents
                tabBtns.forEach(t => t.classList.remove('active'));
                tabContents.forEach(t => t.classList.remove('active'));
                
                // Add active class to clicked tab and corresponding content
                btn.classList.add('active');
                document.getElementById(targetTab).classList.add('active');
            });
        });

        // Quantity controls
        document.querySelectorAll('.qty-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const input = btn.parentElement.querySelector('.qty-input');
                const isPlus = btn.classList.contains('plus');
                let value = parseInt(input.value);
                
                if (isPlus) {
                    value++;
                } else if (value > 1) {
                    value--;
                }
                
                input.value = value;
                
                // Update cart total (simplified)
                const cartItem = btn.closest('.cart-item');
                const price = parseInt(cartItem.querySelector('.cart-price').textContent.replace(/[^\d]/g, ''));
                const total = cartItem.querySelector('.cart-total');
                total.textContent = (price * value).toLocaleString('vi-VN') + ' VND';
            });
        });
    </script>
</body>
</html>