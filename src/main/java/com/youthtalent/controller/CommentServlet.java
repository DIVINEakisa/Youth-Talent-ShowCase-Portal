package com.youthtalent.controller;

import com.youthtalent.dao.CommentDAO;
import com.youthtalent.dao.TalentDAO;
import com.youthtalent.model.Comment;
import com.youthtalent.model.Talent;
import com.youthtalent.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Comment Servlet
 * Handles comment operations
 */
@WebServlet("/comment/*")
public class CommentServlet extends HttpServlet {
    
    private CommentDAO commentDAO;
    private TalentDAO talentDAO;

    @Override
    public void init() throws ServletException {
        commentDAO = new CommentDAO();
        talentDAO = new TalentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.equals("/list")) {
            listComments(request, response);
        }
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
                addComment(request, response);
                break;
            case "/delete":
                deleteComment(request, response);
                break;
            case "/flag":
                flagComment(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/talent/list");
        }
    }

    /**
     * List comments for a talent
     */
    private void listComments(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String talentIdParam = request.getParameter("talentId");
        
        if (talentIdParam != null) {
            int talentId = Integer.parseInt(talentIdParam);
            List<Comment> comments = commentDAO.getCommentsByTalent(talentId);
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            
            // Simple JSON serialization
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < comments.size(); i++) {
                Comment c = comments.get(i);
                if (i > 0) json.append(",");
                json.append("{\"commentId\":").append(c.getCommentId())
                    .append(",\"username\":\"").append(c.getUsername()).append("\"")
                    .append(",\"commentText\":\"").append(ValidationUtil.sanitizeInput(c.getCommentText())).append("\"")
                    .append(",\"createdAt\":\"").append(c.getCreatedAt()).append("\"}");
            }
            json.append("]");
            
            out.print(json.toString());
            out.flush();
        }
    }

    /**
     * Add new comment
     */
    private void addComment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        String talentIdParam = request.getParameter("talentId");
        String commentText = request.getParameter("commentText");
        
        // Validation
        if (!ValidationUtil.isNotEmpty(commentText)) {
            response.sendRedirect(request.getContextPath() + "/talent/view?id=" + talentIdParam + "&error=Comment cannot be empty");
            return;
        }
        
        if (!ValidationUtil.isValidLength(commentText, 1, 1000)) {
            response.sendRedirect(request.getContextPath() + "/talent/view?id=" + talentIdParam + "&error=Comment must be between 1 and 1000 characters");
            return;
        }
        
        int talentId = Integer.parseInt(talentIdParam);
        
        // Check if talent exists and is approved
        Talent talent = talentDAO.getTalentById(talentId);
        if (talent == null || !talent.isApproved()) {
            response.sendRedirect(request.getContextPath() + "/talent/list");
            return;
        }
        
        // Create comment
        Comment comment = new Comment();
        comment.setTalentId(talentId);
        comment.setUserId(userId);
        comment.setCommentText(commentText);
        
        boolean success = commentDAO.createComment(comment);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/talent/view?id=" + talentId + "&success=Comment added successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/talent/view?id=" + talentId + "&error=Failed to add comment");
        }
    }

    /**
     * Delete comment
     */
    private void deleteComment(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        String commentIdParam = request.getParameter("commentId");
        String talentIdParam = request.getParameter("talentId");
        
        int commentId = Integer.parseInt(commentIdParam);
        
        // Get comment to check ownership
        Comment comment = commentDAO.getCommentById(commentId);
        
        // User can delete their own comment, Admin can delete any comment
        if (comment != null && (comment.getUserId() == userId || "ADMIN".equals(role))) {
            commentDAO.deleteComment(commentId);
            response.sendRedirect(request.getContextPath() + "/talent/view?id=" + talentIdParam + "&success=Comment deleted successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/talent/view?id=" + talentIdParam + "&error=Unauthorized action");
        }
    }

    /**
     * Flag comment as inappropriate
     */
    private void flagComment(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        String commentIdParam = request.getParameter("commentId");
        String talentIdParam = request.getParameter("talentId");
        
        int commentId = Integer.parseInt(commentIdParam);
        
        boolean success = commentDAO.flagComment(commentId);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/talent/view?id=" + talentIdParam + "&success=Comment flagged for review");
        } else {
            response.sendRedirect(request.getContextPath() + "/talent/view?id=" + talentIdParam + "&error=Failed to flag comment");
        }
    }
}
