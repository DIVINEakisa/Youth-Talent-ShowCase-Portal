<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.youthtalent.model.User" %>
<%@ page import="com.youthtalent.model.Report" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }

    List<Report> reports = (List<Report>) request.getAttribute("reports");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - Youth Talent Showcase</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-green: #198754; }
        .sidebar { background-color: #212529; min-height: 100vh; color: white; }
        .sidebar a { color: #adb5bd; text-decoration: none; padding: 15px 20px; display: block; transition: all 0.3s; }
        .sidebar a:hover, .sidebar a.active { background-color: var(--primary-green); color: white; }
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
            <a href="${pageContext.request.contextPath}/admin/action/users">
                <i class="fas fa-users me-2"></i>Users
            </a>
            <a href="${pageContext.request.contextPath}/admin/action/reports" class="active">
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
                <h2><i class="fas fa-flag me-2"></i>Reports Management</h2>
                <p class="text-muted">Review and manage user reports</p>
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

            <!-- Filter -->
            <div class="card mb-4">
                <div class="card-body">
                    <form method="get" action="${pageContext.request.contextPath}/admin/action/reports">
                        <div class="row">
                            <div class="col-md-4">
                                <label class="form-label">Filter by Status</label>
                                <select name="status" class="form-select" onchange="this.form.submit()">
                                    <option value="">All Statuses</option>
                                    <option value="PENDING">Pending</option>
                                    <option value="REVIEWED">Reviewed</option>
                                    <option value="RESOLVED">Resolved</option>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Reports List -->
            <% if (reports != null && !reports.isEmpty()) { %>
                <% for (Report report : reports) { %>
                    <div class="card mb-3">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <h5 class="card-title mb-1">
                                        Report #<%= report.getReportId() %>
                                        <span class="badge bg-info"><%= report.getReportedItemType() %></span>
                                    </h5>
                                    <p class="text-muted mb-0">
                                        <small>
                                            <i class="fas fa-user me-1"></i>Reported by: <%= report.getReporterUsername() %>
                                            <i class="fas fa-calendar ms-3 me-1"></i><%= report.getCreatedAt() %>
                                        </small>
                                    </p>
                                </div>
                                <div>
                                    <% if ("PENDING".equals(report.getStatus())) { %>
                                        <span class="badge bg-warning text-dark">Pending</span>
                                    <% } else if ("REVIEWED".equals(report.getStatus())) { %>
                                        <span class="badge bg-info">Reviewed</span>
                                    <% } else if ("RESOLVED".equals(report.getStatus())) { %>
                                        <span class="badge bg-success">Resolved</span>
                                    <% } %>
                                </div>
                            </div>

                            <div class="mb-3">
                                <strong>Content ID:</strong> <%= report.getReportedItemId() %>
                                <span class="ms-3"><strong>Content Type:</strong> <%= report.getReportedItemType() %></span>
                            </div>

                            <div class="mb-3">
                                <strong>Reason:</strong>
                                <p class="mb-0"><%= report.getReportReason() %></p>
                            </div>

                            <% if (report.getReviewedBy() != null) { %>
                                <div class="alert alert-light mb-2">
                                    <strong>Admin Notes:</strong>
                                    <p class="mb-0"><%= report.getAdminNotes() != null ? report.getAdminNotes() : "No notes" %></p>
                                    <small class="text-muted">Reviewed at: <%= report.getUpdatedAt() %></small>
                                </div>
                            <% } %>

                            <% if ("PENDING".equals(report.getStatus())) { %>
                                <div class="d-flex justify-content-end">
                                    <button type="button" class="btn btn-success btn-sm me-2"
                                            data-bs-toggle="modal"
                                            data-bs-target="#reviewModal<%= report.getReportId() %>">
                                        <i class="fas fa-check me-1"></i>Review
                                    </button>
                                </div>
                            <% } %>
                        </div>
                    </div>

                    <!-- Review Modal -->
                    <div class="modal fade" id="reviewModal<%= report.getReportId() %>" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Review Report #<%= report.getReportId() %></h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <form method="post" action="${pageContext.request.contextPath}/admin/action/report/review">
                                    <div class="modal-body">
                                        <input type="hidden" name="reportId" value="<%= report.getReportId() %>">
                                        <div class="mb-3">
                                            <label class="form-label">Status</label>
                                            <select class="form-select" name="status" required>
                                                <option value="">Select Status</option>
                                                <option value="REVIEWED">Reviewed</option>
                                                <option value="RESOLVED">Resolved</option>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Admin Notes</label>
                                            <textarea class="form-control" name="adminNotes" rows="4"
                                                      placeholder="Add your notes about this report..." required></textarea>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                        <button type="submit" class="btn btn-success">Submit Review</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="alert alert-info text-center py-5">
                    <i class="fas fa-info-circle fa-3x mb-3"></i>
                    <h4>No Reports</h4>
                    <p class="mb-0">There are no reports to review at the moment.</p>
                </div>
            <% } %>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
