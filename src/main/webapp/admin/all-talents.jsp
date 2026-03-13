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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Talents - Youth Talent Showcase</title>
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
                <a href="${pageContext.request.contextPath}/admin/action/talents/pending">
                    <i class="fas fa-clock me-2"></i>Pending Talents
                </a>
                <a href="${pageContext.request.contextPath}/admin/action/talents/all" class="active">
                    <i class="fas fa-trophy me-2"></i>All Talents
                </a>
                <a href="${pageContext.request.contextPath}/admin/action/users">
                    <i class="fas fa-users me-2"></i>Users
                </a>
                <a href="${pageContext.request.contextPath}/admin/action/reports">
                    <i class="fas fa-flag me-2"></i>Reports
                </a>
                <a href="${pageContext.request.contextPath}/admin/action/opportunities">
                    <i class="fas fa-briefcase me-2"></i>Opportunities
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
                    <h2><i class="fas fa-trophy me-2"></i>All Talents</h2>
                    <p class="text-muted">View and manage all talent submissions</p>
                </div>
                
                <!-- Filter Options -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form method="get" action="${pageContext.request.contextPath}/admin/action/talents/all">
                            <div class="row">
                                <div class="col-md-4">
                                    <label class="form-label">Filter by Status</label>
                                    <select name="status" class="form-select" onchange="this.form.submit()">
                                        <option value="">All Statuses</option>
                                        <option value="PENDING">Pending</option>
                                        <option value="APPROVED">Approved</option>
                                        <option value="REJECTED">Rejected</option>
                                    </select>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Talents Table -->
                <div class="card">
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
                                        <th>Submitted</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (talents != null && !talents.isEmpty()) {
                                        for (Talent talent : talents) { %>
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
                                                    <span class="badge bg-warning text-dark">Pending</span>
                                                <% } else { %>
                                                    <span class="badge bg-danger">Rejected</span>
                                                <% } %>
                                            </td>
                                            <td><small><%= talent.getSubmittedAt() %></small></td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/talents/detail?id=<%= talent.getTalentId() %>" 
                                                   class="btn btn-sm btn-outline-primary" target="_blank">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    <% } } else { %>
                                        <tr>
                                            <td colspan="9" class="text-center py-4">
                                                <i class="fas fa-info-circle text-muted fa-2x mb-2"></i>
                                                <p class="mb-0">No talents found</p>
                                            </td>
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
