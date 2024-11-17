-- User profiles
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Content creation (posts)
CREATE TABLE posts (
  post_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Content creation (comments)
CREATE TABLE comments (
  comment_id INT AUTO_INCREMENT PRIMARY KEY,
  post_id INT NOT NULL,
  user_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES posts(post_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Friend/follower relationships
CREATE TABLE relationships (
  relationship_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  friend_id INT NOT NULL,
  status ENUM('pending', 'accepted', 'declined') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (friend_id) REFERENCES users(user_id)
);

-- Real-time notifications
CREATE TABLE notifications (
  notification_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Media storage (images, videos)
CREATE TABLE media (
  media_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  post_id INT,
  media_type ENUM('image', 'video') NOT NULL,
  media_url VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (post_id) REFERENCES posts(post_id)
);

-- Query to get all posts with their respective user information
SELECT
  posts.post_id,
  posts.content AS post_content,
  posts.created_at AS post_created_at,
  users.username AS post_author
FROM
  posts
JOIN
  users ON posts.user_id = users.user_id;

-- Query to get all comments for a specific post
SELECT
  comments.comment_id,
  comments.content AS comment_content,
  comments.created_at AS comment_created_at,
  users.username AS comment_author
FROM
  comments
JOIN
  users ON comments.user_id = users.user_id
WHERE
  comments.post_id = 1;

-- Query to get all friends for a specific user
SELECT
  users.username AS friend_username,
  relationships.status,
  relationships.created_at AS friendship_created_at
FROM
  relationships
JOIN
  users ON relationships.friend_id = users.user_id
WHERE
  relationships.user_id = 1 AND relationships.status = 'accepted';

-- Query to get all unread notifications for a specific user
SELECT
  notifications.notification_id,
  notifications.message,
  notifications.created_at AS notification_created_at
FROM
  notifications
WHERE
  notifications.user_id = 1 AND notifications.is_read = FALSE;

-- Query to get all media (images and videos) for a specific post
SELECT
  media.media_id,
  media.media_type,
  media.media_url,
  media.created_at AS media_created_at
FROM
  media
WHERE
  media.post_id = 1;
