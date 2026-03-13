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
        String sql = "INSERT INTO opportunities (employer_id, youth_id, talent_id, title, description, type, status) VALUES (?, ?, ?, ?, ?, ?, 'PENDING')";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, opportunity.getEmployerId());
            stmt.setInt(2, opportunity.getYouthId());
            stmt.setInt(3, opportunity.getTalentId());
            stmt.setString(4, opportunity.getTitle());
            stmt.setString(5, opportunity.getDescription());
            stmt.setString(6, opportunity.getType());

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
                "JOIN talents t ON o.talent_id = t.talent_id " +
                "WHERE o.youth_id = ? ORDER BY o.created_at DESC";

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

    public List<Opportunity> getOpportunitiesByEmployer(int employerId) {
        List<Opportunity> opportunities = new ArrayList<>();
        String sql = "SELECT o.*, e.username AS employer_name, y.username AS youth_name, t.title AS talent_title " +
                "FROM opportunities o " +
                "JOIN users e ON o.employer_id = e.user_id " +
                "JOIN users y ON o.youth_id = y.user_id " +
                "JOIN talents t ON o.talent_id = t.talent_id " +
                "WHERE o.employer_id = ? ORDER BY o.created_at DESC";

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

    public boolean updateOpportunityStatus(int opportunityId, int youthId, String status) {
        String sql = "UPDATE opportunities SET status = ?, responded_at = NOW() WHERE opportunity_id = ? AND youth_id = ? AND status = 'PENDING'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, opportunityId);
            stmt.setInt(3, youthId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public int getOfferCountByEmployer(int employerId) {
        String sql = "SELECT COUNT(*) FROM opportunities WHERE employer_id = ?";

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
        String sql = "SELECT COUNT(*) FROM opportunities WHERE youth_id = ? AND status = 'PENDING'";

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

    private Opportunity extractOpportunity(ResultSet rs) throws SQLException {
        Opportunity opportunity = new Opportunity();
        opportunity.setOpportunityId(rs.getInt("opportunity_id"));
        opportunity.setEmployerId(rs.getInt("employer_id"));
        opportunity.setYouthId(rs.getInt("youth_id"));
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
            opportunity.setTalentTitle(rs.getString("talent_title"));
        } catch (SQLException ignored) {
            // Ignore when select query does not include join aliases.
        }

        return opportunity;
    }
}
