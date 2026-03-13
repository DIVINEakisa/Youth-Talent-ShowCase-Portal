<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.youthtalent.model.User" %>
<%@ page import="com.youthtalent.model.Talent" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isEmployer()) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }

    List<Talent> talents = (List<Talent>) request.getAttribute("talents");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hire Talents - Youth Talent Showcase</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-green: #198754;
            --dark-green: #146c43;
        }

        .header-band {
            background: linear-gradient(135deg, var(--primary-green), var(--dark-green));
            color: #fff;
            padding: 40px 0;
            margin-bottom: 30px;
        }

        .talent-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            height: 100%;
        }

        .talent-image {
            width: 100%;
            height: 190px;
            object-fit: cover;
        }

        .btn-green {
            background: var(--primary-green);
            color: #fff;
            border: none;
        }

        .btn-green:hover {
            background: var(--dark-green);
            color: #fff;
        }
    </style>
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>

    <div class="header-band">
        <div class="container">
            <h1><i class="fas fa-briefcase me-2"></i>Find Youth Talent</h1>
            <p class="mb-0">Browse approved showcases and send opportunities directly to creators.</p>
        </div>
    </div>

    <div class="container mb-5">
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger"><%= request.getParameter("error") %></div>
        <% } %>
        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success"><%= request.getParameter("success") %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/opportunity/search" method="get" class="row g-2 mb-4">
            <div class="col-md-10">
                <input class="form-control form-control-lg" type="text" name="keyword"
                       value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>"
                       placeholder="Search approved talents by title, description, or category">
            </div>
            <div class="col-md-2 d-grid">
                <button type="submit" class="btn btn-green btn-lg">
                    <i class="fas fa-search me-1"></i>Search
                </button>
            </div>
        </form>

        <div class="row g-4">
            <% if (talents != null && !talents.isEmpty()) {
                for (Talent talent : talents) { %>
                <div class="col-md-4">
                    <div class="card talent-card">
                        <% if (talent.getImageUrl() != null && !talent.getImageUrl().isEmpty()) { %>
                            <img src="<%= talent.getImageUrl() %>" class="talent-image" alt="<%= talent.getTitle() %>"
                                 onerror="this.onerror=null; this.src='https://via.placeholder.com/640x360?text=Talent';">
                        <% } %>
                        <div class="card-body">
                            <span class="badge bg-success mb-2"><%= talent.getCategoryName() %></span>
                            <h5 class="card-title"><%= talent.getTitle() %></h5>
                            <p class="text-muted small mb-2">By <strong><%= talent.getUsername() %></strong></p>
                            <p class="card-text">
                                <%= talent.getDescription() != null && talent.getDescription().length() > 120
                                        ? talent.getDescription().substring(0, 120) + "..."
                                        : talent.getDescription() %>
                            </p>
                            <div class="d-grid gap-2">
                                <a href="${pageContext.request.contextPath}/talent/view?id=<%= talent.getTalentId() %>" class="btn btn-outline-secondary btn-sm">
                                    <i class="fas fa-eye me-1"></i>View Talent
                                </a>
                                <a href="${pageContext.request.contextPath}/opportunity/send-form?talentId=<%= talent.getTalentId() %>" class="btn btn-green btn-sm">
                                    <i class="fas fa-paper-plane me-1"></i>Send Opportunity
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            <% }
            } else { %>
                <div class="col-12">
                    <div class="alert alert-info">No approved talents matched your search.</div>
                </div>
            <% } %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
