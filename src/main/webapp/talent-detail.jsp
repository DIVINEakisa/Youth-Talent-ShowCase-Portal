<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.youthtalent.model.Talent" %>
<%@ page import="com.youthtalent.model.Rating" %>
<%@ page import="com.youthtalent.model.Comment" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("talent") != null ? ((Talent) request.getAttribute("talent")).getTitle() : "Talent Details" %> - Youth Talent Showcase</title>
    
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
        
        .talent-header {
            background: linear-gradient(135deg, var(--primary-green), var(--dark-green));
            color: white;
            padding: 40px 0;
            margin-bottom: 30px;
        }
        
        .talent-image {
            width: 100%;
            max-height: 500px;
            object-fit: cover;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            display: block;
        }
        
        .talent-image-placeholder {
            width: 100%;
            height: 400px;
            background: linear-gradient(135deg, var(--light-green), var(--primary-green));
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .rating-section {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .rating-stars-interactive {
            font-size: 2rem;
            color: #ddd;
            cursor: pointer;
        }
        
        .rating-stars-interactive .fa-star {
            transition: color 0.2s;
        }
        
        .rating-stars-interactive .fa-star:hover,
        .rating-stars-interactive .fa-star.filled {
            color: #ffc107;
        }
        
        .comment-section {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .comment-item {
            border-bottom: 1px solid #dee2e6;
            padding: 20px 0;
        }
        
        .comment-item:last-child {
            border-bottom: none;
        }
        
        .comment-author {
            font-weight: 600;
            color: var(--primary-green);
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
        
        .media-player {
            width: 100%;
            border-radius: 10px;
            margin-top: 20px;
        }
        
        .stats-card {
            background: linear-gradient(135deg, var(--light-green), white);
            border-left: 4px solid var(--primary-green);
            padding: 20px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <% 
    User user = (User) session.getAttribute("user");
    // User can be null for detail page (public page)
    %>
    <%@ include file="includes/navbar.jsp" %>
    
    <% 
    Talent talent = (Talent) request.getAttribute("talent");
    List<Comment> comments = (List<Comment>) request.getAttribute("comments");
    Double userRating = (Double) request.getAttribute("userRating");
    Boolean canRate = (Boolean) request.getAttribute("canRate");
    
    if (talent == null) {
    %>
        <div class="container mt-5">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i> Talent not found or access denied.
            </div>
            <a href="${pageContext.request.contextPath}/talent/list" class="btn btn-green">
                <i class="fas fa-arrow-left"></i> Back to Talents
            </a>
        </div>
    <% 
        return;
    }
    %>
    
    <!-- Talent Header -->
    <div class="talent-header">
        <div class="container">
            <div class="row">
                <div class="col-md-8">
                    <h1 class="display-4"><%= talent.getTitle() %></h1>
                    <p class="lead">
                        <span class="badge bg-light text-dark">
                            <i class="fas fa-folder"></i> <%= talent.getCategoryName() %>
                        </span>
                        <span class="badge bg-light text-dark ms-2">
                            <i class="fas fa-user"></i> By <%= talent.getUsername() %>
                        </span>
                    </p>
                </div>
                <div class="col-md-4 text-md-end">
                    <div class="stats-card bg-white text-dark">
                        <div class="row text-center">
                            <div class="col-6">
                                <h3><%= String.format("%.1f", talent.getAverageRating()) %></h3>
                                <small>Rating</small>
                            </div>
                            <div class="col-6">
                                <h3><%= talent.getTotalRatings() %></h3>
                                <small>Ratings</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="row">
            <!-- Main Content -->
            <div class="col-lg-8">
                <!-- Talent Image/Media -->
                <% if (talent.getImageUrl() != null && !talent.getImageUrl().isEmpty()) { %>
                <img src="<%= talent.getImageUrl() %>" 
                     alt="<%= talent.getTitle() %> - <%= talent.getCategoryName() != null ? talent.getCategoryName() : "talent" %> showcase" 
                     class="talent-image"
                     loading="eager"
                     onerror="this.onerror=null; this.style.display='none'; this.nextElementSibling.style.display='flex';">
                <div class="talent-image-placeholder" style="display: none;">
                    <i class="fas fa-image" style="font-size: 5rem; color: white;"></i>
                </div>
                <% } else { %>
                <div class="talent-image-placeholder">
                    <i class="fas fa-star" style="font-size: 5rem; color: white;"></i>
                </div>
                <% } %>
                
                <!-- Media Player -->
                <% if (talent.getMediaUrl() != null && !talent.getMediaUrl().isEmpty()) { %>
                <div class="mt-3">
                    <h5><i class="fas fa-play-circle"></i> Media</h5>
                    <% if (talent.getMediaUrl().contains("youtube.com") || talent.getMediaUrl().contains("youtu.be")) { %>
                        <!-- YouTube Embed -->
                        <iframe class="media-player" height="400" 
                                src="<%= talent.getMediaUrl().replace("watch?v=", "embed/") %>" 
                                frameborder="0" allowfullscreen></iframe>
                    <% } else { %>
                        <a href="<%= talent.getMediaUrl() %>" target="_blank" class="btn btn-green">
                            <i class="fas fa-external-link-alt"></i> View Media
                        </a>
                    <% } %>
                </div>
                <% } %>
                
                <!-- Description -->
                <div class="mt-4">
                    <h3><i class="fas fa-info-circle"></i> Description</h3>
                    <p class="lead"><%= talent.getDescription() %></p>
                </div>
                
                <!-- Comments Section -->
                <div class="comment-section mt-4">
                    <h3><i class="fas fa-comments"></i> Comments (<%= comments != null ? comments.size() : 0 %>)</h3>
                    
                    <!-- Add Comment Form -->
                    <% if (session.getAttribute("loggedInUser") != null) { %>
                    <form action="${pageContext.request.contextPath}/comment/add" method="post" class="mt-3">
                        <input type="hidden" name="talentId" value="<%= talent.getTalentId() %>">
                        <div class="mb-3">
                            <textarea class="form-control" name="commentText" rows="3" 
                                      placeholder="Share your thoughts..." required maxlength="1000"></textarea>
                        </div>
                        <button type="submit" class="btn btn-green">
                            <i class="fas fa-paper-plane"></i> Post Comment
                        </button>
                    </form>
                    <% } else { %>
                    <div class="alert alert-info mt-3">
                        <i class="fas fa-info-circle"></i> 
                        <a href="${pageContext.request.contextPath}/login.jsp">Login</a> to post a comment.
                    </div>
                    <% } %>
                    
                    <hr class="my-4">
                    
                    <!-- Comments List -->
                    <% if (comments != null && !comments.isEmpty()) { %>
                        <% for (Comment comment : comments) { %>
                        <div class="comment-item">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <span class="comment-author">
                                        <i class="fas fa-user-circle"></i> <%= comment.getUsername() %>
                                    </span>
                                    <small class="text-muted ms-2">
                                        <i class="fas fa-clock"></i> 
                                        <%= new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(comment.getCreatedAt()) %>
                                    </small>
                                </div>
                                <% 
                                if (user != null) {
                                    if (user.getUserId() == comment.getUserId() || user.isAdmin()) {
                                %>
                                <form action="${pageContext.request.contextPath}/comment/delete" method="post" 
                                      onsubmit="return confirm('Delete this comment?');" class="d-inline">
                                    <input type="hidden" name="commentId" value="<%= comment.getCommentId() %>">
                                    <input type="hidden" name="talentId" value="<%= talent.getTalentId() %>">
                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </form>
                                <% 
                                    }
                                }
                                %>
                            </div>
                            <p class="mt-2 mb-0"><%= comment.getCommentText() %></p>
                        </div>
                        <% } %>
                    <% } else { %>
                        <p class="text-muted text-center py-4">
                            <i class="fas fa-comment-slash"></i> No comments yet. Be the first to comment!
                        </p>
                    <% } %>
                </div>
            </div>
            
            <!-- Sidebar -->
            <div class="col-lg-4">
                <!-- Rating Section -->
                <div class="rating-section">
                    <h4 class="mb-3"><i class="fas fa-star"></i> Rate This Talent</h4>
                    
                    <% if (canRate != null && canRate) { %>
                    <div class="text-center mb-3">
                        <div class="rating-stars-interactive" id="ratingStars">
                            <i class="far fa-star" data-value="1"></i>
                            <i class="far fa-star" data-value="2"></i>
                            <i class="far fa-star" data-value="3"></i>
                            <i class="far fa-star" data-value="4"></i>
                            <i class="far fa-star" data-value="5"></i>
                        </div>
                        <p class="text-muted mt-2" id="ratingText">Click to rate</p>
                    </div>
                    
                    <form id="ratingForm" action="${pageContext.request.contextPath}/rating/add" method="post">
                        <input type="hidden" name="talentId" value="<%= talent.getTalentId() %>">
                        <input type="hidden" name="ratingValue" id="ratingValue" value="">
                        <button type="submit" class="btn btn-green w-100" id="submitRating" disabled>
                            <i class="fas fa-check"></i> Submit Rating
                        </button>
                    </form>
                    
                    <% if (userRating != null && userRating > 0) { %>
                    <div class="alert alert-success mt-3">
                        <i class="fas fa-info-circle"></i> You rated this: <%= String.format("%.0f", userRating) %> stars
                    </div>
                    <% } %>
                    
                    <% } else if (session.getAttribute("loggedInUser") == null) { %>
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i> 
                        <a href="${pageContext.request.contextPath}/login.jsp">Login</a> to rate this talent.
                    </div>
                    <% } else { %>
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle"></i> You cannot rate your own talent.
                    </div>
                    <% } %>
                    
                    <!-- Current Rating Display -->
                    <hr>
                    <h5 class="text-center">Current Rating</h5>
                    <h2 class="text-center text-warning">
                        <%= String.format("%.1f", talent.getAverageRating()) %> / 5.0
                    </h2>
                    <p class="text-center text-muted">
                        Based on <%= talent.getTotalRatings() %> <%= talent.getTotalRatings() == 1 ? "rating" : "ratings" %>
                    </p>
                </div>
                
                <!-- Talent Info -->
                <div class="rating-section">
                    <h5><i class="fas fa-info-circle"></i> Talent Information</h5>
                    <ul class="list-unstyled mt-3">
                        <li class="mb-2">
                            <strong><i class="fas fa-user"></i> Creator:</strong> <%= talent.getUsername() %>
                        </li>
                        <li class="mb-2">
                            <strong><i class="fas fa-folder"></i> Category:</strong> <%= talent.getCategoryName() %>
                        </li>
                        <li class="mb-2">
                            <strong><i class="fas fa-calendar"></i> Posted:</strong> 
                            <%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(talent.getCreatedAt()) %>
                        </li>
                        <li class="mb-2">
                            <strong><i class="fas fa-check-circle"></i> Status:</strong> 
                            <span class="badge bg-success">Approved</span>
                        </li>
                    </ul>
                </div>
                
                <!-- Action Buttons -->
                <% 
                if (user != null && user.getUserId() == talent.getUserId()) {
                %>
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/edit-talent.jsp?id=<%= talent.getTalentId() %>" 
                       class="btn btn-outline-success">
                        <i class="fas fa-edit"></i> Edit Talent
                    </a>
                </div>
                <% 
                    }
                }
                %>
                
                <!-- Report Abuse -->
                <div class="mt-3">
                    <button class="btn btn-outline-danger btn-sm w-100" data-bs-toggle="modal" data-bs-target="#reportModal">
                        <i class="fas fa-flag"></i> Report Abuse
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Report Modal -->
    <div class="modal fade" id="reportModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-flag"></i> Report Content</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/report/add" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="contentType" value="TALENT">
                        <input type="hidden" name="contentId" value="<%= talent.getTalentId() %>">
                        
                        <div class="mb-3">
                            <label class="form-label">Reason</label>
                            <select class="form-select" name="reason" required>
                                <option value="">Select reason...</option>
                                <option value="INAPPROPRIATE">Inappropriate Content</option>
                                <option value="SPAM">Spam</option>
                                <option value="MISLEADING">Misleading Information</option>
                                <option value="COPYRIGHT">Copyright Violation</option>
                                <option value="OTHER">Other</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Additional Details (Optional)</label>
                            <textarea class="form-control" name="details" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Submit Report</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Interactive rating stars
        const stars = document.querySelectorAll('#ratingStars i');
        const ratingValue = document.getElementById('ratingValue');
        const ratingText = document.getElementById('ratingText');
        const submitButton = document.getElementById('submitRating');
        
        <% if (userRating != null && userRating > 0) { %>
        // Pre-fill user's existing rating
        const existingRating = <%= userRating %>;
        stars.forEach((star, index) => {
            if (index < existingRating) {
                star.classList.remove('far');
                star.classList.add('fas', 'filled');
            }
        });
        <% } %>
        
        stars.forEach(star => {
            star.addEventListener('mouseenter', function() {
                const value = this.getAttribute('data-value');
                highlightStars(value);
                ratingText.textContent = value + ' stars';
            });
            
            star.addEventListener('click', function() {
                const value = this.getAttribute('data-value');
                ratingValue.value = value;
                submitButton.disabled = false;
                submitButton.classList.add('pulse');
                ratingText.textContent = 'You selected ' + value + ' stars';
            });
        });
        
        document.getElementById('ratingStars').addEventListener('mouseleave', function() {
            if (ratingValue.value) {
                highlightStars(ratingValue.value);
            } else {
                resetStars();
            }
        });
        
        function highlightStars(count) {
            stars.forEach((star, index) => {
                if (index < count) {
                    star.classList.remove('far');
                    star.classList.add('fas', 'filled');
                } else {
                    star.classList.remove('fas', 'filled');
                    star.classList.add('far');
                }
            });
        }
        
        function resetStars() {
            stars.forEach(star => {
                star.classList.remove('fas', 'filled');
                star.classList.add('far');
            });
            ratingText.textContent = 'Click to rate';
        }
    </script>
</body>
</html>
