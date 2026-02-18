package com.youthtalent.model;

import java.sql.Timestamp;

/**
 * Report Model Class
 * Represents an abuse/inappropriate content report
 */
public class Report {
    private int reportId;
    private int reporterId;
    private String reportedItemType; // TALENT, COMMENT
    private int reportedItemId;
    private String reportReason;
    private String status; // PENDING, REVIEWED, RESOLVED, DISMISSED
    private String adminNotes;
    private Integer reviewedBy;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Extended fields
    private String reporterUsername;
    private String reviewerUsername;

    // Constructors
    public Report() {
    }

    public Report(int reporterId, String reportedItemType, int reportedItemId, String reportReason) {
        this.reporterId = reporterId;
        this.reportedItemType = reportedItemType;
        this.reportedItemId = reportedItemId;
        this.reportReason = reportReason;
        this.status = "PENDING";
    }

    // Getters and Setters
    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public int getReporterId() {
        return reporterId;
    }

    public void setReporterId(int reporterId) {
        this.reporterId = reporterId;
    }

    public String getReportedItemType() {
        return reportedItemType;
    }

    public void setReportedItemType(String reportedItemType) {
        this.reportedItemType = reportedItemType;
    }

    public int getReportedItemId() {
        return reportedItemId;
    }

    public void setReportedItemId(int reportedItemId) {
        this.reportedItemId = reportedItemId;
    }

    public String getReportReason() {
        return reportReason;
    }

    public void setReportReason(String reportReason) {
        this.reportReason = reportReason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAdminNotes() {
        return adminNotes;
    }

    public void setAdminNotes(String adminNotes) {
        this.adminNotes = adminNotes;
    }

    public Integer getReviewedBy() {
        return reviewedBy;
    }

    public void setReviewedBy(Integer reviewedBy) {
        this.reviewedBy = reviewedBy;
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

    public String getReporterUsername() {
        return reporterUsername;
    }

    public void setReporterUsername(String reporterUsername) {
        this.reporterUsername = reporterUsername;
    }

    public String getReviewerUsername() {
        return reviewerUsername;
    }

    public void setReviewerUsername(String reviewerUsername) {
        this.reviewerUsername = reviewerUsername;
    }

    @Override
    public String toString() {
        return "Report{" +
                "reportId=" + reportId +
                ", reportedItemType='" + reportedItemType + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
