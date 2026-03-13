package com.youthtalent.controller;

import com.youthtalent.dao.CategoryDAO;
import com.youthtalent.dao.TalentDAO;
import com.youthtalent.model.Talent;
import com.youthtalent.model.User;
import com.youthtalent.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Talent Servlet
 * Handles talent CRUD operations
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class TalentServlet extends HttpServlet {
    
    private TalentDAO talentDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        talentDAO = new TalentDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            listTalents(request, response);
            return;
        }
        
        switch (pathInfo) {
            case "/list":
                listTalents(request, response);
                break;
            case "/view":
                viewTalent(request, response);
                break;
            case "/my-talents":
                viewMyTalents(request, response);
                break;
            case "/add":
                showAddForm(request, response);
                break;
            case "/edit":
                showEditForm(request, response);
                break;
            case "/delete":
                deleteTalent(request, response);
                break;
            case "/search":
                searchTalents(request, response);
                break;
            default:
                listTalents(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        System.out.println("DEBUG TalentServlet.doPost() - pathInfo: " + pathInfo);
        System.out.println("DEBUG TalentServlet.doPost() - talentId param: " + request.getParameter("talentId"));
        
        if (pathInfo == null) {
            System.out.println("DEBUG: pathInfo is null, redirecting to list");
            response.sendRedirect(request.getContextPath() + "/talent/list");
            return;
        }
        
        switch (pathInfo) {
            case "/add":
                System.out.println("DEBUG: Calling addTalent()");
                addTalent(request, response);
                break;
            case "/edit":
                System.out.println("DEBUG: Calling editTalent()");
                editTalent(request, response);
                break;
            case "/delete":
                System.out.println("DEBUG: Calling deleteTalent()");
                deleteTalent(request, response);
                break;
            default:
                System.out.println("DEBUG: No matching case for: " + pathInfo);
                response.sendRedirect(request.getContextPath() + "/talent/list");
        }
    }

    /**
     * List all approved talents
     */
    private void listTalents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String categoryParam = request.getParameter("category");
        
        List<Talent> talents;
        if (categoryParam != null && !categoryParam.isEmpty()) {
            int categoryId = Integer.parseInt(categoryParam);
            talents = talentDAO.getTalentsByCategory(categoryId);
        } else {
            talents = talentDAO.getAllApprovedTalents();
        }
        
        request.setAttribute("talents", talents);
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.getRequestDispatcher("/talents.jsp").forward(request, response);
    }

    /**
     * View single talent with details
     */
    private void viewTalent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String talentIdParam = request.getParameter("id");
        
        if (talentIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/talent/list");
            return;
        }
        
        int talentId = Integer.parseInt(talentIdParam);
        Talent talent = talentDAO.getTalentById(talentId);
        
        if (talent != null) {
            // Increment views
            talentDAO.incrementViews(talentId);
            
            request.setAttribute("talent", talent);
            request.getRequestDispatcher("/talent-detail.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/talent/list");
        }
    }

    /**
     * View user's own talents
     */
    private void viewMyTalents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        if (isEmployerSession(session)) {
            response.sendRedirect(request.getContextPath() + "/opportunity/talents?error=Employers cannot manage youth submissions");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        List<Talent> talents = talentDAO.getTalentsByUserId(userId);
        
        request.setAttribute("talents", talents);
        request.getRequestDispatcher("/my-talents.jsp").forward(request, response);
    }

    /**
     * Show add talent form
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        if (isEmployerSession(session)) {
            response.sendRedirect(request.getContextPath() + "/opportunity/talents?error=Employers cannot submit talents");
            return;
        }
        
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.getRequestDispatcher("/add-talent.jsp").forward(request, response);
    }

    /**
     * Show edit talent form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        if (isEmployerSession(session)) {
            response.sendRedirect(request.getContextPath() + "/opportunity/talents?error=Employers cannot edit talents");
            return;
        }
        
        String talentIdParam = request.getParameter("id");
        if (talentIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/talent/my-talents");
            return;
        }
        
        int talentId = Integer.parseInt(talentIdParam);
        Talent talent = talentDAO.getTalentById(talentId);
        
        // Check ownership
        int userId = (Integer) session.getAttribute("userId");
        if (talent == null || talent.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/talent/my-talents");
            return;
        }
        
        request.setAttribute("talent", talent);
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.getRequestDispatcher("/edit-talent.jsp").forward(request, response);
    }

    /**
     * Add new talent
     */
    private void addTalent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        if (isEmployerSession(session)) {
            response.sendRedirect(request.getContextPath() + "/opportunity/talents?error=Employers cannot submit talents");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String categoryIdParam = request.getParameter("categoryId");
        String imageUrl = request.getParameter("imageUrl");
        String mediaUrl = request.getParameter("mediaUrl");
        
        // Validation
        int categoryId = categoryIdParam != null ? Integer.parseInt(categoryIdParam) : 0;
        String validationError = ValidationUtil.validateTalentData(title, description, categoryId);
        
        if (validationError != null) {
            request.setAttribute("error", validationError);
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/add-talent.jsp").forward(request, response);
            return;
        }
        
        // Validate media URL if provided
        if (mediaUrl != null && !mediaUrl.isEmpty() && !ValidationUtil.isValidURL(mediaUrl)) {
            request.setAttribute("error", "Invalid media URL format");
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/add-talent.jsp").forward(request, response);
            return;
        }
        
        // Create talent
        Talent talent = new Talent();
        talent.setUserId(userId);
        talent.setTitle(title);
        talent.setDescription(description);
        talent.setCategoryId(categoryId);
        talent.setImageUrl(imageUrl != null && !imageUrl.isEmpty() ? imageUrl : "default-talent.jpg");
        talent.setMediaUrl(mediaUrl);
        talent.setStatus("PENDING");
        
        boolean success = talentDAO.createTalent(talent);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/talent/my-talents?success=Talent added successfully and is pending approval");
        } else {
            request.setAttribute("error", "Failed to add talent. Please try again.");
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/add-talent.jsp").forward(request, response);
        }
    }

    /**
     * Edit existing talent
     */
    private void editTalent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        if (isEmployerSession(session)) {
            response.sendRedirect(request.getContextPath() + "/opportunity/talents?error=Employers cannot edit talents");
            return;
        }
        
        String talentIdParam = request.getParameter("talentId");
        int talentId = Integer.parseInt(talentIdParam);
        int userId = (Integer) session.getAttribute("userId");
        
        // Get existing talent
        Talent existingTalent = talentDAO.getTalentById(talentId);
        
        // Check ownership
        if (existingTalent == null || existingTalent.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/talent/my-talents");
            return;
        }
        
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String categoryIdParam = request.getParameter("categoryId");
        String imageUrl = request.getParameter("imageUrl");
        String mediaUrl = request.getParameter("mediaUrl");
        
        // Validation
        int categoryId = categoryIdParam != null ? Integer.parseInt(categoryIdParam) : 0;
        String validationError = ValidationUtil.validateTalentData(title, description, categoryId);
        
        if (validationError != null) {
            request.setAttribute("error", validationError);
            request.setAttribute("talent", existingTalent);
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/edit-talent.jsp").forward(request, response);
            return;
        }
        
        // Update talent
        existingTalent.setTitle(title);
        existingTalent.setDescription(description);
        existingTalent.setCategoryId(categoryId);
        existingTalent.setImageUrl(imageUrl != null && !imageUrl.isEmpty() ? imageUrl : existingTalent.getImageUrl());
        existingTalent.setMediaUrl(mediaUrl);
        
        boolean success = talentDAO.updateTalent(existingTalent);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/talent/my-talents?success=Talent updated successfully");
        } else {
            request.setAttribute("error", "Failed to update talent. Please try again.");
            request.setAttribute("talent", existingTalent);
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/edit-talent.jsp").forward(request, response);
        }
    }

    /**
     * Delete talent
     */
    private void deleteTalent(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        System.out.println("DEBUG deleteTalent() - METHOD CALLED");
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("DEBUG deleteTalent() - No session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        if (isEmployerSession(session)) {
            response.sendRedirect(request.getContextPath() + "/opportunity/talents?error=Employers cannot delete talents");
            return;
        }
        
        String talentIdParam = request.getParameter("talentId");
        System.out.println("DEBUG deleteTalent() - talentId param: " + talentIdParam);
        
        int talentId = Integer.parseInt(talentIdParam);
        int userId = (Integer) session.getAttribute("userId");
        
        System.out.println("DEBUG deleteTalent() - Parsed talentId: " + talentId + ", userId: " + userId);
        
        // Get talent to check ownership
        Talent talent = talentDAO.getTalentById(talentId);
        
        if (talent != null && talent.getUserId() == userId) {
            System.out.println("DEBUG deleteTalent() - Ownership verified, attempting delete...");
            // Try to delete and check if successful
            boolean deleted = talentDAO.deleteTalent(talentId);
            
            if (deleted) {
                System.out.println("DEBUG deleteTalent() - Delete SUCCESS");
                session.setAttribute("message", "Talent deleted successfully!");
                session.setAttribute("messageType", "success");
            } else {
                System.out.println("DEBUG deleteTalent() - Delete FAILED");
                session.setAttribute("message", "Failed to delete talent. Please try again.");
                session.setAttribute("messageType", "danger");
            }
        } else {
            System.out.println("DEBUG deleteTalent() - Ownership check FAILED or talent not found");
            session.setAttribute("message", "Unauthorized action!");
            session.setAttribute("messageType", "danger");
        }
        
        System.out.println("DEBUG deleteTalent() - Redirecting to my-talents");
        response.sendRedirect(request.getContextPath() + "/talent/my-talents");
    }

    /**
     * Search talents
     */
    private void searchTalents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        
        List<Talent> talents;
        if (keyword != null && !keyword.isEmpty()) {
            talents = talentDAO.searchTalents(keyword);
        } else {
            talents = talentDAO.getAllApprovedTalents();
        }
        
        request.setAttribute("talents", talents);
        request.setAttribute("keyword", keyword);
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.getRequestDispatcher("/talents.jsp").forward(request, response);
    }

    private boolean isEmployerSession(HttpSession session) {
        String role = (String) session.getAttribute("role");
        return "EMPLOYER".equals(role);
    }
}
