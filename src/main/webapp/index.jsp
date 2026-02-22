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
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #198754;
            --primary-dark: #146c43;
            --primary-light: #20c997;
            --accent-color: #0d6efd;
            --text-dark: #1a1a1a;
            --text-light: #6c757d;
            --bg-light: #f8f9fa;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            color: var(--text-dark);
            overflow-x: hidden;
        }
        
        /* Modern Navbar */
        .navbar {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(10px);
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.05);
            padding: 1rem 0;
            transition: all 0.3s ease;
        }
        
        .navbar.scrolled {
            box-shadow: 0 2px 30px rgba(0, 0, 0, 0.1);
        }
        
        .navbar-brand {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color) !important;
            transition: transform 0.3s ease;
        }
        
        .navbar-brand:hover {
            transform: scale(1.05);
        }
        
        .navbar-brand i {
            margin-right: 8px;
            font-size: 1.8rem;
        }
        
        .nav-link {
            font-weight: 500;
            color: var(--text-dark) !important;
            margin: 0 15px;
            transition: color 0.3s ease;
        }
        
        .nav-link:hover {
            color: var(--primary-color) !important;
        }
        
        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, #0f2027 0%, #203a43 50%, #2c5364 100%);
            color: white;
            padding: 120px 0 100px;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=1920&q=80') center/cover;
            opacity: 0.15;
            z-index: 0;
        }
        
        .hero-section::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(25, 135, 84, 0.8) 0%, rgba(13, 110, 253, 0.6) 100%);
            z-index: 0;
        }
        
        .hero-content {
            position: relative;
            z-index: 1;
        }
        
        .hero-section h1 {
            font-size: 4rem;
            font-weight: 800;
            margin-bottom: 24px;
            line-height: 1.2;
            animation: fadeInUp 0.8s ease;
        }
        
        .hero-section .subtitle {
            font-size: 1.5rem;
            margin-bottom: 16px;
            font-weight: 300;
            opacity: 0.95;
            animation: fadeInUp 0.8s ease 0.2s both;
        }
        
        .hero-section .description {
            font-size: 1.15rem;
            margin-bottom: 40px;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.7;
            opacity: 0.9;
            animation: fadeInUp 0.8s ease 0.4s both;
        }
        
        .hero-buttons {
            animation: fadeInUp 0.8s ease 0.6s both;
        }
        
        .btn-hero {
            padding: 16px 48px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 50px;
            margin: 10px;
            transition: all 0.3s ease;
            border: none;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .btn-hero-primary {
            background: white;
            color: var(--primary-color);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }
        
        .btn-hero-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
            background: var(--bg-light);
            color: var(--primary-dark);
        }
        
        .btn-hero-outline {
            background: transparent;
            color: white;
            border: 2px solid white;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        
        .btn-hero-outline:hover {
            background: white;
            color: var(--primary-color);
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(255, 255, 255, 0.3);
        }
        
        /* Stats Bar */
        .stats-bar {
            background: white;
            padding: 40px 0;
            box-shadow: 0 5px 30px rgba(0, 0, 0, 0.1);
            margin-top: -50px;
            position: relative;
            z-index: 2;
            border-radius: 15px;
        }
        
        .stat-item {
            text-align: center;
            padding: 20px;
        }
        
        .stat-number {
            font-size: 3rem;
            font-weight: 800;
            color: var(--primary-color);
            display: block;
            line-height: 1;
        }
        
        .stat-label {
            font-size: 1rem;
            color: var(--text-light);
            margin-top: 8px;
            font-weight: 500;
        }
        
        /* Section Styling */
        .section {
            padding: 100px 0;
        }
        
        .section-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 16px;
            color: var(--text-dark);
        }
        
        .section-subtitle {
            font-size: 1.2rem;
            color: var(--text-light);
            margin-bottom: 60px;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
        }
        
        /* Feature Cards */
        .feature-card {
            background: white;
            border-radius: 20px;
            padding: 40px 30px;
            text-align: center;
            transition: all 0.4s ease;
            border: 1px solid #e9ecef;
            height: 100%;
            position: relative;
            overflow: hidden;
        }
        
        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--primary-light));
            transform: scaleX(0);
            transition: transform 0.4s ease;
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            border-color: var(--primary-color);
        }
        
        .feature-card:hover::before {
            transform: scaleX(1);
        }
        
        .feature-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-light));
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 24px;
            font-size: 2rem;
            color: white;
            transition: all 0.4s ease;
        }
        
        .feature-card:hover .feature-icon {
            transform: rotateY(360deg);
            box-shadow: 0 10px 30px rgba(25, 135, 84, 0.4);
        }
        
        .feature-title {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 16px;
            color: var(--text-dark);
        }
        
        .feature-text {
            font-size: 1rem;
            color: var(--text-light);
            line-height: 1.7;
        }
        
        /* How It Works Section */
        .how-it-works {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        }
        
        .step-card {
            background: white;
            border-radius: 20px;
            padding: 40px 30px;
            text-align: center;
            position: relative;
            transition: all 0.3s ease;
            height: 100%;
            border: 2px solid transparent;
        }
        
        .step-card:hover {
            border-color: var(--primary-color);
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
        }
        
        .step-number {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-light));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 24px;
            font-size: 1.8rem;
            font-weight: 800;
            color: white;
            box-shadow: 0 8px 20px rgba(25, 135, 84, 0.3);
        }
        
        .step-title {
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 12px;
            color: var(--text-dark);
        }
        
        .step-text {
            font-size: 1rem;
            color: var(--text-light);
            line-height: 1.6;
        }
        
        /* CTA Section */
        .cta-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 80px 0;
            position: relative;
            overflow: hidden;
        }
        
        .cta-section::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 500px;
            height: 500px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }
        
        .cta-section::after {
            content: '';
            position: absolute;
            bottom: -30%;
            left: -10%;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
        }
        
        .cta-content {
            position: relative;
            z-index: 1;
        }
        
        .cta-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 20px;
        }
        
        .cta-text {
            font-size: 1.2rem;
            margin-bottom: 40px;
            opacity: 0.95;
        }
        
        /* Footer */
        .footer {
            background: #1a1a1a;
            color: white;
            padding: 60px 0 30px;
        }
        
        .footer-title {
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 20px;
            color: var(--primary-light);
        }
        
        .footer-link {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            display: block;
            margin-bottom: 10px;
            transition: color 0.3s ease;
        }
        
        .footer-link:hover {
            color: white;
            padding-left: 5px;
        }
        
        .social-icons a {
            width: 40px;
            height: 40px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
            color: white;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .social-icons a:hover {
            background: var(--primary-color);
            transform: translateY(-3px);
        }
        
        .copyright {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            margin-top: 40px;
            padding-top: 30px;
            text-align: center;
            color: rgba(255, 255, 255, 0.6);
        }
        
        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes float {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-20px);
            }
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .hero-section h1 {
                font-size: 2.5rem;
            }
            
            .hero-section .subtitle {
                font-size: 1.2rem;
            }
            
            .hero-section .description {
                font-size: 1rem;
            }
            
            .btn-hero {
                padding: 14px 32px;
                font-size: 1rem;
            }
            
            .section-title {
                font-size: 2rem;
            }
            
            .stat-number {
                font-size: 2rem;
            }
        }
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
    <!-- Modern Navbar -->
    <nav class="navbar navbar-expand-lg fixed-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-rocket"></i> Youth Talent Portal
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item">
                        <a class="nav-link" href="#what-we-do">What We Do</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#how-it-works">How It Works</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#features">Features</a>
                    </li>
                    <li class="nav-item ms-3">
                        <a class="btn btn-outline-success rounded-pill px-4" href="${pageContext.request.contextPath}/login.jsp">
                            <i class="fas fa-sign-in-alt"></i> Login
                        </a>
                    </li>
                    <li class="nav-item ms-2">
                        <a class="btn btn-success rounded-pill px-4" href="${pageContext.request.contextPath}/register.jsp">
                            <i class="fas fa-user-plus"></i> Sign Up
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-12 hero-content text-center">
                    <h1>Empower Your Talent.<br>Showcase Your Potential.</h1>
                    <p class="subtitle">The Digital Platform for Young Innovators & Creators</p>
                    <p class="description">
                        Join a thriving community where youth can upload, manage, and showcase their talents. 
                        Get rated by peers, receive admin approval, and gain the recognition you deserve.
                    </p>
                    <div class="hero-buttons">
                        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-hero btn-hero-primary">
                            <i class="fas fa-rocket"></i> Get Started Free
                        </a>
                        <a href="${pageContext.request.contextPath}/talent/list" class="btn btn-hero btn-hero-outline">
                            <i class="fas fa-compass"></i> Explore Talents
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Stats Bar -->
    <section class="container">
        <div class="stats-bar">
            <div class="row">
                <div class="col-md-3 col-6">
                    <div class="stat-item">
                        <span class="stat-number">1,000+</span>
                        <div class="stat-label">Young Creators</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-item">
                        <span class="stat-number">500+</span>
                        <div class="stat-label">Talents Showcased</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-item">
                        <span class="stat-number">15K+</span>
                        <div class="stat-label">Ratings & Reviews</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-item">
                        <span class="stat-number">98%</span>
                        <div class="stat-label">Satisfaction Rate</div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- What We Do Section -->
    <section class="section" id="what-we-do">
        <div class="container">
            <div class="text-center">
                <h2 class="section-title">What We Do</h2>
                <p class="section-subtitle">
                    A comprehensive platform designed to help young people showcase their unique talents 
                    and gain the recognition they deserve in a supportive, structured environment.
                </p>
            </div>
            <div class="row g-4">
                <div class="col-md-6 col-lg-3">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <h3 class="feature-title">Talent Showcase</h3>
                        <p class="feature-text">
                            Upload and manage your creative works, projects, and skills. Share your journey with a community that values innovation.
                        </p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-star-half-alt"></i>
                        </div>
                        <h3 class="feature-title">Community Rating</h3>
                        <p class="feature-text">
                            Receive honest feedback through our 1-5 star rating system. Get constructive comments that help you grow and improve.
                        </p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-shield-check"></i>
                        </div>
                        <h3 class="feature-title">Admin Approval</h3>
                        <p class="feature-text">
                            Every talent submission is reviewed by our team before publication, ensuring quality content and a safe environment for all.
                        </p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-lock"></i>
                        </div>
                        <h3 class="feature-title">Secure Platform</h3>
                        <p class="feature-text">
                            Built with security in mind. Your data is protected with modern encryption and secure authentication systems.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- How It Works Section -->
    <section class="section how-it-works" id="how-it-works">
        <div class="container">
            <div class="text-center">
                <h2 class="section-title">How It Works</h2>
                <p class="section-subtitle">
                    Getting started is simple. Follow these four easy steps to showcase your talent to the world.
                </p>
            </div>
            <div class="row g-4">
                <div class="col-md-6 col-lg-3">
                    <div class="step-card">
                        <div class="step-number">1</div>
                        <h3 class="step-title">Create Account</h3>
                        <p class="step-text">
                            Sign up in seconds with your email. Create your profile and tell us about your passions and interests.
                        </p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="step-card">
                        <div class="step-number">2</div>
                        <h3 class="step-title">Upload Talent</h3>
                        <p class="step-text">
                            Share your work! Add descriptions, images, videos, and choose the right category for your talent submission.
                        </p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="step-card">
                        <div class="step-number">3</div>
                        <h3 class="step-title">Get Approved</h3>
                        <p class="step-text">
                            Our admin team reviews your submission to ensure quality. Approved talents go live for the community to see.
                        </p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="step-card">
                        <div class="step-number">4</div>
                        <h3 class="step-title">Gain Recognition</h3>
                        <p class="step-text">
                            Receive ratings, comments, and recognition from peers. Build your reputation and connect with opportunities.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Features Section -->
    <section class="section" id="features">
        <div class="container">
            <div class="text-center">
                <h2 class="section-title">Platform Features</h2>
                <p class="section-subtitle">
                    Everything you need to showcase, manage, and grow your talents in one powerful platform.
                </p>
            </div>
            <div class="row g-4">
                <div class="col-md-6 col-lg-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-palette"></i>
                        </div>
                        <h3 class="feature-title">Multiple Categories</h3>
                        <p class="feature-text">
                            Music, Art, Coding, Writing, Innovation, Entrepreneurship, and more. Find your niche and showcase what you love.
                        </p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-search"></i>
                        </div>
                        <h3 class="feature-title">Smart Search</h3>
                        <p class="feature-text">
                            Advanced filters and search functionality help you discover talents by category, rating, and popularity instantly.
                        </p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-comments"></i>
                        </div>
                        <h3 class="feature-title">Feedback System</h3>
                        <p class="feature-text">
                            Get valuable feedback through comments and ratings. Learn from the community and improve your craft continuously.
                        </p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <h3 class="feature-title">Analytics Dashboard</h3>
                        <p class="feature-text">
                            Track your talent views, ratings, and engagement. See how your work performs and what resonates with your audience.
                        </p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-award"></i>
                        </div>
                        <h3 class="feature-title">Achievement Badges</h3>
                        <p class="feature-text">
                            Earn recognition badges as you hit milestones. Showcase your achievements and build credibility in the community.
                        </p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-mobile-alt"></i>
                        </div>
                        <h3 class="feature-title">Mobile Responsive</h3>
                        <p class="feature-text">
                            Access the platform anywhere, anytime. Fully optimized for desktop, tablet, and mobile devices for seamless experience.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- CTA Section -->
    <section class="cta-section">
        <div class="container">
            <div class="cta-content text-center">
                <h2 class="cta-title">Ready to Showcase Your Talent?</h2>
                <p class="cta-text">
                    Join thousands of young creators who are already sharing their skills and gaining recognition. 
                    It's free, secure, and takes less than 2 minutes to get started.
                </p>
                <div>
                    <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-hero btn-hero-primary me-3">
                        <i class="fas fa-user-plus"></i> Create Free Account
                    </a>
                    <a href="${pageContext.request.contextPath}/talent/list" class="btn btn-hero btn-hero-outline">
                        <i class="fas fa-eye"></i> View Talents
                    </a>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-lg-4 mb-4 mb-lg-0">
                    <h3 class="footer-title">
                        <i class="fas fa-rocket"></i> Youth Talent Portal
                    </h3>
                    <p style="color: rgba(255, 255, 255, 0.7); line-height: 1.7;">
                        Empowering the next generation of creators, innovators, and leaders through 
                        technology and community support.
                    </p>
                    <div class="social-icons mt-4">
                        <a href="#" title="Facebook"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" title="Twitter"><i class="fab fa-twitter"></i></a>
                        <a href="#" title="Instagram"><i class="fab fa-instagram"></i></a>
                        <a href="#" title="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                        <a href="#" title="YouTube"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>
                <div class="col-lg-2 col-md-4 mb-4 mb-lg-0">
                    <h3 class="footer-title">Platform</h3>
                    <a href="${pageContext.request.contextPath}/register.jsp" class="footer-link">Sign Up</a>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="footer-link">Login</a>
                    <a href="${pageContext.request.contextPath}/talent/list" class="footer-link">Browse Talents</a>
                    <a href="#how-it-works" class="footer-link">How It Works</a>
                </div>
                <div class="col-lg-2 col-md-4 mb-4 mb-lg-0">
                    <h3 class="footer-title">Categories</h3>
                    <a href="#" class="footer-link">Music</a>
                    <a href="#" class="footer-link">Art & Design</a>
                    <a href="#" class="footer-link">Coding & Tech</a>
                    <a href="#" class="footer-link">Writing</a>
                    <a href="#" class="footer-link">Innovation</a>
                </div>
                <div class="col-lg-2 col-md-4 mb-4 mb-lg-0">
                    <h3 class="footer-title">Support</h3>
                    <a href="#" class="footer-link">Help Center</a>
                    <a href="#" class="footer-link">Guidelines</a>
                    <a href="#" class="footer-link">Safety Tips</a>
                    <a href="#" class="footer-link">Contact Us</a>
                </div>
                <div class="col-lg-2 col-md-4">
                    <h3 class="footer-title">Legal</h3>
                    <a href="#" class="footer-link">Privacy Policy</a>
                    <a href="#" class="footer-link">Terms of Service</a>
                    <a href="#" class="footer-link">Cookie Policy</a>
                </div>
            </div>
            <div class="copyright">
                <p class="mb-0">
                    &copy; 2024 Youth Talent Showcase & Opportunity Portal. All rights reserved. | 
                    Built with <i class="fas fa-heart" style="color: var(--primary-light);"></i> for young creators
                </p>
            </div>
        </div>
    </footer>
    
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Smooth Scroll & Navbar Effect -->
    <script>
        // Smooth scroll for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
        
        // Navbar scroll effect
        window.addEventListener('scroll', function() {
            const navbar = document.querySelector('.navbar');
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });
        
        // Add animation on scroll
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };
        
        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);
        
        // Observe all cards
        document.querySelectorAll('.feature-card, .step-card').forEach(card => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(30px)';
            card.style.transition = 'all 0.6s ease';
            observer.observe(card);
        });
    </script>
</body>
</html>
