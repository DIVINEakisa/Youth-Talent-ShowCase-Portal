package com.youthtalent.dao;

import com.youthtalent.model.Comment;
import com.youthtalent.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Comment Data Access Object
 * Handles all database operations for Comment entity
 */
public class CommentDAO {

    /**
     * Create a new comment
     * @param comment Comment object
     * @return true if successful
     */
    public boolean createComment(Comment comment) {
        String sql = "INSERT INTO comments (talent_id, user_id, comment_text) VALUES (?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, comment.getTalentId());
            stmt.setInt(2, comment.getUserId());
            stmt.setString(3, comment.getCommentText());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    comment.setCommentId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get comment by ID
     * @param commentId Comment ID
     * @return Comment object or null
     */
    public Comment getCommentById(int commentId) {
        String sql = "SELECT c.*, u.username, u.profile_image, t.title AS talent_title " +
                     "FROM comments c " +
                     "JOIN users u ON c.user_id = u.user_id " +
                     "JOIN talents t ON c.talent_id = t.talent_id " +
                     "WHERE c.comment_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, commentId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractCommentFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all comments for a talent
     * @param talentId Talent ID
     * @return List of comments
     */
    public List<Comment> getCommentsByTalent(int talentId) {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT c.*, u.username, u.profile_image, t.title AS talent_title " +
                     "FROM comments c " +
                     "JOIN users u ON c.user_id = u.user_id " +
                     "JOIN talents t ON c.talent_id = t.talent_id " +
                     "WHERE c.talent_id = ? " +
                     "ORDER BY c.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, talentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                comments.add(extractCommentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comments;
    }

    /**
     * Get all comments by a user
     * @param userId User ID
     * @return List of comments
     */
    public List<Comment> getCommentsByUser(int userId) {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT c.*, u.username, u.profile_image, t.title AS talent_title " +
                     "FROM comments c " +
                     "JOIN users u ON c.user_id = u.user_id " +
                     "JOIN talents t ON c.talent_id = t.talent_id " +
                     "WHERE c.user_id = ? " +
                     "ORDER BY c.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                comments.add(extractCommentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comments;
    }

    /**
     * Update comment
     * @param comment Comment object
     * @return true if successful
     */
    public boolean updateComment(Comment comment) {
        String sql = "UPDATE comments SET comment_text = ? WHERE comment_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, comment.getCommentText());
            stmt.setInt(2, comment.getCommentId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Flag comment as inappropriate
     * @param commentId Comment ID
     * @return true if successful
     */
    public boolean flagComment(int commentId) {
        String sql = "UPDATE comments SET is_flagged = true WHERE comment_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, commentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete comment
     * @param commentId Comment ID
     * @return true if successful
     */
    public boolean deleteComment(int commentId) {
        String sql = "DELETE FROM comments WHERE comment_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, commentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get comment count for a talent
     * @param talentId Talent ID
     * @return Number of comments
     */
    public int getCommentCount(int talentId) {
        String sql = "SELECT COUNT(*) FROM comments WHERE talent_id = ?";
        
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
     * Get all flagged comments
     * @return List of flagged comments
     */
    public List<Comment> getFlaggedComments() {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT c.*, u.username, u.profile_image, t.title AS talent_title " +
                     "FROM comments c " +
                     "JOIN users u ON c.user_id = u.user_id " +
                     "JOIN talents t ON c.talent_id = t.talent_id " +
                     "WHERE c.is_flagged = true " +
                     "ORDER BY c.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                comments.add(extractCommentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comments;
    }

    /**
     * Extract Comment object from ResultSet
     * @param rs ResultSet
     * @return Comment object
     * @throws SQLException
     */
    private Comment extractCommentFromResultSet(ResultSet rs) throws SQLException {
        Comment comment = new Comment();
        comment.setCommentId(rs.getInt("comment_id"));
        comment.setTalentId(rs.getInt("talent_id"));
        comment.setUserId(rs.getInt("user_id"));
        comment.setCommentText(rs.getString("comment_text"));
        comment.setCreatedAt(rs.getTimestamp("created_at"));
        comment.setUpdatedAt(rs.getTimestamp("updated_at"));
        comment.setFlagged(rs.getBoolean("is_flagged"));
        comment.setUsername(rs.getString("username"));
        comment.setUserProfileImage(rs.getString("profile_image"));
        comment.setTalentTitle(rs.getString("talent_title"));
        return comment;
    }
}
