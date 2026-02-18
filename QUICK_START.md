# 🚀 Quick Start Guide - Youth Talent Showcase Portal

## ⚡ Get Started in 5 Minutes

This guide will help you quickly set up and run the Youth Talent Showcase & Opportunity Portal.

---

## 📋 Prerequisites Check

Before starting, ensure you have:

- [ ] **Java JDK 8+** installed (`java -version`)
- [ ] **Apache Tomcat 9.0+** installed
- [ ] **MySQL 8.0+** installed and running
- [ ] **MySQL Connector/J** JAR file downloaded

---

## 🎯 5-Step Quick Setup

### Step 1: Database Setup (2 minutes)

```bash
# Login to MySQL
mysql -u root -p

# Run the schema (from project root)
mysql -u root -p < database/schema.sql

# Verify
mysql -u root -p -e "USE youth_talent_portal; SHOW TABLES;"
```

**Expected Output**: 8 tables listed (users, categories, talents, ratings, comments, badges, user_badges, reports)

---

### Step 2: Configure Database Connection (1 minute)

Edit: `src/main/java/com/youthtalent/util/DatabaseConnection.java`

```java
// Line 9-11: Update these values
private static final String DB_URL = "jdbc:mysql://localhost:3306/youth_talent_portal?useSSL=false&serverTimezone=UTC";
private static final String DB_USER = "root";
private static final String DB_PASSWORD = "YOUR_MYSQL_PASSWORD";  // ⬅️ CHANGE THIS
```

---

### Step 3: Add MySQL Connector (1 minute)

Copy `mysql-connector-java-8.0.XX.jar` to:
```
src/main/webapp/WEB-INF/lib/mysql-connector-java-8.0.XX.jar
```

Create `lib` folder if it doesn't exist:
```bash
mkdir -p src/main/webapp/WEB-INF/lib
```

---

### Step 4: Deploy to Tomcat (1 minute)

**Option A: Copy to Tomcat**
```bash
# Copy project to Tomcat webapps
cp -r Youth-Talent-ShowCase-Portal /path/to/tomcat/webapps/YouthTalent

# Start Tomcat
cd /path/to/tomcat/bin
./startup.sh  # Linux/Mac
startup.bat   # Windows
```

**Option B: IDE Deployment** (Recommended)
1. Import project into Eclipse/IntelliJ/NetBeans
2. Configure Tomcat server in IDE
3. Right-click project → Run on Server

---

### Step 5: Access Application (30 seconds)

Open browser and navigate to:
```
http://localhost:8080/YouthTalent/
```

**Login with demo account:**
- **Admin**: `admin` / `admin123`
- **User**: `jane_smith` / `password`

---

## 🎉 Success Indicators

✅ **Login page displays** with green theme  
✅ **Login successful** with demo credentials  
✅ **Dashboard loads** with statistics  
✅ **Talents page** shows sample talents  

---

## 🔧 Troubleshooting Quick Fixes

### Problem: "Cannot connect to database"
**Solution:**
1. Check MySQL is running: `mysql -u root -p`
2. Verify database exists: `SHOW DATABASES;`
3. Check password in `DatabaseConnection.java`

### Problem: "ClassNotFoundException: com.mysql.cj.jdbc.Driver"
**Solution:**
- Ensure `mysql-connector-java.jar` is in `WEB-INF/lib/`
- Clean and rebuild project
- Restart Tomcat

### Problem: "Port 8080 already in use"
**Solution:**
```bash
# Find process using port 8080
netstat -ano | findstr :8080  # Windows
lsof -i :8080                 # Linux/Mac

# Kill the process
taskkill /PID <PID> /F        # Windows
kill -9 <PID>                 # Linux/Mac
```

### Problem: "404 Not Found"
**Solution:**
- Check URL: `http://localhost:8080/YouthTalent/` (note the context path)
- Verify Tomcat deployed the app: Check `tomcat/webapps/YouthTalent/`
- Check Tomcat logs: `tomcat/logs/catalina.out`

---

## 📚 Next Steps

After successful setup:

1. **Explore the Application**
   - Browse talents at `/talent/list`
   - Add new talent at `/add-talent.jsp`
   - Check admin panel at `/admin/dashboard`

2. **Read Documentation**
   - `README.md` - Project overview
   - `docs/SETUP_GUIDE.md` - Detailed installation
   - `docs/TESTING_GUIDE.md` - Test the features
   - `docs/PROJECT_REPORT.md` - Academic documentation

3. **Test Key Features**
   - User registration
   - Talent submission
   - Rating system
   - Comment system
   - Admin approval workflow

---

## 🎓 Demo Credentials

### Admin Account
- **Username**: `admin`
- **Password**: `admin123`
- **Access**: Full system control, approval rights

### User Accounts
| Username | Password | Has Talents? |
|----------|----------|--------------|
| jane_smith | password | ✅ Yes (3) |
| john_doe | password | ✅ Yes (2) |
| emily_chen | password | ✅ Yes (1) |
| michael_brown | password | ✅ Yes (1) |

---

## 🌐 Application URLs

### Public Pages
- **Home**: `http://localhost:8080/YouthTalent/`
- **Login**: `http://localhost:8080/YouthTalent/login.jsp`
- **Register**: `http://localhost:8080/YouthTalent/register.jsp`
- **Browse Talents**: `http://localhost:8080/YouthTalent/talent/list`

### User Pages (After Login)
- **Dashboard**: `http://localhost:8080/YouthTalent/dashboard.jsp`
- **My Talents**: `http://localhost:8080/YouthTalent/my-talents.jsp`
- **Add Talent**: `http://localhost:8080/YouthTalent/add-talent.jsp`

### Admin Pages (Admin Only)
- **Admin Dashboard**: `http://localhost:8080/YouthTalent/admin/dashboard`
- **Pending Approvals**: `/admin/dashboard?view=pending`

---

## 🎨 Features to Test

### User Features
- [x] Register new account
- [x] Login/Logout
- [x] View all talents
- [x] Search talents by keyword
- [x] Filter by category
- [x] View talent details
- [x] Rate a talent (1-5 stars)
- [x] Comment on talents
- [x] Add new talent
- [x] Edit own talent
- [x] Delete own talent
- [x] View personal dashboard

### Admin Features
- [x] View admin dashboard
- [x] View pending talents
- [x] Approve talents
- [x] Reject talents
- [x] View all users
- [x] View statistics

---

## 📊 Sample Data Overview

The database comes pre-populated with:
- **5 Users** (1 admin, 4 regular users)
- **6 Categories** (Music, Art, Coding, Writing, Innovation, Entrepreneurship)
- **6 Talents** (Mix of approved, pending, rejected)
- **8 Ratings** (Various ratings on different talents)
- **5 Comments** (Sample comments on talents)
- **5 Badges** (Achievement badges available)

---

## 🔐 Security Notes

**For Educational Use:**
- MD5 password hashing (not production-ready)
- No HTTPS enforcement
- Basic session management

**For Production:**
- Upgrade to BCrypt password hashing
- Implement CSRF protection
- Enable HTTPS
- Add input sanitization
- Implement rate limiting
- Use connection pooling

---

## 💡 Pro Tips

1. **IDE Recommendation**: IntelliJ IDEA Ultimate or Eclipse IDE for Enterprise Java
2. **Database Tool**: MySQL Workbench for database management
3. **Browser**: Chrome DevTools for debugging
4. **Testing**: Use different browsers to test compatibility
5. **Logs**: Always check Tomcat logs for errors

---

## 🆘 Need Help?

1. **Read Full Documentation**
   - `docs/SETUP_GUIDE.md` for detailed installation
   - `docs/TESTING_GUIDE.md` for feature testing
   - `docs/PROJECT_REPORT.md` for architecture details

2. **Check Logs**
   - Tomcat logs: `tomcat/logs/catalina.out`
   - MySQL logs: `/var/log/mysql/error.log`
   - Browser console: F12 → Console tab

3. **Common Issues**
   - Database connection → Check MySQL running
   - Servlet errors → Check servlet-api.jar in classpath
   - 404 errors → Verify context path and deployment

---

## ✅ Verification Checklist

After setup, verify these work:

- [ ] Database connection successful
- [ ] Login page loads with green theme
- [ ] Admin login works
- [ ] User dashboard shows statistics
- [ ] Talents page displays sample talents
- [ ] Can view talent details
- [ ] Can add a new talent
- [ ] Can rate a talent
- [ ] Can post a comment
- [ ] Admin can access admin panel
- [ ] Admin can approve/reject talents

---

## 🎯 What's Next?

**You're all set!** 🎉

The application is ready to use. You can:
- Test all features using the demo accounts
- Add your own talents
- Customize the theme and UI
- Extend functionality
- Deploy to production server

**Enjoy exploring the Youth Talent Showcase Portal!**

---

## 📞 Support

For detailed information, refer to:
- 📖 `README.md` - Project overview
- 🔧 `docs/SETUP_GUIDE.md` - Comprehensive setup
- 🧪 `docs/TESTING_GUIDE.md` - Testing procedures
- 📚 `docs/PROJECT_REPORT.md` - Academic documentation
- 📋 `PROJECT_SUMMARY.md` - Complete project summary

**Happy coding! 💚**
