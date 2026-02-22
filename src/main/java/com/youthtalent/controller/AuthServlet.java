package com.youthtalent.controller;

import com.youthtalent.dao.UserDAO;
import com.youthtalent.model.User;
import com.youthtalent.util.PasswordUtil;
import com.youthtalent.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Authentication Servlet
 * Handles user login and registration
 */
public class AuthServlet extends HttpServlet {
    
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        switch (pathInfo) {
            case "/login":
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                break;
            case "/register":
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                break;
            case "/logout":
                handleLogout(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        switch (pathInfo) {
            case "/login":
                handleLogin(request, response);
                break;
            case "/register":
                handleRegister(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    /**
     * Handle user login
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            System.out.println("DEBUG: Login attempt for username: " + username);
            
            // Validation
            if (!ValidationUtil.isNotEmpty(username) || !ValidationUtil.isNotEmpty(password)) {
                request.setAttribute("error", "Username and password are required");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            
            // Hash password
            String passwordHash = PasswordUtil.hashPassword(password);
            System.out.println("DEBUG: Password hash: " + passwordHash);
            
            // Authenticate user
            User user = userDAO.authenticateUser(username, passwordHash);
            System.out.println("DEBUG: Authentication result: " + (user != null ? "SUCCESS" : "FAILED"));
            
            if (user != null) {
                System.out.println("DEBUG: User found: " + user.getUsername() + " (Role: " + user.getRole() + ")");
                
                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", user.getRole());
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
                
                System.out.println("DEBUG: Session created, redirecting...");
                
                // Redirect based on role
                if (user.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/admin/action/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
                }
            } else {
                System.out.println("DEBUG: Authentication failed - no user found");
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.err.println("ERROR in handleLogin: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Login error: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    /**
     * Handle user registration
     */
    private void handleRegister(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String bio = request.getParameter("bio");
        
        // Validation
        String usernameError = ValidationUtil.validateUsername(username);
        if (usernameError != null) {
            request.setAttribute("error", usernameError);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        String emailError = ValidationUtil.validateEmail(email);
        if (emailError != null) {
            request.setAttribute("error", emailError);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        String passwordError = PasswordUtil.getPasswordValidationError(password);
        if (passwordError != null) {
            request.setAttribute("error", passwordError);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Check if username exists
        if (userDAO.usernameExists(username)) {
            request.setAttribute("error", "Username already exists");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Check if email exists
        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email already exists");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Create user
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPasswordHash(PasswordUtil.hashPassword(password));
        user.setFullName(fullName);
        user.setRole("USER");
        user.setBio(bio);
        
        boolean success = userDAO.createUser(user);
        
        if (success) {
            request.setAttribute("success", "Registration successful! Please login.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    /**
     * Handle user logout
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
