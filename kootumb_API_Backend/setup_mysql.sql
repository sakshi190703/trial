-- MySQL setup script for Kootumb
-- Create database
CREATE DATABASE IF NOT EXISTS kootumb_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user for Kootumb
CREATE USER IF NOT EXISTS 'kootumb_user'@'localhost' IDENTIFIED BY 'KootumbPassword123!';

-- Grant privileges
GRANT ALL PRIVILEGES ON kootumb_db.* TO 'kootumb_user'@'localhost';
FLUSH PRIVILEGES;

-- Show databases to confirm
SHOW DATABASES;

-- Show user privileges
SHOW GRANTS FOR 'kootumb_user'@'localhost';
