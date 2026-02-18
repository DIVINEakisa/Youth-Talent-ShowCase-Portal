<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.youthtalent.model.Talent" %>
<%@ page import="com.youthtalent.model.Category" %>
<%@ page import="com.youthtalent.model.User" %>
<%@ page import="com.youthtalent.dao.TalentDAO" %>
<%@ page import="com.youthtalent.dao.CategoryDAO" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Talent - Youth Talent Showcase</title>
    
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
        
        .form-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            padding: 40px;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .btn-green {
            background-color: var(--primary-green);
            color: white;
            border: none;
            padding: 12px 30px;
        }
        
        .btn-green:hover {
            background-color: var(--dark-green);
            color: white;
        }
        
        .form-label {
            font-weight: 600;
            color: #333;
        }
        
        .required-field::after {
            content: " *";
            color: red;
        }
        
        .char-counter {
            font-size: 0.875rem;
            color: #6c757d;
            float: right;
        }
        
        .preview-box {
            border: 2px dashed var(--primary-green);
            border-radius: 10px;
            padding: 20px;
            background-color: var(--light-green);
            text-align: center;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    
    <% 
    User currentUser = (User) session.getAttribute("loggedInUser");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get talent ID from request
    String talentIdParam = request.getParameter("id");
    if (talentIdParam == null) {
        response.sendRedirect("my-talents.jsp");
        return;
    }
    
    int talentId = Integer.parseInt(talentIdParam);
    TalentDAO talentDAO = new TalentDAO();
    Talent talent = talentDAO.getTalentById(talentId);
    
    // Check if talent exists
    if (talent == null) {
    %>
        <div class="container mt-5">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i> Talent not found.
            </div>
            <a href="${pageContext.request.contextPath}/my-talents.jsp" class="btn btn-green">
                <i class="fas fa-arrow-left"></i> Back to My Talents
            </a>
        </div>
    <% 
        return;
    }
    
    // Check if user owns this talent
    if (talent.getUserId() != currentUser.getUserId() && !currentUser.isAdmin()) {
    %>
        <div class="container mt-5">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i> You do not have permission to edit this talent.
            </div>
            <a href="${pageContext.request.contextPath}/my-talents.jsp" class="btn btn-green">
                <i class="fas fa-arrow-left"></i> Back to My Talents
            </a>
        </div>
    <% 
        return;
    }
    %>
    
    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <h1 class="display-5">
                <i class="fas fa-edit"></i> Edit Talent
            </h1>
            <p class="lead mb-0">Update your talent information</p>
        </div>
    </div>
    
    <div class="container mb-5">
        <div class="form-card">
            <!-- Error/Success Messages -->
            <% 
            String error = request.getParameter("error");
            String success = request.getParameter("success");
            if (error != null) {
            %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle"></i> 
                <%= error.equals("validation") ? "Please fix the validation errors and try again." 
                   : error.equals("unauthorized") ? "You do not have permission to edit this talent." 
                   : "An error occurred. Please try again." %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            
            <% if (success != null && success.equals("true")) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle"></i> 
                Talent updated successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            
            <!-- Current Status Info -->
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i> <strong>Current Status:</strong> 
                <span class="badge bg-<%= "APPROVED".equals(talent.getStatus()) ? "success" : "PENDING".equals(talent.getStatus()) ? "warning" : "danger" %>">
                    <%= talent.getStatus() %>
                </span>
                <% if ("PENDING".equals(talent.getStatus())) { %>
                    <br><small>Your talent is under review. Major edits may reset the approval process.</small>
                <% } %>
            </div>
            
            <!-- Form -->
            <form action="${pageContext.request.contextPath}/talent/edit" method="post" id="editTalentForm" novalidate>
                <input type="hidden" name="talentId" value="<%= talent.getTalentId() %>">
                
                <!-- Title -->
                <div class="mb-4">
                    <label for="title" class="form-label required-field">Talent Title</label>
                    <input type="text" class="form-control form-control-lg" id="title" name="title" 
                           value="<%= talent.getTitle() %>"
                           required minlength="5" maxlength="200">
                    <span class="char-counter" id="titleCounter"><%= talent.getTitle().length() %>/200</span>
                    <div class="invalid-feedback">
                        Please provide a title between 5 and 200 characters.
                    </div>
                </div>
                
                <!-- Category -->
                <div class="mb-4">
                    <label for="categoryId" class="form-label required-field">Category</label>
                    <select class="form-select form-select-lg" id="categoryId" name="categoryId" required>
                        <option value="">Select a category...</option>
                        <% 
                        CategoryDAO categoryDAO = new CategoryDAO();
                        List<Category> categories = categoryDAO.getAllCategories();
                        
                        if (categories != null) {
                            for (Category cat : categories) {
                                String selected = (cat.getCategoryId() == talent.getCategoryId()) ? "selected" : "";
                        %>
                            <option value="<%= cat.getCategoryId() %>" <%= selected %>><%= cat.getCategoryName() %></option>
                        <% 
                            }
                        }
                        %>
                    </select>
                    <div class="invalid-feedback">
                        Please select a category.
                    </div>
                </div>
                
                <!-- Description -->
                <div class="mb-4">
                    <label for="description" class="form-label required-field">Description</label>
                    <textarea class="form-control" id="description" name="description" rows="6" 
                              required minlength="20" maxlength="2000"><%= talent.getDescription() %></textarea>
                    <span class="char-counter" id="descCounter"><%= talent.getDescription().length() %>/2000</span>
                    <div class="invalid-feedback">
                        Description must be between 20 and 2000 characters.
                    </div>
                </div>
                
                <!-- Image URL -->
                <div class="mb-4">
                    <label for="imageUrl" class="form-label">Image URL (Optional)</label>
                    <input type="url" class="form-control" id="imageUrl" name="imageUrl" 
                           value="<%= talent.getImageUrl() != null ? talent.getImageUrl() : "" %>">
                    <div class="invalid-feedback">
                        Please enter a valid URL.
                    </div>
                    
                    <!-- Current Image -->
                    <% if (talent.getImageUrl() != null && !talent.getImageUrl().isEmpty()) { %>
                    <div class="preview-box mt-2">
                        <p class="text-muted mb-2">Current Image:</p>
                        <img src="<%= talent.getImageUrl() %>" alt="Current" style="max-width: 100%; max-height: 200px; border-radius: 5px;">
                    </div>
                    <% } %>
                    
                    <!-- Image Preview -->
                    <div id="imagePreview" class="preview-box" style="display: none;">
                        <p class="text-muted mb-2">New Image Preview:</p>
                        <img id="previewImg" src="" alt="Preview" style="max-width: 100%; max-height: 200px; border-radius: 5px;">
                    </div>
                </div>
                
                <!-- Media URL -->
                <div class="mb-4">
                    <label for="mediaUrl" class="form-label">Media URL (Optional)</label>
                    <input type="url" class="form-control" id="mediaUrl" name="mediaUrl" 
                           value="<%= talent.getMediaUrl() != null ? talent.getMediaUrl() : "" %>">
                    <div class="invalid-feedback">
                        Please enter a valid URL.
                    </div>
                </div>
                
                <!-- Action Buttons -->
                <div class="d-flex justify-content-between">
                    <a href="${pageContext.request.contextPath}/my-talents.jsp" class="btn btn-outline-secondary btn-lg">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-green btn-lg">
                        <i class="fas fa-save"></i> Save Changes
                    </button>
                </div>
            </form>
            
            <!-- Delete Section -->
            <hr class="my-4">
            <div class="text-center">
                <h5 class="text-danger"><i class="fas fa-exclamation-triangle"></i> Danger Zone</h5>
                <p class="text-muted">Once you delete this talent, there is no going back.</p>
                <form action="${pageContext.request.contextPath}/talent/delete" method="post" 
                      onsubmit="return confirm('Are you absolutely sure? This action cannot be undone. All ratings and comments will also be deleted.');">
                    <input type="hidden" name="talentId" value="<%= talent.getTalentId() %>">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash"></i> Delete This Talent
                    </button>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Character counter for title
        const titleInput = document.getElementById('title');
        const titleCounter = document.getElementById('titleCounter');
        
        titleInput.addEventListener('input', function() {
            const length = this.value.length;
            titleCounter.textContent = length + '/200';
            titleCounter.style.color = length > 200 ? 'red' : '#6c757d';
        });
        
        // Character counter for description
        const descInput = document.getElementById('description');
        const descCounter = document.getElementById('descCounter');
        
        descInput.addEventListener('input', function() {
            const length = this.value.length;
            descCounter.textContent = length + '/2000';
            descCounter.style.color = length > 2000 ? 'red' : '#6c757d';
        });
        
        // Image preview for new URL
        const imageUrlInput = document.getElementById('imageUrl');
        const imagePreview = document.getElementById('imagePreview');
        const previewImg = document.getElementById('previewImg');
        
        imageUrlInput.addEventListener('input', function() {
            const url = this.value.trim();
            
            if (url && isValidUrl(url)) {
                previewImg.src = url;
                imagePreview.style.display = 'block';
                
                previewImg.onerror = function() {
                    imagePreview.style.display = 'none';
                };
            } else {
                imagePreview.style.display = 'none';
            }
        });
        
        function isValidUrl(string) {
            try {
                const url = new URL(string);
                return url.protocol === 'http:' || url.protocol === 'https:';
            } catch (_) {
                return false;
            }
        }
        
        // Form validation
        const form = document.getElementById('editTalentForm');
        
        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            
            form.classList.add('was-validated');
        });
        
        // Prevent multiple submissions
        form.addEventListener('submit', function() {
            const submitButton = form.querySelector('button[type="submit"]');
            submitButton.disabled = true;
            submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
        });
        
        // Warn about unsaved changes
        let formChanged = false;
        const formInputs = form.querySelectorAll('input, select, textarea');
        
        formInputs.forEach(input => {
            input.addEventListener('change', () => {
                formChanged = true;
            });
        });
        
        window.addEventListener('beforeunload', function(e) {
            if (formChanged) {
                e.preventDefault();
                e.returnValue = '';
            }
        });
        
        // Don't warn when form is submitted
        form.addEventListener('submit', () => {
            formChanged = false;
        });
    </script>
</body>
</html>
