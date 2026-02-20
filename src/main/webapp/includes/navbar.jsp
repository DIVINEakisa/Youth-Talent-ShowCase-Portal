<%@ page import="com.youthtalent.model.User" %>
<%
    // User variable is expected to be declared in the parent JSP
    String currentPage = request.getParameter("page") != null ? request.getParameter("page") : "";
%>
<nav class="navbar navbar-expand-lg navbar-dark" style="background-color: #198754;">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard.jsp">
            <i class="fas fa-star me-2"></i>Youth Talent Portal
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <% if (user != null) { %>
                <li class="nav-item">
                    <a class="nav-link <%= "dashboard".equals(currentPage) ? "active" : "" %>" 
                       href="${pageContext.request.contextPath}/dashboard.jsp">
                        <i class="fas fa-home me-1"></i>Dashboard
                    </a>
                </li>
                <% } %>
                <li class="nav-item">
                    <a class="nav-link <%= "talents".equals(currentPage) ? "active" : "" %>" 
                       href="${pageContext.request.contextPath}/talent/list">
                        <i class="fas fa-trophy me-1"></i>Explore Talents
                    </a>
                </li>
                <% if (user != null) { %>
                <li class="nav-item">
                    <a class="nav-link <%= "mytalents".equals(currentPage) ? "active" : "" %>" 
                       href="${pageContext.request.contextPath}/talent/my-talents">
                        <i class="fas fa-folder me-1"></i>My Talents
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/talent/add">
                        <i class="fas fa-plus-circle me-1"></i>Add Talent
                    </a>
                </li>
                <% if (user.isAdmin()) { %>
                <li class="nav-item">
                    <a class="nav-link <%= "admin".equals(currentPage) ? "active" : "" %>" 
                       href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="fas fa-shield-alt me-1"></i>Admin Panel
                    </a>
                </li>
                <% } %>
                <% } %>
            </ul>
            <ul class="navbar-nav">
                <% if (user != null) { %>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" 
                       data-bs-toggle="dropdown">
                        <i class="fas fa-user-circle me-1"></i><%= user.getUsername() %>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="#">
                            <i class="fas fa-user me-2"></i>Profile
                        </a></li>
                        <li><a class="dropdown-item" href="#">
                            <i class="fas fa-cog me-2"></i>Settings
                        </a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" 
                               href="${pageContext.request.contextPath}/auth/logout">
                            <i class="fas fa-sign-out-alt me-2"></i>Logout
                        </a></li>
                    </ul>
                </li>
                <% } else { %>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/auth/login">
                        <i class="fas fa-sign-in-alt me-1"></i>Login
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/auth/register">
                        <i class="fas fa-user-plus me-1"></i>Register
                    </a>
                </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>
