<%@ page import="java.security.MessageDigest" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Password Hash Test</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2>Password Hash Tester</h2>
    <div class="card">
        <div class="card-body">
            <%
            String hashPassword(String password) {
                try {
                    MessageDigest md = MessageDigest.getInstance("MD5");
                    byte[] hashBytes = md.digest(password.getBytes());
                    StringBuilder hexString = new StringBuilder();
                    for (byte b : hashBytes) {
                        String hex = Integer.toHexString(0xff & b);
                        if (hex.length() == 1) {
                            hexString.append('0');
                        }
                        hexString.append(hex);
                    }
                    return hexString.toString();
                } catch (Exception e) {
                    return "ERROR: " + e.getMessage();
                }
            }
            
            String adminHash = hashPassword("admin123");
            String passwordHash = hashPassword("password");
            %>
            
            <h4>Expected Hashes from Database:</h4>
            <ul>
                <li><strong>admin123:</strong> <code>0192023a7bbd73250516f069df18b500</code></li>
                <li><strong>password:</strong> <code>5f4dcc3b5aa765d61d8327deb882cf99</code></li>
            </ul>
            
            <h4>Generated Hashes:</h4>
            <ul>
                <li><strong>admin123:</strong> <code><%= adminHash %></code> 
                    <%= adminHash.equals("0192023a7bbd73250516f069df18b500") ? "<span class='text-success'>✓ MATCH</span>" : "<span class='text-danger'>✗ NO MATCH</span>" %>
                </li>
                <li><strong>password:</strong> <code><%= passwordHash %></code>
                    <%= passwordHash.equals("5f4dcc3b5aa765d61d8327deb882cf99") ? "<span class='text-success'>✓ MATCH</span>" : "<span class='text-danger'>✗ NO MATCH</span>" %>
                </li>
            </ul>
            
            <h4>Database Connection Test:</h4>
            <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                java.sql.Connection conn = java.sql.DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/youth_talent_portal?useSSL=false&serverTimezone=UTC",
                    "root",
                    ""
                );
                out.println("<div class='alert alert-success'>✓ Database connection successful!</div>");
                
                // Check if users exist
                java.sql.Statement stmt = conn.createStatement();
                java.sql.ResultSet rs = stmt.executeQuery("SELECT username, password_hash FROM users WHERE username='admin'");
                if (rs.next()) {
                    String dbUsername = rs.getString("username");
                    String dbPasswordHash = rs.getString("password_hash");
                    out.println("<div class='alert alert-info'>");
                    out.println("<strong>Admin user found in DB:</strong><br>");
                    out.println("Username: " + dbUsername + "<br>");
                    out.println("Password Hash: <code>" + dbPasswordHash + "</code><br>");
                    out.println("Expected: <code>0192023a7bbd73250516f069df18b500</code><br>");
                    out.println(dbPasswordHash.equals("0192023a7bbd73250516f069df18b500") ? 
                        "<span class='text-success'>✓ Hashes match!</span>" : 
                        "<span class='text-danger'>✗ Hashes DON'T match!</span>");
                    out.println("</div>");
                } else {
                    out.println("<div class='alert alert-warning'>⚠ Admin user NOT found in database!</div>");
                }
                conn.close();
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>✗ Database error: " + e.getMessage() + "</div>");
                e.printStackTrace();
            }
            %>
        </div>
    </div>
    <div class="mt-3">
        <a href="login.jsp" class="btn btn-primary">Back to Login</a>
    </div>
</div>
</body>
</html>
