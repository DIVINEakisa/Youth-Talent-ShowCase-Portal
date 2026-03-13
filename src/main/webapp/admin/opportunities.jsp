<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.youthtalent.model.User" %>
<%@ page import="com.youthtalent.model.Opportunity" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }

    List<Opportunity> opportunities = (List<Opportunity>) request.getAttribute("opportunities");
    String selectedStatus = (String) request.getAttribute("selectedStatus");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Opportunities - Youth Talent Showcase</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-green: #198754; }
        .sidebar { background-color: #212529; min-height: 100vh; color: #fff; }
        .sidebar a { color: #adb5bd; text-decoration: none; padding: 15px 20px; display: block; transition: all 0.3s; }
        .sidebar a:hover, .sidebar a.active { background-color: var(--primary-green); color: #fff; }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 sidebar p-0">
            <div class="p-3 text-center border-bottom">
                <h5><i class="fas fa-shield-alt me-2"></i>Admin Panel</h5>
            </div>
            <a href="${pageContext.request.contextPath}/admin/action/dashboard"><i class="fas fa-tachometer-alt me-2"></i>Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/action/talents/pending"><i class="fas fa-clock me-2"></i>Pending Talents</a>
            <a href="${pageContext.request.contextPath}/admin/action/talents/all"><i class="fas fa-trophy me-2"></i>All Talents</a>
            <a href="${pageContext.request.contextPath}/admin/action/users"><i class="fas fa-users me-2"></i>Users</a>
            <a href="${pageContext.request.contextPath}/admin/action/reports"><i class="fas fa-flag me-2"></i>Reports</a>
            <a href="${pageContext.request.contextPath}/admin/action/opportunities" class="active"><i class="fas fa-briefcase me-2"></i>Opportunities</a>
            <hr class="bg-secondary">
            <a href="${pageContext.request.contextPath}/dashboard.jsp"><i class="fas fa-home me-2"></i>Back to Portal</a>
            <a href="${pageContext.request.contextPath}/auth/logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i>Logout</a>
        </div>

        <div class="col-md-10 p-4">
            <h2><i class="fas fa-briefcase me-2"></i>Opportunities Moderation</h2>
            <p class="text-muted">Review offers sent by employers and remove inappropriate items.</p>

            <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success"><%= request.getParameter("success") %></div>
            <% } %>
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger"><%= request.getParameter("error") %></div>
            <% } %>

            <div class="card mb-3">
                <div class="card-body">
                    <form method="get" action="${pageContext.request.contextPath}/admin/action/opportunities">
                        <div class="row g-2 align-items-end">
                            <div class="col-md-4">
                                <label class="form-label">Filter by Status</label>
                                <select name="status" class="form-select" onchange="this.form.submit()">
                                    <option value="" <%= (selectedStatus == null || selectedStatus.isEmpty()) ? "selected" : "" %>>All</option>
                                    <option value="PENDING" <%= "PENDING".equals(selectedStatus) ? "selected" : "" %>>PENDING</option>
                                    <option value="ACCEPTED" <%= "ACCEPTED".equals(selectedStatus) ? "selected" : "" %>>ACCEPTED</option>
                                    <option value="REJECTED" <%= "REJECTED".equals(selectedStatus) ? "selected" : "" %>>REJECTED</option>
                                    <option value="REMOVED" <%= "REMOVED".equals(selectedStatus) ? "selected" : "" %>>REMOVED</option>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card">
                <div class="card-body table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Type</th>
                            <th>Employer</th>
                            <th>Youth</th>
                            <th>Talent</th>
                            <th>Status</th>
                            <th>Created</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (opportunities != null && !opportunities.isEmpty()) {
                            for (Opportunity opportunity : opportunities) { %>
                            <tr>
                                <td><%= opportunity.getOpportunityId() %></td>
                                <td>
                                    <strong><%= opportunity.getTitle() %></strong><br>
                                    <small class="text-muted"><%= opportunity.getDescription() %></small>
                                </td>
                                <td><span class="badge bg-secondary"><%= opportunity.getType() %></span></td>
                                <td><%= opportunity.getEmployerName() %></td>
                                <td><%= opportunity.getYouthName() %></td>
                                <td><%= opportunity.getTalentTitle() %></td>
                                <td>
                                    <% if ("PENDING".equals(opportunity.getStatus())) { %>
                                        <span class="badge bg-warning text-dark">PENDING</span>
                                    <% } else if ("ACCEPTED".equals(opportunity.getStatus())) { %>
                                        <span class="badge bg-success">ACCEPTED</span>
                                    <% } else { %>
                                        <span class="badge bg-danger">REJECTED</span>
                                    <% } %>
                                </td>
                                <td><small><%= opportunity.getCreatedAt() %></small></td>
                                <td>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/action/opportunity/delete" onsubmit="return confirmRemovalReason(this);">
                                        <input type="hidden" name="opportunityId" value="<%= opportunity.getOpportunityId() %>">
                                        <input type="hidden" name="reason" value="">
                                        <button class="btn btn-sm btn-outline-danger" type="submit">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        <% }
                        } else { %>
                            <tr><td colspan="9" class="text-center text-muted py-4">No opportunities found.</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function confirmRemovalReason(form) {
        var reason = window.prompt('Enter moderation reason for removal:');
        if (reason === null) {
            return false;
        }
        form.querySelector('input[name="reason"]').value = reason;
        return true;
    }
</script>
</body>
</html>
