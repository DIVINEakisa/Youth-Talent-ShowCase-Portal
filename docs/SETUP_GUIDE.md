# Youth Talent Showcase Portal - Setup Guide

## Complete Installation & Configuration Guide

---

## TABLE OF CONTENTS

1. [Prerequisites](#prerequisites)
2. [Environment Setup](#environment-setup)
3. [Database Configuration](#database-configuration)
4. [Project Setup](#project-setup)
5. [Deployment](#deployment)
6. [Troubleshooting](#troubleshooting)
7. [Verification](#verification)

---

## PREREQUISITES

### Required Software

#### 1. Java Development Kit (JDK)
- **Version**: JDK 8 or higher (JDK 11 recommended)
- **Download**: https://www.oracle.com/java/technologies/javase-downloads.html
- **Installation**:
  ```bash
  # Windows
  - Download installer and run
  - Set JAVA_HOME environment variable
  - Add %JAVA_HOME%\bin to PATH
  
  # Linux
  sudo apt update
  sudo apt install openjdk-11-jdk
  
  # Verify installation
  java -version
  javac -version
  ```

#### 2. Apache Tomcat
- **Version**: Tomcat 9.0 or higher
- **Download**: https://tomcat.apache.org/download-90.cgi
- **Installation**:
  ```bash
  # Windows
  - Download ZIP archive
  - Extract to C:\tomcat9
  - Configure environment variables
  
  # Linux
  wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.xx/bin/apache-tomcat-9.0.xx.tar.gz
  tar -xvzf apache-tomcat-9.0.xx.tar.gz
  sudo mv apache-tomcat-9.0.xx /opt/tomcat9
  
  # Verify
  /opt/tomcat9/bin/version.sh
  ```

#### 3. MySQL Server
- **Version**: MySQL 8.0 or higher
- **Download**: https://dev.mysql.com/downloads/mysql/
- **Installation**:
  ```bash
  # Windows
  - Download MySQL Installer
  - Run installer and select "Server only"
  - Set root password
  - Complete installation
  
  # Linux
  sudo apt update
  sudo apt install mysql-server
  sudo mysql_secure_installation
  
  # Verify
  mysql --version
  ```

#### 4. MySQL Connector/J (JDBC Driver)
- **Version**: 8.0.33 or compatible
- **Download**: https://dev.mysql.com/downloads/connector/j/
- **Note**: Will be added to project lib folder

#### 5. IDE (Choose One)
- **Eclipse IDE for Enterprise Java**: https://www.eclipse.org/downloads/
- **IntelliJ IDEA**: https://www.jetbrains.com/idea/download/
- **NetBeans**: https://netbeans.apache.org/download/

---

## ENVIRONMENT SETUP

### 1. Configure JAVA_HOME

**Windows:**
```cmd
# Set System Environment Variable
setx JAVA_HOME "C:\Program Files\Java\jdk-11.0.x"
setx PATH "%PATH%;%JAVA_HOME%\bin"

# Verify
echo %JAVA_HOME%
```

**Linux:**
```bash
# Add to ~/.bashrc or ~/.profile
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Reload
source ~/.bashrc

# Verify
echo $JAVA_HOME
```

### 2. Configure Tomcat

**Set CATALINA_HOME:**

**Windows:**
```cmd
setx CATALINA_HOME "C:\tomcat9"
```

**Linux:**
```bash
export CATALINA_HOME=/opt/tomcat9
export PATH=$CATALINA_HOME/bin:$PATH
```

**Test Tomcat:**
```bash
# Start Tomcat
# Windows: C:\tomcat9\bin\startup.bat
# Linux: /opt/tomcat9/bin/startup.sh

# Access: http://localhost:8080
# You should see Tomcat welcome page

# Stop Tomcat
# Windows: C:\tomcat9\bin\shutdown.bat
# Linux: /opt/tomcat9/bin/shutdown.sh
```

---

## DATABASE CONFIGURATION

### Step 1: Start MySQL Service

**Windows:**
```cmd
# Start MySQL Service
net start MySQL80

# Or use Services application
```

**Linux:**
```bash
sudo systemctl start mysql
sudo systemctl enable mysql  # Enable on boot
sudo systemctl status mysql  # Check status
```

### Step 2: Login to MySQL

```bash
mysql -u root -p
# Enter your root password when prompted
```

### Step 3: Create Database and Execute Schema

**Method 1: From Command Line**
```bash
# Execute schema file
mysql -u root -p < path/to/database/schema.sql

# Or login first and use source command
mysql -u root -p
mysql> source /path/to/database/schema.sql
```

**Method 2: Using MySQL Workbench**
1. Open MySQL Workbench
2. Connect to MySQL Server
3. Open `database/schema.sql`
4. Execute the entire script (Ctrl+Shift+Enter)
5. Refresh to see `youth_talent_portal` database

**Method 3: Copy-Paste**
1. Login to MySQL
2. Copy contents of `schema.sql`
3. Paste into MySQL console
4. Execute

### Step 4: Verify Database Creation

```sql
-- Show databases
SHOW DATABASES;

-- Use the database
USE youth_talent_portal;

-- Show tables
SHOW TABLES;

-- Verify sample data
SELECT * FROM users;
SELECT * FROM categories;
SELECT * FROM talents;

-- Expected output: 8 tables + sample data
```

### Step 5: Create Application Database User (Optional but Recommended)

```sql
-- Create user for application
CREATE USER 'youthtalent_app'@'localhost' IDENTIFIED BY 'StrongPassword123!';

-- Grant permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON youth_talent_portal.* TO 'youthtalent_app'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;

-- Verify
SHOW GRANTS FOR 'youthtalent_app'@'localhost';
```

---

## PROJECT SETUP

### Method 1: Using Eclipse IDE

#### Step 1: Import Project

1. **Open Eclipse**
2. **File → Import → General → Existing Projects into Workspace**
3. **Browse to project folder**
4. **Click Finish**

#### Step 2: Configure Project

1. **Right-click project → Properties**
2. **Project Facets:**
   - ✓ Dynamic Web Module (3.1 or higher)
   - ✓ Java (1.8 or higher)
3. **Java Build Path:**
   - Add JRE System Library
   - Add Tomcat Runtime Library

#### Step 3: Add MySQL Connector

1. **Download MySQL Connector/J** (mysql-connector-java-8.0.33.jar)
2. **Copy JAR file to:**
   - `src/main/webapp/WEB-INF/lib/`
3. **Refresh project** (F5)

#### Step 4: Configure Database Connection

1. **Open:** `src/main/java/com/youthtalent/util/DatabaseConnection.java`

2. **Update these lines:**
```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/youth_talent_portal?useSSL=false&serverTimezone=UTC";
private static final String DB_USER = "root";  // or "youthtalent_app"
private static final String DB_PASSWORD = "your_mysql_password";
```

3. **Save file**

#### Step 5: Test Database Connection

1. **Right-click** `DatabaseConnection.java`
2. **Run As → Java Application**
3. **Expected Output:**
   ```
   MySQL JDBC Driver loaded successfully!
   ✅ Database connection test successful!
   Database connection closed successfully.
   ```

#### Step 6: Configure Tomcat in Eclipse

1. **Window → Preferences → Server → Runtime Environments**
2. **Add → Apache Tomcat v9.0**
3. **Browse to Tomcat installation directory**
4. **Finish**

#### Step 7: Create Tomcat Server Instance

1. **Window → Show View → Servers**
2. **Right-click in Servers view → New → Server**
3. **Select Tomcat v9.0 Server**
4. **Add project to configured server**
5. **Finish**

---

### Method 2: Using IntelliJ IDEA

#### Step 1: Open Project

1. **File → Open**
2. **Navigate to project folder**
3. **Click OK**

#### Step 2: Configure Project Structure

1. **File → Project Structure**
2. **Project:**
   - SDK: Java 11
   - Language Level: 11
3. **Modules:**
   - Add Web facet
   - Set web resource directory to `src/main/webapp`
4. **Libraries:**
   - Add MySQL Connector JAR
   - Add Tomcat libraries

#### Step 3: Configure Tomcat

1. **Run → Edit Configurations**
2. **+ → Tomcat Server → Local**
3. **Configure:**
   - Name: Tomcat 9
   - Application server: Browse to Tomcat directory
4. **Deployment tab:**
   - Add artifact: YouthTalent:war exploded
   - Context path: /YouthTalent
5. **Apply and OK**

---

## DEPLOYMENT

### Option 1: Deploy via IDE (Recommended for Development)

**Eclipse:**
1. **Right-click project**
2. **Run As → Run on Server**
3. **Select Tomcat 9**
4. **Finish**
5. **Browser opens automatically**

**IntelliJ:**
1. **Select Tomcat configuration**
2. **Click Run (Shift+F10)**
3. **IntelliJ deploys and opens browser**

### Option 2: Manual WAR Deployment

#### Step 1: Create WAR File

**Using IDE:**
- Eclipse: File → Export → WAR file
- IntelliJ: Build → Build Artifacts → WAR

**Using Command Line:**
```bash
cd project_directory
jar -cvf YouthTalent.war -C src/main/webapp .
```

#### Step 2: Deploy WAR

```bash
# Copy WAR to Tomcat
cp YouthTalent.war $CATALINA_HOME/webapps/

# Start Tomcat
$CATALINA_HOME/bin/startup.sh  # Linux
# or
$CATALINA_HOME\bin\startup.bat  # Windows

# Tomcat will auto-extract the WAR
```

#### Step 3: Access Application

```
http://localhost:8080/YouthTalent/
```

### Option 3: Exploded Deployment (Development)

1. **Copy entire project structure** to:
   ```
   $CATALINA_HOME/webapps/YouthTalent/
   ```

2. **Directory structure:**
   ```
   webapps/
   └── YouthTalent/
       ├── WEB-INF/
       │   ├── classes/
       │   │   └── com/youthtalent/
       │   ├── lib/
       │   │   └── mysql-connector-java-8.0.33.jar
       │   └── web.xml
       ├── login.jsp
       ├── dashboard.jsp
       └── ...
   ```

3. **Restart Tomcat**

---

## TROUBLESHOOTING

### Issue 1: MySQL Connection Failed

**Error:**
```
SQLException: Access denied for user 'root'@'localhost'
```

**Solutions:**
1. Verify MySQL is running:
   ```bash
   sudo systemctl status mysql  # Linux
   net start MySQL80            # Windows
   ```

2. Check password in `DatabaseConnection.java`

3. Test MySQL login:
   ```bash
   mysql -u root -p
   ```

4. Verify user permissions:
   ```sql
   SHOW GRANTS FOR 'root'@'localhost';
   ```

### Issue 2: ClassNotFoundException: com.mysql.cj.jdbc.Driver

**Solutions:**
1. Ensure MySQL Connector JAR is in `WEB-INF/lib/`
2. Check JAR file name (correct version)
3. Refresh/rebuild project
4. Check library is added to build path

### Issue 3: Tomcat Port Already in Use

**Error:**
```
Address already in use: bind
```

**Solutions:**

**Windows:**
```cmd
# Find process using port 8080
netstat -ano | findstr :8080
# Kill process
taskkill /PID <PID> /F
```

**Linux:**
```bash
# Find and kill process
sudo lsof -i :8080
sudo kill -9 <PID>

# Or change Tomcat port
# Edit $CATALINA_HOME/conf/server.xml
# Change Connector port="8080" to port="8081"
```

### Issue 4: 404 Error - Page Not Found

**Solutions:**
1. Verify correct URL: `http://localhost:8080/YouthTalent/login.jsp`
2. Check application deployed correctly
3. Review Tomcat logs: `$CATALINA_HOME/logs/catalina.out`
4. Verify web.xml configuration

### Issue 5: 500 Internal Server Error

**Solutions:**
1. Check Tomcat logs for stack trace
2. Verify all Java files compiled successfully
3. Check for syntax errors in JSP
4. Verify database connection
5. Check servlet mappings in web.xml

### Issue 6: Session Timeout Too Fast

**Solution:**
Edit `web.xml`:
```xml
<session-config>
    <session-timeout>30</session-timeout>
</session-config>
```

### Issue 7: Images/CSS Not Loading

**Solutions:**
1. Verify files in correct directory
2. Check file permissions
3. Use correct context path
4. Clear browser cache

---

## VERIFICATION

### 1. Verify Installation

**Checklist:**
- [ ] JDK installed and JAVA_HOME set
- [ ] Tomcat installed and running
- [ ] MySQL installed and running
- [ ] Database created with sample data
- [ ] MySQL Connector JAR in WEB-INF/lib
- [ ] DatabaseConnection.java configured
- [ ] Project deployed successfully

### 2. Test Application

#### Test 1: Database Connection
```bash
# Run DatabaseConnection main method
# Expected: "✅ Database connection test successful!"
```

#### Test 2: Application Access
```
URL: http://localhost:8080/YouthTalent/
Expected: Login page with green theme
```

#### Test 3: Login
```
Username: admin
Password: admin123
Expected: Admin dashboard with statistics
```

#### Test 4: Create Talent
```
1. Login as user (jane_smith / password)
2. Click "Add Talent"
3. Fill form
4. Submit
Expected: Success message, talent in pending status
```

#### Test 5: Admin Approval
```
1. Login as admin
2. Go to Admin Panel → Pending Talents
3. Approve a talent
Expected: Talent visible on public page
```

### 3. Verify Features

**Essential Features Checklist:**
- [ ] User registration works
- [ ] User login works
- [ ] Dashboard displays correctly
- [ ] Talent creation works
- [ ] Talent editing works
- [ ] Admin can approve talents
- [ ] Rating system works
- [ ] Comments can be added
- [ ] Search functionality works
- [ ] Admin dashboard shows statistics

---

## NEXT STEPS

After successful installation:

1. **Explore the Application:**
   - Register a new user
   - Create talents
   - Rate and comment on talents
   - Explore admin features

2. **Review Documentation:**
   - Read `PROJECT_REPORT.md` for technical details
   - Study `TESTING_GUIDE.md` for test cases

3. **Customize:**
   - Add your own categories
   - Modify theme colors
   - Add custom validations

4. **Enhance:**
   - Implement file upload
   - Add email notifications
   - Create mobile app

---

## SUPPORT RESOURCES

### Official Documentation
- **Java**: https://docs.oracle.com/javase/
- **Tomcat**: https://tomcat.apache.org/tomcat-9.0-doc/
- **MySQL**: https://dev.mysql.com/doc/
- **Bootstrap**: https://getbootstrap.com/docs/

### Community Help
- **Stack Overflow**: https://stackoverflow.com/
- **MySQL Forums**: https://forums.mysql.com/
- **Apache Tomcat Users**: http://tomcat.apache.org/lists.html

---

## BACKUP AND MAINTENANCE

### Database Backup

```bash
# Backup database
mysqldump -u root -p youth_talent_portal > backup.sql

# Restore database
mysql -u root -p youth_talent_portal < backup.sql
```

### Application Backup

```bash
# Backup entire application
tar -czf youthtalent_backup.tar.gz webapps/YouthTalent/

# Restore
tar -xzf youthtalent_backup.tar.gz -C /opt/tomcat9/webapps/
```

---

**Installation Complete! 🎉**

Access your application at: **http://localhost:8080/YouthTalent/**

For issues, refer to the Troubleshooting section or check project documentation.

---

*Setup Guide Version 1.0 - February 2026*
