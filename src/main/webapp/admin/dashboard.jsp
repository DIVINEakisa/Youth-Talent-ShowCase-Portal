<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.youthtalent.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.youthtalent.model.Talent" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }
    
    Integer totalUsers = (Integer) request.getAttribute("totalUsers");
    Integer totalTalents = (Integer) request.getAttribute("totalTalents");
    Integer pendingTalents = (Integer) request.getAttribute("pendingTalents");
    Integer approvedTalents = (Integer) request.getAttribute("approvedTalents");
    Integer rejectedTalents = (Integer) request.getAttribute("rejectedTalents");
    Integer pendingReports = (Integer) request.getAttribute("pendingReports");
    List<Talent> topTalents = (List<Talent>) request.getAttribute("topTalents");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Youth Talent Showcase</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-green: #198754;
        }
        
        .sidebar {
            background-color: #212529;
            min-height: 100vh;
            color: white;
        }
        
        .sidebar a {
            color: #adb5bd;
            text-decoration: none;
            padding: 15px 20px;
            display: block;
            transition: all 0.3s;
        }
        
        .sidebar a:hover, .sidebar a.active {
            background-color: var(--primary-green);
            color: white;
        }
        
        .stat-card {
            border-radius: 10px;
            padding: 20px;
            color: white;
            margin-bottom: 20px;
        }
        
        .stat-card i {
            font-size: 40px;
            opacity: 0.8;
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
                <a href="${pageContext.request.contextPath}/admin/action/dashboard" class="active">
                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/admin/action/talents/pending">
                    <i class="fas fa-clock me-2"></i>Pending Talents 
                    <% if (pendingTalents != null && pendingTalents > 0) { %>
                        <span class="badge bg-danger"><%= pendingTalents %></span>
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
                    <% if (pendingReports != null && pendingReports > 0) { %>
                        <span class="badge bg-warning"><%= pendingReports %></span>
                    <% } %>
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
            <div class="col-md-10 p-4">
                <div class="mb-4">
                    <h2><i class="fas fa-tachometer-alt me-2"></i>Admin Dashboard</h2>
                    <p class="text-muted">Welcome back, <%= user.getFullName() %></p>
                </div>
                
                <% if (request.getParameter("success") != null) { %>
                    <div class="alert alert-success alert-dismissible fade show">
                        <i class="fas fa-check-circle me-2"></i><%= request.getParameter("success") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                
                <!-- Statistics Cards -->
                <div class="row">
                    <div class="col-md-3">
                        <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <h6>Total Users</h6>
                                    <h2><%= totalUsers != null ? totalUsers : 0 %></h2>
                                </div>
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-3">
                        <div class="stat-card" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <h6>Total Talents</h6>
                                    <h2><%= totalTalents != null ? totalTalents : 0 %></h2>
                                </div>
                                <i class="fas fa-trophy"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-3">
                        <div class="stat-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <h6>Approved</h6>
                                    <h2><%= approvedTalents != null ? approvedTalents : 0 %></h2>
                                </div>
                                <i class="fas fa-check-circle"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-3">
                        <div class="stat-card" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <h6>Pending</h6>
                                    <h2><%= pendingTalents != null ? pendingTalents : 0 %></h2>
                                </div>
                                <i class="fas fa-clock"></i>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Top Rated Talents -->
                <div class="card mt-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-star me-2"></i>Top Rated Talents</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Title</th>
                                        <th>User</th>
                                        <th>Category</th>
                                        <th>Rating</th>
                                        <th>Views</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (topTalents != null && !topTalents.isEmpty()) {
                                        for (Talent talent : topTalents) { %>
                                        <tr>
                                            <td><%= talent.getTalentId() %></td>
                                            <td><%= talent.getTitle() %></td>
                                            <td><%= talent.getUsername() %></td>
                                            <td><span class="badge bg-info"><%= talent.getCategoryName() %></span></td>
                                            <td>
                                                <i class="fas fa-star text-warning"></i>
                                                <%= String.format("%.1f", talent.getAverageRating()) %>
                                                (<%= talent.getTotalRatings() %>)
                                            </td>
                                            <td><%= talent.getViewsCount() %></td>
                                            <td>
                                                <% if ("APPROVED".equals(talent.getStatus())) { %>
                                                    <span class="badge bg-success">Approved</span>
                                                <% } else if ("PENDING".equals(talent.getStatus())) { %>
                                                    <span class="badge bg-warning">Pending</span>
                                                <% } else { %>
                                                    <span class="badge bg-danger">Rejected</span>
                                                <% } %>
                                            </td>
                                        </tr>
                                    <% } } else { %>
                                        <tr>
                                            <td colspan="7" class="text-center">No data available</td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
