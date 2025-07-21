<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Product Details - Gaming Gear</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/productDetail.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <div class="container">
            <c:choose>
                <c:when test="${not empty PRODUCT}">
                    <nav class="breadcrumb">
                        <a href="${pageContext.request.contextPath}/home.jsp" class="back-btn">
                            <i class="fas fa-arrow-left"></i> Back to Home
                        </a>
                        <div class="breadcrumb-links">
                            <a href="MainController?action=listProducts" class="breadcrumb-link">
                                <i class="fas fa-home"></i> Products
                            </a>
                            <span class="breadcrumb-separator">/</span>
                            <span class="breadcrumb-current">${PRODUCT.productName}</span>
                        </div>
                    </nav>

                    <c:if test="${not empty SUCCESS}">
                        <div class="success-message">
                            <p>${SUCCESS}</p>
                        </div>
                    </c:if>

                    <c:if test="${not empty ERROR}">
                        <div class="error-message">
                            <p>${ERROR}</p>
                            <a href="MainController?action=login" class="browse-btn">
                                <i class="fas fa-sign-in-alt"></i>
                                Log In
                            </a>
                        </div>
                    </c:if>

                    <div class="product-header">
                        <div class="product-image-section">
                            <div class="product-image-container">
                                <c:choose>
                                    <c:when test="${not empty PRODUCT.productImage}">
                                        <img src="${PRODUCT.productImage}" alt="${PRODUCT.productName}" class="product-image">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-image">
                                            <i class="fas fa-image"></i>
                                            <span>No Image Available</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="product-info-section">
                            <h1 class="product-title">${PRODUCT.productName}</h1>

                            <div class="product-price">
                                <span class="price-amount">
                                    <fmt:setLocale value="vi_VN"/>
                                    <fmt:formatNumber value="${PRODUCT.productPrice}" type="currency" currencySymbol="VND"/>
                                </span>
                            </div>

                            <div class="product-description">
                                <h3>Description</h3>
                                <p>${PRODUCT.productDescription != null ? PRODUCT.productDescription : "No description available."}</p>
                            </div>

                            <div class="product-actions">
                                <form action="MainController" method="POST" style="display: inline;">
                                    <input type="hidden" name="action" value="placeOrder">
                                    <input type="hidden" name="productId" value="${PRODUCT.productId}">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-shopping-cart"></i>
                                        Add to Cart
                                    </button>
                                </form>
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

                            <c:if test="${sessionScope.user != null && sessionScope.user.userRole == 'A'}">
                                <div class="admin-product-controls">
                                    <h3>Admin Controls</h3>
                                    <form action="${pageContext.request.contextPath}/MainController" method="POST" class="admin-form">
                                        <input type="hidden" name="action" value="editProduct">
                                        <input type="hidden" name="productId" value="${PRODUCT.productId}">
                                        <div class="form-group">
                                            <label for="productName">Product Name</label>
                                            <input type="text" name="productName" value="${PRODUCT.productName}" required class="form-input">
                                        </div>
                                        <div class="form-group">
                                            <label for="productDescription">Description</label>
                                            <textarea name="productDescription" class="form-textarea">${PRODUCT.productDescription}</textarea>
                                        </div>
                                        <div class="form-group">
                                            <label for="productPrice">Price (VND)</label>
                                            <input type="number" name="productPrice" value="${PRODUCT.productPrice}" min="0" step="0.01" required class="form-input">
                                        </div>
                                        <div class="form-group">
                                            <label for="productImage">Image URL</label>
                                            <input type="text" name="productImage" value="${PRODUCT.productImage}" class="form-input">
                                        </div>
                                        <div class="form-group">
                                            <label for="categoryId">Category</label>
                                            <select name="categoryId" required class="form-select">
                                                <c:forEach var="category" items="${CATEGORIES}">
                                                    <option value="${category.categoryId}" ${category.categoryId == PRODUCT.categoryId ? 'selected' : ''}>
                                                        ${category.categoryName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="brandId">Brand</label>
                                            <select name="brandId" required class="form-select">
                                                <c:forEach var="brand" items="${BRANDS}">
                                                    <option value="${brand.brandId}" ${brand.brandId == PRODUCT.brandId ? 'selected' : ''}>
                                                        ${brand.brandName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="status">Status</label>
                                            <select name="status" class="form-select">
                                                <option value="true" ${PRODUCT.status ? 'selected' : ''}>Active</option>
                                                <option value="false" ${!PRODUCT.status ? 'selected' : ''}>Inactive</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="quantity">Quantity</label>
                                            <input type="number" name="quantity" value="${PRODUCT.quantity}" min="0" required class="form-input">
                                        </div>
                                        <button type="submit" class="admin-btn update">
                                            <i class="fas fa-save"></i>
                                            Save Changes
                                        </button>
                                    </form>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <div class="reviews-section">
                        <div class="section-header">
                            <h2>Customer Reviews</h2>
                            <c:if test="${sessionScope.user != null}">
                                <button class="btn btn-outline write-review-btn">Write a Review</button>
                            </c:if>
                        </div>

                        <c:if test="${sessionScope.user != null}">
                            <div class="review-form-container" style="display: none;">
                                <form action="${pageContext.request.contextPath}/MainController" method="POST" class="review-form">
                                    <input type="hidden" name="action" value="addReview">
                                    <input type="hidden" name="productId" value="${PRODUCT.productId}">
                                    <div class="form-group">
                                        <label for="rating">Rating</label>
                                        <select name="rating" id="rating" required class="form-select">
                                            <option value="" disabled selected>Select a rating</option>
                                            <option value="1">1 Star</option>
                                            <option value="2">2 Stars</option>
                                            <option value="3">3 Stars</option>
                                            <option value="4">4 Stars</option>
                                            <option value="5">5 Stars</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="comment">Comment</label>
                                        <textarea name="comment" id="comment" class="form-textarea" placeholder="Write your review here..." rows="4"></textarea>
                                    </div>
                                    <div class="form-actions">
                                        <button type="submit" class="btn btn-primary submit-review">
                                            <i class="fas fa-paper-plane"></i> Submit Review
                                        </button>
                                        <button type="button" class="btn btn-outline cancel-review">
                                            <i class="fas fa-times"></i> Cancel
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </c:if>

                        <div class="reviews-container">
                            <c:choose>
                                <c:when test="${not empty REVIEWS}">
                                    <c:forEach var="review" items="${REVIEWS}">
                                        <div class="review-card">
                                            <div class="review-header">
                                                <div class="reviewer-info">
                                                    <div class="reviewer-avatar">
                                                        <i class="fas fa-user"></i>
                                                    </div>
                                                    <div class="reviewer-details">
                                                        <h4 class="reviewer-name">${review.username}</h4>
                                                        <div class="review-rating">
                                                            <c:forEach begin="1" end="5" var="i">
                                                                <c:choose>
                                                                    <c:when test="${i <= review.rating}">
                                                                        <i class="fas fa-star star-filled"></i>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <i class="fas fa-star star-empty"></i>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:forEach>
                                                            <span class="rating-text">(${review.rating}/5)</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="review-date">
                                                    <i class="fas fa-calendar-alt"></i>
                                                    ${review.reviewDate}
                                                </div>
                                            </div>
                                            <div class="review-content">
                                                <p>${review.comment != null ? review.comment : "No comment provided."}</p>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-reviews">
                                        <i class="fas fa-comments"></i>
                                        <h3>No Reviews Yet</h3>
                                        <p>Be the first to review this product!</p>
                                        <c:if test="${sessionScope.user != null}">
                                            <button class="btn btn-primary write-review-btn">Write First Review</button>
                                        </c:if>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="error-container">
                        <div class="error-content">
                            <i class="fas fa-exclamation-triangle"></i>
                            <h2>Product Not Found</h2>
                            <p>The product you're looking for doesn't exist or has been removed.</p>
                            <a href="${pageContext.request.contextPath}/home.jsp" class="btn btn-primary">
                                <i class="fas fa-arrow-left"></i>
                                Back to Home
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const buttons = document.querySelectorAll('.btn');
                buttons.forEach(button => {
                    button.addEventListener('mouseenter', function () {
                        this.style.transform = 'translateY(-2px)';
                    });
                    button.addEventListener('mouseleave', function () {
                        this.style.transform = 'translateY(0)';
                    });
                });

                const editForm = document.querySelector('.admin-form');
                if (editForm) {
                    editForm.addEventListener('submit', function (event) {
                        const productName = document.querySelector('input[name="productName"]').value;
                        const productPrice = document.querySelector('input[name="productPrice"]').value;
                        const quantity = document.querySelector('input[name="quantity"]').value;
                        if (!productName.trim()) {
                            alert('Product Name is required!');
                            event.preventDefault();
                        } else if (productPrice <= 0) {
                            alert('Price must be greater than 0!');
                            event.preventDefault();
                        } else if (quantity < 0) {
                            alert('Quantity must be non-negative!');
                            event.preventDefault();
                        }
                    });
                }

                const writeReviewButtons = document.querySelectorAll('.write-review-btn');
                const reviewFormContainer = document.querySelector('.review-form-container');
                const cancelReviewButton = document.querySelector('.cancel-review');
                const reviewForm = document.querySelector('.review-form');

                if (writeReviewButtons && reviewFormContainer) {
                    writeReviewButtons.forEach(button => {
                        button.addEventListener('click', function () {
                            reviewFormContainer.style.display = 'block';
                        });
                    });
                }

                if (cancelReviewButton && reviewFormContainer) {
                    cancelReviewButton.addEventListener('click', function () {
                        reviewFormContainer.style.display = 'none';
                        reviewForm.reset();
                    });
                }

                if (reviewForm) {
                    reviewForm.addEventListener('submit', function (event) {
                        const rating = document.querySelector('select[name="rating"]').value;
                        if (!rating) {
                            alert('Please select a rating!');
                            event.preventDefault();
                        }
                    });
                }
            });
        </script>
    </body>
</html>