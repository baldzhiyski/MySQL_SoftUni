-- Creating the data base
CREATE DATABASE universities_db;

CREATE TABLE countries(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE cities(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(40) NOT NULL UNIQUE,
population INT NOT NULL,
country_id INT,
CONSTRAINT FOREIGN KEY (country_id)
REFERENCES countries(id)
);


CREATE TABLE universities(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(60) NOT NULL UNIQUE,
address VARCHAR(80) NOT NULL UNIQUE,
tuition_fee DECIMAL(19,2) NOT NULL,
number_of_staff INT,
city_id INT,
CONSTRAINT FOREIGN KEY (city_id)
REFERENCES cities(id)
);

CREATE TABLE students(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(40) NOT NULL,
last_name VARCHAR(40) NOT NULL,
age INT ,
phone VARCHAR(20) NOT NULL UNIQUE,
email VARCHAR(255) NOT NULL UNIQUE,
is_graduated BOOL NOT NULL,
city_id INT,
CONSTRAINT FOREIGN KEY (city_id)
REFERENCES cities(id)
);

CREATE TABLE courses(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(40) NOT NULL UNIQUE,
duration_hours DECIMAL(19,2),
start_date DATE,
teacher_name VARCHAR(60) NOT NULL UNIQUE,
description TEXT ,
university_id INT ,
CONSTRAINT FOREIGN KEY (university_id)
REFERENCES universities(id)
);

CREATE TABLE students_courses(
grade DECIMAL(19,2) NOT NULL,
student_id INT NOT NULL,
course_id INT NOT NULL,
CONSTRAINT FOREIGN KEY(student_id)
REFERENCES students(id),
CONSTRAINT FOREIGN KEY (course_id)
REFERENCES courses(id)
);

-- Second Section
-- INSERT
INSERT INTO courses(name,duration_hours,start_date,teacher_name,description,
university_id)
SELECT 
CONCAT(teacher_name,' course') AS name,
LENGTH(`name`) / 10 AS duration_hours,
DATE_ADD(start_date, INTERVAL 5 DAY) AS start_date,
REVERSE(teacher_name) AS teacher_name,
CONCAT("Course ",`teacher_name`,REVERSE(description)) AS description,
DAY(`start_date`) AS university_id
FROM courses
WHERE id<=5;

-- UPDATE
UPDATE universities
SET tuition_fee = tuition_fee + 300
WHERE id BETWEEN 5 AND 12;

-- DELETE
DELETE FROM universities
WHERE number_of_staff IS NULL;

-- Third Section
SELECT id,name,population,country_id
FROM cities
ORDER BY population DESC;

-- 06.Students age
SELECT
first_name,last_name,age,phone,email
FROM students
where age>=21
ORDER BY first_name DESC , email,id 
LIMIT 10;

-- 07. New students
SELECT
CONCAT_WS(' ',first_name,last_name) AS 'full_name',
SUBSTRING(email,2 ,10) AS 'username',
REVERSE(phone) AS 'password'
FROM students AS s
LEFT JOIN students_courses AS sc ON s.id = sc.student_id
WHERE  sc.course_id  IS NULL
ORDER BY `password` DESC;

-- 08.Students count
 SELECT COUNT(c.id) students_count, u.name university_name
FROM universities u
          JOIN courses c ON u.id = c.university_id
          JOIN students_courses sc ON c.id = sc.course_id
 GROUP BY u.name
 HAVING students_count >= 8
 ORDER BY students_count DESC, u.name DESC;
 
-- 09. Price Rankings
DELIMITER //
CREATE FUNCTION display_rank(fee DECIMAL(19,2))
RETURNS VARCHAR(60)
DETERMINISTIC
BEGIN
    CASE
       WHEN fee <= 800 THEN  RETURN 'cheap';
       WHEN fee >= 800 AND fee < 1200 THEN RETURN 'normal';
       WHEN fee >= 1200 AND fee < 2500 THEN RETURN'high';
       ELSE RETURN 'expensive' ;
       END CASE;
END//
DELIMITER ;

SELECT 
u.name AS university_name,
c.name AS city_name,
u.address,
(SELECT display_rank(u.tuition_fee)) AS price_rank,
u.tuition_fee
FROM universities AS u
JOIN cities AS c ON u.city_id = c.id
ORDER BY tuition_fee;

-- Another Solution 
SELECT 
    u.name AS university_name,
    c.name AS city_name,
    u.address,
    (CASE
        WHEN tuition_fee <= 800 THEN 'cheap'
        WHEN tuition_fee >= 800 AND tuition_fee < 1200 THEN 'normal'
        WHEN tuition_fee >= 1200 AND tuition_fee < 2500 THEN 'high'
        ELSE 'expensive'
    END) AS price_rank,
    u.tuition_fee
FROM
    universities AS u
        JOIN
    cities AS c ON u.city_id = c.id
ORDER BY tuition_fee;

-- Section Four
-- 10. Average grades
DELIMITER //
CREATE FUNCTION udf_average_alumni_grade_by_course_name(course_name VARCHAR(60))
RETURNS DECIMAL(19,2) 
DETERMINISTIC
BEGIN
    DECLARE average_sum DECIMAL(19,2);
    SET average_sum :=(
    SELECT AVG(sc.grade) 
    FROM courses AS c
    JOIN students_courses AS sc ON c.id = sc.course_id
    JOIN students AS st ON st.id = sc.student_id
    WHERE c.name = course_name  AND 
    st.is_graduated = 1
    GROUP BY c.id);
    RETURN average_sum;
END//
DELIMITER ;

-- 11. Graduate students
DELIMITER //
CREATE PROCEDURE  udp_graduate_all_students_by_year(year_started INT)
BEGIN
    UPDATE courses AS c
    JOIN students_courses AS sc ON c.id = sc.course_id
    JOIN students AS s ON sc.student_id = s.id
    SET  s.is_graduated = 1
    WHERE YEAR(c.start_date) = year_started ;
END//
DELIMITER ;

CALL udp_graduate_all_students_by_year(2017);