package com.youthtalent.controller;

import com.youthtalent.dao.*;
import com.youthtalent.model.Talent;
import com.youthtalent.model.Report;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Admin Servlet
 * Handles admin operations including talent approval workflow
 */
public class AdminServlet extends HttpServlet {
    
    private TalentDAO talentDAO;
    private UserDAO userDAO;
    private ReportDAO reportDAO;

    @Override
    public void init() throws ServletException {
        talentDAO = new TalentDAO();
        userDAO = new UserDAO();
        reportDAO = new ReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is admin
        if (!isAdmin(request, response)) {
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            showDashboard(request, response);
            return;
        }
        
        switch (pathInfo) {
            case "/dashboard":
                showDashboard(request, response);
                break;
            case "/talents/pending":
                showPendingTalents(request, response);
                break;
            case "/talents/all":
                showAllTalents(request, response);
                break;
            case "/users":
                showUsers(request, response);
                break;
            case "/reports":
                showReports(request, response);
                break;
            default:
                showDashboard(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is admin
        if (!isAdmin(request, response)) {
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }
        
        switch (pathInfo) {
            case "/talent/approve":
                approveTalent(request, response);
                break;
            case "/talent/reject":
                rejectTalent(request, response);
                break;
            case "/report/review":
                reviewReport(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    /**
     * Check if user is admin
     */
    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return false;
        }
        
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=Unauthorized access");
            return false;
        }
        
        return true;
    }

    /**
     * Show admin dashboard
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get statistics
        int totalUsers = userDAO.getTotalUserCount();
        int totalTalents = talentDAO.getTotalTalentCount();
        int pendingTalents = talentDAO.getCountByStatus("PENDING");
        int approvedTalents = talentDAO.getCountByStatus("APPROVED");
        int rejectedTalents = talentDAO.getCountByStatus("REJECTED");
        int pendingReports = reportDAO.getPendingReportsCount();
        
        // Get top rated talents
        List<Talent> topTalents = talentDAO.getTopRatedTalents(5);
        
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalTalents", totalTalents);
        request.setAttribute("pendingTalents", pendingTalents);
        request.setAttribute("approvedTalents", approvedTalents);
        request.setAttribute("rejectedTalents", rejectedTalents);
        request.setAttribute("pendingReports", pendingReports);
        request.setAttribute("topTalents", topTalents);
        
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    /**
     * Show pending talents for approval
     */
    private void showPendingTalents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Talent> pendingTalents = talentDAO.getTalentsByStatus("PENDING");
        
        request.setAttribute("talents", pendingTalents);
        request.setAttribute("status", "PENDING");
        request.getRequestDispatcher("/admin/manage-talents.jsp").forward(request, response);
    }

    /**
     * Show all talents
     */
    private void showAllTalents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String status = request.getParameter("status");
        
        List<Talent> talents;
        if (status != null && !status.isEmpty()) {
            talents = talentDAO.getTalentsByStatus(status);
        } else {
            // Get all talents (need to create method in DAO)
            talents = talentDAO.getTalentsByStatus("APPROVED");
            talents.addAll(talentDAO.getTalentsByStatus("PENDING"));
            talents.addAll(talentDAO.getTalentsByStatus("REJECTED"));
        }
        
        request.setAttribute("talents", talents);
        request.getRequestDispatcher("/admin/all-talents.jsp").forward(request, response);
    }

    /**
     * Show all users
     */
    private void showUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<com.youthtalent.model.User> users = userDAO.getAllUsers();
        
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    /**
     * Show reports
     */
    private void showReports(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String status = request.getParameter("status");
        
        List<Report> reports;
        if (status != null && !status.isEmpty()) {
            reports = reportDAO.getReportsByStatus(status);
        } else {
            reports = reportDAO.getAllReports();
        }
        
        request.setAttribute("reports", reports);
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }

    /**
     * Approve talent
     */
    private void approveTalent(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        int adminId = (Integer) session.getAttribute("userId");
        
        String talentIdParam = request.getParameter("talentId");
        int talentId = Integer.parseInt(talentIdParam);
        
        boolean success = talentDAO.updateTalentStatus(talentId, "APPROVED", adminId, null);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/talents/pending?success=Talent approved successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/talents/pending?error=Failed to approve talent");
        }
    }

    /**
     * Reject talent
     */
    private void rejectTalent(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        int adminId = (Integer) session.getAttribute("userId");
        
        String talentIdParam = request.getParameter("talentId");
        String rejectionReason = request.getParameter("rejectionReason");
        
        int talentId = Integer.parseInt(talentIdParam);
        
        boolean success = talentDAO.updateTalentStatus(talentId, "REJECTED", adminId, rejectionReason);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/talents/pending?success=Talent rejected");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/talents/pending?error=Failed to reject talent");
        }
    }

    /**
     * Review report
     */
    private void reviewReport(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        int adminId = (Integer) session.getAttribute("userId");
        
        String reportIdParam = request.getParameter("reportId");
        String status = request.getParameter("status");
        String adminNotes = request.getParameter("adminNotes");
        
        int reportId = Integer.parseInt(reportIdParam);
        
        boolean success = reportDAO.updateReportStatus(reportId, status, adminId, adminNotes);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/reports?success=Report reviewed successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/reports?error=Failed to review report");
        }
    }
}
