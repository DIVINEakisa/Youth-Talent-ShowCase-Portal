package com.youthtalent.controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Manager Servlet
 * Handles talent manager dashboard routing
 */
public class ManagerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"TALENT_MANAGER".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=Unauthorized access");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || "/".equals(pathInfo) || "/dashboard".equals(pathInfo)) {
            request.getRequestDispatcher("/manager-dashboard.jsp").forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/manager/dashboard");
    }
}