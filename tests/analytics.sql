-- Create table for storing user information
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  user_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for storing sessions
CREATE TABLE sessions (
  session_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  session_start TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  session_end TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Create table for storing page views
CREATE TABLE page_views (
  page_view_id INT AUTO_INCREMENT PRIMARY KEY,
  session_id INT,
  page_url VARCHAR(255) NOT NULL,
  view_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES sessions(session_id)
);

-- Create table for storing events
CREATE TABLE events (
  event_id INT AUTO_INCREMENT PRIMARY KEY,
  session_id INT,
  event_name VARCHAR(255) NOT NULL,
  event_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES sessions(session_id)
);

-- Create table for storing traffic sources
CREATE TABLE traffic_sources (
  source_id INT AUTO_INCREMENT PRIMARY KEY,
  session_id INT,
  source_name VARCHAR(255) NOT NULL,
  medium VARCHAR(255) NOT NULL,
  campaign VARCHAR(255),
  FOREIGN KEY (session_id) REFERENCES sessions(session_id)
);

-- Query to get the number of users who signed up each day
SELECT DATE(created_at) AS signup_date, COUNT(*) AS user_count
FROM users
GROUP BY signup_date
ORDER BY signup_date;

-- Query to get the average session duration for each user
SELECT u.user_id, u.user_name, AVG(TIMESTAMPDIFF(SECOND, s.session_start, s.session_end)) AS avg_session_duration
FROM users u
JOIN sessions s ON u.user_id = s.user_id
GROUP BY u.user_id, u.user_name
ORDER BY avg_session_duration DESC;

-- Query to get the most viewed pages
SELECT pv.page_url, COUNT(*) AS view_count
FROM page_views pv
GROUP BY pv.page_url
ORDER BY view_count DESC;

-- Query to get the number of events per session
SELECT s.session_id, COUNT(e.event_id) AS event_count
FROM sessions s
JOIN events e ON s.session_id = e.session_id
GROUP BY s.session_id
ORDER BY event_count DESC;

-- Query to get the traffic sources breakdown
SELECT ts.source_name, ts.medium, COUNT(*) AS session_count
FROM traffic_sources ts
GROUP BY ts.source_name, ts.medium
ORDER BY session_count DESC;
