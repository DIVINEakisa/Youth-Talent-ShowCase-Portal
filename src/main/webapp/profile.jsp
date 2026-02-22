<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.youthtalent.model.User" %>
<%@ page import="com.youthtalent.model.Talent" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Youth Talent Portal</title>
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
        
        .profile-header {
            background: linear-gradient(135deg, var(--primary-green), var(--dark-green));
            color: white;
            padding: 60px 0 120px;
            margin-bottom: -80px;
        }
        
        .profile-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .profile-cover {
            height: 200px;
            background: linear-gradient(135deg, var(--light-green), var(--primary-green));
            position: relative;
        }
        
        .profile-avatar-container {
            position: relative;
            margin-top: -80px;
            text-align: center;
            margin-bottom: 20px;
        }
        
        .profile-avatar {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 5px solid white;
            object-fit: cover;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            background: white;
        }
        
        .profile-name {
            font-size: 2rem;
            font-weight: bold;
            margin-top: 15px;
            color: #212529;
        }
        
        .profile-username {
            color: #6c757d;
            font-size: 1.1rem;
        }
        
        .profile-bio {
            color: #495057;
            font-size: 1rem;
            max-width: 600px;
            margin: 20px auto;
            line-height: 1.6;
        }
        
        .profile-stats {
            display: flex;
            justify-content: center;
            gap: 40px;
            padding: 30px;
            border-top: 1px solid #dee2e6;
            border-bottom: 1px solid #dee2e6;
            margin: 20px 0;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: var(--primary-green);
            display: block;
        }
        
        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .info-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            padding: 25px;
            margin-bottom: 20px;
        }
        
        .info-card h5 {
            color: var(--primary-green);
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--light-green);
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f1f3f5;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            color: #6c757d;
            font-weight: 500;
        }
        
        .info-value {
            color: #212529;
            font-weight: 400;
        }
        
        .badge-display {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 15px;
        }
        
        .badge-item {
            background: linear-gradient(135deg, #fff, var(--light-green));
            border: 2px solid var(--primary-green);
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            flex: 1;
            min-width: 120px;
            transition: transform 0.3s;
        }
        
        .badge-item:hover {
            transform: translateY(-5px);
        }
        
        .badge-icon {
            font-size: 2rem;
            color: var(--primary-green);
            margin-bottom: 8px;
        }
        
        .badge-name {
            font-weight: 600;
            color: #212529;
            font-size: 0.9rem;
        }
        
        .btn-edit-profile {
            background: var(--primary-green);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .btn-edit-profile:hover {
            background: var(--dark-green);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(25, 135, 84, 0.3);
        }
        
        .activity-timeline {
            position: relative;
            padding-left: 30px;
        }
        
        .activity-timeline::before {
            content: '';
            position: absolute;
            left: 10px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: var(--light-green);
        }
        
        .activity-item {
            position: relative;
            padding-bottom: 20px;
        }
        
        .activity-item::before {
            content: '';
            position: absolute;
            left: -24px;
            top: 5px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: var(--primary-green);
            border: 2px solid white;
            box-shadow: 0 0 0 2px var(--primary-green);
        }
        
        .activity-content {
            background: #f8f9fa;
            padding: 12px 15px;
            border-radius: 8px;
            border-left: 3px solid var(--primary-green);
        }
        
        .activity-date {
            color: #6c757d;
            font-size: 0.85rem;
            margin-top: 5px;
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
    %>
    <%@ include file="includes/navbar.jsp" %>
    
    <!-- Profile Header -->
    <div class="profile-header">
        <div class="container">
            <h1 class="text-center"><i class="fas fa-user-circle me-2"></i>My Profile</h1>
        </div>
    </div>
    
    <!-- Profile Content -->
    <div class="container mb-5">
        <!-- Main Profile Card -->
        <div class="profile-card">
            <div class="profile-cover"></div>
            
            <div class="profile-avatar-container">
                <% if (user.getProfileImage() != null && !user.getProfileImage().isEmpty()) { %>
                    <img src="<%= user.getProfileImage() %>" alt="<%= user.getFullName() %>" class="profile-avatar">
                <% } else { %>
                    <div class="profile-avatar d-flex align-items-center justify-content-center" 
                         style="background: linear-gradient(135deg, var(--light-green), var(--primary-green)); color: white; font-size: 3rem;">
                        <i class="fas fa-user"></i>
                    </div>
                <% } %>
            </div>
            
            <div class="text-center px-4">
                <h2 class="profile-name"><%= user.getFullName() %></h2>
                <p class="profile-username">@<%= user.getUsername() %></p>
                <p class="profile-bio">
                    <%= user.getBio() != null ? user.getBio() : "No bio yet. Add one to tell others about yourself!" %>
                </p>
                
                <div class="mb-4">
                    <span class="badge bg-success px-3 py-2">
                        <i class="fas fa-shield-alt me-1"></i> 
                        <%= user.getRole() %>
                    </span>
                </div>
                
                <a href="${pageContext.request.contextPath}/settings.jsp" class="btn btn-edit-profile mb-4">
                    <i class="fas fa-edit me-2"></i>Edit Profile
                </a>
            </div>
            
            <!-- Profile Stats -->
            <div class="profile-stats">
                <div class="stat-item">
                    <span class="stat-number">
                        <% 
                        // Get talent count from request or default to 0
                        Integer talentCount = (Integer) request.getAttribute("talentCount");
                        if (talentCount == null) talentCount = 0;
                        %>
                        <%= talentCount %>
                    </span>
                    <span class="stat-label">Talents</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">
                        <% 
                        Integer totalViews = (Integer) request.getAttribute("totalViews");
                        if (totalViews == null) totalViews = 0;
                        %>
                        <%= totalViews %>
                    </span>
                    <span class="stat-label">Total Views</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">
                        <% 
                        Double avgRating = (Double) request.getAttribute("avgRating");
                        if (avgRating == null) avgRating = 0.0;
                        %>
                        <%= String.format("%.1f", avgRating) %>
                    </span>
                    <span class="stat-label">Avg Rating</span>
                </div>
            </div>
        </div>
        
        <!-- Additional Info Grid -->
        <div class="row mt-4">
            <!-- Account Information -->
            <div class="col-lg-6 mb-4">
                <div class="info-card">
                    <h5><i class="fas fa-info-circle me-2"></i>Account Information</h5>
                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-envelope me-2"></i>Email</span>
                        <span class="info-value"><%= user.getEmail() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-user-tag me-2"></i>Username</span>
                        <span class="info-value"><%= user.getUsername() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-id-card me-2"></i>Full Name</span>
                        <span class="info-value"><%= user.getFullName() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-calendar-alt me-2"></i>Member Since</span>
                        <span class="info-value">
                            <%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(user.getCreatedAt()) %>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-circle me-2 text-success"></i>Status</span>
                        <span class="info-value">
                            <span class="badge bg-success">Active</span>
                        </span>
                    </div>
                </div>
            </div>
            
            <!-- Achievements & Badges -->
            <div class="col-lg-6 mb-4">
                <div class="info-card">
                    <h5><i class="fas fa-trophy me-2"></i>Achievements & Badges</h5>
                    <div class="badge-display">
                        <div class="badge-item">
                            <div class="badge-icon">
                                <i class="fas fa-star"></i>
                            </div>
                            <div class="badge-name">First Talent</div>
                        </div>
                        <div class="badge-item" style="opacity: 0.4;">
                            <div class="badge-icon">
                                <i class="fas fa-fire"></i>
                            </div>
                            <div class="badge-name">Rising Star</div>
                        </div>
                        <div class="badge-item" style="opacity: 0.4;">
                            <div class="badge-icon">
                                <i class="fas fa-heart"></i>
                            </div>
                            <div class="badge-name">Popular</div>
                        </div>
                    </div>
                    <p class="text-muted mt-3 mb-0 text-center">
                        <small>Keep sharing your talents to unlock more badges!</small>
                    </p>
                </div>
            </div>
        </div>
        
        <!-- Recent Activity -->
        <div class="row">
            <div class="col-12">
                <div class="info-card">
                    <h5><i class="fas fa-clock me-2"></i>Recent Activity</h5>
                    <div class="activity-timeline">
                        <div class="activity-item">
                            <div class="activity-content">
                                <strong>Joined Youth Talent Portal</strong>
                                <div class="activity-date">
                                    <%= new java.text.SimpleDateFormat("MMM dd, yyyy 'at' hh:mm a").format(user.getCreatedAt()) %>
                                </div>
                            </div>
                        </div>
                        <% if (talentCount > 0) { %>
                        <div class="activity-item">
                            <div class="activity-content">
                                <strong>Posted <%= talentCount %> talent<%= talentCount > 1 ? "s" : "" %></strong>
                                <div class="activity-date">Check your talents page for details</div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="row mt-4">
            <div class="col-12 text-center">
                <a href="${pageContext.request.contextPath}/talent/my-talents" class="btn btn-outline-success btn-lg me-2">
                    <i class="fas fa-th-list me-2"></i>View My Talents
                </a>
                <a href="${pageContext.request.contextPath}/add-talent.jsp" class="btn btn-success btn-lg">
                    <i class="fas fa-plus-circle me-2"></i>Add New Talent
                </a>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
