<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Products - Gaming Store</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/products.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <!-- Error Message -->
            <c:if test="${not empty ERROR}">
                <div class="error-message">
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
            </nav>

            <!-- Header -->
            <header class="header">
                <div class="header-content">
                    <h1 class="page-title">
                        <i class="fas fa-gamepad"></i>
                        Gaming Products
                    </h1>
                    <div class="header-accent"></div>
                </div>
            </header>

            <!-- Search and Filters Section -->
            <section class="search-section">
                <div class="search-form">
                    <!-- Search Bar -->
                    <div class="search-bar-container">
                        <form action="${pageContext.request.contextPath}/MainController" method="GET" class="search-form-inner">
                            <input type="hidden" name="action" value="search">
                            <div class="search-input-wrapper">
                                <i class="fas fa-search search-icon"></i>
                                <input type="text" name="query" class="search-input" 
                                       placeholder="Search for gaming gear, peripherals, accessories..." 
                                       value="${param.query != null ? param.query : ''}">
                                <button type="submit" class="search-btn">
                                    <i class="fas fa-search"></i>
                                    Search
                                </button>
                            </div>                    
                            <input type="hidden" name="categoryId" value="${param.categoryId != null ? param.categoryId : ''}">
                            <input type="hidden" name="brandId" value="${param.brandId != null ? param.brandId : ''}">
                            <input type="hidden" name="minPrice" value="${param.minPrice != null ? param.minPrice : ''}">
                            <input type="hidden" name="maxPrice" value="${param.maxPrice != null ? param.maxPrice : ''}">
                        </form>
                    </div>

                    <!-- Filters -->
                    <form action="${pageContext.request.contextPath}/MainController" method="GET" id="filterForm">
                        <input type="hidden" name="action" value="search"> <!-- Sử dụng action=search để kết hợp -->
                        <div class="filters-container">
                            <div class="filter-group">
                                <label class="filter-label">
                                    <i class="fas fa-tags"></i>
                                    Category
                                </label>
                                <select name="categoryId" class="filter-select" onchange="this.form.submit()">
                                    <option value="">All Categories</option>
                                    <c:forEach var="category" items="${CATEGORIES}">
                                        <option value="${category.categoryId}" 
                                                ${param.categoryId != null && param.categoryId == category.categoryId ? 'selected' : ''}>
                                            ${category.categoryName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label class="filter-label">
                                    <i class="fas fa-trademark"></i>
                                    Brand
                                </label>
                                <select name="brandId" class="filter-select" onchange="this.form.submit()">
                                    <option value="">All Brands</option>
                                    <c:forEach var="brand" items="${BRANDS}">
                                        <option value="${brand.brandId}" 
                                                ${param.brandId != null && param.brandId == brand.brandId ? 'selected' : ''}>
                                            ${brand.brandName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="filter-group price-filter">
                                <label class="filter-label">
                                    <i class="fas fa-dollar-sign"></i>
                                    Price Range (VND)
                                </label>
                                <div class="price-inputs">
                                    <input type="number" name="minPrice" class="price-input" 
                                           placeholder="Min Price" 
                                           value="${param.minPrice != null ? param.minPrice : ''}" 
                                           onchange="this.form.submit()">
                                    <span class="price-separator">-</span>
                                    <input type="number" name="maxPrice" class="price-input" 
                                           placeholder="Max Price" 
                                           value="${param.maxPrice != null ? param.maxPrice : ''}" 
                                           onchange="this.form.submit()">
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </section>

            <!-- Suggestions Section -->
            <section class="suggestions-section">
                <h3 class="suggestions-title">
                    <i class="fas fa-fire"></i>
                    Popular Categories
                </h3>
                <div class="suggestions-container">
                    <c:forEach var="category" items="${CATEGORIES}">
                        <a href="${pageContext.request.contextPath}/MainController?action=listProducts&categoryId=${category.categoryId}" 
                           class="suggestion-tag">
                            <c:choose>
                                <c:when test="${category.categoryId == 1}"><i class="fas fa-gamepad"></i></c:when>
                                <c:when test="${category.categoryId == 2}"><i class="fas fa-hand-point-up"></i></c:when>
                                <c:when test="${category.categoryId == 3}"><i class="fas fa-headphones"></i></c:when>
                                <c:when test="${category.categoryId == 4}"><i class="fas fa-credit-card"></i></c:when>
                                <c:otherwise><i class="fas fa-gamepad"></i></c:otherwise>
                            </c:choose>
                            ${category.categoryName}
                        </a>
                    </c:forEach>
                </div>
            </section>

            <!-- Results Section -->
            <section class="results-section">
                <div class="results-header">
                    <h2 class="results-title">
                        <i class="fas fa-list"></i>
                        Products
                        <c:if test="${not empty PRODUCTS}">
                            <span class="results-count">(${PRODUCTS.size()} items found)</span>
                        </c:if>
                    </h2>
                </div>

                <div class="products-grid">
                    <c:choose>
                        <c:when test="${not empty PRODUCTS}">
                            <c:forEach var="product" items="${PRODUCTS}">
                                <div class="product-card">
                                    <div class="product-image-container">
                                        <c:choose>
                                            <c:when test="${not empty product.productImage}">
                                                <img src="${product.productImage}" alt="${product.productName}" class="product-image">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="product-image-placeholder">
                                                    <i class="fas fa-image"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="product-overlay">
                                            <a href="${pageContext.request.contextPath}/MainController?action=productDetail&productId=${product.productId}" 
                                               class="quick-view-btn" 
                                               onclick="console.log('Clicking Quick View for productId: ${product.productId}')">
                                                <i class="fas fa-eye"></i>
                                                View Details
                                            </a>
                                        </div>
                                    </div>

                                    <div class="product-info">
                                        <h3 class="product-name">
                                            <a href="${pageContext.request.contextPath}/MainController?action=productDetail&productId=${product.productId}">
                                                ${product.productName}
                                            </a>
                                        </h3>

                                        <div class="product-price">
                                            <span class="price-value">
                                                <fmt:formatNumber value="${product.productPrice}" type="number" pattern="#,##0"/>
                                            </span>
                                            <span class="price-symbol">VND</span>
                                        </div>

                                        <div class="product-actions">
                                            <button class="add-to-cart-btn" onclick="addToCart(${product.productId})">
                                                <i class="fas fa-shopping-cart"></i>
                                                Add to Cart
                                            </button>
                                            <button class="wishlist-btn" onclick="addToWishlist(${product.productId})">
                                                <i class="fas fa-heart"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="no-results">
                                <div class="no-results-icon">
                                    <i class="fas fa-search"></i>
                                </div>
                                <h3 class="no-results-title">No Products Found</h3>
                                <p class="no-results-message">
                                    We couldn't find any products matching your criteria. Try adjusting your filters or search terms.
                                </p>
                                <a href="${pageContext.request.contextPath}/MainController?action=listProducts" class="browse-btn">
                                    <i class="fas fa-list"></i>
                                    Browse All Products
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </div>

        <script>
            // Add focus effects for search input
            const searchInput = document.querySelector('.search-input');
            const searchWrapper = document.querySelector('.search-input-wrapper');

            searchInput.addEventListener('focus', () => {
                searchWrapper.classList.add('focused');
            });

            searchInput.addEventListener('blur', () => {
                searchWrapper.classList.remove('focused');
            });

            // Add to cart functionality
            function addToCart(productId) {
                console.log('Adding product to cart:', productId);
                // Implement AJAX call for cart functionality if needed
            }

            // Add to wishlist functionality
            function addToWishlist(productId) {
                console.log('Adding product to wishlist:', productId);
                // Implement AJAX call for wishlist functionality if needed
            }

            // Auto-submit filter form when select or price input changes
            const filterSelects = document.querySelectorAll('.filter-select');
            const priceInputs = document.querySelectorAll('.price-input');
            filterSelects.forEach(select => {
                select.addEventListener('change', () => {
                    document.getElementById('filterForm').submit();
                });
            });
            priceInputs.forEach(input => {
                input.addEventListener('change', () => {
                    document.getElementById('filterForm').submit();
                });
            });

            // Log Quick View click to debug
            document.querySelectorAll('.quick-view-btn').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    console.log('Quick View clicked for productId:', e.target.closest('a').href.match(/productId=(\d+)/)[1]);
                });
            });
        </script>
    </body>
</html>
