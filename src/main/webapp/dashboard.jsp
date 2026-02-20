<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.youthtalent.model.User" %>
<%@ page import="com.youthtalent.dao.TalentDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.youthtalent.model.Talent" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }
    
    TalentDAO talentDAO = new TalentDAO();
    List<Talent> recentTalents = talentDAO.getTopRatedTalents(6);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Youth Talent Showcase</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-green: #198754;
            --light-green: #20c997;
        }
        
        body {
            background-color: #f8f9fa;
        }
        
        .welcome-banner {
            background: linear-gradient(135deg, var(--primary-green) 0%, var(--light-green) 100%);
            color: white;
            padding: 50px 0;
            margin-bottom: 30px;
        }
        
        .stat-card {
            border-left: 4px solid var(--primary-green);
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .talent-card {
            transition: transform 0.3s;
            height: 100%;
            border-radius: 12px;
            overflow: hidden;
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .talent-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        
        .talent-image {
            height: 200px;
            width: 100%;
            object-fit: cover;
            display: block;
        }
        
        .talent-image-placeholder {
            height: 200px;
            width: 100%;
            background: linear-gradient(135deg, #198754, #146c43);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
        }
        
        .btn-green {
            background: var(--primary-green);
            border-color: var(--primary-green);
            color: white;
        }
        
        .btn-green:hover {
            background: #146c43;
            border-color: #146c43;
            color: white;
        }
    </style>
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>
    
    <div class="welcome-banner">
        <div class="container">
            <h1><i class="fas fa-star me-2"></i>Welcome, <%= user.getFullName() %>!</h1>
            <p class="lead">Showcase your talents and discover amazing creators</p>
        </div>
    </div>
    
    <div class="container mb-5">
        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="card stat-card h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted">My Talents</h6>
                                <h3 class="mb-0"><%= talentDAO.getTalentsByUserId(user.getUserId()).size() %></h3>
                            </div>
                            <div class="text-success" style="font-size: 40px;">
                                <i class="fas fa-folder-open"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer bg-transparent">
                        <a href="${pageContext.request.contextPath}/talent/my-talents" class="text-success">
                            View All <i class="fas fa-arrow-right ms-1"></i>
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card stat-card h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted">Total Talents</h6>
                                <h3 class="mb-0"><%= talentDAO.getCountByStatus("APPROVED") %></h3>
                            </div>
                            <div class="text-success" style="font-size: 40px;">
                                <i class="fas fa-trophy"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer bg-transparent">
                        <a href="${pageContext.request.contextPath}/talent/list" class="text-success">
                            Explore <i class="fas fa-arrow-right ms-1"></i>
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card stat-card h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted">Quick Action</h6>
                                <h6 class="mb-0">Add New Talent</h6>
                            </div>
                            <div class="text-success" style="font-size: 40px;">
                                <i class="fas fa-plus-circle"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer bg-transparent">
                        <a href="${pageContext.request.contextPath}/talent/add" class="text-success">
                            Get Started <i class="fas fa-arrow-right ms-1"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="mb-4">
            <h3><i class="fas fa-fire text-danger me-2"></i>Top Rated Talents</h3>
            <hr>
        </div>
        
        <div class="row g-4">
            <% if (recentTalents != null && !recentTalents.isEmpty()) { 
                for (Talent talent : recentTalents) { %>
                <div class="col-md-4">
                    <div class="card talent-card">
                        <% if (talent.getImageUrl() != null && !talent.getImageUrl().isEmpty()) { %>
                            <img src="<%= talent.getImageUrl() %>" 
                                 class="talent-image" 
                                 alt="<%= talent.getTitle() %> - a <%= talent.getCategoryName() %> talent showcase"
                                 loading="lazy"
                                 onerror="this.onerror=null; this.style.display='none'; this.nextElementSibling.style.display='flex';">
                            <div class="talent-image-placeholder" style="display: none;">
                                <i class="fas fa-image"></i>
                            </div>
                        <% } else { %>
                            <div class="talent-image-placeholder">
                                <i class="fas fa-star"></i>
                            </div>
                        <% } %>
                        <div class="card-body">
                            <span class="badge bg-success mb-2"><%= talent.getCategoryName() %></span>
                            <h5 class="card-title"><%= talent.getTitle() %></h5>
                            <p class="card-text text-muted">
                                <small>by <%= talent.getUsername() %></small>
                            </p>
                            <div class="mb-2">
                                <% 
                                    int fullStars = (int) talent.getAverageRating();
                                    for (int i = 0; i < fullStars; i++) { %>
                                        <i class="fas fa-star text-warning"></i>
                                <% } 
                                    for (int i = fullStars; i < 5; i++) { %>
                                        <i class="far fa-star text-warning"></i>
                                <% } %>
                                <small class="text-muted">(<%= String.format("%.1f", talent.getAverageRating()) %> / <%= talent.getTotalRatings() %> ratings)</small>
                            </div>
                            <a href="${pageContext.request.contextPath}/talent/view?id=<%= talent.getTalentId() %>" 
                               class="btn btn-green btn-sm w-100">
                                <i class="fas fa-eye me-1"></i>View Details
                            </a>
                        </div>
                    </div>
                </div>
            <% } } else { %>
                <div class="col-12">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>No talents available yet. Be the first to showcase your talent!
                    </div>
                </div>
            <% } %>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
