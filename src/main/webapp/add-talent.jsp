<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.youthtalent.model.Category" %>
<%@ page import="com.youthtalent.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Talent - Youth Talent Showcase</title>
    
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
        
        .help-text {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 5px;
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
    <% 
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }
    %>
    <%@ include file="includes/navbar.jsp" %>
    
    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <h1 class="display-5">
                <i class="fas fa-plus-circle"></i> Add New Talent
            </h1>
            <p class="lead mb-0">Showcase your amazing skills and creativity</p>
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
                   : error.equals("upload") ? "Error uploading media. Please try again." 
                   : "An error occurred. Please try again." %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            
            <% if (success != null && success.equals("true")) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle"></i> 
                Talent submitted successfully! It will be reviewed by our admin team.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            
            <!-- Form -->
            <form action="${pageContext.request.contextPath}/talent/add" method="post" id="addTalentForm" novalidate>
                <!-- Title -->
                <div class="mb-4">
                    <label for="title" class="form-label required-field">Talent Title</label>
                    <input type="text" class="form-control form-control-lg" id="title" name="title" 
                           placeholder="Enter a catchy title for your talent" 
                           required minlength="5" maxlength="200">
                    <span class="char-counter" id="titleCounter">0/200</span>
                    <div class="help-text">
                        <i class="fas fa-info-circle"></i> Choose a clear, descriptive title (5-200 characters)
                    </div>
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
                        // Fetch categories from database
                        com.youthtalent.dao.CategoryDAO categoryDAO = new com.youthtalent.dao.CategoryDAO();
                        List<Category> categories = categoryDAO.getAllCategories();
                        
                        if (categories != null) {
                            for (Category cat : categories) {
                        %>
                            <option value="<%= cat.getCategoryId() %>"><%= cat.getCategoryName() %></option>
                        <% 
                            }
                        }
                        %>
                    </select>
                    <div class="help-text">
                        <i class="fas fa-info-circle"></i> Select the category that best describes your talent
                    </div>
                    <div class="invalid-feedback">
                        Please select a category.
                    </div>
                </div>
                
                <!-- Description -->
                <div class="mb-4">
                    <label for="description" class="form-label required-field">Description</label>
                    <textarea class="form-control" id="description" name="description" rows="6" 
                              placeholder="Describe your talent in detail. What makes it special? What inspired you?" 
                              required minlength="20" maxlength="2000"></textarea>
                    <span class="char-counter" id="descCounter">0/2000</span>
                    <div class="help-text">
                        <i class="fas fa-info-circle"></i> Provide a detailed description (20-2000 characters)
                    </div>
                    <div class="invalid-feedback">
                        Description must be between 20 and 2000 characters.
                    </div>
                </div>
                
                <!-- Image URL -->
                <div class="mb-4">
                    <label for="imageUrl" class="form-label">Image URL (Optional)</label>
                    <input type="url" class="form-control" id="imageUrl" name="imageUrl" 
                           placeholder="https://example.com/image.jpg">
                    <div class="help-text">
                        <i class="fas fa-info-circle"></i> Paste a direct link to an image representing your talent
                    </div>
                    <div class="invalid-feedback">
                        Please enter a valid URL (e.g., https://example.com/image.jpg).
                    </div>
                    
                    <!-- Image Preview -->
                    <div id="imagePreview" class="preview-box" style="display: none;">
                        <img id="previewImg" src="" alt="Preview" style="max-width: 100%; max-height: 300px; border-radius: 5px;">
                    </div>
                </div>
                
                <!-- Media URL -->
                <div class="mb-4">
                    <label for="mediaUrl" class="form-label">Media URL (Optional)</label>
                    <input type="url" class="form-control" id="mediaUrl" name="mediaUrl" 
                           placeholder="https://youtube.com/watch?v=... or https://example.com/demo.mp3">
                    <div class="help-text">
                        <i class="fas fa-info-circle"></i> Add a link to YouTube video, audio file, or demo (optional)
                    </div>
                    <div class="invalid-feedback">
                        Please enter a valid URL.
                    </div>
                </div>
                
                <!-- Terms Agreement -->
                <div class="mb-4">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="termsAgree" required>
                        <label class="form-check-label" for="termsAgree">
                            I confirm that this content is my original work and does not violate any copyrights or community guidelines. <span class="text-danger">*</span>
                        </label>
                        <div class="invalid-feedback">
                            You must agree before submitting.
                        </div>
                    </div>
                </div>
                
                <!-- Info Box -->
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i> <strong>Note:</strong> 
                    Your talent will be submitted for admin review and approval before becoming publicly visible.
                </div>
                
                <!-- Action Buttons -->
                <div class="d-flex justify-content-between">
                    <a href="${pageContext.request.contextPath}/my-talents.jsp" class="btn btn-outline-secondary btn-lg">
                        <i class="fas fa-arrow-left"></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-green btn-lg">
                        <i class="fas fa-paper-plane"></i> Submit Talent
                    </button>
                </div>
            </form>
        </div>
        
        <!-- Tips Section -->
        <div class="mt-5">
            <div class="row">
                <div class="col-md-12">
                    <div class="card border-success">
                        <div class="card-header bg-success text-white">
                            <i class="fas fa-lightbulb"></i> <strong>Tips for Success</strong>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-4">
                                    <h6><i class="fas fa-pencil-alt text-success"></i> Clear Title</h6>
                                    <p class="small text-muted">Use a descriptive title that clearly explains what your talent is about.</p>
                                </div>
                                <div class="col-md-4">
                                    <h6><i class="fas fa-image text-success"></i> Quality Media</h6>
                                    <p class="small text-muted">High-quality images and media increase engagement and ratings.</p>
                                </div>
                                <div class="col-md-4">
                                    <h6><i class="fas fa-align-left text-success"></i> Detailed Description</h6>
                                    <p class="small text-muted">Explain your process, inspiration, and what makes your talent unique.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
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
            
            if (length > 200) {
                titleCounter.style.color = 'red';
            } else {
                titleCounter.style.color = '#6c757d';
            }
        });
        
        // Character counter for description
        const descInput = document.getElementById('description');
        const descCounter = document.getElementById('descCounter');
        
        descInput.addEventListener('input', function() {
            const length = this.value.length;
            descCounter.textContent = length + '/2000';
            
            if (length > 2000) {
                descCounter.style.color = 'red';
            } else {
                descCounter.style.color = '#6c757d';
            }
        });
        
        // Image preview
        const imageUrlInput = document.getElementById('imageUrl');
        const imagePreview = document.getElementById('imagePreview');
        const previewImg = document.getElementById('previewImg');
        
        imageUrlInput.addEventListener('input', function() {
            const url = this.value.trim();
            
            if (url && isValidUrl(url)) {
                previewImg.src = url;
                imagePreview.style.display = 'block';
                
                // Handle image load error
                previewImg.onerror = function() {
                    imagePreview.style.display = 'none';
                };
            } else {
                imagePreview.style.display = 'none';
            }
        });
        
        // URL validation
        function isValidUrl(string) {
            try {
                const url = new URL(string);
                return url.protocol === 'http:' || url.protocol === 'https:';
            } catch (_) {
                return false;
            }
        }
        
        // Form validation (Bootstrap 5)
        const form = document.getElementById('addTalentForm');
        
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
            submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Submitting...';
        });
    </script>
</body>
</html>
