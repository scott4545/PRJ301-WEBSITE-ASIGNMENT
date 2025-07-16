/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


function togglePassword(inputId, iconId) {
    const passwordInput = document.getElementById(inputId);
    const toggleIcon = document.getElementById(iconId);
    
    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        toggleIcon.classList.remove('fa-eye');
        toggleIcon.classList.add('fa-eye-slash');
    } else {
        passwordInput.type = 'password';
        toggleIcon.classList.remove('fa-eye-slash');
        toggleIcon.classList.add('fa-eye');
    }
}

function showTermsModal() {
    document.getElementById('termsModal').style.display = 'block';
}

function closeTermsModal() {
    document.getElementById('termsModal').style.display = 'none';
}

// Close modal when clicking outside of it
window.onclick = function(event) {
    const modal = document.getElementById('termsModal');
    if (event.target === modal) {
        modal.style.display = 'none';
    }
}

// Add focus effects for inputs
document.querySelectorAll('.input-wrapper input').forEach(input => {
    input.addEventListener('focus', function() {
        this.parentElement.classList.add('focused');
    });
    
    input.addEventListener('blur', function() {
        this.parentElement.classList.remove('focused');
    });
});

// Add particle animation on button click
document.querySelector('.register-btn').addEventListener('click', function(e) {
    this.classList.add('clicked');
    setTimeout(() => {
        this.classList.remove('clicked');
    }, 300);
});

// Form validation feedback
document.querySelectorAll('input[required]').forEach(input => {
    input.addEventListener('blur', function() {
        if (this.value.trim() === '') {
            this.parentElement.classList.add('error');
        } else {
            this.parentElement.classList.remove('error');
        }
    });
    
    input.addEventListener('input', function() {
        if (this.value.trim() !== '') {
            this.parentElement.classList.remove('error');
        }
    });
});

// Email validation
document.getElementById('customerEmail').addEventListener('blur', function() {
    if (this.value && !this.value.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) {
        this.parentElement.classList.add('error');
    } else {
        this.parentElement.classList.remove('error');
    }
});

// Phone validation
document.getElementById('customerPhone').addEventListener('input', function() {
    this.value = this.value.replace(/[^0-9+\-\s]/g, '');
});