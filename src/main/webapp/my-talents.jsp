<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.youthtalent.model.Talent" %>
<%@ page import="com.youthtalent.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Talents - Youth Talent Showcase</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --primary-green: #198754;
            --dark-green: #146c43;
            --light-green: #d1e7dd;
        }
        
        .page-header {
            background: linear-gradient(135deg, var(--primary-green), var(--dark-green));
            color: white;
            padding: 40px 0;
            margin-bottom: 30px;
        }
        
        .talent-table-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            padding: 25px;
        }
        
        .status-badge {
            font-size: 0.85rem;
            padding: 5px 12px;
        }
        
        .btn-green {
            background-color: var(--primary-green);
            color: white;
            border: none;
        }
        
        .btn-green:hover {
            background-color: var(--dark-green);
            color: white;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }
        
        .empty-state i {
            font-size: 5rem;
            color: #dee2e6;
            margin-bottom: 20px;
        }
        
        .stats-row {
            background: var(--light-green);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 25px;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: var(--primary-green);
        }
        
        .talent-thumbnail {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
            display: block;
        }
        
        .talent-thumbnail-placeholder {
            width: 60px;
            height: 60px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
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
    <% 
    @SuppressWarnings("unchecked")
    List<Talent> talents = (List<Talent>) request.getAttribute("talents");
    
    // Calculate statistics
    int totalTalents = 0;
    int approvedCount = 0;
    int pendingCount = 0;
    int rejectedCount = 0;
    
    if (talents != null) {
        totalTalents = talents.size();
        for (Talent talent : talents) {
            if ("APPROVED".equals(talent.getStatus())) {
                approvedCount++;
            } else if ("PENDING".equals(talent.getStatus())) {
                pendingCount++;
            } else if ("REJECTED".equals(talent.getStatus())) {
                rejectedCount++;
            }
        }
    }
    %>
    
    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <h1 class="display-5">
                <i class="fas fa-briefcase"></i> My Talents
            </h1>
            <p class="lead mb-0">Manage and track all your talent submissions</p>
        </div>
    </div>
    
    <div class="container">
        <!-- Statistics Row -->
        <div class="stats-row">
            <div class="row">
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number"><%= totalTalents %></div>
                        <div class="text-muted">Total Talents</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number text-success"><%= approvedCount %></div>
                        <div class="text-muted">Approved</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number text-warning"><%= pendingCount %></div>
                        <div class="text-muted">Pending</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number text-danger"><%= rejectedCount %></div>
                        <div class="text-muted">Rejected</div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Action Buttons -->
        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/add-talent.jsp" class="btn btn-green btn-lg">
                <i class="fas fa-plus"></i> Add New Talent
            </a>
            <a href="${pageContext.request.contextPath}/talent/list" class="btn btn-outline-success btn-lg ms-2">
                <i class="fas fa-search"></i> Explore All Talents
            </a>
        </div>
        
        <!-- Talents Table -->
        <div class="talent-table-card">
            <% if (talents != null && !talents.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th style="width: 80px;">Image</th>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Status</th>
                            <th>Rating</th>
                            <th>Views</th>
                            <th>Posted</th>
                            <th style="width: 200px;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Talent talent : talents) { %>
                        <tr>
                            <td>
                                <% if (talent.getImageUrl() != null && !talent.getImageUrl().isEmpty()) { %>
                                <img src="<%= talent.getImageUrl() %>" 
                                     alt="<%= talent.getTitle() %> thumbnail" 
                                     class="talent-thumbnail"
                                     loading="lazy"
                                     onerror="this.onerror=null; this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                <div class="talent-thumbnail-placeholder bg-success text-white" style="display: none;">
                                    <i class="fas fa-image"></i>
                                </div>
                                <% } else { %>
                                <div class="talent-thumbnail-placeholder bg-success text-white">
                                    <i class="fas fa-star"></i>
                                </div>
                                <% } %>
                            </td>
                            <td>
                                <strong><%= talent.getTitle() %></strong><br>
                                <small class="text-muted">
                                    <%= talent.getDescription() != null && talent.getDescription().length() > 50 
                                        ? talent.getDescription().substring(0, 50) + "..." 
                                        : talent.getDescription() %>
                                </small>
                            </td>
                            <td>
                                <span class="badge bg-secondary">
                                    <%= talent.getCategoryName() != null ? talent.getCategoryName() : "Uncategorized" %>
                                </span>
                            </td>
                            <td>
                                <% 
                                String statusClass = "secondary";
                                String statusIcon = "fa-clock";
                                if ("APPROVED".equals(talent.getStatus())) {
                                    statusClass = "success";
                                    statusIcon = "fa-check-circle";
                                } else if ("REJECTED".equals(talent.getStatus())) {
                                    statusClass = "danger";
                                    statusIcon = "fa-times-circle";
                                } else if ("PENDING".equals(talent.getStatus())) {
                                    statusClass = "warning";
                                    statusIcon = "fa-clock";
                                }
                                %>
                                <span class="badge bg-<%= statusClass %> status-badge">
                                    <i class="fas <%= statusIcon %>"></i> <%= talent.getStatus() %>
                                </span>
                            </td>
                            <td>
                                <i class="fas fa-star text-warning"></i> 
                                <%= String.format("%.1f", talent.getAverageRating()) %>
                                <small class="text-muted">(<%= talent.getTotalRatings() %>)</small>
                            </td>
                            <td>
                                <i class="fas fa-eye text-muted"></i> 
                                <%= talent.getViewsCount() %>
                            </td>
                            <td>
                                <small class="text-muted">
                                    <%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(talent.getCreatedAt()) %>
                                </small>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <% if ("APPROVED".equals(talent.getStatus())) { %>
                                    <a href="${pageContext.request.contextPath}/talent/view?id=<%= talent.getTalentId() %>" 
                                       class="btn btn-outline-info" title="View">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <% } %>
                                    
                                    <a href="${pageContext.request.contextPath}/edit-talent.jsp?id=<%= talent.getTalentId() %>" 
                                       class="btn btn-outline-success" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    
                                    <form action="${pageContext.request.contextPath}/talent/delete" method="post" 
                                          class="d-inline" onsubmit="return confirm('Are you sure you want to delete this talent? This action cannot be undone.');">
                                        <input type="hidden" name="talentId" value="<%= talent.getTalentId() %>">
                                        <button type="submit" class="btn btn-outline-danger" title="Delete">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <!-- Pagination -->
            <nav aria-label="Talents pagination" class="mt-3">
                <ul class="pagination justify-content-center">
                    <li class="page-item disabled">
                        <a class="page-link" href="#" tabindex="-1">Previous</a>
                    </li>
                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                    <li class="page-item">
                        <a class="page-link" href="#">Next</a>
                    </li>
                </ul>
            </nav>
            
            <% } else { %>
            <!-- Empty State -->
            <div class="empty-state">
                <i class="fas fa-folder-open"></i>
                <h3 class="text-muted">No Talents Yet</h3>
                <p class="text-muted">You haven't added any talents yet. Start showcasing your skills!</p>
                <a href="${pageContext.request.contextPath}/add-talent.jsp" class="btn btn-green btn-lg mt-3">
                    <i class="fas fa-plus"></i> Add Your First Talent
                </a>
            </div>
            <% } %>
        </div>
        
        <!-- Tips Section -->
        <div class="mt-5 mb-5">
            <div class="row">
                <div class="col-md-4">
                    <div class="card border-success h-100">
                        <div class="card-body text-center">
                            <i class="fas fa-lightbulb fa-3x text-success mb-3"></i>
                            <h5>Pro Tip</h5>
                            <p class="text-muted">Add detailed descriptions and high-quality images to increase engagement.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border-warning h-100">
                        <div class="card-body text-center">
                            <i class="fas fa-clock fa-3x text-warning mb-3"></i>
                            <h5>Pending Review</h5>
                            <p class="text-muted">Talents are reviewed by admins within 24-48 hours of submission.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border-info h-100">
                        <div class="card-body text-center">
                            <i class="fas fa-chart-line fa-3x text-info mb-3"></i>
                            <h5>Track Progress</h5>
                            <p class="text-muted">Monitor your ratings and comments to see how your talents perform.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <% 
    // Display success/error messages
    String message = (String) session.getAttribute("message");
    String messageType = (String) session.getAttribute("messageType");
    if (message != null) {
        session.removeAttribute("message");
        session.removeAttribute("messageType");
    %>
    <script>
        // Show toast notification
        const toastHTML = `
            <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
                <div class="toast show align-items-center text-white bg-<%= messageType != null ? messageType : "success" %> border-0" role="alert">
                    <div class="d-flex">
                        <div class="toast-body">
                            <i class="fas fa-<%= "error".equals(messageType) ? "exclamation-circle" : "check-circle" %>"></i>
                            <%= message %>
                        </div>
                        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                    </div>
                </div>
            </div>
        `;
        document.body.insertAdjacentHTML('beforeend', toastHTML);
        
        // Auto-hide after 5 seconds
        setTimeout(() => {
            const toastEl = document.querySelector('.toast');
            if (toastEl) {
                const toast = new bootstrap.Toast(toastEl);
                toast.hide();
            }
        }, 5000);
    </script>
    <% } %>
</body>
</html>
