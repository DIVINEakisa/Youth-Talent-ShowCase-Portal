package com.youthtalent.dao;

import com.youthtalent.model.Opportunity;
import com.youthtalent.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Opportunity Data Access Object
 * Handles database operations for opportunity offers
 */
public class OpportunityDAO {

    public boolean createOpportunity(Opportunity opportunity) {
        String sql = "INSERT INTO opportunities (employer_id, youth_id, manager_id, talent_id, title, description, type, status) VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING')";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, opportunity.getEmployerId());
            stmt.setInt(2, opportunity.getYouthId());
            if (opportunity.getManagerId() != null) {
                stmt.setInt(3, opportunity.getManagerId());
            } else {
                stmt.setNull(3, Types.INTEGER);
            }
            stmt.setInt(4, opportunity.getTalentId());
            stmt.setString(5, opportunity.getTitle());
            stmt.setString(6, opportunity.getDescription());
            stmt.setString(7, opportunity.getType());

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    opportunity.setOpportunityId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Opportunity> getOpportunitiesForYouth(int youthId) {
        List<Opportunity> opportunities = new ArrayList<>();
        String sql = "SELECT o.*, e.username AS employer_name, y.username AS youth_name, t.title AS talent_title " +
                "FROM opportunities o " +
                "JOIN users e ON o.employer_id = e.user_id " +
                "JOIN users y ON o.youth_id = y.user_id " +
            "LEFT JOIN users m ON o.manager_id = m.user_id " +
                "JOIN talents t ON o.talent_id = t.talent_id " +
            "WHERE o.youth_id = ? AND o.manager_id IS NULL AND o.is_deleted = false ORDER BY o.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, youthId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                opportunities.add(extractOpportunity(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return opportunities;
    }

    public List<Opportunity> getOpportunitiesForManager(int managerId) {
        List<Opportunity> opportunities = new ArrayList<>();
        String sql = "SELECT o.*, e.username AS employer_name, y.username AS youth_name, m.username AS manager_name, t.title AS talent_title " +
                "FROM opportunities o " +
                "JOIN users e ON o.employer_id = e.user_id " +
                "JOIN users y ON o.youth_id = y.user_id " +
                "LEFT JOIN users m ON o.manager_id = m.user_id " +
                "JOIN talents t ON o.talent_id = t.talent_id " +
                "WHERE o.manager_id = ? AND o.is_deleted = false ORDER BY o.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, managerId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                opportunities.add(extractOpportunity(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return opportunities;
    }

    public List<Opportunity> getOpportunitiesByEmployer(int employerId) {
        List<Opportunity> opportunities = new ArrayList<>();
        String sql = "SELECT o.*, e.username AS employer_name, y.username AS youth_name, t.title AS talent_title " +
                "FROM opportunities o " +
                "JOIN users e ON o.employer_id = e.user_id " +
                "JOIN users y ON o.youth_id = y.user_id " +
            "LEFT JOIN users m ON o.manager_id = m.user_id " +
                "JOIN talents t ON o.talent_id = t.talent_id " +
                "WHERE o.employer_id = ? AND o.is_deleted = false ORDER BY o.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, employerId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                opportunities.add(extractOpportunity(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return opportunities;
    }

    public boolean updateOpportunityStatusForRecipient(int opportunityId, int recipientUserId, String status) {
        String sql = "UPDATE opportunities SET status = ?, responded_at = NOW() " +
                "WHERE opportunity_id = ? AND status = 'PENDING' AND is_deleted = false " +
                "AND ((manager_id IS NULL AND youth_id = ?) OR (manager_id = ?))";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, opportunityId);
            stmt.setInt(3, recipientUserId);
            stmt.setInt(4, recipientUserId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public int getOfferCountByEmployer(int employerId) {
        String sql = "SELECT COUNT(*) FROM opportunities WHERE employer_id = ? AND is_deleted = false";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, employerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int getPendingOfferCountForYouth(int youthId) {
        String sql = "SELECT COUNT(*) FROM opportunities WHERE youth_id = ? AND status = 'PENDING' AND is_deleted = false";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, youthId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int getPendingOfferCountForManager(int managerId) {
        String sql = "SELECT COUNT(*) FROM opportunities WHERE manager_id = ? AND status = 'PENDING' AND is_deleted = false";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, managerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int getTotalOpportunityCount() {
        String sql = "SELECT COUNT(*) FROM opportunities WHERE is_deleted = false";

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

    public int getPendingOpportunityCount() {
        String sql = "SELECT COUNT(*) FROM opportunities WHERE status = 'PENDING' AND is_deleted = false";

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

    public List<Opportunity> getAllOpportunities(String status) {
        List<Opportunity> opportunities = new ArrayList<>();
        String baseSql = "SELECT o.*, e.username AS employer_name, y.username AS youth_name, t.title AS talent_title " +
                "FROM opportunities o " +
                "JOIN users e ON o.employer_id = e.user_id " +
                "JOIN users y ON o.youth_id = y.user_id " +
            "LEFT JOIN users m ON o.manager_id = m.user_id " +
                "JOIN talents t ON o.talent_id = t.talent_id ";

        String sql;
        if ("REMOVED".equals(status)) {
            sql = baseSql + "WHERE o.is_deleted = true ORDER BY o.created_at DESC";
        } else if (status != null && !status.isEmpty()) {
            sql = baseSql + "WHERE o.is_deleted = false AND o.status = ? ORDER BY o.created_at DESC";
        } else {
            sql = baseSql + "WHERE o.is_deleted = false ORDER BY o.created_at DESC";
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (status != null && !status.isEmpty() && !"REMOVED".equals(status)) {
                stmt.setString(1, status);
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                opportunities.add(extractOpportunity(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return opportunities;
    }

    public Opportunity getOpportunityById(int opportunityId) {
        String sql = "SELECT o.*, e.username AS employer_name, y.username AS youth_name, t.title AS talent_title " +
                "FROM opportunities o " +
                "JOIN users e ON o.employer_id = e.user_id " +
                "JOIN users y ON o.youth_id = y.user_id " +
            "LEFT JOIN users m ON o.manager_id = m.user_id " +
                "JOIN talents t ON o.talent_id = t.talent_id " +
                "WHERE o.opportunity_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, opportunityId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractOpportunity(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean softDeleteOpportunity(int opportunityId, int adminId, String reason) {
        String updateSql = "UPDATE opportunities SET is_deleted = true, deleted_by = ?, deleted_at = NOW() " +
                "WHERE opportunity_id = ? AND is_deleted = false";
        String auditSql = "INSERT INTO opportunity_moderation_logs (opportunity_id, admin_id, action, reason) " +
                "VALUES (?, ?, 'SOFT_DELETE', ?)";

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                 PreparedStatement auditStmt = conn.prepareStatement(auditSql)) {

                updateStmt.setInt(1, adminId);
                updateStmt.setInt(2, opportunityId);
                int updated = updateStmt.executeUpdate();

                if (updated == 0) {
                    conn.rollback();
                    return false;
                }

                auditStmt.setInt(1, opportunityId);
                auditStmt.setInt(2, adminId);
                auditStmt.setString(3, reason);
                auditStmt.executeUpdate();

                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    private Opportunity extractOpportunity(ResultSet rs) throws SQLException {
        Opportunity opportunity = new Opportunity();
        opportunity.setOpportunityId(rs.getInt("opportunity_id"));
        opportunity.setEmployerId(rs.getInt("employer_id"));
        opportunity.setYouthId(rs.getInt("youth_id"));
        opportunity.setManagerId((Integer) rs.getObject("manager_id"));
        opportunity.setTalentId(rs.getInt("talent_id"));
        opportunity.setTitle(rs.getString("title"));
        opportunity.setDescription(rs.getString("description"));
        opportunity.setType(rs.getString("type"));
        opportunity.setStatus(rs.getString("status"));
        opportunity.setCreatedAt(rs.getTimestamp("created_at"));
        opportunity.setUpdatedAt(rs.getTimestamp("updated_at"));
        opportunity.setRespondedAt(rs.getTimestamp("responded_at"));

        try {
            opportunity.setEmployerName(rs.getString("employer_name"));
            opportunity.setYouthName(rs.getString("youth_name"));
            opportunity.setManagerName(rs.getString("manager_name"));
            opportunity.setTalentTitle(rs.getString("talent_title"));
        } catch (SQLException ignored) {
            // Ignore when select query does not include join aliases.
        }

        return opportunity;
    }
}
