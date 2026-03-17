package com.youthtalent.util;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

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
    private static volatile boolean schemaVerified = false;

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
            ensureManagerSchema(connection);
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

    private static synchronized void ensureManagerSchema(Connection connection) {
        if (schemaVerified) {
            return;
        }

        try {
            if (!columnExists(connection, "talents", "manager_id")) {
                executeSchemaUpdate(connection,
                        "ALTER TABLE talents ADD COLUMN manager_id INT NULL AFTER user_id");
                System.out.println("Added talents.manager_id column for talent manager support.");
            }

            if (!columnExists(connection, "opportunities", "manager_id")) {
                executeSchemaUpdate(connection,
                        "ALTER TABLE opportunities ADD COLUMN manager_id INT NULL AFTER youth_id");
                System.out.println("Added opportunities.manager_id column for talent manager support.");
            }

            backfillSeedManagerAssignments(connection);
            schemaVerified = true;
        } catch (SQLException e) {
            System.err.println("Failed to verify/update manager schema support.");
            e.printStackTrace();
        }
    }

    private static boolean columnExists(Connection connection, String tableName, String columnName) throws SQLException {
        DatabaseMetaData metaData = connection.getMetaData();

        try (ResultSet columns = metaData.getColumns(connection.getCatalog(), null, tableName, columnName)) {
            if (columns.next()) {
                return true;
            }
        }

        try (ResultSet columns = metaData.getColumns(connection.getCatalog(), null,
                tableName.toUpperCase(), columnName.toUpperCase())) {
            return columns.next();
        }
    }

    private static void executeSchemaUpdate(Connection connection, String sql) throws SQLException {
        try (Statement stmt = connection.createStatement()) {
            stmt.executeUpdate(sql);
        }
    }

    private static void backfillSeedManagerAssignments(Connection connection) throws SQLException {
        String sql = "UPDATE talents t " +
                "JOIN users youth ON t.user_id = youth.user_id " +
                "JOIN users manager ON manager.username = 'mike_talent' AND manager.role = 'TALENT_MANAGER' " +
                "SET t.manager_id = manager.user_id " +
                "WHERE t.manager_id IS NULL AND youth.username IN ('john_doe', 'jane_smith')";

        try (Statement stmt = connection.createStatement()) {
            stmt.executeUpdate(sql);
        } catch (SQLException e) {
            System.err.println("Seed manager assignment backfill skipped: " + e.getMessage());
        }
    }
}
