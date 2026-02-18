package com.youthtalent.model;

import java.sql.Timestamp;

/**
 * Rating Model Class
 * Represents a rating given by a user to a talent
 */
public class Rating {
    private int ratingId;
    private int talentId;
    private int userId;
    private int ratingValue; // 1-5
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Extended fields
    private String username;
    private String talentTitle;

    // Constructors
    public Rating() {
    }

    public Rating(int talentId, int userId, int ratingValue) {
        this.talentId = talentId;
        this.userId = userId;
        this.ratingValue = ratingValue;
    }

    // Getters and Setters
    public int getRatingId() {
        return ratingId;
    }

    public void setRatingId(int ratingId) {
        this.ratingId = ratingId;
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

    public int getRatingValue() {
        return ratingValue;
    }

    public void setRatingValue(int ratingValue) {
        this.ratingValue = ratingValue;
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

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getTalentTitle() {
        return talentTitle;
    }

    public void setTalentTitle(String talentTitle) {
        this.talentTitle = talentTitle;
    }

    // Validation
    public boolean isValid() {
        return ratingValue >= 1 && ratingValue <= 5;
    }

    @Override
    public String toString() {
        return "Rating{" +
                "ratingId=" + ratingId +
                ", talentId=" + talentId +
                ", userId=" + userId +
                ", ratingValue=" + ratingValue +
                '}';
    }
}
