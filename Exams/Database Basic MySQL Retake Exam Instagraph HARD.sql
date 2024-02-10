-- Database Overview and creation
CREATE DATABASE instagraph_db;
USE instagraph_db;

CREATE TABLE pictures(
id INT PRIMARY KEY AUTO_INCREMENT,
`path` VARCHAR(255) NOT NULL,
size DECIMAL(10,2) NOT NULL
);
CREATE TABLE users(
id INT PRIMARY KEY AUTO_INCREMENT,
username VARCHAR(30) NOT NULL UNIQUE,
password VARCHAR(30) NOT NULL,
profile_picture_id INT ,
CONSTRAINT fk_user_picture FOREIGN KEY (profile_picture_id)
REFERENCES pictures(id)
);
CREATE TABLE posts(
id INT PRIMARY KEY AUTO_INCREMENT,
caption VARCHAR(255) NOT NULL,
user_id INT NOT NULL,
picture_id INT  NOT NULL ,
CONSTRAINT fk_user_id_users FOREIGN KEY (user_id)
REFERENCES users(id),
CONSTRAINT fk_picture_id_pictures FOREIGN KEY (picture_id)
REFERENCES pictures(id)
);
CREATE TABLE comments(
id INT PRIMARY KEY AUTO_INCREMENT,
content VARCHAR(255) NOT NULL,
user_id INT NOT NULL,
post_id INT NOT NULL,
CONSTRAINT fk_comment_user FOREIGN KEY (user_id)
REFERENCES users(id),
CONSTRAINT fk_comment_post FOREIGN KEY(post_id)
REFERENCES posts(id)
);
CREATE TABLE users_followers(
user_id INT ,
follower_id INT ,
CONSTRAINT fk_user_id_userss FOREIGN KEY(user_id)
REFERENCES users(id),
CONSTRAINT fk_follower_id_users FOREIGN KEY (follower_id)
REFERENCES users(id)
);

-- 02. Data Insert
INSERT INTO comments(content,user_id,post_id)
SELECT 
CONCAT('Omg!',u.username,'!This is so cool!') AS content,
CEILING((p.id * 3) / 2 ) AS user_id,
p.id AS post_id
FROM posts AS p
JOIN users AS u ON p.user_id = u.id
WHERE p.id BETWEEN 1 AND 10;

-- 03. Data Update
UPDATE users AS u
SET u.profile_picture_id = IFNULL(
    (SELECT COUNT(user_id) FROM users_followers WHERE u.id = user_id),
    u.id
)
WHERE u.profile_picture_id IS NULL;

-- 04. Data Deletion
DELETE FROM users
WHERE id NOT IN (
    SELECT user_id FROM users_followers
) AND id NOT IN (
    SELECT follower_id FROM users_followers
);

-- Second Solution
DELETE u
FROM users AS u
LEFT JOIN users_followers AS following ON u.id = following.user_id
LEFT JOIN users_followers AS followers ON u.id = followers.follower_id
WHERE following.user_id IS NULL AND followers.follower_id IS NULL;

-- 05. Users
SELECT id,username 
FROM users
ORDER BY id;

-- 06. Cheaters 
SELECT u.id,u.username
FROM users_followers AS uf
JOIN users AS u ON uf.user_id = u.id
WHERE uf.user_id = uf.follower_id
ORDER BY u.id;

-- 07. High Quality Pictures
SELECT 
    p.id, p.path, p.size
FROM
    pictures AS p
WHERE
    size > 50000 AND p.path LIKE '%jpeg%'
        OR p.path LIKE '%png%'
ORDER BY p.size DESC;

-- 08. Comments and Users
SELECT 
c.id ,
CONCAT(u.username,' : ',c.content) AS 'full_comment'
FROM comments AS c
JOIN users AS u ON c.user_id = u.id
ORDER BY c.id DESC;

-- 09. Profile Pictures
-- The query retrieves users who have 
-- the same profile picture as at least one other user.
SELECT u.id, u.username, CONCAT(p.size, 'KB') AS size
FROM users AS u
JOIN pictures AS p ON u.profile_picture_id = p.id
WHERE u.profile_picture_id IN (
    SELECT profile_picture_id
    FROM users
    GROUP BY profile_picture_id
    HAVING COUNT(*) > 1
)
ORDER BY u.id;

-- 10. Spam Posts
-- Top 5 posts in terms of count of comments
SELECT
p.id,
p.caption,
COUNT(p.id) AS 'comments'
FROM posts AS p
JOIN comments AS c ON c.post_id = p.id
GROUP BY c.post_id
ORDER BY `comments` DESC, p.id 
limit 5;

-- 11. Most Popular User
SELECT 
    u.id,
    u.username,
    (SELECT 
            COUNT(*)
        FROM
            posts AS p
        WHERE
            u.id = p.user_id
        GROUP BY p.user_id) AS 'posts',
    (SELECT 
            COUNT(*)
        FROM
            users_followers AS uf
        WHERE
            u.id = uf.user_id
        GROUP BY uf.user_id) AS 'followers'
FROM
    users AS u
ORDER BY `followers` DESC
LIMIT 1;

