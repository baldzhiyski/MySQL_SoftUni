-- Database Overview and Creation
CREATE DATABASE stc;
USE stc;

CREATE TABLE addresses(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100) NOT NULL
);

CREATE TABLE categories(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(10) NOT NULL
);

CREATE TABLE clients(
id INT PRIMARY KEY AUTO_INCREMENT,
full_name VARCHAR(50) NOT NULL,
phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE drivers(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
age INT NOT NULL,
rating  FLOAT DEFAULT 5.5 NOT NULL
);

CREATE TABLE cars(
id INT PRIMARY KEY AUTO_INCREMENT,
make VARCHAR(20) NOT NULL,
model VARCHAR(20) ,
year INT DEFAULT 0 NOT NULL,
mileage INT DEFAULT 0 ,
`condition` CHAR(1) NOT NULL,
category_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (category_id)
REFERENCES categories(id)
);

CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    from_address_id INT NOT NULL,
    start DATETIME NOT NULL,
    bill DECIMAL(10 , 2 ) DEFAULT 10,
    car_id INT NOT NULL,
    client_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY (from_address_id)
        REFERENCES addresses (id),
    CONSTRAINT FOREIGN KEY (car_id)
        REFERENCES cars (id),
    CONSTRAINT FOREIGN KEY (client_id)
        REFERENCES clients (id)
);

CREATE TABLE cars_drivers(
car_id INT NOT NULL,
driver_id INT NOT NULL,
CONSTRAINT PRIMARY KEY ( car_id,driver_id),
CONSTRAINT FOREIGN KEY (car_id)
REFERENCES cars(id),
CONSTRAINT FOREIGN KEY (driver_id) 
REFERENCES drivers(id)
);

-- Second Section
-- 02. Insert
INSERT INTO clients(full_name,phone_number)
SELECT 
CONCAT(first_name,' ',last_name),
CONCAT('(088) 9999',id*2)
FROM drivers
WHERE id BETWEEN 10 AND 20;

-- 03. Update
UPDATE cars
SET `condition` = 'C'
WHERE (mileage >= 800000 OR  mileage IS NULL )
AND year <= '2010';

-- 04. Delete
DELETE  c FROM clients AS c
LEFT JOIN courses AS cs ON cs.client_id = c.id
WHERE cs.id IS NULL  AND LENGTH(c.full_name) >3;

-- Third Section
-- 05. Cats
SELECT make,model,`condition`
FROM cars ORDER BY id;

-- 06. Drivers and Cars
SELECT 
    d.first_name, d.last_name, c.make, c.model, c.mileage
FROM
    drivers AS d
        JOIN
    cars_drivers AS cd ON cd.driver_id = d.id
        JOIN
    cars AS c ON cd.car_id = c.id
WHERE
    c.mileage IS NOT NULL
ORDER BY c.mileage DESC , first_name;

-- 07. Number of courses for each car
-- In Progress
SELECT 
    c.id AS 'car_id',
    c.make,
    c.mileage,
    COUNT(c.id) AS 'count_of_courses',
    ROUND(AVG(cs.bill), 2) AS 'avg_bill'
FROM
    cars AS c
       LEFT  JOIN
    courses AS cs ON cs.car_id = c.id
GROUP BY c.id 
HAVING `count_of_courses` <> 2
ORDER BY `count_of_courses` DESC , c.id ; 

-- 08. Regular clients
SELECT 
    c.full_name,
    COUNT(ca.id) AS 'count_of_cars',
    SUM(cs.bill) AS 'total_sum'
FROM
    clients AS c
        JOIN
    courses AS cs ON cs.client_id = c.id
        JOIN
    cars AS ca ON ca.id = cs.car_id
WHERE
    SUBSTRING(c.full_name, 2, 1) = 'a'
GROUP BY c.id
HAVING `count_of_cars` > 1
ORDER BY c.full_name;

-- 09. Full Info for courses
SELECT 
a.name AS 'name',
(CASE
    WHEN HOUR(c.start) BETWEEN 6 AND 20 THEN 'Day'
    ELSE 'Night'
    END) AS 'day_time',
    c.bill,
    cl.full_name,
    cr.make,cr.model,
    cat.name    
FROM courses AS c
JOIN addresses AS a ON a.id = c.from_address_id
JOIN clients AS cl ON cl.id = c.client_id
JOIN cars AS cr ON cr.id = c.car_id
JOIN categories AS cat ON cat.id = cr.category_id
ORDER BY c.id;

-- 10. Find all courses by clients phone number
DELIMITER // 
CREATE FUNCTION udf_courses_by_client (phone_num VARCHAR (20))
RETURNS INT 
DETERMINISTIC
BEGIN
    RETURN(SELECT COUNT(*) AS 'count'
    FROM clients  AS c
    JOIN courses AS co ON co.client_id = c.id
    WHERE c.phone_number=phone_num
    GROUP BY c.id);
END//
DELIMITER ;
SELECT udf_courses_by_client ('(803) 6386812') as `count`; 

-- 11. Full info for address
DELIMITER //
CREATE PROCEDURE  udp_courses_by_address(address_name VARCHAR(100))
BEGIN
   SELECT 
   a.name,
   c.full_name,
   (CASE 
      WHEN co.bill <= 20 THEN 'Low'
      WHEN co.bill <=30 THEN 'Medium'
      ELSE 'High'
      END) AS 'level_of_bill',
      ca.make,
      ca.`condition`,
      cat.name AS 'cat_name'
   FROM addresses AS a
   JOIN courses AS co ON co.from_address_id = a.id
   JOIN clients AS c ON c.id = co.client_id
   JOIN cars AS ca ON ca.id =co.car_id
   JOIN  categories AS cat ON cat.id = ca.category_id
   WHERE a.name = address_name
   ORDER BY ca.make,c.full_name;
END //
DELIMITER ;

CALL udp_courses_by_address('700 Monterey Avenue');
