<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.youthtalent.model.User" %>
<%@ page import="com.youthtalent.model.Talent" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }
    
    List<Talent> talents = (List<Talent>) request.getAttribute("talents");
    String status = (String) request.getAttribute("status");
    
    // Get counts for badges
    Integer pendingCount = 0;
    Integer approvedCount = 0;
    Integer rejectedCount = 0;
    
    if (talents != null) {
        for (Talent talent : talents) {
            if ("PENDING".equals(talent.getStatus())) pendingCount++;
            else if ("APPROVED".equals(talent.getStatus())) approvedCount++;
            else if ("REJECTED".equals(talent.getStatus())) rejectedCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Talents - Youth Talent Showcase</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-green: #198754;
        }
        
        body {
            overflow-x: hidden;
        }
        
        .sidebar {
            background-color: #212529;
            min-height: 100vh;
            color: white;
            position: sticky;
            top: 0;
            height: 100vh;
            overflow-y: auto;
        }
        
        .sidebar a {
            color: #adb5bd;
            text-decoration: none;
            padding: 15px 20px;
            display: block;
            transition: background-color 0.3s, color 0.3s;
        }
        
        .sidebar a:hover, .sidebar a.active {
            background-color: var(--primary-green);
            color: white;
        }
        
        .talent-card {
            border: 1px solid #dee2e6;
            border-radius: 10px;
            overflow: hidden;
            transition: box-shadow 0.3s;
            margin-bottom: 20px;
            height: 100%;
        }
        
        .talent-card:hover {
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .talent-card .card-body {
            display: flex;
            flex-direction: column;
        }
        
        .talent-media {
            width: 100%;
            height: 200px;
            object-fit: cover;
            display: block;
            background-color: #f8f9fa;
        }
        
        .badge-lg {
            padding: 8px 15px;
            font-size: 14px;
        }
        
        .main-content {
            max-height: 100vh;
            overflow-y: auto;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 sidebar p-0">
                <div class="p-3 text-center border-bottom">
                    <h5><i class="fas fa-shield-alt me-2"></i>Admin Panel</h5>
                </div>
                <a href="${pageContext.request.contextPath}/admin/action/dashboard">
                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/admin/action/talents/pending" class="<%= "PENDING".equals(status) ? "active" : "" %>">
                    <i class="fas fa-clock me-2"></i>Pending Talents
                    <% if (pendingCount > 0) { %>
                        <span class="badge bg-danger"><%= pendingCount %></span>
                    <% } %>
                </a>
                <a href="${pageContext.request.contextPath}/admin/action/talents/all">
                    <i class="fas fa-trophy me-2"></i>All Talents
                </a>
                <a href="${pageContext.request.contextPath}/admin/action/users">
                    <i class="fas fa-users me-2"></i>Users
                </a>
                <a href="${pageContext.request.contextPath}/admin/action/reports">
                    <i class="fas fa-flag me-2"></i>Reports
                </a>
                <hr class="bg-secondary">
                <a href="${pageContext.request.contextPath}/dashboard.jsp">
                    <i class="fas fa-home me-2"></i>Back to Portal
                </a>
                <a href="${pageContext.request.contextPath}/auth/logout" class="text-danger">
                    <i class="fas fa-sign-out-alt me-2"></i>Logout
                </a>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 p-4 main-content">
                <div class="mb-4">
                    <h2>
                        <i class="fas fa-clock me-2"></i>
                        <% if ("PENDING".equals(status)) { %>
                            Pending Talents
                        <% } else { %>
                            Manage Talents
                        <% } %>
                    </h2>
                    <p class="text-muted">Review and manage talent submissions</p>
                </div>
                
                <!-- Alert Messages -->
                <% if (request.getParameter("success") != null) { %>
                    <div class="alert alert-success alert-dismissible fade show">
                        <i class="fas fa-check-circle me-2"></i><%= request.getParameter("success") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                
                <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="fas fa-exclamation-circle me-2"></i><%= request.getParameter("error") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                
                <!-- Talents List -->
                <% if (talents != null && !talents.isEmpty()) { %>
                    <div class="row row-cols-1 row-cols-md-2 g-4">
                        <% for (Talent talent : talents) { %>
                            <div class="col">
                                <div class="talent-card">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start mb-3">
                                            <div>
                                                <h5 class="card-title mb-1"><%= talent.getTitle() %></h5>
                                                <p class="text-muted mb-0">
                                                    <small>
                                                        <i class="fas fa-user me-1"></i><%= talent.getUsername() %>
                                                        <i class="fas fa-calendar ms-3 me-1"></i><%= talent.getSubmittedAt() %>
                                                    </small>
                                                </p>
                                            </div>
                                            <div>
                                                <% if ("PENDING".equals(talent.getStatus())) { %>
                                                    <span class="badge bg-warning text-dark badge-lg">Pending</span>
                                                <% } else if ("APPROVED".equals(talent.getStatus())) { %>
                                                    <span class="badge bg-success badge-lg">Approved</span>
                                                <% } else { %>
                                                    <span class="badge bg-danger badge-lg">Rejected</span>
                                                <% } %>
                                            </div>
                                        </div>
                                        
                                        <p class="card-text" style="max-height: 60px; overflow: hidden; text-overflow: ellipsis;"><%= talent.getDescription() %></p>
                                        
                                        <div class="mb-3">
                                            <span class="badge bg-info me-2">
                                                <i class="fas fa-tag me-1"></i><%= talent.getCategoryName() %>
                                            </span>
                                            <span class="badge bg-secondary">
                                                <i class="fas fa-star me-1"></i><%= String.format("%.1f", talent.getAverageRating()) %> (<%= talent.getTotalRatings() %>)
                                            </span>
                                            <span class="badge bg-secondary ms-2">
                                                <i class="fas fa-eye me-1"></i><%= talent.getViewsCount() %> views
                                            </span>
                                        </div>
                                        
                                        <!-- Media Preview -->
                                        <div class="mb-3" style="height: 200px; background-color: #f8f9fa; border-radius: 8px; overflow: hidden;">
                                            <% 
                                            String imageSource = null;
                                            if (talent.getImageUrl() != null && !talent.getImageUrl().isEmpty()) {
                                                imageSource = talent.getImageUrl();
                                            } else if (talent.getMediaUrl() != null && !talent.getMediaUrl().isEmpty() && "IMAGE".equals(talent.getMediaType())) {
                                                imageSource = talent.getMediaUrl();
                                            }
                                            
                                            if (imageSource != null) { %>
                                                <img src="<%= imageSource %>" 
                                                     class="talent-media" 
                                                     alt="<%= talent.getTitle() %>"
                                                     loading="lazy"
                                                     style="width: 100%; height: 100%; object-fit: cover;"
                                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                <div class="d-none align-items-center justify-content-center" style="width: 100%; height: 100%;">
                                                    <i class="fas fa-image fa-3x text-muted"></i>
                                                </div>
                                            <% } else if (talent.getMediaUrl() != null && !talent.getMediaUrl().isEmpty() && "VIDEO".equals(talent.getMediaType())) { %>
                                                <video class="talent-media" controls style="width: 100%; height: 100%; object-fit: cover;">
                                                    <source src="<%= talent.getMediaUrl() %>" type="video/mp4">
                                                    Your browser does not support video.
                                                </video>
                                            <% } else { %>
                                                <div class="d-flex align-items-center justify-content-center" style="width: 100%; height: 100%;">
                                                    <i class="fas fa-image fa-3x text-muted"></i>
                                                </div>
                                            <% } %>
                                        </div>
                                        
                                        <!-- Action Buttons -->
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <a href="${pageContext.request.contextPath}/talents/detail?id=<%= talent.getTalentId() %>" 
                                                   class="btn btn-sm btn-outline-primary" target="_blank">
                                                    <i class="fas fa-eye me-1"></i>View Details
                                                </a>
                                            </div>
                                            
                                            <% if ("PENDING".equals(talent.getStatus())) { %>
                                                <div>
                                                    <button type="button" class="btn btn-sm btn-success" 
                                                            onclick="approveTalent(<%= talent.getTalentId() %>)">
                                                        <i class="fas fa-check me-1"></i>Approve
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-danger" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#rejectModal<%= talent.getTalentId() %>">
                                                        <i class="fas fa-times me-1"></i>Reject
                                                    </button>
                                                </div>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Reject Modal -->
                            <div class="modal fade" id="rejectModal<%= talent.getTalentId() %>" tabindex="-1">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Reject Talent</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/action/talent/reject">
                                            <div class="modal-body">
                                                <input type="hidden" name="talentId" value="<%= talent.getTalentId() %>">
                                                <div class="mb-3">
                                                    <label class="form-label">Rejection Reason</label>
                                                    <textarea class="form-control" name="rejectionReason" rows="4" 
                                                              placeholder="Please provide a reason for rejection..." required></textarea>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-danger">Reject Talent</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="alert alert-info text-center py-5">
                        <i class="fas fa-info-circle fa-3x mb-3"></i>
                        <h4>No Pending Talents</h4>
                        <p class="mb-0">There are no talents waiting for review at the moment.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function approveTalent(talentId) {
            if (confirm('Are you sure you want to approve this talent?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/action/talent/approve';
                
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'talentId';
                input.value = talentId;
                
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
