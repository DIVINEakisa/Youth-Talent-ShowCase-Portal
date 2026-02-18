package com.youthtalent.dao;

import com.youthtalent.model.Report;
import com.youthtalent.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Report Data Access Object
 * Handles all database operations for Report entity
 */
public class ReportDAO {

    /**
     * Create a new report
     * @param report Report object
     * @return true if successful
     */
    public boolean createReport(Report report) {
        String sql = "INSERT INTO reports (reporter_id, reported_item_type, reported_item_id, report_reason, status) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, report.getReporterId());
            stmt.setString(2, report.getReportedItemType());
            stmt.setInt(3, report.getReportedItemId());
            stmt.setString(4, report.getReportReason());
            stmt.setString(5, report.getStatus());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    report.setReportId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get report by ID
     * @param reportId Report ID
     * @return Report object or null
     */
    public Report getReportById(int reportId) {
        String sql = "SELECT r.*, u1.username AS reporter_username, u2.username AS reviewer_username " +
                     "FROM reports r " +
                     "JOIN users u1 ON r.reporter_id = u1.user_id " +
                     "LEFT JOIN users u2 ON r.reviewed_by = u2.user_id " +
                     "WHERE r.report_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, reportId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractReportFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all reports
     * @return List of reports
     */
    public List<Report> getAllReports() {
        List<Report> reports = new ArrayList<>();
        String sql = "SELECT r.*, u1.username AS reporter_username, u2.username AS reviewer_username " +
                     "FROM reports r " +
                     "JOIN users u1 ON r.reporter_id = u1.user_id " +
                     "LEFT JOIN users u2 ON r.reviewed_by = u2.user_id " +
                     "ORDER BY r.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                reports.add(extractReportFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reports;
    }

    /**
     * Get reports by status
     * @param status Report status
     * @return List of reports
     */
    public List<Report> getReportsByStatus(String status) {
        List<Report> reports = new ArrayList<>();
        String sql = "SELECT r.*, u1.username AS reporter_username, u2.username AS reviewer_username " +
                     "FROM reports r " +
                     "JOIN users u1 ON r.reporter_id = u1.user_id " +
                     "LEFT JOIN users u2 ON r.reviewed_by = u2.user_id " +
                     "WHERE r.status = ? " +
                     "ORDER BY r.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                reports.add(extractReportFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reports;
    }

    /**
     * Update report status
     * @param reportId Report ID
     * @param status New status
     * @param reviewedBy Admin user ID
     * @param adminNotes Admin notes
     * @return true if successful
     */
    public boolean updateReportStatus(int reportId, String status, int reviewedBy, String adminNotes) {
        String sql = "UPDATE reports SET status = ?, reviewed_by = ?, admin_notes = ? WHERE report_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, reviewedBy);
            stmt.setString(3, adminNotes);
            stmt.setInt(4, reportId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete report
     * @param reportId Report ID
     * @return true if successful
     */
    public boolean deleteReport(int reportId) {
        String sql = "DELETE FROM reports WHERE report_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, reportId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get pending reports count
     * @return Count of pending reports
     */
    public int getPendingReportsCount() {
        String sql = "SELECT COUNT(*) FROM reports WHERE status = 'PENDING'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Extract Report object from ResultSet
     * @param rs ResultSet
     * @return Report object
     * @throws SQLException
     */
    private Report extractReportFromResultSet(ResultSet rs) throws SQLException {
        Report report = new Report();
        report.setReportId(rs.getInt("report_id"));
        report.setReporterId(rs.getInt("reporter_id"));
        report.setReportedItemType(rs.getString("reported_item_type"));
        report.setReportedItemId(rs.getInt("reported_item_id"));
        report.setReportReason(rs.getString("report_reason"));
        report.setStatus(rs.getString("status"));
        report.setAdminNotes(rs.getString("admin_notes"));
        
        Integer reviewedBy = (Integer) rs.getObject("reviewed_by");
        report.setReviewedBy(reviewedBy);
        
        report.setCreatedAt(rs.getTimestamp("created_at"));
        report.setUpdatedAt(rs.getTimestamp("updated_at"));
        report.setReporterUsername(rs.getString("reporter_username"));
        report.setReviewerUsername(rs.getString("reviewer_username"));
        return report;
    }
}
