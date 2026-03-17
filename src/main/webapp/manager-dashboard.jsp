<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.youthtalent.model.User" %>
<%@ page import="com.youthtalent.dao.TalentDAO" %>
<%@ page import="com.youthtalent.dao.OpportunityDAO" %>
<%@ page import="com.youthtalent.model.Talent" %>
<%@ page import="com.youthtalent.model.Opportunity" %>
<%@ page import="java.util.LinkedHashSet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }

    if (!user.isTalentManager()) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        return;
    }

    TalentDAO talentDAO = new TalentDAO();
    OpportunityDAO opportunityDAO = new OpportunityDAO();

    List<Talent> managedTalents = talentDAO.getTalentsByManagerId(user.getUserId());
    List<Opportunity> managerOffers = opportunityDAO.getOpportunitiesForManager(user.getUserId());

    int managedTalentCount = managedTalents.size();
    int pendingOffers = 0;
    int acceptedOffers = 0;
    int rejectedOffers = 0;
    Set<Integer> managedYouthIds = new LinkedHashSet<>();

    for (Talent talent : managedTalents) {
        managedYouthIds.add(talent.getUserId());
    }

    for (Opportunity opportunity : managerOffers) {
        if ("PENDING".equals(opportunity.getStatus())) {
            pendingOffers++;
        } else if ("ACCEPTED".equals(opportunity.getStatus())) {
            acceptedOffers++;
        } else if ("REJECTED".equals(opportunity.getStatus())) {
            rejectedOffers++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Talent Manager Dashboard - Youth Talent Showcase</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-green: #198754;
            --light-green: #20c997;
            --soft-bg: #f8f9fa;
        }

        body {
            background-color: var(--soft-bg);
        }

        .hero {
            background: linear-gradient(135deg, var(--primary-green), var(--light-green));
            color: white;
            padding: 48px 0;
            margin-bottom: 32px;
        }

        .summary-card {
            border: none;
            border-radius: 14px;
            box-shadow: 0 10px 24px rgba(0, 0, 0, 0.08);
            height: 100%;
        }

        .summary-icon {
            width: 54px;
            height: 54px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(25, 135, 84, 0.12);
            color: var(--primary-green);
            font-size: 1.35rem;
        }

        .action-card,
        .list-card {
            border: none;
            border-radius: 14px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.06);
        }

        .section-title {
            font-weight: 700;
            margin-bottom: 16px;
        }

        .badge-soft {
            background-color: #e9f7ef;
            color: #146c43;
        }
    </style>
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>

    <div class="hero">
        <div class="container">
            <h1 class="display-6 mb-2"><i class="fas fa-users-cog me-2"></i>Talent Manager Dashboard</h1>
            <p class="lead mb-0">Manage assigned youth talents, review routed offers, and keep track of outcomes.</p>
        </div>
    </div>

    <div class="container pb-5">
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="card summary-card">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted">Managed Talents</div>
                            <h2 class="mb-0"><%= managedTalentCount %></h2>
                        </div>
                        <span class="summary-icon"><i class="fas fa-folder-open"></i></span>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card summary-card">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted">Managed Youth</div>
                            <h2 class="mb-0"><%= managedYouthIds.size() %></h2>
                        </div>
                        <span class="summary-icon"><i class="fas fa-user-friends"></i></span>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card summary-card">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted">Pending Offers</div>
                            <h2 class="mb-0"><%= pendingOffers %></h2>
                        </div>
                        <span class="summary-icon"><i class="fas fa-inbox"></i></span>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card summary-card">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted">Offer Decisions</div>
                            <h2 class="mb-0"><%= acceptedOffers + rejectedOffers %></h2>
                        </div>
                        <span class="summary-icon"><i class="fas fa-clipboard-check"></i></span>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-lg-4">
                <div class="card action-card h-100">
                    <div class="card-body">
                        <h5 class="section-title">Talent Management</h5>
                        <p class="text-muted">Open assigned youth profiles, edit submissions, and keep the managed talent list current.</p>
                        <a href="${pageContext.request.contextPath}/talent/my-talents" class="btn btn-success">
                            <i class="fas fa-folder me-1"></i>Manage Talents
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="card action-card h-100">
                    <div class="card-body">
                        <h5 class="section-title">Add Talent for Youth</h5>
                        <p class="text-muted">Create a new talent entry and assign it to one of the youth profiles under your supervision.</p>
                        <a href="${pageContext.request.contextPath}/talent/add" class="btn btn-outline-success">
                            <i class="fas fa-plus-circle me-1"></i>Add Talent Entry
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="card action-card h-100">
                    <div class="card-body">
                        <h5 class="section-title">Manager Offers</h5>
                        <p class="text-muted">Review routed opportunities from employers and record the decision for managed youth.</p>
                        <a href="${pageContext.request.contextPath}/opportunity/received" class="btn btn-outline-success">
                            <i class="fas fa-inbox me-1"></i>Review Offers
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-7">
                <div class="card list-card h-100">
                    <div class="card-body">
                        <h5 class="section-title">Assigned Talents</h5>
                        <% if (managedTalents.isEmpty()) { %>
                            <div class="alert alert-info mb-0">No talents are currently assigned to you.</div>
                        <% } else { %>
                            <div class="table-responsive">
                                <table class="table align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th>Talent</th>
                                            <th>Youth</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <% for (Talent talent : managedTalents) { %>
                                        <tr>
                                            <td>
                                                <strong><%= talent.getTitle() %></strong><br>
                                                <small class="text-muted"><%= talent.getCategoryName() %></small>
                                            </td>
                                            <td><%= talent.getUsername() %></td>
                                            <td><span class="badge badge-soft"><%= talent.getStatus() %></span></td>
                                        </tr>
                                    <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
            <div class="col-lg-5">
                <div class="card list-card h-100">
                    <div class="card-body">
                        <h5 class="section-title">Recent Routed Offers</h5>
                        <% if (managerOffers.isEmpty()) { %>
                            <div class="alert alert-info mb-0">No employer offers have been routed to you yet.</div>
                        <% } else { %>
                            <% for (Opportunity opportunity : managerOffers) { %>
                                <div class="border rounded p-3 mb-3">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <strong><%= opportunity.getTitle() %></strong>
                                        <span class="badge bg-secondary"><%= opportunity.getStatus() %></span>
                                    </div>
                                    <div class="small text-muted mb-1">Youth: <%= opportunity.getYouthName() %></div>
                                    <div class="small text-muted mb-2">Talent: <%= opportunity.getTalentTitle() %></div>
                                    <div class="small"><%= opportunity.getEmployerName() %></div>
                                </div>
                            <% } %>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>