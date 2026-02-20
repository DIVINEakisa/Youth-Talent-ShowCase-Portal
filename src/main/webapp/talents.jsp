<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.youthtalent.model.Talent" %>
<%@ page import="com.youthtalent.model.Category" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Explore Talents - Youth Talent Showcase</title>
    
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
        
        body {
            background-color: #f8f9fa;
        }
        
        .talent-card {
            transition: transform 0.3s, box-shadow 0.3s;
            height: 100%;
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 12px;
            overflow: hidden;
        }
        
        .talent-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 16px rgba(25, 135, 84, 0.3);
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
            background: linear-gradient(135deg, var(--light-green), var(--primary-green));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
        }
        
        .category-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: var(--primary-green);
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        
        .rating-stars {
            color: #ffc107;
        }
        
        .search-section {
            background: linear-gradient(135deg, var(--primary-green), var(--dark-green));
            padding: 60px 0;
            margin-bottom: 40px;
            color: white;
        }
        
        .filter-section {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
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
        
        .no-talents {
            text-align: center;
            padding: 60px 20px;
        }
        
        .no-talents i {
            font-size: 5rem;
            color: #dee2e6;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <% 
    User user = (User) session.getAttribute("user");
    // User can be null for talents page (public page)
    %>
    <%@ include file="includes/navbar.jsp" %>
    
    <!-- Search Header Section -->
    <div class="search-section">
        <div class="container">
            <h1 class="text-center mb-4">
                <i class="fas fa-star"></i> Explore Amazing Talents
            </h1>
            <p class="text-center lead mb-4">
                Discover incredible talents from young creators around the world
            </p>
            
            <!-- Search Form -->
            <form action="${pageContext.request.contextPath}/talent/search" method="get" class="row g-3 justify-content-center">
                <div class="col-md-6">
                    <div class="input-group input-group-lg">
                        <input type="text" class="form-control" name="keyword" 
                               placeholder="Search talents by title or description..." 
                               value="${param.keyword}">
                        <button class="btn btn-light" type="submit">
                            <i class="fas fa-search"></i> Search
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    
    <div class="container">
        <!-- Filter Section -->
        <div class="filter-section">
            <form action="${pageContext.request.contextPath}/talent/list" method="get" id="filterForm">
                <div class="row align-items-end">
                    <div class="col-md-4">
                        <label class="form-label fw-bold">
                            <i class="fas fa-folder"></i> Category
                        </label>
                        <select class="form-select" name="categoryId" id="categoryFilter">
                            <option value="">All Categories</option>
                            <% 
                            List<Category> categories = (List<Category>) request.getAttribute("categories");
                            if (categories != null) {
                                String selectedCategory = request.getParameter("categoryId");
                                for (Category cat : categories) {
                                    String selected = (selectedCategory != null && selectedCategory.equals(String.valueOf(cat.getCategoryId()))) ? "selected" : "";
                            %>
                                <option value="<%= cat.getCategoryId() %>" <%= selected %>>
                                    <%= cat.getCategoryName() %>
                                </option>
                            <% 
                                }
                            }
                            %>
                        </select>
                    </div>
                    
                    <div class="col-md-4">
                        <label class="form-label fw-bold">
                            <i class="fas fa-sort"></i> Sort By
                        </label>
                        <select class="form-select" name="sortBy" id="sortFilter">
                            <option value="recent" ${param.sortBy == 'recent' ? 'selected' : ''}>Most Recent</option>
                            <option value="rating" ${param.sortBy == 'rating' ? 'selected' : ''}>Highest Rated</option>
                            <option value="popular" ${param.sortBy == 'popular' ? 'selected' : ''}>Most Popular</option>
                        </select>
                    </div>
                    
                    <div class="col-md-4">
                        <button type="submit" class="btn btn-green w-100">
                            <i class="fas fa-filter"></i> Apply Filters
                        </button>
                    </div>
                </div>
            </form>
            
            <!-- Active Filters Display -->
            <% if (request.getParameter("categoryId") != null || request.getParameter("sortBy") != null || request.getParameter("keyword") != null) { %>
            <div class="mt-3">
                <span class="text-muted">Active Filters:</span>
                <% if (request.getParameter("keyword") != null && !request.getParameter("keyword").isEmpty()) { %>
                    <span class="badge bg-success ms-2">
                        <i class="fas fa-search"></i> "<%= request.getParameter("keyword") %>"
                    </span>
                <% } %>
                <% if (request.getParameter("categoryId") != null && !request.getParameter("categoryId").isEmpty()) { %>
                    <span class="badge bg-success ms-2">
                        <i class="fas fa-folder"></i> Category Filter
                    </span>
                <% } %>
                <a href="${pageContext.request.contextPath}/talent/list" class="btn btn-sm btn-outline-secondary ms-2">
                    <i class="fas fa-times"></i> Clear All
                </a>
            </div>
            <% } %>
        </div>
        
        <!-- Talents Grid -->
        <div class="row">
            <% 
            List<Talent> talents = (List<Talent>) request.getAttribute("talents");
            if (talents != null && !talents.isEmpty()) {
                for (Talent talent : talents) {
            %>
            <div class="col-md-4 mb-4">
                <div class="card talent-card">
                    <div class="position-relative">
                        <% if (talent.getImageUrl() != null && !talent.getImageUrl().isEmpty()) { %>
                            <img src="<%= talent.getImageUrl() %>" 
                                 class="talent-image" 
                                 alt="<%= talent.getTitle() %> - a <%= talent.getCategoryName() != null ? talent.getCategoryName() : "talent" %> showcase by <%= talent.getUsername() != null ? talent.getUsername() : "anonymous" %>"
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
                        <span class="category-badge"><%= talent.getCategoryName() != null ? talent.getCategoryName() : "Uncategorized" %></span>
                    </div>
                    
                    <div class="card-body">
                        <h5 class="card-title">
                            <a href="${pageContext.request.contextPath}/talent/view?id=<%= talent.getTalentId() %>" 
                               class="text-decoration-none text-dark">
                                <%= talent.getTitle() %>
                            </a>
                        </h5>
                        
                        <p class="card-text text-muted">
                            <%= talent.getDescription() != null && talent.getDescription().length() > 100 
                                ? talent.getDescription().substring(0, 100) + "..." 
                                : talent.getDescription() %>
                        </p>
                        
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <div class="rating-stars">
                                <% 
                                double rating = talent.getAverageRating();
                                int fullStars = (int) rating;
                                boolean hasHalfStar = (rating - fullStars) >= 0.5;
                                
                                for (int i = 0; i < fullStars; i++) { %>
                                    <i class="fas fa-star"></i>
                                <% } 
                                if (hasHalfStar) { %>
                                    <i class="fas fa-star-half-alt"></i>
                                <% }
                                for (int i = fullStars + (hasHalfStar ? 1 : 0); i < 5; i++) { %>
                                    <i class="far fa-star"></i>
                                <% } %>
                                <span class="text-muted ms-1">
                                    <%= String.format("%.1f", rating) %> (<%= talent.getTotalRatings() %>)
                                </span>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-between align-items-center text-muted small">
                            <span>
                                <i class="fas fa-user"></i> <%= talent.getUsername() != null ? talent.getUsername() : "Anonymous" %>
                            </span>
                            <span>
                                <i class="fas fa-calendar"></i> 
                                <%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(talent.getCreatedAt()) %>
                            </span>
                        </div>
                        
                        <a href="${pageContext.request.contextPath}/talent/view?id=<%= talent.getTalentId() %>" 
                           class="btn btn-green w-100 mt-3">
                            <i class="fas fa-eye"></i> View Details
                        </a>
                    </div>
                </div>
            </div>
            <% 
                }
            } else {
            %>
            <div class="col-12">
                <div class="no-talents">
                    <i class="fas fa-search"></i>
                    <h3 class="text-muted">No Talents Found</h3>
                    <p class="text-muted">
                        <% if (request.getParameter("keyword") != null) { %>
                            No talents match your search criteria. Try different keywords.
                        <% } else { %>
                            Be the first to showcase your talent!
                        <% } %>
                    </p>
                    <a href="${pageContext.request.contextPath}/add-talent.jsp" class="btn btn-green btn-lg mt-3">
                        <i class="fas fa-plus"></i> Add Your Talent
                    </a>
                </div>
            </div>
            <% } %>
        </div>
        
        <!-- Pagination (if needed) -->
        <% if (talents != null && talents.size() > 0) { %>
        <nav aria-label="Page navigation" class="mt-4 mb-5">
            <ul class="pagination justify-content-center">
                <li class="page-item disabled">
                    <a class="page-link" href="#" tabindex="-1">Previous</a>
                </li>
                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                <li class="page-item"><a class="page-link" href="#">2</a></li>
                <li class="page-item"><a class="page-link" href="#">3</a></li>
                <li class="page-item">
                    <a class="page-link" href="#">Next</a>
                </li>
            </ul>
        </nav>
        <% } %>
    </div>
    
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Auto-submit filter form on change
        document.getElementById('categoryFilter').addEventListener('change', function() {
            document.getElementById('filterForm').submit();
        });
        
        document.getElementById('sortFilter').addEventListener('change', function() {
            document.getElementById('filterForm').submit();
        });
    </script>
</body>
</html>
