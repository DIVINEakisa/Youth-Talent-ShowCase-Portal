package com.youthtalent.controller;

import com.youthtalent.dao.RatingDAO;
import com.youthtalent.dao.TalentDAO;
import com.youthtalent.model.Rating;
import com.youthtalent.model.Talent;
import com.youthtalent.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Rating Servlet
 * Handles talent rating operations
 */
@WebServlet("/rating/*")
public class RatingServlet extends HttpServlet {
    
    private RatingDAO ratingDAO;
    private TalentDAO talentDAO;

    @Override
    public void init() throws ServletException {
        ratingDAO = new RatingDAO();
        talentDAO = new TalentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null) {
            response.sendRedirect(request.getContextPath() + "/talent/list");
            return;
        }
        
        switch (pathInfo) {
            case "/add":
                addOrUpdateRating(request, response);
                break;
            case "/remove":
                removeRating(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/talent/list");
        }
    }

    /**
     * Add or update rating
     */
    private void addOrUpdateRating(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Please login to rate\"}");
            out.flush();
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        String talentIdParam = request.getParameter("talentId");
        String ratingValueParam = request.getParameter("rating");
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            int talentId = Integer.parseInt(talentIdParam);
            int ratingValue = Integer.parseInt(ratingValueParam);
            
            // Validate rating
            if (!ValidationUtil.isValidRating(ratingValue)) {
                out.print("{\"success\": false, \"message\": \"Rating must be between 1 and 5\"}");
                out.flush();
                return;
            }
            
            // Check if talent exists
            Talent talent = talentDAO.getTalentById(talentId);
            if (talent == null) {
                out.print("{\"success\": false, \"message\": \"Talent not found\"}");
                out.flush();
                return;
            }
            
            // Business rule: User cannot rate their own talent
            if (talent.getUserId() == userId) {
                out.print("{\"success\": false, \"message\": \"You cannot rate your own talent\"}");
                out.flush();
                return;
            }
            
            // Business rule: Only approved talents can be rated
            if (!talent.isApproved()) {
                out.print("{\"success\": false, \"message\": \"Only approved talents can be rated\"}");
                out.flush();
                return;
            }
            
            // Create or update rating
            Rating rating = new Rating();
            rating.setTalentId(talentId);
            rating.setUserId(userId);
            rating.setRatingValue(ratingValue);
            
            boolean success = ratingDAO.addOrUpdateRating(rating);
            
            if (success) {
                // Get updated statistics
                double avgRating = ratingDAO.getAverageRating(talentId);
                int totalRatings = ratingDAO.getRatingCount(talentId);
                
                out.print("{\"success\": true, \"message\": \"Rating submitted successfully\", " +
                         "\"averageRating\": " + avgRating + ", \"totalRatings\": " + totalRatings + "}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to submit rating\"}");
            }
        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
        
        out.flush();
    }

    /**
     * Remove rating
     */
    private void removeRating(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Please login\"}");
            out.flush();
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        String talentIdParam = request.getParameter("talentId");
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            int talentId = Integer.parseInt(talentIdParam);
            boolean success = ratingDAO.deleteRating(talentId, userId);
            
            if (success) {
                out.print("{\"success\": true, \"message\": \"Rating removed successfully\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to remove rating\"}");
            }
        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
        
        out.flush();
    }
}
