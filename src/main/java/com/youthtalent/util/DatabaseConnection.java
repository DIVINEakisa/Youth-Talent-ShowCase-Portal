package com.youthtalent.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Connection Utility Class
 * Manages database connections using JDBC
 */
public class DatabaseConnection {
    // Database configuration
    private static final String DB_URL = "jdbc:mysql://localhost:3306/youth_talent_portal?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = ""; // Update with your MySQL root password
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    // Static block to load the driver
    static {
        try {
            Class.forName(DB_DRIVER);
            System.out.println("MySQL JDBC Driver loaded successfully!");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
        }
    }

    /**
     * Get a database connection
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            return connection;
        } catch (SQLException e) {
            System.err.println("Database connection failed!");
            System.err.println("URL: " + DB_URL);
            System.err.println("User: " + DB_USER);
            throw e;
        }
    }

    /**
     * Close a database connection
     * @param connection Connection to close
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Database connection closed successfully.");
            } catch (SQLException e) {
                System.err.println("Failed to close database connection!");
                e.printStackTrace();
            }
        }
    }

    /**
     * Test the database connection
     * @return true if connection successful, false otherwise
     */
    public static boolean testConnection() {
        try (Connection connection = getConnection()) {
            if (connection != null && !connection.isClosed()) {
                System.out.println("✅ Database connection test successful!");
                return true;
            }
        } catch (SQLException e) {
            System.err.println("❌ Database connection test failed!");
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Main method for testing database connection
     */
    public static void main(String[] args) {
        System.out.println("Testing Database Connection...");
        testConnection();
    }
}
