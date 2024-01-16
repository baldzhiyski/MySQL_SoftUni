CREATE DATABASE minions;

CREATE TABLE minions (
 id INT AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(50),
 age INT 
);
CREATE TABLE towns(
town_id INT AUTO_INCREMENT ,
name VARCHAR(50),
CONSTRAINT pk_town_id
PRIMARY KEY (town_id)
);

ALTER TABLE towns
CHANGE COLUMN town_id  id INT; 

ALTER TABLE minions
ADD COLUMN town_id INT, 
ADD CONSTRAINT fk_town_id 
FOREIGN KEY (town_id) REFERENCES townsid(id);

INSERT INTO towns(id,name) VALUES(1,'Sofia');
INSERT INTO towns(id,name) VALUES(2,'Plovdiv');
INSERT INTO towns(id,name) VALUES(3,'Varna');


INSERT INTO minions(id,name,age,town_id) VALUES(1,'Kevin',22,1);
INSERT INTO minions(id,name,age,town_id) VALUES(2,'Bob',15,3);
INSERT INTO minions(id,name,age,town_id) VALUES(3,'Steward',NULL,2);

UPDATE minions
SET name = 'Bob'
WHERE id =2;
UPDATE minions
SET age = '15'
WHERE id =2;
UPDATE minions
SET town_id = 2
WHERE id =3;
UPDATE minions
SET town_id = 3
WHERE id =2;

TRUNCATE TABLE minions;
DROP TABLE minions;
DROP TABLE towns;

CREATE TABLE people(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(200) NOT NULL,
picture BLOB,
height DOUBLE (6,2),
weight DOUBLE(6,2),
gender CHAR(1) NOT NULL,
birthdate DATE NOT NULL,
biography BLOB
);

INSERT INTO people(name,picture,height,weight,gender,birthdate,biography) VALUES
('Ivan','text',1.89,95,'m','1976-05-04','test'),
('Gosho','text',1.89,95,'m','1976-05-04','test'),
('Ilian','text',1.89,95,'m','1976-05-04','test'),
('Mariq','text',1.89,95,'f','1976-05-04','test'),
('Cveti','text',1.89,95,'f','1976-05-04','test');

SELECT *FROM people;


CREATE TABLE users(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
username VARCHAR(30) NOT NULL UNIQUE,
password VARCHAR(26) NOT NULL,
profile_picture BLOB,
last_login_time DATETIME,
is_deleted BOOlEAN
);

ALTER TABLE users
MODIFY COLUMN id INT NOT NULL;


INSERT INTO users(username,password,profile_picture,last_login_time,is_deleted) VALUES
('Pesho','123','text',NOW(),false),
('Pesho1','123','text',NOW(),false),
('Pesho2','123','text',NOW(),true),
('Pesho3','123','text',NOW(),false),
('Pesho4','123','text',NOW(),false);

ALTER TABLE users
ADD PRIMARY KEY(id,username);

ALTER TABLE users
CHANGE last_login_time last_login_time DATETIME DEFAULT NOW();

-- 10. Set Unique Field
ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY users(id),
CHANGE COLUMN username
username VARCHAR(30) UNIQUE;

-- 11. Movies Database
CREATE DATABASE movies;
CREATE TABLE directors(
id INT PRIMARY KEY NOT NULL,
director_name VARCHAR(30) NOT NULL,
notes BLOB
);
CREATE TABLE genres(
id INT PRIMARY KEY NOT NULL,
genre_name VARCHAR(30) NOT NULL,
notes BLOB
);
CREATE TABLE categories(
id INT PRIMARY KEY NOT NULL,
category_name VARCHAR(30) NOT NULL,
notes BLOB
);
CREATE TABLE movies(
id INT PRIMARY KEY NOT NULL,
title VARCHAR(30) NOT NULL,
director_id INT NOT NULL,
copyright_year YEAR NOT NULL,
length INT NOT NULL,
genre_id INT NOT NULL,
category_id INT NOT NULL,
rating INT NOT NULL,
notes BLOB
);
-- Insert data into directors table
INSERT INTO directors (id, director_name, notes) VALUES
(1, 'Christopher Nolan', 'Renowned director'),
(2, 'Quentin Tarantino', 'Famous for unique storytelling'),
(3, 'Steven Spielberg', 'Legendary filmmaker'),
(4, 'Greta Gerwig', 'Acclaimed for indie films'),
(5, 'Martin Scorsese', 'Master of crime dramas');

-- Insert data into genres table
INSERT INTO genres (id, genre_name, notes) VALUES
(1, 'Action', 'Thrilling and fast-paced'),
(2, 'Drama', 'Emotionally intense storytelling'),
(3, 'Comedy', 'Humorous and light-hearted'),
(4, 'Sci-Fi', 'Futuristic and imaginative'),
(5, 'Horror', 'Scary and suspenseful');

-- Insert data into categories table
INSERT INTO categories (id, category_name, notes) VALUES
(1, 'Classic', 'Timeless films'),
(2, 'Independent', 'Produced outside major studios'),
(3, 'Blockbuster', 'High-budget and widely popular'),
(4, 'Foreign', 'Produced in a language other than English'),
(5, 'Cult', 'Developed a dedicated fan base');

-- Insert data into movies table
INSERT INTO movies (id, title, director_id, copyright_year, length, genre_id, category_id, rating, notes) VALUES
(1, 'Inception', 1, 2010, 148, 1, 3, 9, 'Mind-bending thriller'),
(2, 'Pulp Fiction', 2, 1994, 154, 2, 1, 8, 'Non-linear narrative'),
(3, 'Jurassic Park', 3, 1993, 127, 1, 3, 7, 'Dinosaurs come alive'),
(4, 'Lady Bird', 4, 2017, 94, 2, 2, 8, 'Coming-of-age drama'),
(5, 'Goodfellas', 5, 1990, 146, 1, 1, 9, 'Gritty crime epic');

-- 12. Car Rental Database
CREATE DATABASE car_rental;
CREATE TABLE categories(
id INT NOT NULL PRIMARY KEY,
category VARCHAR(30) NOT NULL,
daily_rate INT NOT NULL,
weekly_rate INT NOT NULL,
monthly_rate INT NOT NULL,
weekend_rate INT NOT NULL
);
CREATE TABLE cars(
id INT NOT NULL PRIMARY KEY,
plate_number INT NOT NULL UNIQUE,
make VARCHAR(30) NOT NULL,
model VARCHAR(30),
car_year YEAR NOT NULL,
doors INT ,
picture BLOB,
car_condition VARCHAR(20) NOT NULL,
available BOOLEAN
);
CREATE TABLE employees(
id INT NOT NULL PRIMARY KEY,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
title VARCHAR(30),
notes BLOB
);
CREATE TABLE customers(
id INT NOT NULL PRIMARY KEY,
driver_licence_number INT NOT NULL UNIQUE,
full_name VARCHAR(80) NOT NULL,
address VARCHAR(100),
city VARCHAR(20),
zip_code INT NOT NULL,
notes BLOB
);
CREATE TABLE rental_orders(
id INT NOT NULL PRIMARY KEY,
employee_id INT NOT NULL ,
customer_id INT NOT NULL ,
car_id INT NOT NULL ,
car_condition VARCHAR(30) NOT NULL,
tank_level INT,
kilometrage_start INT,
kilometrage_end INT,
total_kilometrage INT,
start_date DATE NOT NULL,
end_date DATE NOT NULL,
total_days INT ,
rate_applied INT,
tax_rate INT,
order_status VARCHAR(30),
notes BLOB
);
-- Insert data into categories table
INSERT INTO categories (id, category, daily_rate, weekly_rate, monthly_rate, weekend_rate) VALUES
(1, 'Economy', 30, 150, 500, 40),
(2, 'Midsize', 40, 200, 700, 50),
(3, 'Luxury', 60, 300, 1000, 80);

-- Insert data into cars table
INSERT INTO cars (id, plate_number, make, model, car_year, doors, picture, car_condition) VALUES
(1, 123456, 'Toyota', 'Camry', 2022, 4, NULL, 'Excellent'),
(2, 789012, 'Honda', 'Accord', 2021, 4, NULL, 'Good'),
(3, 345678, 'BMW', 'X5', 2023, 4, NULL, 'Excellent');

-- Insert data into employees table
INSERT INTO employees (id, first_name, last_name, title, notes) VALUES
(1, 'John', 'Doe', 'Manager', 'Experienced employee'),
(2, 'Jane', 'Smith', 'Sales Associate', 'Customer service expert'),
(3, 'Bob', 'Johnson', 'Mechanic', 'Skilled technician');

-- Insert data into customers table
INSERT INTO customers (id, driver_licence_number, full_name, address, city, zip_code, notes) VALUES
(1, 987654321, 'Alice Johnson', '123 Main St', 'Cityville', 12345, 'Regular customer'),
(2, 654321987, 'Mark Davis', '456 Oak St', 'Townsburg', 54321, 'Preferred member'),
(3, 123789456, 'Emily Williams', '789 Pine St', 'Villagetown', 67890, 'New customer');

-- Insert data into rental_orders table
INSERT INTO rental_orders (id, employee_id, customer_id, car_id, car_condition, tank_level, kilometrage_start, kilometrage_end, total_kilometrage, start_date, end_date, total_days, rate_applied, tax_rate, order_status, notes) VALUES
(1, 1, 1, 1, 'Clean', 80, 1000, 1500, 500, '2024-01-01', '2024-01-05', 5, 40, 5, 'Completed', 'Satisfied customer'),
(2, 2, 2, 2, 'Good', 75, 800, 1200, 400, '2024-02-01', '2024-02-07', 7, 50, 7, 'In Progress', 'Follow up required'),
(3, 3, 3, 3, 'Excellent', 90, 1200, 1800, 600, '2024-03-01', '2024-03-10', 9, 60, 8, 'Pending Payment', 'VIP customer');

-- 13. Basic Insert
CREATE DATABASE soft_uni;
CREATE TABLE towns(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
name VARCHAR(30)
);
CREATE TABLE addresses(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
address_text VARCHAR(80) NOT NULL,
town_id INT NOT NULL UNIQUE,
FOREIGN KEY fk_town_id (town_id)
REFERENCES addresses(id)
);
CREATE TABLE departments(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(80)
);
CREATE TABLE employees(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50),
middle_name VARCHAR(50),
last_name VARCHAR(50),
job_title VARCHAR(50),
department_id INT NOT NULL UNIQUE,
hire_date DATE,
salary DOUBLE(6,2) ,
address_id INT NOT NULL UNIQUE,
FOREIGN KEY fk_employees_id (address_id)
REFERENCES employees(id)
);

ALTER TABLE employees
MODIFY address_id INT UNIQUE;

-- Insert data into towns table
INSERT INTO towns (name) VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

-- Insert data into addresses table
INSERT INTO addresses (address_text, town_id) VALUES
('Address 1', 1),
('Address 2', 2),
('Address 3', 3),
('Address 4', 4);

-- Insert data into departments table
INSERT INTO departments (name) VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

-- Insert data into employees table
INSERT INTO employees (first_name, middle_name, last_name, job_title, department_id, hire_date, salary) VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013/02/01' , 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004/03/02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016/08/28', 525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007/12/09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016/08/28', 599.88);

-- 14. Basic Select All Fields
SELECT *FROM towns;
SELECT*  FROM departments;
SELECT* FROM employees;

-- 15. Basic Select All Fields and Order Them
SELECT *FROM towns
ORDER BY name;
SELECT*  FROM departments
ORDER BY name;
SELECT* FROM employees
ORDER BY salary DESC;

-- 16. Basic Select Some Fields
SELECT 
    name
FROM
    towns
ORDER BY name;
SELECT 
    name
FROM
    departments
ORDER BY name;
SELECT 
    first_name,last_name,job_title,salary
FROM
    employees
ORDER BY salary DESC;

-- 17 . Increcement of all salaries.
UPDATE employees
SET salary = salary * 1.1;

SELECT salary FROM employees;







