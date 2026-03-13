package com.youthtalent.controller;

import com.youthtalent.dao.CategoryDAO;
import com.youthtalent.dao.OpportunityDAO;
import com.youthtalent.dao.TalentDAO;
import com.youthtalent.model.Opportunity;
import com.youthtalent.model.Talent;
import com.youthtalent.model.User;
import com.youthtalent.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Opportunity Servlet
 * Handles employer offers and youth responses
 */
public class OpportunityServlet extends HttpServlet {

    private OpportunityDAO opportunityDAO;
    private TalentDAO talentDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        opportunityDAO = new OpportunityDAO();
        talentDAO = new TalentDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || "/".equals(pathInfo)) {
            routeDefault(request, response);
            return;
        }

        switch (pathInfo) {
            case "/talents":
                browseApprovedTalents(request, response);
                break;
            case "/search":
                browseApprovedTalents(request, response);
                break;
            case "/send-form":
                showSendForm(request, response);
                break;
            case "/sent":
                showSentOffers(request, response);
                break;
            case "/received":
                showReceivedOffers(request, response);
                break;
            default:
                routeDefault(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null) {
            routeDefault(request, response);
            return;
        }

        switch (pathInfo) {
            case "/send":
                sendOffer(request, response);
                break;
            case "/respond":
                respondToOffer(request, response);
                break;
            default:
                routeDefault(request, response);
        }
    }

    private void routeDefault(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.isEmployer()) {
            response.sendRedirect(request.getContextPath() + "/opportunity/talents");
        } else {
            response.sendRedirect(request.getContextPath() + "/opportunity/received");
        }
    }

    private boolean requireLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return false;
        }
        return true;
    }

    private boolean requireEmployer(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!requireLogin(request, response)) {
            return false;
        }

        User user = (User) request.getSession(false).getAttribute("user");
        if (!user.isEmployer()) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=Employer access required");
            return false;
        }
        return true;
    }

    private boolean requireYouth(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!requireLogin(request, response)) {
            return false;
        }

        User user = (User) request.getSession(false).getAttribute("user");
        if (user.isEmployer() || user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=Youth access required");
            return false;
        }
        return true;
    }

    private void browseApprovedTalents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireEmployer(request, response)) {
            return;
        }

        String keyword = request.getParameter("keyword");
        List<Talent> talents;
        if (ValidationUtil.isNotEmpty(keyword)) {
            talents = talentDAO.searchTalents(keyword);
        } else {
            talents = talentDAO.getAllApprovedTalents();
        }

        request.setAttribute("talents", talents);
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/employer-talents.jsp").forward(request, response);
    }

    private void showSendForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireEmployer(request, response)) {
            return;
        }

        String talentIdParam = request.getParameter("talentId");
        if (!ValidationUtil.isNotEmpty(talentIdParam)) {
            response.sendRedirect(request.getContextPath() + "/opportunity/talents?error=Talent is required");
            return;
        }

        int talentId = Integer.parseInt(talentIdParam);
        Talent talent = talentDAO.getTalentById(talentId);

        if (talent == null || !talent.isApproved()) {
            response.sendRedirect(request.getContextPath() + "/opportunity/talents?error=You can only send offers to approved talents");
            return;
        }

        request.setAttribute("talent", talent);
        request.getRequestDispatcher("/send-opportunity.jsp").forward(request, response);
    }

    private void sendOffer(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        if (!requireEmployer(request, response)) {
            return;
        }

        HttpSession session = request.getSession(false);
        User employer = (User) session.getAttribute("user");

        String talentIdParam = request.getParameter("talentId");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String type = request.getParameter("type");

        if (!ValidationUtil.isNotEmpty(talentIdParam) || !ValidationUtil.isNotEmpty(title)
                || !ValidationUtil.isNotEmpty(description) || !ValidationUtil.isNotEmpty(type)) {
            response.sendRedirect(request.getContextPath() + "/opportunity/talents?error=All offer fields are required");
            return;
        }

        int talentId = Integer.parseInt(talentIdParam);
        Talent talent = talentDAO.getTalentById(talentId);
        if (talent == null || !talent.isApproved()) {
            response.sendRedirect(request.getContextPath() + "/opportunity/talents?error=Invalid approved talent selected");
            return;
        }

        String normalizedType = type.toUpperCase();
        if (!("JOB".equals(normalizedType)
                || "SPONSORSHIP".equals(normalizedType)
                || "COLLABORATION".equals(normalizedType)
                || "MENTORSHIP".equals(normalizedType))) {
            response.sendRedirect(request.getContextPath() + "/opportunity/talents?error=Invalid opportunity type");
            return;
        }

        Opportunity opportunity = new Opportunity();
        opportunity.setEmployerId(employer.getUserId());
        opportunity.setYouthId(talent.getUserId());
        opportunity.setTalentId(talent.getTalentId());
        opportunity.setTitle(title.trim());
        opportunity.setDescription(description.trim());
        opportunity.setType(normalizedType);

        boolean success = opportunityDAO.createOpportunity(opportunity);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/opportunity/sent?success=Opportunity sent successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/opportunity/talents?error=Failed to send opportunity");
        }
    }

    private void showSentOffers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireEmployer(request, response)) {
            return;
        }

        User employer = (User) request.getSession(false).getAttribute("user");
        List<Opportunity> opportunities = opportunityDAO.getOpportunitiesByEmployer(employer.getUserId());
        request.setAttribute("opportunities", opportunities);
        request.getRequestDispatcher("/sent-opportunities.jsp").forward(request, response);
    }

    private void showReceivedOffers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireYouth(request, response)) {
            return;
        }

        User youth = (User) request.getSession(false).getAttribute("user");
        List<Opportunity> opportunities = opportunityDAO.getOpportunitiesForYouth(youth.getUserId());
        request.setAttribute("opportunities", opportunities);
        request.getRequestDispatcher("/received-opportunities.jsp").forward(request, response);
    }

    private void respondToOffer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!requireYouth(request, response)) {
            return;
        }

        String offerIdParam = request.getParameter("opportunityId");
        String status = request.getParameter("status");

        if (!ValidationUtil.isNotEmpty(offerIdParam) || !ValidationUtil.isNotEmpty(status)) {
            response.sendRedirect(request.getContextPath() + "/opportunity/received?error=Invalid response");
            return;
        }

        String normalizedStatus = status.toUpperCase();
        if (!("ACCEPTED".equals(normalizedStatus) || "REJECTED".equals(normalizedStatus))) {
            response.sendRedirect(request.getContextPath() + "/opportunity/received?error=Invalid status");
            return;
        }

        int opportunityId = Integer.parseInt(offerIdParam);
        User youth = (User) request.getSession(false).getAttribute("user");
        boolean success = opportunityDAO.updateOpportunityStatus(opportunityId, youth.getUserId(), normalizedStatus);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/opportunity/received?success=Opportunity updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/opportunity/received?error=Unable to update opportunity");
        }
    }
}
