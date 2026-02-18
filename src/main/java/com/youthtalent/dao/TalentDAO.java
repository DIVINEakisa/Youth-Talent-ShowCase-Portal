package com.youthtalent.dao;

import com.youthtalent.model.Talent;
import com.youthtalent.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Talent Data Access Object
 * Handles all database operations for Talent entity
 */
public class TalentDAO {

    /**
     * Create a new talent
     * @param talent Talent object
     * @return true if successful
     */
    public boolean createTalent(Talent talent) {
        String sql = "INSERT INTO talents (user_id, category_id, title, description, image_url, media_url, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, talent.getUserId());
            stmt.setInt(2, talent.getCategoryId());
            stmt.setString(3, talent.getTitle());
            stmt.setString(4, talent.getDescription());
            stmt.setString(5, talent.getImageUrl());
            stmt.setString(6, talent.getMediaUrl());
            stmt.setString(7, talent.getStatus() != null ? talent.getStatus() : "PENDING");
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    talent.setTalentId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get talent by ID with statistics
     * @param talentId Talent ID
     * @return Talent object or null
     */
    public Talent getTalentById(int talentId) {
        String sql = "SELECT t.*, u.username, c.category_name, " +
                     "COALESCE(AVG(r.rating_value), 0) AS average_rating, " +
                     "COUNT(DISTINCT r.rating_id) AS total_ratings, " +
                     "COUNT(DISTINCT cm.comment_id) AS total_comments " +
                     "FROM talents t " +
                     "JOIN users u ON t.user_id = u.user_id " +
                     "JOIN categories c ON t.category_id = c.category_id " +
                     "LEFT JOIN ratings r ON t.talent_id = r.talent_id " +
                     "LEFT JOIN comments cm ON t.talent_id = cm.talent_id " +
                     "WHERE t.talent_id = ? " +
                     "GROUP BY t.talent_id";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, talentId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractTalentFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all approved talents (public view)
     * @return List of approved talents
     */
    public List<Talent> getAllApprovedTalents() {
        return getTalentsByStatus("APPROVED");
    }

    /**
     * Get talents by status
     * @param status Talent status
     * @return List of talents
     */
    public List<Talent> getTalentsByStatus(String status) {
        List<Talent> talents = new ArrayList<>();
        String sql = "SELECT t.*, u.username, c.category_name, " +
                     "COALESCE(AVG(r.rating_value), 0) AS average_rating, " +
                     "COUNT(DISTINCT r.rating_id) AS total_ratings, " +
                     "COUNT(DISTINCT cm.comment_id) AS total_comments " +
                     "FROM talents t " +
                     "JOIN users u ON t.user_id = u.user_id " +
                     "JOIN categories c ON t.category_id = c.category_id " +
                     "LEFT JOIN ratings r ON t.talent_id = r.talent_id " +
                     "LEFT JOIN comments cm ON t.talent_id = cm.talent_id " +
                     "WHERE t.status = ? " +
                     "GROUP BY t.talent_id " +
                     "ORDER BY t.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                talents.add(extractTalentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return talents;
    }

    /**
     * Get talents by user ID
     * @param userId User ID
     * @return List of user's talents
     */
    public List<Talent> getTalentsByUserId(int userId) {
        List<Talent> talents = new ArrayList<>();
        String sql = "SELECT t.*, u.username, c.category_name, " +
                     "COALESCE(AVG(r.rating_value), 0) AS average_rating, " +
                     "COUNT(DISTINCT r.rating_id) AS total_ratings, " +
                     "COUNT(DISTINCT cm.comment_id) AS total_comments " +
                     "FROM talents t " +
                     "JOIN users u ON t.user_id = u.user_id " +
                     "JOIN categories c ON t.category_id = c.category_id " +
                     "LEFT JOIN ratings r ON t.talent_id = r.talent_id " +
                     "LEFT JOIN comments cm ON t.talent_id = cm.talent_id " +
                     "WHERE t.user_id = ? " +
                     "GROUP BY t.talent_id " +
                     "ORDER BY t.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                talents.add(extractTalentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return talents;
    }

    /**
     * Get talents by category
     * @param categoryId Category ID
     * @return List of talents
     */
    public List<Talent> getTalentsByCategory(int categoryId) {
        List<Talent> talents = new ArrayList<>();
        String sql = "SELECT t.*, u.username, c.category_name, " +
                     "COALESCE(AVG(r.rating_value), 0) AS average_rating, " +
                     "COUNT(DISTINCT r.rating_id) AS total_ratings, " +
                     "COUNT(DISTINCT cm.comment_id) AS total_comments " +
                     "FROM talents t " +
                     "JOIN users u ON t.user_id = u.user_id " +
                     "JOIN categories c ON t.category_id = c.category_id " +
                     "LEFT JOIN ratings r ON t.talent_id = r.talent_id " +
                     "LEFT JOIN comments cm ON t.talent_id = cm.talent_id " +
                     "WHERE t.category_id = ? AND t.status = 'APPROVED' " +
                     "GROUP BY t.talent_id " +
                     "ORDER BY t.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                talents.add(extractTalentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return talents;
    }

    /**
     * Search talents by keyword
     * @param keyword Search keyword
     * @return List of matching talents
     */
    public List<Talent> searchTalents(String keyword) {
        List<Talent> talents = new ArrayList<>();
        String sql = "SELECT t.*, u.username, c.category_name, " +
                     "COALESCE(AVG(r.rating_value), 0) AS average_rating, " +
                     "COUNT(DISTINCT r.rating_id) AS total_ratings, " +
                     "COUNT(DISTINCT cm.comment_id) AS total_comments " +
                     "FROM talents t " +
                     "JOIN users u ON t.user_id = u.user_id " +
                     "JOIN categories c ON t.category_id = c.category_id " +
                     "LEFT JOIN ratings r ON t.talent_id = r.talent_id " +
                     "LEFT JOIN comments cm ON t.talent_id = cm.talent_id " +
                     "WHERE t.status = 'APPROVED' AND (t.title LIKE ? OR t.description LIKE ? OR c.category_name LIKE ?) " +
                     "GROUP BY t.talent_id " +
                     "ORDER BY t.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                talents.add(extractTalentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return talents;
    }

    /**
     * Update talent
     * @param talent Talent object
     * @return true if successful
     */
    public boolean updateTalent(Talent talent) {
        String sql = "UPDATE talents SET category_id = ?, title = ?, description = ?, image_url = ?, media_url = ? WHERE talent_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, talent.getCategoryId());
            stmt.setString(2, talent.getTitle());
            stmt.setString(3, talent.getDescription());
            stmt.setString(4, talent.getImageUrl());
            stmt.setString(5, talent.getMediaUrl());
            stmt.setInt(6, talent.getTalentId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update talent status (for approval/rejection)
     * @param talentId Talent ID
     * @param status New status
     * @param approvedBy Admin user ID
     * @param rejectionReason Reason (if rejected)
     * @return true if successful
     */
    public boolean updateTalentStatus(int talentId, String status, int approvedBy, String rejectionReason) {
        String sql = "UPDATE talents SET status = ?, approved_by = ?, approved_at = NOW(), rejection_reason = ? WHERE talent_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, approvedBy);
            stmt.setString(3, rejectionReason);
            stmt.setInt(4, talentId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Increment talent views
     * @param talentId Talent ID
     * @return true if successful
     */
    public boolean incrementViews(int talentId) {
        String sql = "UPDATE talents SET views_count = views_count + 1 WHERE talent_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, talentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete talent
     * @param talentId Talent ID
     * @return true if successful
     */
    public boolean deleteTalent(int talentId) {
        String sql = "DELETE FROM talents WHERE talent_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, talentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get total talent count
     * @return Total talent count
     */
    public int getTotalTalentCount() {
        String sql = "SELECT COUNT(*) FROM talents";
        
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
     * Get count by status
     * @param status Talent status
     * @return Count
     */
    public int getCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM talents WHERE status = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get top rated talents
     * @param limit Number of talents to return
     * @return List of top rated talents
     */
    public List<Talent> getTopRatedTalents(int limit) {
        List<Talent> talents = new ArrayList<>();
        String sql = "SELECT t.*, u.username, c.category_name, " +
                     "COALESCE(AVG(r.rating_value), 0) AS average_rating, " +
                     "COUNT(DISTINCT r.rating_id) AS total_ratings, " +
                     "COUNT(DISTINCT cm.comment_id) AS total_comments " +
                     "FROM talents t " +
                     "JOIN users u ON t.user_id = u.user_id " +
                     "JOIN categories c ON t.category_id = c.category_id " +
                     "LEFT JOIN ratings r ON t.talent_id = r.talent_id " +
                     "LEFT JOIN comments cm ON t.talent_id = cm.talent_id " +
                     "WHERE t.status = 'APPROVED' " +
                     "GROUP BY t.talent_id " +
                     "HAVING total_ratings > 0 " +
                     "ORDER BY average_rating DESC, total_ratings DESC " +
                     "LIMIT ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                talents.add(extractTalentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return talents;
    }

    /**
     * Extract Talent object from ResultSet
     * @param rs ResultSet
     * @return Talent object
     * @throws SQLException
     */
    private Talent extractTalentFromResultSet(ResultSet rs) throws SQLException {
        Talent talent = new Talent();
        talent.setTalentId(rs.getInt("talent_id"));
        talent.setUserId(rs.getInt("user_id"));
        talent.setCategoryId(rs.getInt("category_id"));
        talent.setTitle(rs.getString("title"));
        talent.setDescription(rs.getString("description"));
        talent.setImageUrl(rs.getString("image_url"));
        talent.setMediaUrl(rs.getString("media_url"));
        talent.setStatus(rs.getString("status"));
        talent.setRejectionReason(rs.getString("rejection_reason"));
        
        Integer approvedBy = (Integer) rs.getObject("approved_by");
        talent.setApprovedBy(approvedBy);
        
        talent.setApprovedAt(rs.getTimestamp("approved_at"));
        talent.setCreatedAt(rs.getTimestamp("created_at"));
        talent.setUpdatedAt(rs.getTimestamp("updated_at"));
        talent.setViewsCount(rs.getInt("views_count"));
        
        // Extended fields
        talent.setUsername(rs.getString("username"));
        talent.setCategoryName(rs.getString("category_name"));
        talent.setAverageRating(rs.getDouble("average_rating"));
        talent.setTotalRatings(rs.getInt("total_ratings"));
        talent.setTotalComments(rs.getInt("total_comments"));
        
        // Calculate talent level
        double avgRating = talent.getAverageRating();
        if (avgRating < 2.5) {
            talent.setTalentLevel("Rising Talent");
        } else if (avgRating < 4.5) {
            talent.setTalentLevel("Popular Talent");
        } else {
            talent.setTalentLevel("Top Talent");
        }
        
        return talent;
    }
}
