
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.ProductDTO, model.CategoryDTO, model.BrandDTO"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        <!-- Navigation - Moved to top -->
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
                    <form action="${pageContext.request.contextPath}/ProductController" method="GET" class="search-form-inner">
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
                    </form>
                </div>

                <!-- Filters -->
                <form action="${pageContext.request.contextPath}/ProductController" method="GET" id="filterForm">
                    <input type="hidden" name="action" value="listProducts">
                    <div class="filters-container">
                        <div class="filter-group">
                            <label class="filter-label">
                                <i class="fas fa-tags"></i>
                                Category
                            </label>
                            <select name="categoryId" class="filter-select">
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
                            <select name="brandId" class="filter-select">
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
                                       value="${param.minPrice != null ? param.minPrice : ''}">
                                <span class="price-separator">-</span>
                                <input type="number" name="maxPrice" class="price-input" 
                                       placeholder="Max Price" 
                                       value="${param.maxPrice != null ? param.maxPrice : ''}">
                            </div>
                        </div>

                        <div class="apply-filter-btn-container">
                            <button type="submit" class="apply-filters-btn">
                                <i class="fas fa-filter"></i>
                                Apply Filters
                            </button>
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
                    <a href="${pageContext.request.contextPath}/ProductController?action=listProducts&categoryId=${category.categoryId}" 
                       class="suggestion-tag">
                        <i class="fas fa-gamepad"></i>
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
                                        <a href="${pageContext.request.contextPath}/ProductController?action=productDetail&productId=${product.productId}" 
                                           class="quick-view-btn">
                                            <i class="fas fa-eye"></i>
                                            View Details
                                        </a>
                                    </div>
                                </div>
                                
                                <div class="product-info">
                                    <h3 class="product-name">
                                        <a href="${pageContext.request.contextPath}/ProductController?action=productDetail&productId=${product.productId}">
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
                            <a href="${pageContext.request.contextPath}/ProductController?action=listProducts" class="browse-btn">
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

        // Auto-submit filter form when select changes
        const filterSelects = document.querySelectorAll('.filter-select');
        filterSelects.forEach(select => {
            select.addEventListener('change', () => {
                document.getElementById('filterForm').submit();
            });
        });
    </script>
</body>
</html>
```