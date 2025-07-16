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
            <c:if test="${not empty SUCCESS}">
                <div class="success-message">
                    <p>${SUCCESS}</p>
                </div>
            </c:if>

            <c:if test="${not empty ERROR}">
                <div class="error-message">
                    <p>${ERROR}</p>
                    <a href="${pageContext.request.contextPath}/MainController?action=login" class="browse-btn">
                        <i class="fas fa-sign-in-alt"></i>
                        Log In
                    </a>
                </div>
            </c:if>

            <nav class="navigation">
                <a href="${pageContext.request.contextPath}/home.jsp" class="back-btn">
                    <i class="fas fa-arrow-left"></i>
                    Back to Home
                </a>
            </nav>

            <header class="header">
                <div class="header-content">
                    <h1 class="page-title">
                        <i class="fas fa-gamepad"></i>
                        Gaming Products
                    </h1>
                    <div class="header-accent"></div>
                </div>
            </header>

            <c:if test="${sessionScope.user != null && sessionScope.user.userRole == 'A'}">
                <section class="admin-controls">
                    <div class="admin-actions">
                        <a href="${pageContext.request.contextPath}/MainController?action=addProduct" class="admin-btn">
                            <i class="fas fa-plus"></i>
                            Add New Product
                        </a>
                    </div>
                </section>
            </c:if>

            <section class="search-section">
                <div class="search-form">
                    <div class="search-bar-container">
                        <form action="${pageContext.request.contextPath}/MainController" method="GET" class="search-form-inner">
                            <input type="hidden" name="action" value="search">
                            <div class="search-input-wrapper">
                                <i class="fas fa-search search-icon"></i>
                                <input type="text" name="query" class="search-input" 
                                       placeholder="Search for gaming gear, peripherals, accessories..." 
                                       value="${requestScope.QUERY != null ? requestScope.QUERY : ''}">
                                <button type="submit" class="search-btn">
                                    <i class="fas fa-search"></i>
                                    Search
                                </button>
                            </div>                    
                            <input type="hidden" name="categoryId" value="${requestScope.CATEGORY_ID != null ? requestScope.CATEGORY_ID : ''}">
                            <input type="hidden" name="brandId" value="${requestScope.BRAND_ID != null ? requestScope.BRAND_ID : ''}">
                            <input type="hidden" name="minPrice" value="${requestScope.MIN_PRICE != null ? requestScope.MIN_PRICE : ''}">
                            <input type="hidden" name="maxPrice" value="${requestScope.MAX_PRICE != null ? requestScope.MAX_PRICE : ''}">
                        </form>
                    </div>

                    <form action="${pageContext.request.contextPath}/MainController" method="GET" id="filterForm">
                        <input type="hidden" name="action" value="listProducts">
                        <input type="hidden" name="query" value="${requestScope.QUERY != null ? requestScope.QUERY : ''}">
                        
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
                                                ${requestScope.CATEGORY_ID != null && requestScope.CATEGORY_ID == category.categoryId ? 'selected' : ''}>
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
                                                ${requestScope.BRAND_ID != null && requestScope.BRAND_ID == brand.brandId ? 'selected' : ''}>
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
                                           value="${requestScope.MIN_PRICE != null ? requestScope.MIN_PRICE : ''}" 
                                           onchange="this.form.submit()">
                                    <span class="price-separator">-</span>
                                    <input type="number" name="maxPrice" class="price-input" 
                                           placeholder="Max Price" 
                                           value="${requestScope.MAX_PRICE != null ? requestScope.MAX_PRICE : ''}" 
                                           onchange="this.form.submit()">
                                </div>
                            </div>

                            <div class="filter-group">
                                <button type="button" class="clear-filters-btn" onclick="clearFilters()">
                                    <i class="fas fa-times"></i>
                                    Clear Filters
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </section>

            <c:if test="${not empty SUGGESTIONS}">
                <section class="suggestions-section">
                    <h3 class="suggestions-title">
                        <i class="fas fa-lightbulb"></i>
                        Search Suggestions
                    </h3>
                    <div class="suggestions-container">
                        <c:forEach var="suggestion" items="${SUGGESTIONS}">
                            <a href="${pageContext.request.contextPath}/MainController?action=search&query=${suggestion}" 
                               class="suggestion-tag">
                                <i class="fas fa-search"></i>
                                ${suggestion}
                            </a>
                        </c:forEach>
                    </div>
                </section>
            </c:if>

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
                                               class="quick-view-btn">
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

                                        <p class="product-description">
                                            ${product.productDescription}
                                        </p>

                                        <div class="product-price">
                                            <span class="price-value">
                                                <fmt:formatNumber value="${product.productPrice}" type="number" pattern="#,##0"/>
                                            </span>
                                            <span class="price-symbol">VND</span>
                                        </div>

                                        <div class="product-status">
                                            <c:choose>
                                                <c:when test="${product.status && product.quantity > 0}">
                                                    <span class="status-badge in-stock">
                                                        <i class="fas fa-check-circle"></i>
                                                        In Stock (${product.quantity})
                                                    </span>
                                                </c:when>
                                                <c:when test="${product.status && product.quantity == 0}">
                                                    <span class="status-badge out-of-stock">
                                                        <i class="fas fa-times-circle"></i>
                                                        Out of Stock
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge unavailable">
                                                        <i class="fas fa-ban"></i>
                                                        Unavailable
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div class="product-actions">
                                            <c:if test="${product.status && product.quantity > 0}">
                                                <button class="add-to-cart-btn" onclick="addToCart(${product.productId})">
                                                    <i class="fas fa-shopping-cart"></i>
                                                    Add to Cart
                                                </button>
                                            </c:if>
                                            <button class="wishlist-btn" onclick="addToWishlist(${product.productId})">
                                                <i class="fas fa-heart"></i>
                                            </button>
                                        </div>

                                        <c:if test="${sessionScope.user != null && sessionScope.user.userRole == 'A'}">
                                            <div class="admin-product-controls">
                                                <form action="${pageContext.request.contextPath}/MainController" method="POST" class="admin-form">
                                                    <input type="hidden" name="action" value="changeProductStatus">
                                                    <input type="hidden" name="productId" value="${product.productId}">
                                                    <input type="hidden" name="status" value="${!product.status}">
                                                    <button type="submit" class="admin-btn ${product.status ? 'disable' : 'enable'}">
                                                        <i class="fas ${product.status ? 'fa-eye-slash' : 'fa-eye'}"></i>
                                                        ${product.status ? 'Disable' : 'Enable'}
                                                    </button>
                                                </form>
                                                
                                                <form action="${pageContext.request.contextPath}/MainController" method="POST" class="admin-form">
                                                    <input type="hidden" name="action" value="updateProductQuantity">
                                                    <input type="hidden" name="productId" value="${product.productId}">
                                                    <input type="number" name="quantity" value="${product.quantity}" min="0" class="quantity-input">
                                                    <button type="submit" class="admin-btn update">
                                                        <i class="fas fa-sync"></i>
                                                        Update
                                                    </button>
                                                </form>

                                                <form action="${pageContext.request.contextPath}/MainController" method="POST" class="admin-form" onsubmit="return confirmDelete()">
                                                    <input type="hidden" name="action" value="deleteProduct">
                                                    <input type="hidden" name="productId" value="${product.productId}">
                                                    <button type="submit" class="admin-btn delete">
                                                        <i class="fas fa-trash"></i>
                                                        Delete
                                                    </button>
                                                </form>
                                            </div>
                                        </c:if>
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
            const searchInput = document.querySelector('.search-input');
            const searchWrapper = document.querySelector('.search-input-wrapper');

            if (searchInput && searchWrapper) {
                searchInput.addEventListener('focus', () => {
                    searchWrapper.classList.add('focused');
                });

                searchInput.addEventListener('blur', () => {
                    searchWrapper.classList.remove('focused');
                });
            }

            function clearFilters() {
                window.location.href = '${pageContext.request.contextPath}/MainController?action=listProducts';
            }

            function addToCart(productId) {
                console.log('Adding product to cart:', productId);
                alert('Product added to cart! (Feature to be implemented)');
            }

            function addToWishlist(productId) {
                console.log('Adding product to wishlist:', productId);
                alert('Product added to wishlist! (Feature to be implemented)');
            }

            const filterSelects = document.querySelectorAll('.filter-select');
            const priceInputs = document.querySelectorAll('.price-input');
            
            filterSelects.forEach(select => {
                select.addEventListener('change', () => {
                    document.getElementById('filterForm').submit();
                });
            });
            
            priceInputs.forEach(input => {
                let timeoutId;
                input.addEventListener('input', () => {
                    clearTimeout(timeoutId);
                    timeoutId = setTimeout(() => {
                        document.getElementById('filterForm').submit();
                    }, 1000);
                });
            });

            const successMessage = document.querySelector('.success-message');
            if (successMessage) {
                setTimeout(() => {
                    successMessage.style.opacity = '0';
                    setTimeout(() => {
                        successMessage.remove();
                    }, 500);
                }, 5000);
            }

            function confirmDelete() {
                console.log("Confirm delete triggered");
                return confirm('Are you sure you want to delete this product?');
            }
        </script>
    </body>
</html>