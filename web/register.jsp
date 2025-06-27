<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Gaming Portal</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/register.css" rel="stylesheet">
</head>
<body>
    <div class="background-effects">
        <div class="grid-overlay"></div>
        <div class="glow-effect glow-1"></div>
        <div class="glow-effect glow-2"></div>
        <div class="glow-effect glow-3"></div>
    </div>

    <div class="register-container">
        <div class="register-header">
            <div class="logo">
                <i class="fas fa-gamepad"></i>
                <span>GAMING PORTAL</span>
            </div>
        </div>

        <div class="register-box">
            <div class="register-form-header">
                <h2>TẠO TÀI KHOẢN</h2>
                <p>Tham gia cộng đồng gaming của chúng tôi</p>
            </div>

            <form action="MainController" method="POST" class="register-form">
                <input type="hidden" name="action" value="register">
                
                <div class="form-row">
                    <div class="input-group">
                        <div class="input-wrapper">
                            <i class="fas fa-user input-icon"></i>
                            <input type="text" name="username" id="username" placeholder="Tên đăng nhập" required>
                            <div class="input-border"></div>
                        </div>
                    </div>

                    <div class="input-group">
                        <div class="input-wrapper">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" name="password" id="password" placeholder="Mật khẩu" required>
                            <button type="button" class="toggle-password" onclick="togglePassword('password', 'toggle-icon-1')">
                                <i class="fas fa-eye" id="toggle-icon-1"></i>
                            </button>
                            <div class="input-border"></div>
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="input-group full-width">
                        <div class="input-wrapper">
                            <i class="fas fa-id-card input-icon"></i>
                            <input type="text" name="customerName" id="customerName" placeholder="Họ và tên" required>
                            <div class="input-border"></div>
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="input-group">
                        <div class="input-wrapper">
                            <i class="fas fa-phone input-icon"></i>
                            <input type="text" name="customerPhone" id="customerPhone" placeholder="Số điện thoại" required>
                            <div class="input-border"></div>
                        </div>
                    </div>

                    <div class="input-group">
                        <div class="input-wrapper">
                            <i class="fas fa-envelope input-icon"></i>
                            <input type="email" name="customerEmail" id="customerEmail" placeholder="Email (tùy chọn)">
                            <div class="input-border"></div>
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="input-group full-width">
                        <div class="input-wrapper">
                            <i class="fas fa-map-marker-alt input-icon"></i>
                            <input type="text" name="customerAddress" id="customerAddress" placeholder="Địa chỉ (tùy chọn)">
                            <div class="input-border"></div>
                        </div>
                    </div>
                </div>

                <div class="form-options">
                    <label class="checkbox-container">
                        <input type="checkbox" id="terms" required>
                        <span class="checkmark"></span>
                        Tôi đồng ý với <span class="terms-link" onclick="showTermsModal()">Điều khoản sử dụng</span>
                    </label>
                    
                    <label class="checkbox-container">
                        <input type="checkbox" id="newsletter">
                        <span class="checkmark"></span>
                        Nhận tin tức và ưu đãi từ chúng tôi
                    </label>
                </div>

                <button type="submit" class="register-btn">
                    <span>TẠO TÀI KHOẢN</span>
                    <div class="btn-glow"></div>
                </button>

                <div class="login-link">
                    <span>Đã có tài khoản? </span>
                    <a href="login.jsp">Đăng nhập ngay</a>
                </div>
            </form>
        </div>

        <div class="features-preview">
            <div class="feature-item">
                <i class="fas fa-trophy"></i>
                <span>Thành tích gaming</span>
            </div>
            <div class="feature-item">
                <i class="fas fa-users"></i>
                <span>Cộng đồng sôi động</span>
            </div>
            <div class="feature-item">
                <i class="fas fa-gift"></i>
                <span>Ưu đãi độc quyền</span>
            </div>
        </div>
    </div>

    <!-- Terms Modal -->
    <div id="termsModal" class="modal">
        <div class="modal-content">
            <h3>Terms of Service</h3>
            <p>Nothing here</p>
            <button class="close-modal" onclick="closeTermsModal()">Close</button>
        </div>
    </div>

    <script src="js/register.js"></script>
</body>
</html>