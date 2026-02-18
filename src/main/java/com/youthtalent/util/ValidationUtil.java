package com.youthtalent.util;

import java.util.regex.Pattern;

/**
 * Validation Utility Class
 * Provides server-side validation methods
 */
public class ValidationUtil {

    // Email validation pattern
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    );

    // URL validation pattern
    private static final Pattern URL_PATTERN = Pattern.compile(
        "^(https?://)?(www\\.)?[a-zA-Z0-9-]+(\\.[a-zA-Z]{2,})+(/.*)?$"
    );

    /**
     * Validate email format
     * @param email Email address to validate
     * @return true if valid email format
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email).matches();
    }

    /**
     * Validate URL format
     * @param url URL to validate
     * @return true if valid URL format
     */
    public static boolean isValidURL(String url) {
        if (url == null || url.trim().isEmpty()) {
            return true; // URL is optional
        }
        return URL_PATTERN.matcher(url).matches();
    }

    /**
     * Validate if string is not empty
     * @param value String to check
     * @return true if not empty
     */
    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }

    /**
     * Validate string length
     * @param value String to check
     * @param minLength Minimum length
     * @param maxLength Maximum length
     * @return true if length is within range
     */
    public static boolean isValidLength(String value, int minLength, int maxLength) {
        if (value == null) {
            return false;
        }
        int length = value.trim().length();
        return length >= minLength && length <= maxLength;
    }

    /**
     * Validate rating value
     * @param rating Rating value
     * @return true if rating is between 1 and 5
     */
    public static boolean isValidRating(int rating) {
        return rating >= 1 && rating <= 5;
    }

    /**
     * Validate username format
     * @param username Username to validate
     * @return true if valid username
     */
    public static boolean isValidUsername(String username) {
        if (!isNotEmpty(username)) {
            return false;
        }
        // Username should be 3-50 characters, alphanumeric with underscores
        return username.matches("^[a-zA-Z0-9_]{3,50}$");
    }

    /**
     * Sanitize HTML input to prevent XSS attacks
     * @param input User input
     * @return Sanitized string
     */
    public static String sanitizeInput(String input) {
        if (input == null) {
            return null;
        }
        return input.replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;")
                    .replace("&", "&amp;");
    }

    /**
     * Get validation error message for email
     * @param email Email to validate
     * @return Error message or null if valid
     */
    public static String validateEmail(String email) {
        if (!isNotEmpty(email)) {
            return "Email is required";
        }
        if (!isValidEmail(email)) {
            return "Invalid email format";
        }
        return null;
    }

    /**
     * Get validation error message for username
     * @param username Username to validate
     * @return Error message or null if valid
     */
    public static String validateUsername(String username) {
        if (!isNotEmpty(username)) {
            return "Username is required";
        }
        if (!isValidUsername(username)) {
            return "Username must be 3-50 characters and contain only letters, numbers, and underscores";
        }
        return null;
    }

    /**
     * Validate talent data
     * @param title Talent title
     * @param description Talent description
     * @param categoryId Category ID
     * @return Error message or null if valid
     */
    public static String validateTalentData(String title, String description, int categoryId) {
        if (!isNotEmpty(title)) {
            return "Title is required";
        }
        if (!isValidLength(title, 5, 200)) {
            return "Title must be between 5 and 200 characters";
        }
        if (!isNotEmpty(description)) {
            return "Description is required";
        }
        if (!isValidLength(description, 10, 5000)) {
            return "Description must be between 10 and 5000 characters";
        }
        if (categoryId <= 0) {
            return "Please select a valid category";
        }
        return null;
    }
}
