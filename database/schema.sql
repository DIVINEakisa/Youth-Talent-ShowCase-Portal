-- ============================================================
-- Youth Talent Showcase & Opportunity Portal
-- Database Schema
-- Database: youth_talent_portal
-- ============================================================

DROP DATABASE IF EXISTS youth_talent_portal;
CREATE DATABASE youth_talent_portal CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE youth_talent_portal;

-- ============================================================
-- Table: users
-- Description: Stores user account information
-- ============================================================
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('USER', 'ADMIN', 'TALENT_MANAGER') DEFAULT 'USER',
    profile_image VARCHAR(255) DEFAULT 'default-avatar.png',
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_email (email),
    INDEX idx_username (username),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Table: categories
-- Description: Talent categories
-- ============================================================
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    icon VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Table: talents
-- Description: Stores talent showcase entries
-- ============================================================
CREATE TABLE talents (
    talent_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    image_url VARCHAR(255),
    media_url VARCHAR(255),
    status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    rejection_reason TEXT,
    approved_by INT,
    approved_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    views_count INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT,
    FOREIGN KEY (approved_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_category_id (category_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Table: ratings
-- Description: Stores talent ratings (1-5 stars)
-- ============================================================
CREATE TABLE ratings (
    rating_id INT PRIMARY KEY AUTO_INCREMENT,
    talent_id INT NOT NULL,
    user_id INT NOT NULL,
    rating_value INT NOT NULL CHECK (rating_value BETWEEN 1 AND 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (talent_id) REFERENCES talents(talent_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_talent_rating (talent_id, user_id),
    INDEX idx_talent_id (talent_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Table: comments
-- Description: Stores user comments on talents
-- ============================================================
CREATE TABLE comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    talent_id INT NOT NULL,
    user_id INT NOT NULL,
    comment_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_flagged BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (talent_id) REFERENCES talents(talent_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_talent_id (talent_id),
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Table: badges
-- Description: Achievement badges
-- ============================================================
CREATE TABLE badges (
    badge_id INT PRIMARY KEY AUTO_INCREMENT,
    badge_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    badge_icon VARCHAR(100),
    criteria TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Table: user_badges
-- Description: Badges earned by users
-- ============================================================
CREATE TABLE user_badges (
    user_badge_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    badge_id INT NOT NULL,
    earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (badge_id) REFERENCES badges(badge_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_badge (user_id, badge_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Table: reports
-- Description: Abuse/inappropriate content reports
-- ============================================================
CREATE TABLE reports (
    report_id INT PRIMARY KEY AUTO_INCREMENT,
    reporter_id INT NOT NULL,
    reported_item_type ENUM('TALENT', 'COMMENT') NOT NULL,
    reported_item_id INT NOT NULL,
    report_reason TEXT NOT NULL,
    status ENUM('PENDING', 'REVIEWED', 'RESOLVED', 'DISMISSED') DEFAULT 'PENDING',
    admin_notes TEXT,
    reviewed_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (reporter_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_status (status),
    INDEX idx_reporter_id (reporter_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- View: talent_statistics
-- Description: Calculated statistics for each talent
-- ============================================================
CREATE VIEW talent_statistics AS
SELECT 
    t.talent_id,
    t.title,
    t.user_id,
    u.username,
    c.category_name,
    t.status,
    t.views_count,
    COALESCE(AVG(r.rating_value), 0) AS average_rating,
    COUNT(DISTINCT r.rating_id) AS total_ratings,
    COUNT(DISTINCT cm.comment_id) AS total_comments,
    CASE 
        WHEN COALESCE(AVG(r.rating_value), 0) < 2.5 THEN 'Rising Talent'
        WHEN COALESCE(AVG(r.rating_value), 0) < 4.5 THEN 'Popular Talent'
        ELSE 'Top Talent'
    END AS talent_level,
    t.created_at
FROM talents t
JOIN users u ON t.user_id = u.user_id
JOIN categories c ON t.category_id = c.category_id
LEFT JOIN ratings r ON t.talent_id = r.talent_id
LEFT JOIN comments cm ON t.talent_id = cm.talent_id
GROUP BY t.talent_id, t.title, t.user_id, u.username, c.category_name, t.status, t.views_count, t.created_at;

-- ============================================================
-- Stored Procedure: Update Talent Average Rating
-- ============================================================
DELIMITER //
CREATE PROCEDURE UpdateTalentRating(IN p_talent_id INT)
BEGIN
    -- This procedure can be called after a new rating is added
    -- Currently, ratings are calculated via the view, but this can be used for denormalization
    SELECT AVG(rating_value) INTO @avg_rating FROM ratings WHERE talent_id = p_talent_id;
END //
DELIMITER ;

-- ============================================================
-- Sample Data Insertions
-- ============================================================

-- Insert Categories
INSERT INTO categories (category_name, description, icon) VALUES
('Music', 'Musical talents including singing, instruments, and composition', 'fa-music'),
('Art', 'Visual arts including painting, drawing, digital art, and sculpture', 'fa-palette'),
('Coding', 'Programming, software development, and technical projects', 'fa-code'),
('Writing', 'Creative writing, poetry, articles, and storytelling', 'fa-pen'),
('Innovation', 'Innovative projects, inventions, and creative solutions', 'fa-lightbulb'),
('Entrepreneurship', 'Business ideas, startups, and entrepreneurial ventures', 'fa-briefcase');

-- Insert Admin User (Password: admin123)
-- Password hash for 'admin123' using simple hashing (in real app, use BCrypt)
INSERT INTO users (username, email, password_hash, full_name, role, bio) VALUES
('admin', 'admin@youthtalent.com', '0192023a7bbd73250516f069df18b500', 'System Administrator', 'ADMIN', 'Platform administrator managing content and users'),
('john_doe', 'john@example.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'John Doe', 'USER', 'Passionate musician and artist'),
('jane_smith', 'jane@example.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'Jane Smith', 'USER', 'Software developer and innovation enthusiast'),
('mike_talent', 'mike@example.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'Mike Johnson', 'TALENT_MANAGER', 'Talent manager helping youth showcase their skills'),
('sarah_writer', 'sarah@example.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'Sarah Williams', 'USER', 'Creative writer and storyteller');

-- Insert Sample Talents
INSERT INTO talents (user_id, category_id, title, description, image_url, media_url, status, approved_by, approved_at) VALUES
(2, 1, 'Original Piano Composition', 'An original piano piece composed and performed by me. This piece reflects themes of hope and resilience.', 'piano-composition.jpg', 'https://youtube.com/watch?v=example1', 'APPROVED', 1, NOW()),
(2, 2, 'Digital Portrait Series', 'A series of digital portraits exploring human emotions using vibrant colors and modern techniques.', 'digital-portraits.jpg', 'https://instagram.com/example', 'APPROVED', 1, NOW()),
(3, 3, 'AI-Powered Study Assistant', 'A web application that helps students organize their study schedule using machine learning algorithms.', 'study-assistant.jpg', 'https://github.com/example/study-assistant', 'APPROVED', 1, NOW()),
(3, 5, 'Smart Recycling System', 'An IoT-based system that automatically sorts recyclable materials using computer vision.', 'recycling-system.jpg', 'https://github.com/example/smart-recycle', 'PENDING', NULL, NULL),
(5, 4, 'Poetry Collection: Urban Dreams', 'A collection of poems about life in the modern city, exploring themes of connection and isolation.', 'poetry-book.jpg', NULL, 'APPROVED', 1, NOW()),
(2, 6, 'Youth Mentorship Platform', 'A business proposal for connecting young entrepreneurs with experienced mentors in their field.', 'mentorship-platform.jpg', NULL, 'PENDING', NULL, NULL);

-- Insert Sample Ratings
INSERT INTO ratings (talent_id, user_id, rating_value) VALUES
(1, 3, 5),
(1, 5, 4),
(2, 3, 5),
(2, 5, 5),
(3, 2, 5),
(3, 5, 4),
(5, 2, 4),
(5, 3, 5);

-- Insert Sample Comments
INSERT INTO comments (talent_id, user_id, comment_text) VALUES
(1, 3, 'Beautiful composition! The melody is very touching.'),
(1, 5, 'I love the emotional depth in this piece. Keep creating!'),
(2, 3, 'Amazing use of colors! Your art style is unique.'),
(3, 2, 'This is exactly what students need. Great work!'),
(5, 2, 'Your poetry really resonates with me. Looking forward to more.');

-- Insert Badges
INSERT INTO badges (badge_name, description, badge_icon, criteria) VALUES
('First Talent', 'Posted your first talent showcase', 'badge-first.png', 'Upload first talent'),
('Rising Star', 'Received 10 ratings with average 4+', 'badge-star.png', '10 ratings, avg >= 4'),
('Popular Creator', 'Received 50+ views on a talent', 'badge-popular.png', '50+ views on single talent'),
('Community Champion', 'Made 25+ helpful comments', 'badge-champion.png', '25+ comments'),
('Top Innovator', 'Received 5-star rating on 3+ talents', 'badge-innovator.png', '3 talents with 5-star average');

-- Insert Sample User Badges
INSERT INTO user_badges (user_id, badge_id) VALUES
(2, 1),
(3, 1),
(5, 1),
(2, 2);

-- ============================================================
-- Indexes for Performance Optimization
-- ============================================================
-- Additional indexes already created inline with tables

-- ============================================================
-- Database User for Application (Optional)
-- ============================================================
-- CREATE USER 'youthtalent_app'@'localhost' IDENTIFIED BY 'StrongPassword123!';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON youth_talent_portal.* TO 'youthtalent_app'@'localhost';
-- FLUSH PRIVILEGES;

-- ============================================================
-- End of Schema
-- ============================================================
