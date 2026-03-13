<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.youthtalent.model.User" %>
<%@ page import="com.youthtalent.model.Opportunity" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isEmployer()) {
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
    <title>Sent Opportunities - Youth Talent Showcase</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>

    <div class="container py-4">
        <h2 class="mb-3"><i class="fas fa-paper-plane me-2"></i>Sent Opportunities</h2>

        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success"><%= request.getParameter("success") %></div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger"><%= request.getParameter("error") %></div>
        <% } %>

        <div class="card shadow-sm">
            <div class="card-body table-responsive">
                <table class="table table-striped align-middle">
                    <thead>
                    <tr>
                        <th>Opportunity</th>
                        <th>Type</th>
                        <th>Youth</th>
                        <th>Talent</th>
                        <th>Status</th>
                        <th>Sent At</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (opportunities != null && !opportunities.isEmpty()) {
                        for (Opportunity opportunity : opportunities) { %>
                        <tr>
                            <td>
                                <strong><%= opportunity.getTitle() %></strong><br>
                                <small class="text-muted"><%= opportunity.getDescription() %></small>
                            </td>
                            <td><span class="badge bg-secondary"><%= opportunity.getType() %></span></td>
                            <td><%= opportunity.getYouthName() %></td>
                            <td><%= opportunity.getTalentTitle() %></td>
                            <td>
                                <% if ("PENDING".equals(opportunity.getStatus())) { %>
                                    <span class="badge bg-warning text-dark">PENDING</span>
                                <% } else if ("ACCEPTED".equals(opportunity.getStatus())) { %>
                                    <span class="badge bg-success">ACCEPTED</span>
                                <% } else { %>
                                    <span class="badge bg-danger">REJECTED</span>
                                <% } %>
                            </td>
                            <td><%= opportunity.getCreatedAt() %></td>
                        </tr>
                    <% }
                    } else { %>
                        <tr>
                            <td colspan="6" class="text-center text-muted py-4">No opportunities sent yet.</td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
