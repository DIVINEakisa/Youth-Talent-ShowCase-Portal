# 🌟 Youth Talent Showcase & Opportunity Portal

## 📋 Project Overview

Youth Talent Showcase & Opportunity Portal is a comprehensive web-based platform designed to empower young individuals to showcase their talents across various domains including Music, Art, Coding, Writing, Innovation, and Entrepreneurship. The platform features a robust approval workflow, rating system, and administrative dashboard.

## 🏗️ Technology Stack

- **Backend**: Java Servlets, JSP
- **Architecture**: MVC (Model-View-Controller)
- **Database**: MySQL 8.0+
- **Data Access**: JDBC
- **Frontend**: Bootstrap 5, HTML5, CSS3, JavaScript
- **Server**: Apache Tomcat 9.0+
- **Theme**: Professional Green Theme (#198754)

## ✨ Key Features

### 1. **Authentication & Authorization**
- Secure user registration and login
- Password hashing using MD5 (educational purpose)
- Session management
- Role-based access control (USER, ADMIN, TALENT_MANAGER)

### 2. **Talent Management**
- Create, Read, Update, Delete (CRUD) operations
- Image and media URL support
- Category-based organization
- Status tracking (Pending/Approved/Rejected)

### 3. **Approval Workflow**
- Admin-based talent approval system
- Rejection with reason
- Only approved talents visible publicly

### 4. **Rating System**
- 1-5 star rating mechanism
- One rating per user per talent
- Users cannot rate own talents
- Automatic average calculation
- Talent levels: Rising (0-2.5★), Popular (2.5-4.5★), Top (4.5-5★)

### 5. **Comment System**
- User comments on approved talents
- Admin moderation capabilities
- Flag inappropriate comments

### 6. **Innovation Features**
- Achievement badges
- Report abuse system
- Search and filter by category
- Analytics dashboard
- Top-rated talents showcase

## 📁 Project Structure

```
Youth-Talent-ShowCase-Portal/
├── database/
│   └── schema.sql                          # Complete database schema
├── src/main/java/com/youthtalent/
│   ├── controller/                         # Servlets (MVC Controllers)
│   │   ├── AuthServlet.java
│   │   ├── TalentServlet.java
│   │   ├── RatingServlet.java
│   │   ├── CommentServlet.java
│   │   └── AdminServlet.java
│   ├── dao/                                # Data Access Objects
│   │   ├── UserDAO.java
│   │   ├── CategoryDAO.java
│   │   ├── TalentDAO.java
│   │   ├── RatingDAO.java
│   │   ├── CommentDAO.java
│   │   └── ReportDAO.java
│   ├── model/                              # JavaBeans (MVC Model)
│   │   ├── User.java
│   │   ├── Category.java
│   │   ├── Talent.java
│   │   ├── Rating.java
│   │   ├── Comment.java
│   │   ├── Report.java
│   │   └── Badge.java
│   └── util/                               # Utility Classes
│       ├── DatabaseConnection.java
│       ├── PasswordUtil.java
│       └── ValidationUtil.java
├── src/main/webapp/                        # JSP Views (MVC View)
│   ├── WEB-INF/web.xml
│   ├── admin/dashboard.jsp
│   ├── includes/navbar.jsp
│   ├── login.jsp
│   ├── register.jsp
│   └── dashboard.jsp
├── docs/
│   ├── PROJECT_REPORT.md
│   ├── SETUP_GUIDE.md
│   └── TESTING_GUIDE.md
└── README.md
```

## 🚀 Quick Start

### Prerequisites
- JDK 8+
- Apache Tomcat 9.0+
- MySQL 8.0+
- MySQL Connector/J (JDBC Driver)

### Installation Steps

1. **Create Database**
```bash
mysql -u root -p < database/schema.sql
```

2. **Configure Database Connection**
Edit `DatabaseConnection.java`:
```java
private static final String DB_PASSWORD = "your_password";
```

3. **Add MySQL Connector**
Copy `mysql-connector-java-x.x.xx.jar` to `src/main/webapp/WEB-INF/lib/`

4. **Deploy to Tomcat**
- Import as Dynamic Web Project
- Deploy and run on Tomcat
- Access: http://localhost:8080/YouthTalent/

## 👤 Default Login Credentials

**Admin Account:**
- Username: `admin`
- Password: `admin123`

**Test Users:**
- Username: `jane_smith` | Password: `password`
- Username: `john_doe` | Password: `password`

## 🎨 Features Showcase

### For Users:
✓ Register and create profile
✓ Showcase talents with images and media links
✓ Browse and discover other talents
✓ Rate and comment on talents
✓ Track personal talent performance
✓ Earn achievement badges

### For Admins:
✓ Comprehensive analytics dashboard
✓ Approve/reject talent submissions
✓ Manage users and content
✓ Review abuse reports
✓ Monitor platform statistics

## 🔐 Security Features

- Password hashing (MD5 - upgrade to BCrypt for production)
- Session management
- SQL injection prevention (Prepared Statements)
- XSS attack prevention (Input sanitization)
- Role-based access control
- CSRF protection

## ✅ Business Rules

1. ✓ Users cannot rate their own talents
2. ✓ One rating per user per talent
3. ✓ Only admins can approve talents
4. ✓ Only approved talents visible publicly
5. ✓ Email must be unique
6. ✓ Passwords hashed before storage
7. ✓ Server-side validation

## 📊 Database Schema

**Tables:**
- `users` - User accounts
- `categories` - Talent categories
- `talents` - Talent showcase entries
- `ratings` - User ratings
- `comments` - User comments
- `badges` - Achievement badges
- `user_badges` - User achievements
- `reports` - Abuse reports

**Relationships:**
- 1:N - User to Talents
- 1:N - Category to Talents
- N:M - Users to Badges (via user_badges)
- Foreign keys with proper CASCADE rules

## 🧪 Testing

Sample test credentials and data provided in database schema.

**Test Scenarios:**
- User registration/login
- Talent CRUD operations
- Rating system validations
- Comment moderation
- Admin approval workflow
- Search and filtering

## 🚀 Future Enhancements

- File upload for images
- Email notifications
- Real-time chat
- Mobile app version
- Video content support
- Advanced analytics
- Social media integration

## 📖 Documentation

Comprehensive documentation available in `docs/`:
- **PROJECT_REPORT.md** - Full academic project report
- **SETUP_GUIDE.md** - Detailed setup instructions
- **TESTING_GUIDE.md** - Complete test cases

## 🎓 Academic Context

This project demonstrates:
- MVC Architecture
- JDBC Database Operations
- Servlet-based Web Development
- JSP View Rendering
- Business Logic Implementation
- Database Design (3NF)
- Security Best Practices
- User Interface Design

## 📄 License

Educational project for academic purposes.

## 🤝 Support

For detailed information, refer to documentation in the `docs/` folder.

---

**Built with ❤️ to empower youth talents worldwide!**