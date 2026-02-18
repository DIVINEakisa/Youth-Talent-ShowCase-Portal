-- ============================================================
-- Youth Talent Showcase & Opportunity Portal
-- Database Schema
-- Database: youth_talent_portal
-- ============================================================

-- Note: If DROP DATABASE is disabled, manually create database first:
-- CREATE DATABASE IF NOT EXISTS youth_talent_portal CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- DROP DATABASE IF EXISTS youth_talent_portal;
-- CREATE DATABASE youth_talent_portal CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE youth_talent_portal;

-- Drop existing tables in correct order (respecting foreign keys)
DROP TABLE IF EXISTS user_badges;
DROP TABLE IF EXISTS reports;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS talents;
DROP TABLE IF EXISTS badges;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

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
-- Additional Sample Data for Realistic Testing
-- ============================================================

-- Insert More Users (Password for all: password123)
INSERT INTO users (username, email, password_hash, full_name, role, bio) VALUES
('emily_chen', 'emily@example.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'Emily Chen', 'USER', 'Tech enthusiast and coding wizard'),
('michael_brown', 'michael@example.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'Michael Brown', 'USER', 'Writer and storyteller with a passion for fantasy'),
('alex_kumar', 'alex@example.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'Alex Kumar', 'USER', 'Entrepreneur and business innovator'),
('lisa_taylor', 'lisa@example.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'Lisa Taylor', 'USER', 'Professional artist and graphic designer'),
('david_wilson', 'david@example.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'David Wilson', 'USER', 'Musician, producer, and sound engineer'),
('sophia_garcia', 'sophia@example.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'Sophia Garcia', 'USER', 'Innovation enthusiast and problem solver'),
('ryan_martinez', 'ryan@example.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'Ryan Martinez', 'USER', 'Full-stack developer and open-source contributor'),
('olivia_lee', 'olivia@example.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'Olivia Lee', 'USER', 'Digital artist specializing in character design'),
('james_anderson', 'james@example.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'James Anderson', 'USER', 'Poet and creative writing instructor'),
('emma_thomas', 'emma@example.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'Emma Thomas', 'USER', 'Young entrepreneur building sustainable businesses');

-- Insert More Talents Across Different Categories
INSERT INTO talents (user_id, category_id, title, description, image_url, media_url, status, approved_by, approved_at) VALUES
-- Music Talents
(10, 1, 'Electronic Music Production', 'An original EDM track produced using Ableton Live, featuring dynamic beats and melodic synths.', 'edm-track.jpg', 'https://soundcloud.com/example', 'APPROVED', 1, NOW()),
(10, 1, 'Acoustic Guitar Cover Album', 'A collection of popular song covers played on acoustic guitar with unique arrangements.', 'guitar-covers.jpg', 'https://youtube.com/watch?v=example2', 'APPROVED', 1, NOW()),
(2, 1, 'Jazz Improvisation Session', 'Live jazz improvisation showcasing creative musical expression and technical skill.', 'jazz-improv.jpg', 'https://youtube.com/watch?v=example3', 'APPROVED', 1, NOW()),

-- Art Talents
(9, 2, 'Abstract Watercolor Series', 'A series of abstract watercolor paintings inspired by natural landscapes and emotions.', 'watercolor-abstract.jpg', NULL, 'APPROVED', 1, NOW()),
(13, 2, '3D Character Design Portfolio', 'A portfolio of 3D character models created for games and animation projects.', '3d-characters.jpg', 'https://artstation.com/example', 'APPROVED', 1, NOW()),
(9, 2, 'Street Art Photography', 'A photo collection documenting urban street art and graffiti culture around the city.', 'street-art-photos.jpg', NULL, 'APPROVED', 1, NOW()),
(2, 2, 'Minimalist Logo Design Collection', 'A showcase of minimalist logo designs for various brands and startups.', 'logo-designs.jpg', NULL, 'PENDING', NULL, NULL),

-- Coding Talents
(6, 3, 'E-Commerce Website with React', 'A fully functional e-commerce website built with React, Node.js, and MongoDB.', 'ecommerce-app.jpg', 'https://github.com/example/ecommerce', 'APPROVED', 1, NOW()),
(12, 3, 'Mobile Fitness Tracking App', 'An Android app that tracks workouts, calories, and provides personalized fitness plans.', 'fitness-app.jpg', 'https://github.com/example/fitness-tracker', 'APPROVED', 1, NOW()),
(6, 3, 'Python Data Visualization Tool', 'A Python tool for visualizing complex datasets with interactive charts and graphs.', 'data-viz.jpg', 'https://github.com/example/data-viz', 'APPROVED', 1, NOW()),
(12, 3, 'Blockchain Voting System', 'A secure and transparent voting system built on blockchain technology.', 'blockchain-vote.jpg', 'https://github.com/example/blockchain-vote', 'PENDING', NULL, NULL),

-- Writing Talents
(7, 4, 'Science Fiction Short Story', 'A thrilling sci-fi short story set in a dystopian future where AI controls society.', 'scifi-story.jpg', NULL, 'APPROVED', 1, NOW()),
(14, 4, 'Modern Poetry Anthology', 'An anthology of modern poems exploring themes of identity, love, and social justice.', 'poetry-anthology.jpg', NULL, 'APPROVED', 1, NOW()),
(7, 4, 'Travel Blog Series', 'A series of travel blog posts documenting adventures across different countries and cultures.', 'travel-blog.jpg', NULL, 'APPROVED', 1, NOW()),
(14, 4, 'Fantasy Novel Excerpt', 'The first three chapters of an epic fantasy novel featuring magic, adventure, and dragons.', 'fantasy-novel.jpg', NULL, 'APPROVED', 1, NOW()),

-- Innovation Talents
(11, 5, 'Solar-Powered Water Purifier', 'An innovative device that purifies water using solar energy, designed for rural areas.', 'water-purifier.jpg', NULL, 'APPROVED', 1, NOW()),
(3, 5, 'Smart Home Automation System', 'An IoT-based home automation system controllable via smartphone app.', 'smart-home.jpg', 'https://github.com/example/smart-home', 'APPROVED', 1, NOW()),
(11, 5, 'Eco-Friendly Packaging Solution', 'Biodegradable packaging materials made from agricultural waste.', 'eco-packaging.jpg', NULL, 'APPROVED', 1, NOW()),
(6, 5, 'AI-Powered Plant Disease Detector', 'A machine learning model that identifies plant diseases from leaf images.', 'plant-detector.jpg', 'https://github.com/example/plant-ai', 'PENDING', NULL, NULL),

-- Entrepreneurship Talents
(8, 6, 'Online Tutoring Platform Concept', 'A business plan for connecting students with qualified tutors for personalized learning.', 'tutoring-platform.jpg', NULL, 'APPROVED', 1, NOW()),
(15, 6, 'Sustainable Fashion Startup', 'A startup idea focused on creating eco-friendly clothing from recycled materials.', 'sustainable-fashion.jpg', NULL, 'APPROVED', 1, NOW()),
(8, 6, 'Local Food Delivery Network', 'A business model for connecting local farms directly with urban consumers.', 'food-delivery.jpg', NULL, 'APPROVED', 1, NOW()),
(15, 6, 'Youth Skill Development Center', 'A proposal for a community center offering free skill training for underprivileged youth.', 'skill-center.jpg', NULL, 'PENDING', NULL, NULL);

-- Insert More Ratings (Making the platform more active)
INSERT INTO ratings (talent_id, user_id, rating_value) VALUES
-- Music ratings
(7, 2, 5), (7, 3, 5), (7, 5, 4), (7, 6, 5),
(8, 3, 4), (8, 5, 5), (8, 6, 4), (8, 7, 5),
(9, 5, 5), (9, 6, 5), (9, 7, 4),
-- Art ratings
(10, 2, 4), (10, 3, 5), (10, 6, 4), (10, 7, 5),
(11, 2, 5), (11, 5, 5), (11, 6, 5), (11, 8, 4),
(12, 3, 4), (12, 5, 5), (12, 7, 4),
-- Coding ratings
(14, 2, 5), (14, 5, 5), (14, 7, 4), (14, 8, 5),
(15, 3, 5), (15, 6, 4), (15, 7, 5), (15, 10, 5),
(16, 2, 4), (16, 5, 5), (16, 8, 4),
-- Writing ratings
(18, 2, 5), (18, 3, 4), (18, 6, 5), (18, 10, 5),
(19, 5, 5), (19, 6, 5), (19, 8, 4), (19, 11, 5),
(20, 2, 4), (20, 7, 5), (20, 10, 4),
(21, 3, 5), (21, 6, 5), (21, 11, 5),
-- Innovation ratings
(22, 2, 5), (22, 3, 5), (22, 7, 5), (22, 12, 4),
(23, 5, 5), (23, 6, 4), (23, 10, 5), (23, 12, 5),
(24, 2, 4), (24, 7, 5), (24, 11, 5),
-- Entrepreneurship ratings
(26, 2, 4), (26, 3, 5), (26, 6, 4), (26, 13, 5),
(27, 5, 5), (27, 7, 5), (27, 10, 4), (27, 13, 5),
(28, 2, 5), (28, 6, 4), (28, 11, 5);

-- Insert More Comments (Making the community more engaging)
INSERT INTO comments (talent_id, user_id, comment_text) VALUES
-- Music comments
(7, 3, 'This EDM track is amazing! The drop is incredible.'),
(7, 5, 'Love the energy in this track. Would love to hear more!'),
(8, 2, 'Your acoustic covers are so soothing. Beautiful work!'),
(8, 6, 'The arrangement is unique and refreshing. Keep it up!'),
(9, 5, 'Jazz improvisation at its finest! You have real talent.'),
-- Art comments
(10, 2, 'The colors and composition are stunning. Very inspiring!'),
(10, 6, 'Your watercolor technique is impressive. Love the abstract style.'),
(11, 5, 'These 3D character designs are professional quality. Amazing!'),
(11, 8, 'The level of detail in each character is incredible.'),
(12, 3, 'Great eye for capturing street art. These photos tell a story.'),
-- Coding comments
(14, 5, 'This e-commerce site is well-built and user-friendly. Great job!'),
(14, 7, 'Clean code and good UI/UX design. Impressive project!'),
(15, 3, 'This fitness app would be really useful. Hope to see it launched!'),
(15, 10, 'Love the features! The UI is intuitive and motivating.'),
(16, 2, 'Excellent data visualization capabilities. Very useful tool!'),
-- Writing comments
(18, 2, 'This sci-fi story is gripping! Can\'t wait to read more.'),
(18, 6, 'The world-building is excellent. You have a gift for storytelling.'),
(19, 5, 'Your poems are so powerful and thought-provoking.'),
(19, 11, 'Beautiful use of language. Each poem resonates deeply.'),
(20, 7, 'Your travel stories make me want to pack my bags and go!'),
(21, 6, 'The fantasy world you created is vivid and captivating.'),
-- Innovation comments
(22, 2, 'This solar water purifier could help so many communities. Brilliant!'),
(22, 7, 'Innovative and practical solution. Hope this gets implemented!'),
(23, 5, 'Smart home automation is the future. Great implementation!'),
(24, 7, 'Eco-friendly packaging is so needed. Excellent initiative!'),
-- Entrepreneurship comments
(26, 2, 'This tutoring platform idea is solid. I would definitely use it!'),
(26, 13, 'Great business plan with clear value proposition.'),
(27, 5, 'Sustainable fashion is important. Love this startup idea!'),
(28, 11, 'Local food delivery would benefit both farmers and consumers. Great!');

-- Insert Sample Reports (Testing moderation system)
INSERT INTO reports (reporter_id, reported_item_type, reported_item_id, report_reason, status) VALUES
(5, 'COMMENT', 8, 'This comment contains spam links', 'PENDING'),
(7, 'TALENT', 13, 'Inappropriate content for youth platform', 'PENDING'),
(10, 'COMMENT', 15, 'Offensive language used', 'REVIEWED');

-- Award More Badges to Active Users
INSERT INTO user_badges (user_id, badge_id) VALUES
(6, 1), (7, 1), (8, 1), (9, 1), (10, 1),
(11, 1), (12, 1), (13, 1), (14, 1), (15, 1),
(3, 2), (6, 2), (10, 2),
(2, 3), (6, 3), (10, 3),
(3, 4), (5, 4);

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
