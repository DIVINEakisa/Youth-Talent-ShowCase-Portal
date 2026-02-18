package com.youthtalent.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Password Utility Class
 * Handles password hashing and verification
 */
public class PasswordUtil {

    /**
     * Hash a password using MD5 (simple version for educational purposes)
     * For production, use BCrypt or PBKDF2
     * @param password Plain text password
     * @return Hashed password
     */
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hashBytes = md.digest(password.getBytes());
            
            // Convert bytes to hexadecimal format
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashBytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    /**
     * Verify a password against a hash
     * @param password Plain text password
     * @param hashedPassword Stored hashed password
     * @return true if passwords match
     */
    public static boolean verifyPassword(String password, String hashedPassword) {
        String hashedInput = hashPassword(password);
        return hashedInput.equals(hashedPassword);
    }

    /**
     * Generate a random password
     * @param length Password length
     * @return Random password
     */
    public static String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder();
        
        for (int i = 0; i < length; i++) {
            int index = random.nextInt(chars.length());
            password.append(chars.charAt(index));
        }
        
        return password.toString();
    }

    /**
     * Validate password strength
     * @param password Password to validate
     * @return true if password meets minimum requirements
     */
    public static boolean isValidPassword(String password) {
        if (password == null || password.length() < 6) {
            return false;
        }
        return true;
    }

    /**
     * Get password validation error message
     * @param password Password to check
     * @return Error message or null if valid
     */
    public static String getPasswordValidationError(String password) {
        if (password == null || password.isEmpty()) {
            return "Password cannot be empty";
        }
        if (password.length() < 6) {
            return "Password must be at least 6 characters long";
        }
        if (password.length() > 50) {
            return "Password must not exceed 50 characters";
        }
        return null; // Password is valid
    }

    /**
     * Main method for testing
     */
    public static void main(String[] args) {
        // Test password hashing
        String password = "admin123";
        String hashed = hashPassword(password);
        System.out.println("Original: " + password);
        System.out.println("Hashed: " + hashed);
        System.out.println("Verification: " + verifyPassword(password, hashed));
        
        // Test password "password"
        String password2 = "password";
        String hashed2 = hashPassword(password2);
        System.out.println("\nOriginal: " + password2);
        System.out.println("Hashed: " + hashed2);
    }
}
