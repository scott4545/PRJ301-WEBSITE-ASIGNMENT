<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.ProductDTO, model.ReviewDTO, java.util.List, java.text.NumberFormat, java.util.Locale"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Details - Gaming Gear</title>
    <link rel="stylesheet" href="css/productDetail.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="container">
        <%
            ProductDTO product = (ProductDTO) request.getAttribute("PRODUCT");
            NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
            if (product != null) {
        %>
        
        <!-- Breadcrumb Navigation -->
        <nav class="breadcrumb">
            <a href="MainController?action=listProducts" class="breadcrumb-link">
                <i class="fas fa-home"></i> Products
            </a>
            <span class="breadcrumb-separator">/</span>
            <span class="breadcrumb-current"><%= product.getProductName() %></span>
        </nav>

        <!-- Product Header -->
        <div class="product-header">
            <div class="product-image-section">
                <div class="product-image-container">
                    <% if (product.getProductImage() != null) { %>
                        <img src="<%= product.getProductImage() %>" alt="<%= product.getProductName() %>" class="product-image">
                    <% } else { %>
                        <div class="no-image">
                            <i class="fas fa-image"></i>
                            <span>No Image Available</span>
                        </div>
                    <% } %>
                </div>
            </div>

            <div class="product-info-section">
                <h1 class="product-title"><%= product.getProductName() %></h1>
                
                <div class="product-price">
                    <span class="price-amount"><%= formatter.format(product.getProductPrice()) %> VND</span>
                </div>

                <div class="product-description">
                    <h3>Description</h3>
                    <p><%= product.getProductDescription() != null ? product.getProductDescription() : "No description available." %></p>
                </div>

                <div class="product-actions">
                    <button class="btn btn-primary">
                        <i class="fas fa-shopping-cart"></i>
                        Add to Cart
                    </button>
                    <button class="btn btn-secondary">
                        <i class="fas fa-heart"></i>
                        Add to Wishlist
                    </button>
                </div>

                <div class="product-features">
                    <div class="feature-item">
                        <i class="fas fa-shipping-fast"></i>
                        <span>Free Shipping</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-shield-alt"></i>
                        <span>2 Year Warranty</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-undo"></i>
                        <span>30-Day Returns</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Reviews Section -->
        <div class="reviews-section">
            <div class="section-header">
                <h2>Customer Reviews</h2>
                <button class="btn btn-outline">Write a Review</button>
            </div>

            <div class="reviews-container">
                <%
                    List<ReviewDTO> reviews = (List<ReviewDTO>) request.getAttribute("REVIEWS");
                    if (reviews != null && !reviews.isEmpty()) {
                        for (ReviewDTO review : reviews) {
                %>
                <div class="review-card">
                    <div class="review-header">
                        <div class="reviewer-info">
                            <div class="reviewer-avatar">
                                <i class="fas fa-user"></i>
                            </div>
                            <div class="reviewer-details">
                                <h4 class="reviewer-name"><%= review.getUsername() %></h4>
                                <div class="review-rating">
                                    <% 
                                        int rating = review.getRating();
                                        for (int i = 1; i <= 5; i++) {
                                            if (i <= rating) {
                                    %>
                                        <i class="fas fa-star star-filled"></i>
                                    <% } else { %>
                                        <i class="fas fa-star star-empty"></i>
                                    <% } } %>
                                    <span class="rating-text">(<%= rating %>/5)</span>
                                </div>
                            </div>
                        </div>
                        <div class="review-date">
                            <i class="fas fa-calendar-alt"></i>
                            <%= review.getReviewDate() %>
                        </div>
                    </div>
                    <div class="review-content">
                        <p><%= review.getComment() != null ? review.getComment() : "No comment provided." %></p>
                    </div>
                </div>
                <%  }
                    } else {
                %>
                <div class="no-reviews">
                    <i class="fas fa-comments"></i>
                    <h3>No Reviews Yet</h3>
                    <p>Be the first to review this product!</p>
                    <button class="btn btn-primary">Write First Review</button>
                </div>
                <% } %>
            </div>
        </div>

        <% } else { %>
        <div class="error-container">
            <div class="error-content">
                <i class="fas fa-exclamation-triangle"></i>
                <h2>Product Not Found</h2>
                <p>The product you're looking for doesn't exist or has been removed.</p>
                <a href="MainController?action=listProducts" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i>
                    Back to Products
                </a>
            </div>
        </div>
        <% } %>
    </div>

    <script>
        // Add some interactive effects
        document.addEventListener('DOMContentLoaded', function() {
            // Smooth hover effects for buttons
            const buttons = document.querySelectorAll('.btn');
            buttons.forEach(button => {
                button.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-2px)';
                });
                button.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });
        });
    </script>
</body>
</html>