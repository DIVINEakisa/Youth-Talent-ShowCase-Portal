package com.youthtalent.model;

import java.sql.Timestamp;

/**
 * Talent Model Class
 * Represents a talent showcase entry
 */
public class Talent {
    private int talentId;
    private int userId;
    private int categoryId;
    private String title;
    private String description;
    private String imageUrl;
    private String mediaUrl;
    private String status; // PENDING, APPROVED, REJECTED
    private String rejectionReason;
    private Integer approvedBy;
    private Timestamp approvedAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private int viewsCount;

    // Extended fields (from joins)
    private String username;
    private String categoryName;
    private double averageRating;
    private int totalRatings;
    private int totalComments;
    private String talentLevel;

    // Constructors
    public Talent() {
    }

    public Talent(int talentId, String title, String description, String status) {
        this.talentId = talentId;
        this.title = title;
        this.description = description;
        this.status = status;
    }

    // Getters and Setters
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

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getMediaUrl() {
        return mediaUrl;
    }

    public void setMediaUrl(String mediaUrl) {
        this.mediaUrl = mediaUrl;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public Integer getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
    }

    public Timestamp getApprovedAt() {
        return approvedAt;
    }

    public void setApprovedAt(Timestamp approvedAt) {
        this.approvedAt = approvedAt;
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

    public int getViewsCount() {
        return viewsCount;
    }

    public void setViewsCount(int viewsCount) {
        this.viewsCount = viewsCount;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }

    public int getTotalRatings() {
        return totalRatings;
    }

    public void setTotalRatings(int totalRatings) {
        this.totalRatings = totalRatings;
    }

    public int getTotalComments() {
        return totalComments;
    }

    public void setTotalComments(int totalComments) {
        this.totalComments = totalComments;
    }

    public String getTalentLevel() {
        return talentLevel;
    }

    public void setTalentLevel(String talentLevel) {
        this.talentLevel = talentLevel;
    }

    // Helper methods
    public boolean isPending() {
        return "PENDING".equals(status);
    }

    public boolean isApproved() {
        return "APPROVED".equals(status);
    }

    public boolean isRejected() {
        return "REJECTED".equals(status);
    }

    @Override
    public String toString() {
        return "Talent{" +
                "talentId=" + talentId +
                ", title='" + title + '\'' +
                ", status='" + status + '\'' +
                ", categoryName='" + categoryName + '\'' +
                '}';
    }
}
