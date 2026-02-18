package com.youthtalent.dao;

import com.youthtalent.model.Rating;
import com.youthtalent.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Rating Data Access Object
 * Handles all database operations for Rating entity
 */
public class RatingDAO {

    /**
     * Add or update a rating
     * @param rating Rating object
     * @return true if successful
     */
    public boolean addOrUpdateRating(Rating rating) {
        // Check if rating already exists
        if (hasUserRatedTalent(rating.getTalentId(), rating.getUserId())) {
            return updateRating(rating);
        } else {
            return createRating(rating);
        }
    }

    /**
     * Create a new rating
     * @param rating Rating object
     * @return true if successful
     */
    private boolean createRating(Rating rating) {
        String sql = "INSERT INTO ratings (talent_id, user_id, rating_value) VALUES (?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, rating.getTalentId());
            stmt.setInt(2, rating.getUserId());
            stmt.setInt(3, rating.getRatingValue());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    rating.setRatingId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update existing rating
     * @param rating Rating object
     * @return true if successful
     */
    private boolean updateRating(Rating rating) {
        String sql = "UPDATE ratings SET rating_value = ? WHERE talent_id = ? AND user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, rating.getRatingValue());
            stmt.setInt(2, rating.getTalentId());
            stmt.setInt(3, rating.getUserId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get rating by talent and user
     * @param talentId Talent ID
     * @param userId User ID
     * @return Rating object or null
     */
    public Rating getRatingByTalentAndUser(int talentId, int userId) {
        String sql = "SELECT r.*, u.username, t.title AS talent_title " +
                     "FROM ratings r " +
                     "JOIN users u ON r.user_id = u.user_id " +
                     "JOIN talents t ON r.talent_id = t.talent_id " +
                     "WHERE r.talent_id = ? AND r.user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, talentId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractRatingFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all ratings for a talent
     * @param talentId Talent ID
     * @return List of ratings
     */
    public List<Rating> getRatingsByTalent(int talentId) {
        List<Rating> ratings = new ArrayList<>();
        String sql = "SELECT r.*, u.username, t.title AS talent_title " +
                     "FROM ratings r " +
                     "JOIN users u ON r.user_id = u.user_id " +
                     "JOIN talents t ON r.talent_id = t.talent_id " +
                     "WHERE r.talent_id = ? " +
                     "ORDER BY r.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, talentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ratings.add(extractRatingFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ratings;
    }

    /**
     * Get all ratings by a user
     * @param userId User ID
     * @return List of ratings
     */
    public List<Rating> getRatingsByUser(int userId) {
        List<Rating> ratings = new ArrayList<>();
        String sql = "SELECT r.*, u.username, t.title AS talent_title " +
                     "FROM ratings r " +
                     "JOIN users u ON r.user_id = u.user_id " +
                     "JOIN talents t ON r.talent_id = t.talent_id " +
                     "WHERE r.user_id = ? " +
                     "ORDER BY r.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ratings.add(extractRatingFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ratings;
    }

    /**
     * Check if user has rated a talent
     * @param talentId Talent ID
     * @param userId User ID
     * @return true if user has rated the talent
     */
    public boolean hasUserRatedTalent(int talentId, int userId) {
        String sql = "SELECT COUNT(*) FROM ratings WHERE talent_id = ? AND user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, talentId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get average rating for a talent
     * @param talentId Talent ID
     * @return Average rating (0 if no ratings)
     */
    public double getAverageRating(int talentId) {
        String sql = "SELECT COALESCE(AVG(rating_value), 0) AS avg_rating FROM ratings WHERE talent_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, talentId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("avg_rating");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * Get rating count for a talent
     * @param talentId Talent ID
     * @return Number of ratings
     */
    public int getRatingCount(int talentId) {
        String sql = "SELECT COUNT(*) FROM ratings WHERE talent_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, talentId);
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
     * Delete a rating
     * @param talentId Talent ID
     * @param userId User ID
     * @return true if successful
     */
    public boolean deleteRating(int talentId, int userId) {
        String sql = "DELETE FROM ratings WHERE talent_id = ? AND user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, talentId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Extract Rating object from ResultSet
     * @param rs ResultSet
     * @return Rating object
     * @throws SQLException
     */
    private Rating extractRatingFromResultSet(ResultSet rs) throws SQLException {
        Rating rating = new Rating();
        rating.setRatingId(rs.getInt("rating_id"));
        rating.setTalentId(rs.getInt("talent_id"));
        rating.setUserId(rs.getInt("user_id"));
        rating.setRatingValue(rs.getInt("rating_value"));
        rating.setCreatedAt(rs.getTimestamp("created_at"));
        rating.setUpdatedAt(rs.getTimestamp("updated_at"));
        rating.setUsername(rs.getString("username"));
        rating.setTalentTitle(rs.getString("talent_title"));
        return rating;
    }
}
