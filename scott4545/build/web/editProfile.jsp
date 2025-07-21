<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.UserDTO, model.UserDAO"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - Gaming Hub</title>
    <link rel="stylesheet" href="css/editProfile.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Clear any existing attributes if this is a GET request (first page load)
        if ("GET".equals(request.getMethod())) {
            request.removeAttribute("ERROR");
            request.removeAttribute("SUCCESS");
        }
        
        UserDAO userDAO = new UserDAO();
        String[] customerInfo = userDAO.getCustomerInfo(user.getUsername());
        String customerName = customerInfo[0] != null ? customerInfo[0] : "";
        String customerPhone = customerInfo[1] != null ? customerInfo[1] : "";
        String customerEmail = customerInfo[2] != null ? customerInfo[2] : "";
        String customerAddress = customerInfo[3] != null ? customerInfo[3] : "";
    %>

    <div class="container">
        <!-- Header -->
        <header class="header">
            <div class="nav-left">
                <a href="home.jsp" class="back-btn">
                    <i class="fas fa-arrow-left"></i>
                    <span>Back to Home</span>
                </a>
            </div>
            <h1 class="page-title">
                <i class="fas fa-user-edit"></i>
                Profile Settings
            </h1>
            <div class="nav-right">
                <span class="username">@<%= user.getUsername() %></span>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Status Messages -->
            <% if (request.getAttribute("ERROR") != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span><%= request.getAttribute("ERROR") %></span>
                </div>
            <% } %>
            <% if (request.getAttribute("SUCCESS") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span><%= request.getAttribute("SUCCESS") %></span>
                </div>
            <% } %>

            <div class="profile-sections">
                <!-- Profile Information Section -->
                <section class="profile-card">
                    <div class="card-header">
                        <h2>
                            <i class="fas fa-user"></i>
                            Personal Information
                        </h2>
                        <p class="card-subtitle">Update your personal details and contact information</p>
                    </div>
                    
                    <form action="MainController" method="POST" class="profile-form">
                        <input type="hidden" name="action" value="editProfile">
                        <input type="hidden" name="username" value="<%= user.getUsername() %>">
                        
                        <div class="form-grid">
                            <div class="input-group">
                                <label for="customerName">
                                    <i class="fas fa-id-card"></i>
                                    Full Name
                                </label>
                                <input type="text" 
                                       id="customerName" 
                                       name="customerName" 
                                       value="<%= customerName %>" 
                                       placeholder="Enter your full name">
                            </div>

                            <div class="input-group">
                                <label for="customerPhone">
                                    <i class="fas fa-phone"></i>
                                    Phone Number
                                </label>
                                <input type="text" 
                                       id="customerPhone" 
                                       name="customerPhone" 
                                       value="<%= customerPhone %>" 
                                       placeholder="Enter your phone number">
                            </div>

                            <div class="input-group">
                                <label for="customerEmail">
                                    <i class="fas fa-envelope"></i>
                                    Email Address
                                </label>
                                <input type="email" 
                                       id="customerEmail" 
                                       name="customerEmail" 
                                       value="<%= customerEmail %>" 
                                       placeholder="Enter your email address">
                            </div>

                            <div class="input-group full-width">
                                <label for="customerAddress">
                                    <i class="fas fa-map-marker-alt"></i>
                                    Address
                                </label>
                                <input type="text" 
                                       id="customerAddress" 
                                       name="customerAddress" 
                                       value="<%= customerAddress %>" 
                                       placeholder="Enter your address">
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i>
                                Update Profile
                            </button>
                        </div>
                    </form>
                </section>

                <!-- Security Section -->
                <section class="profile-card">
                    <div class="card-header">
                        <h2>
                            <i class="fas fa-shield-alt"></i>
                            Security Settings
                        </h2>
                        <p class="card-subtitle">Manage your account security and password</p>
                    </div>

                    <div class="security-content">
                        <div class="security-item">
                            <div class="security-info">
                                <h3>Password</h3>
                                <p>Change your account password to keep your account secure</p>
                            </div>
                            <button type="button" class="btn btn-secondary" onclick="openPasswordModal()">
                                <i class="fas fa-key"></i>
                                Change Password
                            </button>
                        </div>

                        <div class="security-item">
                            <div class="security-info">
                                <h3>Account Status</h3>
                                <p>Your account is active and secure</p>
                            </div>
                            <div class="status-badge">
                                <i class="fas fa-check-circle"></i>
                                Active
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </main>
    </div>

    <!-- Password Change Modal -->
    <div id="passwordModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>
                    <i class="fas fa-key"></i>
                    Change Password
                </h3>
                <button type="button" class="close-btn" onclick="closePasswordModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <iframe src="changePassword.jsp" frameborder="0" width="100%" height="400px"></iframe>
            </div>
        </div>
    </div>

    <script>
        function openPasswordModal() {
            document.getElementById('passwordModal').style.display = 'flex';
            document.body.style.overflow = 'hidden';
        }

        function closePasswordModal() {
            document.getElementById('passwordModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('passwordModal');
            if (event.target === modal) {
                closePasswordModal();
            }
        }

        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    setTimeout(() => {
                        alert.remove();
                    }, 300);
                }, 5000);
            });
        });
    </script>
</body>
</html>