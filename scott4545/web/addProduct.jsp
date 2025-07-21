<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product - PRJ301 Web Ban Hang</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/addProduct.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <header class="header">
            <a href="${pageContext.request.contextPath}/home.jsp" class="back-btn"><i class="fas fa-arrow-left"></i> Back to Home</a>
            <h1 class="page-title"><i class="fas fa-plus-circle"></i> Add New Product</h1>
        </header>

        <c:if test="${not empty ERROR}">
            <div class="alert alert-error"><i class="fas fa-exclamation-triangle"></i> ${ERROR}</div>
        </c:if>
        <c:if test="${not empty SUCCESS}">
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${SUCCESS}</div>
        </c:if>

        <c:if test="${sessionScope.user != null && sessionScope.user.userRole == 'A'}">
            <form action="${pageContext.request.contextPath}/MainController" method="POST" class="product-form">
                <input type="hidden" name="action" value="addProduct">
                <div class="form-group">
                    <label for="productName"><i class="fas fa-tag"></i> Product Name</label>
                    <input type="text" id="productName" name="productName" required>
                </div>
                <div class="form-group">
                    <label for="productDescription"><i class="fas fa-info-circle"></i> Description</label>
                    <textarea id="productDescription" name="productDescription"></textarea>
                </div>
                <div class="form-group">
                    <label for="productPrice"><i class="fas fa-dollar-sign"></i> Price (VND)</label>
                    <input type="number" id="productPrice" name="productPrice" step="0.01" min="0.01" required>
                </div>
                <div class="form-group">
                    <label for="productImage"><i class="fas fa-image"></i> Image URL</label>
                    <input type="text" id="productImage" name="productImage">
                </div>
                <div class="form-group">
                    <label for="categoryId"><i class="fas fa-layer-group"></i> Category</label>
                    <select id="categoryId" name="categoryId" required>
                        <option value="">Select Category</option>
                        <c:forEach var="category" items="${CATEGORIES}">
                            <option value="${category.categoryId}">${category.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="brandId"><i class="fas fa-tags"></i> Brand</label>
                    <select id="brandId" name="brandId" required>
                        <option value="">Select Brand</option>
                        <c:forEach var="brand" items="${BRANDS}">
                            <option value="${brand.brandId}">${brand.brandName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="status"><i class="fas fa-toggle-on"></i> Status</label>
                    <input type="checkbox" id="status" name="status" checked> Active
                </div>
                <div class="form-group">
                    <label for="quantity"><i class="fas fa-boxes"></i> Quantity</label>
                    <input type="number" id="quantity" name="quantity" min="0" required>
                </div>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Add Product</button>
            </form>
        </c:if>
        <c:if test="${sessionScope.user == null || sessionScope.user.userRole != 'A'}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-triangle"></i>
                You don't have permission to add products. Please <a href="${pageContext.request.contextPath}/MainController?action=login">log in</a> as an admin.
            </div>
        </c:if>
    </div>

    <script>
        document.querySelector('.product-form')?.addEventListener('submit', function(event) {
            const price = document.getElementById('productPrice').value;
            const quantity = document.getElementById('quantity').value;
            if (price <= 0) {
                alert('Price must be greater than 0.');
                event.preventDefault();
            }
            if (quantity < 0) {
                alert('Quantity cannot be negative.');
                event.preventDefault();
            }
        });
    </script>
</body>
</html>