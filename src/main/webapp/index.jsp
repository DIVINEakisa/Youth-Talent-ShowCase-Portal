<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Youth Talent Showcase & Opportunity Portal</title>
    
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
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .hero-section {
            background: linear-gradient(135deg, var(--primary-green), var(--dark-green));
            color: white;
            padding: 100px 0;
            text-align: center;
        }
        
        .hero-section h1 {
            font-size: 3.5rem;
            font-weight: bold;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .hero-section p {
            font-size: 1.5rem;
            margin-bottom: 40px;
        }
        
        .btn-large {
            padding: 15px 40px;
            font-size: 1.2rem;
            border-radius: 50px;
            margin: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            transition: all 0.3s;
        }
        
        .btn-large:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.3);
        }
        
        .btn-white {
            background-color: white;
            color: var(--primary-green);
        }
        
        .btn-white:hover {
            background-color: #f8f9fa;
            color: var(--dark-green);
        }
        
        .feature-section {
            padding: 80px 0;
        }
        
        .feature-card {
            text-align: center;
            padding: 40px 20px;
            border-radius: 10px;
            transition: all 0.3s;
            height: 100%;
            background-color: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 8px 25px rgba(25, 135, 84, 0.3);
        }
        
        .feature-icon {
            font-size: 4rem;
            color: var(--primary-green);
            margin-bottom: 20px;
        }
        
        .stats-section {
            background: linear-gradient(135deg, var(--light-green), white);
            padding: 60px 0;
        }
        
        .stat-item {
            text-align: center;
            padding: 20px;
        }
        
        .stat-number {
            font-size: 3rem;
            font-weight: bold;
            color: var(--primary-green);
        }
        
        .category-section {
            padding: 80px 0;
            background-color: #f8f9fa;
        }
        
        .category-badge {
            display: inline-block;
            background: white;
            padding: 15px 30px;
            margin: 10px;
            border-radius: 50px;
            border: 2px solid var(--primary-green);
            color: var(--primary-green);
            font-weight: 600;
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .category-badge:hover {
            background-color: var(--primary-green);
            color: white;
            transform: scale(1.1);
        }
        
        .cta-section {
            background: linear-gradient(135deg, var(--dark-green), var(--primary-green));
            color: white;
            padding: 80px 0;
            text-align: center;
        }
        
        .footer {
            background-color: #212529;
            color: white;
            padding: 30px 0;
            text-align: center;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/" style="color: var(--primary-green);">
                <i class="fas fa-star"></i> Youth Talent Portal
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="#features">Features</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#categories">Categories</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#about">About</a>
                    </li>
                    <li class="nav-item ms-2">
                        <a class="btn btn-outline-success" href="${pageContext.request.contextPath}/login.jsp">
                            <i class="fas fa-sign-in-alt"></i> Login
                        </a>
                    </li>
                    <li class="nav-item ms-2">
                        <a class="btn btn-success" href="${pageContext.request.contextPath}/register.jsp">
                            <i class="fas fa-user-plus"></i> Register
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    
    <!-- Hero Section -->
    <div class="hero-section">
        <div class="container">
            <h1 class="animate__animated animate__fadeInDown">
                <i class="fas fa-trophy"></i> Showcase Your Talent
            </h1>
            <p class="animate__animated animate__fadeInUp">
                The ultimate platform for young creators to share their skills, get recognized, and connect with opportunities
            </p>
            <div class="animate__animated animate__fadeInUp animate__delay-1s">
                <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-light btn-large btn-white">
                    <i class="fas fa-rocket"></i> Get Started Free
                </a>
                <a href="${pageContext.request.contextPath}/talent/list" class="btn btn-outline-light btn-large">
                    <i class="fas fa-search"></i> Explore Talents
                </a>
            </div>
        </div>
    </div>
    
    <!-- Stats Section -->
    <div class="stats-section">
        <div class="container">
            <div class="row">
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">500+</div>
                        <div class="text-muted">Talents Showcased</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">1000+</div>
                        <div class="text-muted">Active Users</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">50+</div>
                        <div class="text-muted">Opportunities</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">15K+</div>
                        <div class="text-muted">Ratings Given</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Features Section -->
    <div class="feature-section" id="features">
        <div class="container">
            <h2 class="text-center mb-5 fw-bold" style="color: var(--primary-green);">
                Why Choose Our Platform?
            </h2>
            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-upload"></i>
                        </div>
                        <h4>Easy Upload</h4>
                        <p class="text-muted">
                            Showcase your talents with simple upload forms. Add images, videos, and detailed descriptions in minutes.
                        </p>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-star"></i>
                        </div>
                        <h4>Rating & Reviews</h4>
                        <p class="text-muted">
                            Get valuable feedback from the community with our 5-star rating system and comment features.
                        </p>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <h4>Quality Control</h4>
                        <p class="text-muted">
                            All submissions are reviewed by admins to ensure high-quality, appropriate content for all users.
                        </p>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-search"></i>
                        </div>
                        <h4>Smart Discovery</h4>
                        <p class="text-muted">
                            Advanced search and filtering help users discover talents by category, rating, and popularity.
                        </p>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-trophy"></i>
                        </div>
                        <h4>Achievements</h4>
                        <p class="text-muted">
                            Earn badges and recognition as you showcase more talents and receive positive ratings.
                        </p>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-mobile-alt"></i>
                        </div>
                        <h4>Mobile Friendly</h4>
                        <p class="text-muted">
                            Fully responsive design works seamlessly on desktop, tablet, and mobile devices.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Categories Section -->
    <div class="category-section" id="categories">
        <div class="container">
            <h2 class="text-center mb-5 fw-bold" style="color: var(--primary-green);">
                Explore Talent Categories
            </h2>
            <div class="text-center">
                <span class="category-badge">
                    <i class="fas fa-music"></i> Music
                </span>
                <span class="category-badge">
                    <i class="fas fa-palette"></i> Art & Design
                </span>
                <span class="category-badge">
                    <i class="fas fa-code"></i> Coding & Tech
                </span>
                <span class="category-badge">
                    <i class="fas fa-pen-fancy"></i> Writing
                </span>
                <span class="category-badge">
                    <i class="fas fa-lightbulb"></i> Innovation
                </span>
                <span class="category-badge">
                    <i class="fas fa-briefcase"></i> Entrepreneurship
                </span>
            </div>
        </div>
    </div>
    
    <!-- CTA Section -->
    <div class="cta-section" id="about">
        <div class="container">
            <h2 class="mb-4">Ready to Showcase Your Talent?</h2>
            <p class="lead mb-4">
                Join thousands of young creators sharing their skills and getting discovered
            </p>
            <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-light btn-large btn-white">
                <i class="fas fa-user-plus"></i> Create Free Account
            </a>
        </div>
    </div>
    
    <!-- Footer -->
    <div class="footer">
        <div class="container">
            <p class="mb-2">
                <strong>Youth Talent Showcase & Opportunity Portal</strong>
            </p>
            <p class="text-muted mb-2">
                Empowering young talent through technology
            </p>
            <div class="mt-3">
                <a href="#" class="text-white mx-2"><i class="fab fa-facebook fa-lg"></i></a>
                <a href="#" class="text-white mx-2"><i class="fab fa-twitter fa-lg"></i></a>
                <a href="#" class="text-white mx-2"><i class="fab fa-instagram fa-lg"></i></a>
                <a href="#" class="text-white mx-2"><i class="fab fa-linkedin fa-lg"></i></a>
            </div>
            <p class="text-muted mt-3 mb-0">
                &copy; 2024 Youth Talent Portal. All rights reserved.
            </p>
        </div>
    </div>
    
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
