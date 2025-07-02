<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.ProductDTO, model.CategoryDTO, model.BrandDTO"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - Gaming Store</title>
    <link rel="stylesheet" href="css/products.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="container">
        <!-- Navigation - Moved to top -->
        <nav class="navigation">
            <a href="home.jsp" class="back-btn">
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
                    <form action="MainController" method="GET" class="search-form-inner">
                        <input type="hidden" name="action" value="search">
                        <div class="search-input-wrapper">
                            <i class="fas fa-search search-icon"></i>
                            <input type="text" name="query" class="search-input" 
                                   placeholder="Search for gaming gear, peripherals, accessories..." 
                                   value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>">
                            <button type="submit" class="search-btn">
                                <i class="fas fa-search"></i>
                                Search
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Filters -->
                <form action="MainController" method="GET" id="filterForm">
                    <input type="hidden" name="action" value="listProducts">
                    <div class="filters-container">
                        <div class="filter-group">
                            <label class="filter-label">
                                <i class="fas fa-tags"></i>
                                Category
                            </label>
                            <select name="categoryId" class="filter-select">
                                <option value="">All Categories</option>
                                <% 
                                    List<CategoryDTO> categories = (List<CategoryDTO>) request.getAttribute("CATEGORIES");
                                    String selectedCategory = request.getParameter("categoryId");
                                    if (categories != null) {
                                        for (CategoryDTO category : categories) {
                                %>
                                    <option value="<%= category.getCategoryId() %>" 
                                            <%= (selectedCategory != null && selectedCategory.equals(String.valueOf(category.getCategoryId()))) ? "selected" : "" %>>
                                        <%= category.getCategoryName() %>
                                    </option>
                                <% 
                                        }
                                    }
                                %>
                            </select>
                        </div>

                        <div class="filter-group">
                            <label class="filter-label">
                                <i class="fas fa-trademark"></i>
                                Brand
                            </label>
                            <select name="brandId" class="filter-select">
                                <option value="">All Brands</option>
                                <% 
                                    List<BrandDTO> brands = (List<BrandDTO>) request.getAttribute("BRANDS");
                                    String selectedBrand = request.getParameter("brandId");
                                    if (brands != null) {
                                        for (BrandDTO brand : brands) {
                                %>
                                    <option value="<%= brand.getBrandId() %>" 
                                            <%= (selectedBrand != null && selectedBrand.equals(String.valueOf(brand.getBrandId()))) ? "selected" : "" %>>
                                        <%= brand.getBrandName() %>
                                    </option>
                                <% 
                                        }
                                    }
                                %>
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
                                       value="<%= request.getParameter("minPrice") != null ? request.getParameter("minPrice") : "" %>">
                                <span class="price-separator">-</span>
                                <input type="number" name="maxPrice" class="price-input" 
                                       placeholder="Max Price" 
                                       value="<%= request.getParameter("maxPrice") != null ? request.getParameter("maxPrice") : "" %>">
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
                <a href="MainController?action=listProducts&categoryId=1" class="suggestion-tag">
                    <i class="fas fa-mouse"></i>
                    Gaming Mouse
                </a>
                <a href="MainController?action=listProducts&categoryId=2" class="suggestion-tag">
                    <i class="fas fa-keyboard"></i>
                    Keyboards
                </a>
                <a href="MainController?action=listProducts&categoryId=3" class="suggestion-tag">
                    <i class="fas fa-headphones"></i>
                    Headsets
                </a>
                <a href="MainController?action=listProducts&categoryId=4" class="suggestion-tag">
                    <i class="fas fa-desktop"></i>
                    Monitors
                </a>
                <a href="MainController?action=listProducts&categoryId=5" class="suggestion-tag">
                    <i class="fas fa-chair"></i>
                    Gaming Chairs
                </a>
            </div>
        </section>

        <!-- Results Section -->
        <section class="results-section">
            <div class="results-header">
                <h2 class="results-title">
                    <i class="fas fa-list"></i>
                    Products
                    <% 
                        List<ProductDTO> products = (List<ProductDTO>) request.getAttribute("PRODUCTS");
                        if (products != null) {
                    %>
                        <span class="results-count">(<%= products.size() %> items found)</span>
                    <% } %>
                </h2>
            </div>

            <div class="products-grid">
                <% 
                    if (products != null && !products.isEmpty()) {
                        for (ProductDTO product : products) {
                %>
                    <div class="product-card">
                        <div class="product-image-container">
                            <% if (product.getProductImage() != null && !product.getProductImage().isEmpty()) { %>
                                <img src="<%= product.getProductImage() %>" alt="<%= product.getProductName() %>" class="product-image">
                            <% } else { %>
                                <div class="product-image-placeholder">
                                    <i class="fas fa-image"></i>
                                </div>
                            <% } %>
                            <div class="product-overlay">
                                <a href="MainController?action=productDetail&productId=<%= product.getProductId() %>" class="quick-view-btn">
                                    <i class="fas fa-eye"></i>
                                    View Details
                                </a>
                            </div>
                        </div>
                        
                        <div class="product-info">
                            <h3 class="product-name">
                                <a href="MainController?action=productDetail&productId=<%= product.getProductId() %>">
                                    <%= product.getProductName() %>
                                </a>
                            </h3>
                            
                            <div class="product-price">
                                <span class="price-value"><%= String.format("%,.0f", product.getProductPrice()) %></span>
                                <span class="price-symbol">VND</span>
                            </div>
                            
                            <div class="product-actions">
                                <button class="add-to-cart-btn" onclick="addToCart(<%= product.getProductId() %>)">
                                    <i class="fas fa-shopping-cart"></i>
                                    Add to Cart
                                </button>
                                <button class="wishlist-btn" onclick="addToWishlist(<%= product.getProductId() %>)">
                                    <i class="fas fa-heart"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                <% 
                        }
                    } else {
                %>
                    <div class="no-results">
                        <div class="no-results-icon">
                            <i class="fas fa-search"></i>
                        </div>
                        <h3 class="no-results-title">No Products Found</h3>
                        <p class="no-results-message">
                            We couldn't find any products matching your criteria. Try adjusting your filters or search terms.
                        </p>
                        <a href="MainController?action=listProducts" class="browse-btn">
                            <i class="fas fa-list"></i>
                            Browse All Products
                        </a>
                    </div>
                <% } %>
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
            // Implement add to cart logic
            console.log('Adding product to cart:', productId);
            // You can add AJAX call here to add product to cart
        }

        // Add to wishlist functionality
        function addToWishlist(productId) {
            // Implement add to wishlist logic
            console.log('Adding product to wishlist:', productId);
            // You can add AJAX call here to add product to wishlist
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