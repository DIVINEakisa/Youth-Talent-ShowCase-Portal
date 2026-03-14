package com.youthtalent.model;

import java.sql.Timestamp;

/**
 * Opportunity Model Class
 * Represents an offer sent by an employer to a youth talent
 */
public class Opportunity {
    private int opportunityId;
    private int employerId;
    private int youthId;
    private Integer managerId;
    private int talentId;
    private String title;
    private String description;
    private String type; // JOB, SPONSORSHIP, COLLABORATION, MENTORSHIP
    private String status; // PENDING, ACCEPTED, REJECTED
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp respondedAt;

    // Extended fields from joins
    private String employerName;
    private String youthName;
    private String managerName;
    private String talentTitle;

    public int getOpportunityId() {
        return opportunityId;
    }

    public void setOpportunityId(int opportunityId) {
        this.opportunityId = opportunityId;
    }

    public int getEmployerId() {
        return employerId;
    }

    public void setEmployerId(int employerId) {
        this.employerId = employerId;
    }

    public int getYouthId() {
        return youthId;
    }

    public void setYouthId(int youthId) {
        this.youthId = youthId;
    }

    public int getTalentId() {
        return talentId;
    }

    public Integer getManagerId() {
        return managerId;
    }

    public void setManagerId(Integer managerId) {
        this.managerId = managerId;
    }

    public void setTalentId(int talentId) {
        this.talentId = talentId;
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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public Timestamp getRespondedAt() {
        return respondedAt;
    }

    public void setRespondedAt(Timestamp respondedAt) {
        this.respondedAt = respondedAt;
    }

    public String getEmployerName() {
        return employerName;
    }

    public void setEmployerName(String employerName) {
        this.employerName = employerName;
    }

    public String getYouthName() {
        return youthName;
    }

    public void setYouthName(String youthName) {
        this.youthName = youthName;
    }

    public String getTalentTitle() {
        return talentTitle;
    }

    public String getManagerName() {
        return managerName;
    }

    public void setManagerName(String managerName) {
        this.managerName = managerName;
    }

    public void setTalentTitle(String talentTitle) {
        this.talentTitle = talentTitle;
    }

    public boolean isPending() {
        return "PENDING".equals(status);
    }
}
