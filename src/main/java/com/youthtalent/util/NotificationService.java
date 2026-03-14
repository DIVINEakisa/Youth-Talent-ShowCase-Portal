package com.youthtalent.util;

import com.youthtalent.dao.UserDAO;
import com.youthtalent.model.User;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

/**
 * Notification service hooks.
 * This class provides central integration points for email/SMS/push notifications.
 */
public class NotificationService {

    private final UserDAO userDAO = new UserDAO();

    public void notifyYouthNewOpportunity(int youthId, int opportunityId, String opportunityTitle) {
        User user = userDAO.getUserById(youthId);
        if (user == null || user.getEmail() == null || user.getEmail().isEmpty()) {
            return;
        }

        String subject = "New Opportunity Received";
        String body = "Hello " + user.getFullName() + ",\n\n"
                + "You have received a new opportunity: " + opportunityTitle + "\n"
                + "Opportunity ID: " + opportunityId + "\n\n"
                + "Please log in to review and respond.\n\n"
                + "Youth Talent Showcase Portal";

        sendEmail(user.getEmail(), subject, body);
    }

    public void notifyEmployerOpportunityResponse(int employerId, int opportunityId, String status) {
        User user = userDAO.getUserById(employerId);
        if (user == null || user.getEmail() == null || user.getEmail().isEmpty()) {
            return;
        }

        String subject = "Opportunity Response Update";
        String body = "Hello " + user.getFullName() + ",\n\n"
                + "Your opportunity (ID: " + opportunityId + ") has been " + status + ".\n\n"
                + "Please log in for details.\n\n"
                + "Youth Talent Showcase Portal";

        sendEmail(user.getEmail(), subject, body);
    }

    public void notifyManagerNewOpportunity(int managerId, int opportunityId, String opportunityTitle, String youthName) {
        User user = userDAO.getUserById(managerId);
        if (user == null || user.getEmail() == null || user.getEmail().isEmpty()) {
            return;
        }

        String subject = "New Managed Talent Opportunity";
        String body = "Hello " + user.getFullName() + ",\n\n"
                + "A new opportunity has been sent for a youth you manage.\n"
                + "Youth: " + youthName + "\n"
                + "Opportunity: " + opportunityTitle + "\n"
                + "Opportunity ID: " + opportunityId + "\n\n"
                + "Please log in to review and respond.\n\n"
                + "Youth Talent Showcase Portal";

        sendEmail(user.getEmail(), subject, body);
    }

    private void sendEmail(String toEmail, String subject, String body) {
        String smtpHost = readConfig("SMTP_HOST");
        String smtpPort = readConfig("SMTP_PORT");
        String smtpUser = readConfig("SMTP_USER");
        String smtpPassword = readConfig("SMTP_PASSWORD");
        String smtpFrom = readConfig("SMTP_FROM");

        if (isEmpty(smtpHost) || isEmpty(smtpPort) || isEmpty(smtpUser)
                || isEmpty(smtpPassword) || isEmpty(smtpFrom)) {
            System.out.println("Notification skipped: SMTP config missing for " + toEmail + " subject=" + subject);
            return;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.port", smtpPort);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(smtpUser, smtpPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(smtpFrom));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);
        } catch (Exception e) {
            System.err.println("Notification send failed: " + e.getMessage());
        }
    }

    private String readConfig(String key) {
        String value = System.getenv(key);
        if (!isEmpty(value)) {
            return value;
        }
        return System.getProperty(key);
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }
}
