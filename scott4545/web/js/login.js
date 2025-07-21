/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


// DOM Elements
const togglePassword = document.getElementById('togglePassword');
const passwordInput = document.getElementById('password');
const loginForm = document.getElementById('loginForm');
const loginBtn = document.getElementById('loginBtn');
const inputs = document.querySelectorAll('.form-group input');

// Password toggle functionality
if (togglePassword && passwordInput) {
    togglePassword.addEventListener('click', function() {
        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);
        
        // Toggle eye icon
        this.classList.toggle('fa-eye');
        this.classList.toggle('fa-eye-slash');
    });
}

// Form submission with loading state
if (loginForm && loginBtn) {
    loginForm.addEventListener('submit', function(e) {
        // Add loading state
        loginBtn.classList.add('loading');
        loginBtn.innerHTML = 'Đang đăng nhập...';
        
        // Disable form inputs to prevent multiple submissions
        const formInputs = this.querySelectorAll('input, button');
        formInputs.forEach(input => {
            input.disabled = true;
        });
    });
}

// Auto-focus on username field when page loads
document.addEventListener('DOMContentLoaded', function() {
    const usernameInput = document.getElementById('username');
    if (usernameInput) {
        usernameInput.focus();
    }
});

// Add floating label effect
inputs.forEach(input => {
    // Check if input has value on page load
    if (input.value !== '') {
        input.parentElement.classList.add('focused');
    }
    
    input.addEventListener('focus', function() {
        this.parentElement.classList.add('focused');
    });
    
    input.addEventListener('blur', function() {
        if (this.value === '') {
            this.parentElement.classList.remove('focused');
        }
    });
    
    // Real-time validation feedback
    input.addEventListener('input', function() {
        if (this.validity.valid) {
            this.style.borderColor = '#28a745';
        } else if (this.value !== '') {
            this.style.borderColor = '#dc3545';
        } else {
            this.style.borderColor = '#e1e5e9';
        }
    });
});

// Enter key navigation
document.addEventListener('keydown', function(e) {
    if (e.key === 'Enter') {
        const activeElement = document.activeElement;
        
        if (activeElement.id === 'username') {
            e.preventDefault();
            passwordInput.focus();
        }
    }
});

// Add shake animation for error alerts
const errorAlert = document.querySelector('.alert-error');
if (errorAlert) {
    errorAlert.style.animation = 'shake 0.5s ease-in-out';
}

// Shake animation keyframes (added via JavaScript)
const style = document.createElement('style');
style.textContent = `
    @keyframes shake {
        0%, 100% { transform: translateX(0); }
        10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
        20%, 40%, 60%, 80% { transform: translateX(5px); }
    }
`;
document.head.appendChild(style);

// Form validation enhancement
function validateForm() {
    const username = document.getElementById('username').value.trim();
    const password = document.getElementById('password').value;
    let isValid = true;
    
    // Username validation
    if (username.length < 3) {
        showFieldError('username', 'Tên đăng nhập phải có ít nhất 3 ký tự');
        isValid = false;
    } else {
        clearFieldError('username');
    }
    
    // Password validation
    if (password.length < 6) {
        showFieldError('password', 'Mật khẩu phải có ít nhất 6 ký tự');
        isValid = false;
    } else {
        clearFieldError('password');
    }
    
    return isValid;
}

function showFieldError(fieldId, message) {
    const field = document.getElementById(fieldId);
    const formGroup = field.parentElement;
    
    // Remove existing error
    const existingError = formGroup.querySelector('.field-error');
    if (existingError) {
        existingError.remove();
    }
    
    // Add error styling
    field.style.borderColor = '#dc3545';
    
    // Create error message
    const errorDiv = document.createElement('div');
    errorDiv.className = 'field-error';
    errorDiv.textContent = message;
    errorDiv.style.cssText = `
        color: #dc3545;
        font-size: 12px;
        margin-top: 5px;
        animation: slideIn 0.3s ease;
    `;
    
    formGroup.appendChild(errorDiv);
}

function clearFieldError(fieldId) {
    const field = document.getElementById(fieldId);
    const formGroup = field.parentElement;
    const errorDiv = formGroup.querySelector('.field-error');
    
    if (errorDiv) {
        errorDiv.remove();
    }
    
    field.style.borderColor = '#e1e5e9';
}

// Add form validation on submit
if (loginForm) {
    loginForm.addEventListener('submit', function(e) {
        if (!validateForm()) {
            e.preventDefault();
            
            // Remove loading state if validation fails
            loginBtn.classList.remove('loading');
            loginBtn.innerHTML = 'Đăng nhập';
            
            // Re-enable form inputs
            const formInputs = this.querySelectorAll('input, button');
            formInputs.forEach(input => {
                input.disabled = false;
            });
        }
    });
}