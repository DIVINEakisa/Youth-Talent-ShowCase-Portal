<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.youthtalent.model.User" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }
    
    List<User> users = (List<User>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Youth Talent Showcase</title>
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
                <a href="${pageContext.request.contextPath}/admin/action/talents/all">
                    <i class="fas fa-trophy me-2"></i>All Talents
                </a>
                <a href="${pageContext.request.contextPath}/admin/action/users" class="active">
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
            <div class="col-md-10 p-4">
                <div class="mb-4">
                    <h2><i class="fas fa-users me-2"></i>User Management</h2>
                    <p class="text-muted">View and manage registered users</p>
                </div>
                
                <!-- Users Table -->
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Username</th>
                                        <th>Full Name</th>
                                        <th>Email</th>
                                        <th>Role</th>
                                        <th>Joined</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (users != null && !users.isEmpty()) {
                                        for (User u : users) { %>
                                        <tr>
                                            <td><%= u.getUserId() %></td>
                                            <td>
                                                <i class="fas fa-user-circle me-1"></i>
                                                <%= u.getUsername() %>
                                            </td>
                                            <td><%= u.getFullName() %></td>
                                            <td><%= u.getEmail() %></td>
                                            <td>
                                                <% if ("ADMIN".equals(u.getRole())) { %>
                                                    <span class="badge bg-danger">Admin</span>
                                                <% } else if ("EMPLOYER".equals(u.getRole())) { %>
                                                    <span class="badge bg-warning text-dark">Employer</span>
                                                <% } else { %>
                                                    <span class="badge bg-primary">Youth</span>
                                                <% } %>
                                            </td>
                                            <td><small><%= u.getCreatedAt() %></small></td>
                                            <td>
                                                <span class="badge bg-success">Active</span>
                                            </td>
                                        </tr>
                                    <% } } else { %>
                                        <tr>
                                            <td colspan="7" class="text-center py-4">
                                                <i class="fas fa-info-circle text-muted fa-2x mb-2"></i>
                                                <p class="mb-0">No users found</p>
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
