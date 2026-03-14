<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.youthtalent.model.User" %>
<%@ page import="com.youthtalent.model.Opportunity" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.isEmployer() || user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }

    List<Opportunity> opportunities = (List<Opportunity>) request.getAttribute("opportunities");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Opportunities - Youth Talent Showcase</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>

    <div class="container py-4">
        <h2 class="mb-3"><i class="fas fa-inbox me-2"></i>
            <%= user.isTalentManager() ? "Managed Talent Opportunities" : "My Opportunities" %>
        </h2>

        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success"><%= request.getParameter("success") %></div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger"><%= request.getParameter("error") %></div>
        <% } %>

        <div class="row g-4">
            <% if (opportunities != null && !opportunities.isEmpty()) {
                for (Opportunity opportunity : opportunities) { %>
                <div class="col-md-6">
                    <div class="card shadow-sm h-100">
                        <div class="card-body">
                            <h5 class="card-title"><%= opportunity.getTitle() %></h5>
                            <p class="mb-2">
                                <span class="badge bg-secondary me-2"><%= opportunity.getType() %></span>
                                <% if ("PENDING".equals(opportunity.getStatus())) { %>
                                    <span class="badge bg-warning text-dark">PENDING</span>
                                <% } else if ("ACCEPTED".equals(opportunity.getStatus())) { %>
                                    <span class="badge bg-success">ACCEPTED</span>
                                <% } else { %>
                                    <span class="badge bg-danger">REJECTED</span>
                                <% } %>
                            </p>
                            <p class="mb-2"><strong>From:</strong> <%= opportunity.getEmployerName() %></p>
                            <p class="mb-2"><strong>For Talent:</strong> <%= opportunity.getTalentTitle() %></p>
                            <% if (user.isTalentManager()) { %>
                                <p class="mb-2"><strong>Youth:</strong> <%= opportunity.getRecipientUsername() %></p>
                            <% } %>
                            <p class="card-text"><%= opportunity.getDescription() %></p>

                            <% if ("PENDING".equals(opportunity.getStatus())) { %>
                                <div class="d-flex gap-2 mt-3">
                                    <form method="post" action="${pageContext.request.contextPath}/opportunity/respond" class="m-0">
                                        <input type="hidden" name="opportunityId" value="<%= opportunity.getOpportunityId() %>">
                                        <input type="hidden" name="status" value="ACCEPTED">
                                        <button type="submit" class="btn btn-success btn-sm">
                                            <i class="fas fa-check me-1"></i>Accept
                                        </button>
                                    </form>

                                    <form method="post" action="${pageContext.request.contextPath}/opportunity/respond" class="m-0">
                                        <input type="hidden" name="opportunityId" value="<%= opportunity.getOpportunityId() %>">
                                        <input type="hidden" name="status" value="REJECTED">
                                        <button type="submit" class="btn btn-outline-danger btn-sm">
                                            <i class="fas fa-times me-1"></i>Reject
                                        </button>
                                    </form>
                                </div>
                            <% } %>
                        </div>
                        <div class="card-footer bg-white text-muted small">
                            Sent on <%= opportunity.getCreatedAt() %>
                        </div>
                    </div>
                </div>
            <% }
            } else { %>
                <div class="col-12">
                    <div class="alert alert-info">No opportunities received yet.</div>
                </div>
            <% } %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
