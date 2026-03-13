<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.youthtalent.model.User" %>
<%@ page import="com.youthtalent.model.Talent" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isEmployer()) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }

    Talent talent = (Talent) request.getAttribute("talent");
    if (talent == null) {
        response.sendRedirect(request.getContextPath() + "/opportunity/talents?error=Talent not found");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Send Opportunity - Youth Talent Showcase</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>

    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-sm">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0"><i class="fas fa-paper-plane me-2"></i>Send Opportunity</h4>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-light border">
                            <strong>Talent:</strong> <%= talent.getTitle() %><br>
                            <strong>Youth Creator:</strong> <%= talent.getUsername() %><br>
                            <strong>Category:</strong> <%= talent.getCategoryName() %>
                        </div>

                        <form method="post" action="${pageContext.request.contextPath}/opportunity/send">
                            <input type="hidden" name="talentId" value="<%= talent.getTalentId() %>">

                            <div class="mb-3">
                                <label class="form-label">Opportunity Title *</label>
                                <input class="form-control" type="text" name="title" maxlength="200" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Type *</label>
                                <select class="form-select" name="type" required>
                                    <option value="JOB">Job Opportunity</option>
                                    <option value="SPONSORSHIP">Sponsorship</option>
                                    <option value="COLLABORATION">Collaboration</option>
                                    <option value="MENTORSHIP">Mentorship</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Description *</label>
                                <textarea class="form-control" name="description" rows="6" required
                                          placeholder="Describe the opportunity details, expectations, and next steps."></textarea>
                            </div>

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-paper-plane me-1"></i>Send Offer
                                </button>
                                <a href="${pageContext.request.contextPath}/opportunity/talents" class="btn btn-outline-secondary">
                                    Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
