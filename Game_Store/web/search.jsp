<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.ProductDTO, model.CategoryDTO, model.BrandDTO"%>
<!DOCTYPE html>
<html>
<head>
    <title>Search Results</title>
</head>
<body>
    <h2>Search Results</h2>
    <form action="MainController" method="GET">
        <input type="hidden" name="action" value="search">
        <input type="text" name="query" value="<%= request.getAttribute("QUERY") != null ? request.getAttribute("QUERY") : "" %>" placeholder="Search products...">
        <label>Category:</label>
        <select name="categoryId">
            <option value="">All</option>
            <% for (CategoryDTO category : (List<CategoryDTO>) request.getAttribute("CATEGORIES")) { %>
                <option value="<%= category.getCategoryId() %>"><%= category.getCategoryName() %></option>
            <% } %>
        </select>
        <label>Brand:</label>
        <select name="brandId">
            <option value="">All</option>
            <% for (BrandDTO brand : (List<BrandDTO>) request.getAttribute("BRANDS")) { %>
                <option value="<%= brand.getBrandId() %>"><%= brand.getBrandName() %></option>
            <% } %>
        </select>
        <label>Price Range:</label>
        <input type="number" name="minPrice" placeholder="Min Price">
        <input type="number" name="maxPrice" placeholder="Max Price">
        <input type="submit" value="Search">
    </form>
    <%
        List<String> suggestions = (List<String>) request.getAttribute("SUGGESTIONS");
        if (suggestions != null && !suggestions.isEmpty()) {
    %>
        <p>Suggestions: 
        <% for (String suggestion : suggestions) { %>
            <a href="MainController?action=search&query=<%= java.net.URLEncoder.encode(suggestion, "UTF-8") %>"><%= suggestion %></a> 
        <% } %>
        </p>
    <% } %>
    <%
        List<ProductDTO> products = (List<ProductDTO>) request.getAttribute("PRODUCTS");
        if (products != null && !products.isEmpty()) {
            for (ProductDTO product : products) {
    %>
        <div>
            <h3><a href="MainController?action=productDetail&productId=<%= product.getProductId() %>"><%= product.getProductName() %></a></h3>
            <p>Price: $<%= product.getProductPrice() %></p>
            <% if (product.getProductImage() != null) { %>
                <img src="<%= product.getProductImage() %>" alt="<%= product.getProductName() %>" width="100">
            <% } %>
        </div>
    <%  }
        } else {
    %>
        <p>No products found.</p>
    <% } %>
    <a href="home.jsp">Back to Home</a>
</body>
</html>