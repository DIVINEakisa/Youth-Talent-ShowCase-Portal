<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.youthtalent.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - Youth Talent Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-green: #198754;
            --dark-green: #146c43;
            --light-green: #d1e7dd;
        }
        
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .settings-header {
            background: linear-gradient(135deg, var(--primary-green), var(--dark-green));
            color: white;
            padding: 60px 0;
            margin-bottom: 30px;
        }
        
        .settings-container {
            max-width: 1000px;
            margin: 0 auto;
        }
        
        .settings-nav {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            padding: 20px;
            position: sticky;
            top: 80px;
        }
        
        .settings-nav .nav-link {
            color: #495057;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 8px;
            transition: all 0.3s;
            font-weight: 500;
        }
        
        .settings-nav .nav-link:hover {
            background: var(--light-green);
            color: var(--primary-green);
        }
        
        .settings-nav .nav-link.active {
            background: var(--primary-green);
            color: white;
        }
        
        .settings-nav .nav-link i {
            width: 20px;
            margin-right: 10px;
        }
        
        .settings-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            padding: 30px;
            margin-bottom: 20px;
        }
        
        .settings-card h4 {
            color: var(--primary-green);
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--light-green);
        }
        
        .form-label {
            font-weight: 500;
            color: #495057;
            margin-bottom: 8px;
        }
        
        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #dee2e6;
            padding: 12px 15px;
            transition: all 0.3s;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-green);
            box-shadow: 0 0 0 0.2rem rgba(25, 135, 84, 0.15);
        }
        
        .btn-save {
            background: var(--primary-green);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .btn-save:hover {
            background: var(--dark-green);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(25, 135, 84, 0.3);
        }
        
        .btn-cancel {
            background: #6c757d;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .btn-cancel:hover {
            background: #5a6268;
        }
        
        .avatar-preview {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--light-green);
            margin-bottom: 15px;
        }
        
        .alert-custom {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
        }
        
        .setting-item {
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            margin-bottom: 15px;
            transition: all 0.3s;
        }
        
        .setting-item:hover {
            background: var(--light-green);
        }
        
        .setting-title {
            font-weight: 600;
            color: #212529;
            margin-bottom: 5px;
        }
        
        .setting-description {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 0;
        }
        
        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 24px;
        }
        
        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        
        .toggle-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 24px;
        }
        
        .toggle-slider:before {
            position: absolute;
            content: "";
            height: 18px;
            width: 18px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }
        
        input:checked + .toggle-slider {
            background-color: var(--primary-green);
        }
        
        input:checked + .toggle-slider:before {
            transform: translateX(26px);
        }
        
        .danger-zone {
            border: 2px solid #dc3545;
            border-radius: 12px;
            padding: 25px;
            background: #fff5f5;
        }
        
        .danger-zone h5 {
            color: #dc3545;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <% 
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }
    
    String successMsg = (String) session.getAttribute("successMessage");
    String errorMsg = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
    %>
    <%@ include file="includes/navbar.jsp" %>
    
    <!-- Settings Header -->
    <div class="settings-header">
        <div class="container">
            <h1 class="text-center"><i class="fas fa-cog me-2"></i>Settings</h1>
            <p class="text-center mb-0">Manage your account settings and preferences</p>
        </div>
    </div>
    
    <!-- Settings Content -->
    <div class="container settings-container mb-5">
        <!-- Success/Error Messages -->
        <% if (successMsg != null) { %>
        <div class="alert alert-success alert-custom alert-dismissible fade show">
            <i class="fas fa-check-circle me-2"></i><%= successMsg %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>
        
        <% if (errorMsg != null) { %>
        <div class="alert alert-danger alert-custom alert-dismissible fade show">
            <i class="fas fa-exclamation-circle me-2"></i><%= errorMsg %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>
        
        <div class="row">
            <!-- Left Sidebar Navigation -->
            <div class="col-lg-3 mb-4">
                <div class="settings-nav">
                    <h5 class="mb-3">Settings</h5>
                    <div class="nav flex-column">
                        <a class="nav-link active" href="#profile" data-bs-toggle="pill">
                            <i class="fas fa-user"></i>Profile
                        </a>
                        <a class="nav-link" href="#account" data-bs-toggle="pill">
                            <i class="fas fa-shield-alt"></i>Account
                        </a>
                        <a class="nav-link" href="#security" data-bs-toggle="pill">
                            <i class="fas fa-lock"></i>Security
                        </a>
                        <a class="nav-link" href="#notifications" data-bs-toggle="pill">
                            <i class="fas fa-bell"></i>Notifications
                        </a>
                        <a class="nav-link" href="#privacy" data-bs-toggle="pill">
                            <i class="fas fa-user-secret"></i>Privacy
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Right Content Area -->
            <div class="col-lg-9">
                <div class="tab-content">
                    <!-- Profile Settings -->
                    <div class="tab-pane fade show active" id="profile">
                        <div class="settings-card">
                            <h4><i class="fas fa-user me-2"></i>Profile Information</h4>
                            <form action="${pageContext.request.contextPath}/user/update-profile" method="post" enctype="multipart/form-data">
                                <div class="text-center mb-4">
                                    <% if (user.getProfileImage() != null && !user.getProfileImage().isEmpty()) { %>
                                        <img src="<%= user.getProfileImage() %>" alt="Profile" class="avatar-preview" id="avatarPreview">
                                    <% } else { %>
                                        <div class="avatar-preview d-inline-flex align-items-center justify-content-center" 
                                             style="background: linear-gradient(135deg, var(--light-green), var(--primary-green)); color: white; font-size: 3rem;">
                                            <i class="fas fa-user"></i>
                                        </div>
                                    <% } %>
                                </div>
                                
                                <div class="mb-4">
                                    <label class="form-label">Profile Image URL</label>
                                    <input type="url" class="form-control" name="profileImage" 
                                           value="<%= user.getProfileImage() != null ? user.getProfileImage() : "" %>" 
                                           placeholder="https://example.com/image.jpg">
                                    <small class="text-muted">Enter a URL to your profile image</small>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Full Name *</label>
                                        <input type="text" class="form-control" name="fullName" 
                                               value="<%= user.getFullName() %>" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Username *</label>
                                        <input type="text" class="form-control" name="username" 
                                               value="<%= user.getUsername() %>" readonly>
                                        <small class="text-muted">Username cannot be changed</small>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Email *</label>
                                    <input type="email" class="form-control" name="email" 
                                           value="<%= user.getEmail() %>" required>
                                </div>
                                
                                <div class="mb-4">
                                    <label class="form-label">Bio</label>
                                    <textarea class="form-control" name="bio" rows="4" 
                                              placeholder="Tell others about yourself..."><%= user.getBio() != null ? user.getBio() : "" %></textarea>
                                    <small class="text-muted">Maximum 500 characters</small>
                                </div>
                                
                                <div class="text-end">
                                    <a href="${pageContext.request.contextPath}/profile.jsp" class="btn btn-cancel me-2">
                                        <i class="fas fa-times me-2"></i>Cancel
                                    </a>
                                    <button type="submit" class="btn btn-save">
                                        <i class="fas fa-save me-2"></i>Save Changes
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Account Settings -->
                    <div class="tab-pane fade" id="account">
                        <div class="settings-card">
                            <h4><i class="fas fa-shield-alt me-2"></i>Account Settings</h4>
                            
                            <div class="setting-item">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="setting-title">Account Type</div>
                                        <div class="setting-description">Current role: <%= user.getRole() %></div>
                                    </div>
                                    <span class="badge bg-success px-3 py-2"><%= user.getRole() %></span>
                                </div>
                            </div>
                            
                            <div class="setting-item">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="setting-title">Account Status</div>
                                        <div class="setting-description">Your account is active and in good standing</div>
                                    </div>
                                    <span class="badge bg-success px-3 py-2">Active</span>
                                </div>
                            </div>
                            
                            <div class="setting-item">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="setting-title">Member Since</div>
                                        <div class="setting-description">
                                            <%= new java.text.SimpleDateFormat("MMMM dd, yyyy").format(user.getCreatedAt()) %>
                                        </div>
                                    </div>
                                    <i class="fas fa-calendar-alt text-muted" style="font-size: 1.5rem;"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Security Settings -->
                    <div class="tab-pane fade" id="security">
                        <div class="settings-card">
                            <h4><i class="fas fa-lock me-2"></i>Security Settings</h4>
                            <form action="${pageContext.request.contextPath}/user/change-password" method="post">
                                <div class="mb-3">
                                    <label class="form-label">Current Password *</label>
                                    <input type="password" class="form-control" name="currentPassword" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">New Password *</label>
                                    <input type="password" class="form-control" name="newPassword" 
                                           minlength="6" required>
                                    <small class="text-muted">Minimum 6 characters</small>
                                </div>
                                
                                <div class="mb-4">
                                    <label class="form-label">Confirm New Password *</label>
                                    <input type="password" class="form-control" name="confirmPassword" 
                                           minlength="6" required>
                                </div>
                                
                                <div class="text-end">
                                    <button type="submit" class="btn btn-save">
                                        <i class="fas fa-key me-2"></i>Change Password
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Notification Settings -->
                    <div class="tab-pane fade" id="notifications">
                        <div class="settings-card">
                            <h4><i class="fas fa-bell me-2"></i>Notification Preferences</h4>
                            <form action="${pageContext.request.contextPath}/user/update-notifications" method="post">
                                <div class="setting-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="setting-title">Email Notifications</div>
                                            <div class="setting-description">Receive updates about your talents via email</div>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" name="emailNotifications" checked>
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                </div>
                                
                                <div class="setting-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="setting-title">Comment Notifications</div>
                                            <div class="setting-description">Get notified when someone comments on your talents</div>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" name="commentNotifications" checked>
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                </div>
                                
                                <div class="setting-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="setting-title">Rating Notifications</div>
                                            <div class="setting-description">Get notified when your talents receive new ratings</div>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" name="ratingNotifications" checked>
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                </div>
                                
                                <div class="setting-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="setting-title">Newsletter</div>
                                            <div class="setting-description">Receive our weekly newsletter with tips and features</div>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" name="newsletter">
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                </div>
                                
                                <div class="text-end mt-4">
                                    <button type="submit" class="btn btn-save">
                                        <i class="fas fa-save me-2"></i>Save Preferences
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Privacy Settings -->
                    <div class="tab-pane fade" id="privacy">
                        <div class="settings-card">
                            <h4><i class="fas fa-user-secret me-2"></i>Privacy Settings</h4>
                            <form action="${pageContext.request.contextPath}/user/update-privacy" method="post">
                                <div class="setting-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="setting-title">Profile Visibility</div>
                                            <div class="setting-description">Make your profile visible to all users</div>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" name="profileVisibility" checked>
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                </div>
                                
                                <div class="setting-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="setting-title">Show Email</div>
                                            <div class="setting-description">Display your email on your public profile</div>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" name="showEmail">
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                </div>
                                
                                <div class="setting-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="setting-title">Activity Status</div>
                                            <div class="setting-description">Show when you're active on the platform</div>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" name="activityStatus" checked>
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                </div>
                                
                                <div class="text-end mt-4">
                                    <button type="submit" class="btn btn-save">
                                        <i class="fas fa-save me-2"></i>Save Settings
                                    </button>
                                </div>
                            </form>
                        </div>
                        
                        <!-- Danger Zone -->
                        <div class="danger-zone mt-4">
                            <h5><i class="fas fa-exclamation-triangle me-2"></i>Danger Zone</h5>
                            <p class="text-muted mb-3">These actions are irreversible. Please be careful.</p>
                            <button class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteAccountModal">
                                <i class="fas fa-trash me-2"></i>Delete Account
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Account Modal -->
    <div class="modal fade" id="deleteAccountModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title"><i class="fas fa-exclamation-triangle me-2"></i>Delete Account</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p><strong>Warning:</strong> This action cannot be undone. Deleting your account will:</p>
                    <ul>
                        <li>Permanently delete all your talents</li>
                        <li>Remove all your comments and ratings</li>
                        <li>Delete your profile information</li>
                    </ul>
                    <p>Type your username <strong><%= user.getUsername() %></strong> to confirm:</p>
                    <input type="text" class="form-control" id="confirmUsername" placeholder="Enter username">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" onclick="deleteAccount()">
                        <i class="fas fa-trash me-2"></i>Delete My Account
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function deleteAccount() {
            const confirmUsername = document.getElementById('confirmUsername').value;
            const actualUsername = '<%= user.getUsername() %>';
            
            if (confirmUsername === actualUsername) {
                // Proceed with account deletion
                window.location.href = '${pageContext.request.contextPath}/user/delete-account';
            } else {
                alert('Username does not match. Account deletion cancelled.');
            }
        }
        
        // Password validation
        const newPasswordInput = document.querySelector('input[name="newPassword"]');
        const confirmPasswordInput = document.querySelector('input[name="confirmPassword"]');
        
        if (confirmPasswordInput) {
            confirmPasswordInput.addEventListener('input', function() {
                if (this.value !== newPasswordInput.value) {
                    this.setCustomValidity('Passwords do not match');
                } else {
                    this.setCustomValidity('');
                }
            });
        }
    </script>
</body>
</html>
