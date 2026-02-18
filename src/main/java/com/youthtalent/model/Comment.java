package com.youthtalent.model;

import java.sql.Timestamp;

/**
 * Comment Model Class
 * Represents a comment on a talent
 */
public class Comment {
    private int commentId;
    private int talentId;
    private int userId;
    private String commentText;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private boolean isFlagged;

    // Extended fields
    private String username;
    private String userProfileImage;
    private String talentTitle;

    // Constructors
    public Comment() {
    }

    public Comment(int talentId, int userId, String commentText) {
        this.talentId = talentId;
        this.userId = userId;
        this.commentText = commentText;
    }

    // Getters and Setters
    public int getCommentId() {
        return commentId;
    }

    public void setCommentId(int commentId) {
        this.commentId = commentId;
    }

    public int getTalentId() {
        return talentId;
    }

    public void setTalentId(int talentId) {
        this.talentId = talentId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getCommentText() {
        return commentText;
    }

    public void setCommentText(String commentText) {
        this.commentText = commentText;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isFlagged() {
        return isFlagged;
    }

    public void setFlagged(boolean flagged) {
        isFlagged = flagged;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getUserProfileImage() {
        return userProfileImage;
    }

    public void setUserProfileImage(String userProfileImage) {
        this.userProfileImage = userProfileImage;
    }

    public String getTalentTitle() {
        return talentTitle;
    }

    public void setTalentTitle(String talentTitle) {
        this.talentTitle = talentTitle;
    }

    @Override
    public String toString() {
        return "Comment{" +
                "commentId=" + commentId +
                ", talentId=" + talentId +
                ", userId=" + userId +
                ", commentText='" + commentText + '\'' +
                '}';
    }
}
