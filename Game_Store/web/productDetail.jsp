<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.ProductDTO, model.ReviewDTO, java.util.List"%>
<!DOCTYPE html>
<html>
<head>
    <title>Product Details</title>
</head>
<body>
    <%
        ProductDTO product = (ProductDTO) request.getAttribute("PRODUCT");
        if (product != null) {
    %>
        <h2><%= product.getProductName() %></h2>
        <% if (product.getProductImage() != null) { %>
            <img src="<%= product.getProductImage() %>" alt="<%= product.getProductName() %>" width="200">
        <% } %>
        <p><b>Price:</b> $<%= product.getProductPrice() %></p>
        <p><b>Description:</b> <%= product.getProductDescription() != null ? product.getProductDescription() : "No description available." %></p>
        <h3>Reviews</h3>
        <%
            List<ReviewDTO> reviews = (List<ReviewDTO>) request.getAttribute("REVIEWS");
            if (reviews != null && !reviews.isEmpty()) {
                for (ReviewDTO review : reviews) {
        %>
            <div>
                <p><b><%= review.getUsername() %></b> rated <%= review.getRating() %>/5</p>
                <p><%= review.getComment() != null ? review.getComment() : "No comment." %></p>
                <p><i>Posted on <%= review.getReviewDate() %></i></p>
            </div>
        <%  }
            } else {
        %>
            <p>No reviews yet.</p>
        <% } %>
    <% } else { %>
        <p>Product not found.</p>
    <% } %>
    <a href="MainController?action=listProducts">Back to Products</a>
</body>
</html>