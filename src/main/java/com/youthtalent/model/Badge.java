package com.youthtalent.model;

import java.sql.Timestamp;

/**
 * Badge Model Class
 * Represents an achievement badge
 */
public class Badge {
    private int badgeId;
    private String badgeName;
    private String description;
    private String badgeIcon;
    private String criteria;
    private Timestamp createdAt;

    // Constructors
    public Badge() {
    }

    public Badge(int badgeId, String badgeName, String description) {
        this.badgeId = badgeId;
        this.badgeName = badgeName;
        this.description = description;
    }

    // Getters and Setters
    public int getBadgeId() {
        return badgeId;
    }

    public void setBadgeId(int badgeId) {
        this.badgeId = badgeId;
    }

    public String getBadgeName() {
        return badgeName;
    }

    public void setBadgeName(String badgeName) {
        this.badgeName = badgeName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getBadgeIcon() {
        return badgeIcon;
    }

    public void setBadgeIcon(String badgeIcon) {
        this.badgeIcon = badgeIcon;
    }

    public String getCriteria() {
        return criteria;
    }

    public void setCriteria(String criteria) {
        this.criteria = criteria;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Badge{" +
                "badgeId=" + badgeId +
                ", badgeName='" + badgeName + '\'' +
                '}';
    }
}
