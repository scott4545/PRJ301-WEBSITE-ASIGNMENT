<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.ProductDTO, model.CategoryDTO, model.BrandDTO"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Search Products - Gaming Store</title>
        <link rel="stylesheet" href="css/search.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <div class="container">
            <!-- Back Button at Top -->
            <div class="navigation">
                <a href="home.jsp" class="back-btn">
                    <i class="fas fa-arrow-left"></i>
                    Back to Home
                </a>
            </div>

            <!-- Header -->
            <header class="header">
                <div class="header-content">
                    <h1 class="page-title">
                        <i class="fas fa-search"></i>
                        Search Products
                    </h1>
                    <div class="header-accent"></div>
                </div>
            </header>

            <!-- Search Filters -->
            <section class="search-section">
                <form class="search-form" method="GET" action="ProductController">
                    <input type="hidden" name="action" value="search">
                    <!-- Main Search Bar -->
                    <div class="search-bar-container">
                        <div class="search-input-wrapper">
                            <i class="fas fa-search search-icon"></i>
                            <input type="text" 
                                   name="query" 
                                   class="search-input"
                                   value="<%= request.getParameter("query") != null ? request.getParameter("query") : ""%>" 
                                   placeholder="Search for gaming gear, accessories, devices...">
                            <button type="submit" class="search-btn">
                                <i class="fas fa-arrow-right"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Advanced Filters -->
                    <div class="filters-container">
                        <div class="filter-group">
                            <label class="filter-label">
                                <i class="fas fa-layer-group"></i>
                                Category
                            </label>
                            <select name="categoryId" class="filter-select">
                                <option value="">All Categories</option>
                                <%
                                    List<CategoryDTO> categories = (List<CategoryDTO>) request.getAttribute("CATEGORIES");
                                    if (categories != null) {
                                        for (CategoryDTO category : categories) {
                                %>
                                <option value="<%= category.getCategoryId()%>" 
                                        <%= String.valueOf(category.getCategoryId()).equals(request.getParameter("categoryId")) ? "selected" : ""%>>
                                    <%= category.getCategoryName()%>
                                </option>
                                <% }
                                    } %>
                            </select>
                        </div>

                        <div class="filter-group">
                            <label class="filter-label">
                                <i class="fas fa-tags"></i>
                                Brand
                            </label>
                            <select name="brandId" class="filter-select">
                                <option value="">All Brands</option>
                                <%
                                    List<BrandDTO> brands = (List<BrandDTO>) request.getAttribute("BRANDS");
                                    if (brands != null) {
                                        for (BrandDTO brand : brands) {
                                %>
                                <option value="<%= brand.getBrandId()%>" 
                                        <%= String.valueOf(brand.getBrandId()).equals(request.getParameter("brandId")) ? "selected" : ""%>>
                                    <%= brand.getBrandName()%>
                                </option>
                                <% }
                                    }%>
                            </select>
                        </div>

                        <div class="filter-group price-filter">
                            <label class="filter-label">
                                <i class="fas fa-dollar-sign"></i>
                                Price Range
                            </label>
                            <div class="price-inputs">
                                <input type="number" 
                                       name="minPrice" 
                                       class="price-input"
                                       placeholder="Minimum Price"
                                       value="<%= request.getParameter("minPrice") != null ? request.getParameter("minPrice") : ""%>">
                                <span class="price-separator">-</span>
                                <input type="number" 
                                       name="maxPrice" 
                                       class="price-input"
                                       placeholder="Maximum Price"
                                       value="<%= request.getParameter("maxPrice") != null ? request.getParameter("maxPrice") : ""%>">
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
            </section>

            <!-- Suggestions -->
            <%
                List<String> suggestions = (List<String>) request.getAttribute("SUGGESTIONS");
                if (suggestions != null && !suggestions.isEmpty()) {
            %>
            <section class="suggestions-section">
                <h3 class="suggestions-title">
                    <i class="fas fa-lightbulb"></i>
                    Search Suggestions
                </h3>
                <div class="suggestions-container">
                    <% for (String suggestion : suggestions) {%>
                    <a href="ProductController?action=search&query=<%= suggestion%>" class="suggestion-tag">
                        <i class="fas fa-search"></i>
                        <%= suggestion%>
                    </a>
                    <% } %>
                </div>
            </section>
            <% } %>

            <!-- Results Section -->
            <section class="results-section">
                <%
                    List<ProductDTO> products = (List<ProductDTO>) request.getAttribute("PRODUCTS");
                    if (products != null && !products.isEmpty()) {
                %>
                <div class="results-header">
                    <h2 class="results-title">
                        <i class="fas fa-gamepad"></i>
                        Search Results
                        <span class="results-count">(<%= products.size()%> products)</span>
                    </h2>
                </div>

                <div class="products-grid">
                    <% for (ProductDTO product : products) { %>
                    <div class="product-card">
                        <div class="product-image-container">
                            <% if (product.getProductImage() != null) {%>
                            <img src="<%= product.getProductImage()%>" 
                                 alt="<%= product.getProductName()%>" 
                                 class="product-image">
                            <% } else { %>
                            <div class="product-image-placeholder">
                                <i class="fas fa-image"></i>
                            </div>
                            <% }%>
                            <div class="product-overlay">
                                <button class="quick-view-btn">
                                    <i class="fas fa-eye"></i>
                                    Quick View
                                </button>
                            </div>
                        </div>

                        <div class="product-info">
                            <h3 class="product-name"><%= product.getProductName()%></h3>
                            <div class="product-price">
                                <span class="price-value"><%= String.format("%,d", (int) product.getProductPrice())%></span>
                                <span class="price-symbol">₫</span>
                            </div>

                            <div class="product-actions">
                                <button class="add-to-cart-btn">
                                    <i class="fas fa-shopping-cart"></i>
                                    Add to Cart
                                </button>
                                <button class="wishlist-btn">
                                    <i class="far fa-heart"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } else { %>
                <div class="no-results">
                    <div class="no-results-icon">
                        <i class="fas fa-search"></i>
                    </div>
                    <h3 class="no-results-title">No Products Found</h3>
                    <p class="no-results-message">
                        Try adjusting your search criteria or browse our categories
                    </p>
                    <a href="MainController?action=listProducts" class="browse-btn">
                        <i class="fas fa-th-large"></i>
                        Browse All Products
                    </a>
                </div>
                <% }%>
            </section>
        </div>

        <!-- JavaScript for interactions -->
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Search input focus effect
                const searchInput = document.querySelector('.search-input');
                const searchContainer = document.querySelector('.search-input-wrapper');

                searchInput.addEventListener('focus', () => {
                    searchContainer.classList.add('focused');
                });

                searchInput.addEventListener('blur', () => {
                    searchContainer.classList.remove('focused');
                });

                // Wishlist toggle
                document.querySelectorAll('.wishlist-btn').forEach(btn => {
                    btn.addEventListener('click', function () {
                        const icon = this.querySelector('i');
                        if (icon.classList.contains('far')) {
                            icon.classList.remove('far');
                            icon.classList.add('fas');
                            this.style.color = '#00ff88';
                        } else {
                            icon.classList.remove('fas');
                            icon.classList.add('far');
                            this.style.color = '';
                        }
                    });
                });
            });
        </script>
    </body>
</html>