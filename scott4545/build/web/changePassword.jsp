<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.UserDTO"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password - GameZone</title>
    <link rel="stylesheet" href="css/changePassword.css">
</head>
<body>
    <%
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>

    <!-- Header -->
    <header class="header">
        <div class="header-content">
            <a href="home.jsp" class="logo">🎮 GameZone</a>
            <a href="home.jsp" class="back-btn">
                ← Back to Home
            </a>
        </div>
    </header>

    <!-- Main Content -->
    <div class="container">
        <div class="form-container">
            <h1 class="form-title">Change Password</h1>
            <p class="form-subtitle">Secure your account with a strong password</p>

            <!-- Alert Messages -->
            <% 
                String error = (String) request.getAttribute("ERROR");
                String success = (String) request.getAttribute("SUCCESS");
                if (error != null && !error.isEmpty()) { 
            %>
                <div class="alert alert-error">
                    <%= error %>
                </div>
            <% } %>
            <% if (success != null && !success.isEmpty()) { %>
                <div class="alert alert-success">
                    <%= success %>
                </div>
            <% } %>

            <!-- Change Password Form -->
            <form action="MainController" method="POST" id="changePasswordForm" novalidate>
                <input type="hidden" name="action" value="changePassword">
                
                <div class="form-group">
                    <label class="form-label" for="currentPassword">Current Password</label>
                    <input type="password" 
                           class="form-input" 
                           id="currentPassword" 
                           name="currentPassword" 
                           placeholder="Enter your current password"
                           autocomplete="off"
                           required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="newPassword">New Password</label>
                    <input type="password" 
                           class="form-input" 
                           id="newPassword" 
                           name="newPassword" 
                           placeholder="Enter your new password"
                           autocomplete="off"
                           required>
                    <div class="password-strength">
                        <div class="strength-bar" id="strengthBar"></div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="confirmPassword">Confirm New Password</label>
                    <input type="password" 
                           class="form-input" 
                           id="confirmPassword" 
                           name="confirmPassword" 
                           placeholder="Confirm your new password"
                           autocomplete="off"
                           required>
                </div>

                <button type="submit" class="submit-btn">
                    Change Password
                    <div class="loading" id="loading"></div>
                </button>
            </form>

            <!-- Security Tips -->
            <div class="security-tips">
                <h4>🛡️ Password Security Tips</h4>
                <ul>
                    <li>Use at least 8 characters</li>
                    <li>Mix uppercase and lowercase letters</li>
                    <li>Include numbers and special characters</li>
                    <li>Avoid common words or personal information</li>
                    <li>Don't reuse passwords from other accounts</li>
                </ul>
            </div>
        </div>
    </div>

    <script>
        // Password strength checker
        const newPasswordInput = document.getElementById('newPassword');
        const strengthBar = document.getElementById('strengthBar');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const currentPasswordInput = document.getElementById('currentPassword');
        const form = document.getElementById('changePasswordForm');
        const loading = document.getElementById('loading');

        newPasswordInput.addEventListener('input', function() {
            const password = this.value;
            const strength = calculatePasswordStrength(password);
            updateStrengthBar(strength);
        });

        function calculatePasswordStrength(password) {
            let strength = 0;
            if (password.length >= 8) strength += 25;
            if (password.match(/[a-z]/)) strength += 25;
            if (password.match(/[A-Z]/)) strength += 25;
            if (password.match(/[0-9]/)) strength += 12.5;
            if (password.match(/[^a-zA-Z0-9]/)) strength += 12.5;
            return Math.min(strength, 100);
        }

        function updateStrengthBar(strength) {
            strengthBar.style.width = strength + '%';
        }

        // Form validation for confirm password
        confirmPasswordInput.addEventListener('input', function() {
            const newPassword = newPasswordInput.value;
            const confirmPassword = this.value;

            // Only validate if confirmPassword has content
            if (confirmPassword === '') {
                this.setCustomValidity('');
                this.style.borderColor = '';
            } else if (newPassword !== confirmPassword) {
                this.setCustomValidity('Passwords do not match');
                this.style.borderColor = '#ff4444';
            } else {
                this.setCustomValidity('');
                this.style.borderColor = '#00ff88';
            }
        });

        // Clear validation and styles on page load
        window.addEventListener('load', function() {
            currentPasswordInput.setCustomValidity('');
            newPasswordInput.setCustomValidity('');
            confirmPasswordInput.setCustomValidity('');
            currentPasswordInput.style.borderColor = '';
            newPasswordInput.style.borderColor = '';
            confirmPasswordInput.style.borderColor = '';
        });

        // Form submission with loading
        form.addEventListener('submit', function(event) {
            const currentPassword = currentPasswordInput.value;
            const newPassword = newPasswordInput.value;
            const confirmPassword = confirmPasswordInput.value;

            // Client-side validation
            if (!currentPassword || !newPassword || !confirmPassword) {
                event.preventDefault();
                alert('All password fields are required.');
                loading.style.display = 'none';
                return;
            }
            if (newPassword !== confirmPassword) {
                event.preventDefault();
                alert('New password and confirm password do not match.');
                loading.style.display = 'none';
                return;
            }

            loading.style.display = 'inline-block';
        });

        // Input focus effects
        document.querySelectorAll('.form-input').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.style.transform = 'scale(1.02)';
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.style.transform = 'scale(1)';
            });
        });
    </script>
</body>
</html>