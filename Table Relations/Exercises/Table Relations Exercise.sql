-- 01. One-To-One Realtionship
CREATE TABLE passports(
	`passport_id` INT AUTO_INCREMENT PRIMARY KEY,
    `passport_number` VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO passports (`passport_id`, `passport_number`)
VALUES (101, 'N34FG21B'),
		(102, 'K65LO4R7'),
        (103, 'ZE657QP2');
        
CREATE TABLE people(
		`person_id` INT AUTO_INCREMENT PRIMARY KEY,
        `first_name` VARCHAR(50) NOT NULL,
        `salary` DECIMAL(10, 2),
        `passport_id` INT NOT NULL UNIQUE,
        CONSTRAINT fk_people_passports_id
        FOREIGN KEY (passport_id)
        REFERENCES passports(passport_id)
);

INSERT INTO people (`person_id`, `first_name`, `salary`, `passport_id`)
VALUES (1, 'Roberto', 43300.00, 102),
		(2, 'Tom', 56100.00, 103),
        (3, 'Yana', 60200.00, 101);
        
    
 -- 02. One-To-Many Relationship
 CREATE TABLE manufacturers(
 manufacturer_Id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(50) UNIQUE NOT NULL,
 established_on DATE NOT NULL 
 );
 
 CREATE TABLE models(
 model_id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(50) NOT NULL ,
 manufacturer_id INT,
 CONSTRAINT fk_models_manufactorers
 FOREIGN KEY (manufacturer_id)
 REFERENCES manufacturers(manufacturer_id)
 );
 
 ALTER TABLE models AUTO_INCREMENT = 101;
 
 -- Inserts for manufactures table
INSERT INTO `manufacturers`( `name`, `established_on`)
VALUES ( 'BMW', '1916/03/01'),
       ( 'Tesla', '2003/01/01'),
       ( 'Lada', '1966/05/01');

-- Inserts for models table
INSERT INTO `models`(`name`, `manufacturer_id`)
VALUES ( 'X1', 1),
       ( 'i6', 1),
       ( 'Model S', 2),
       ('Model X', 2),
       ( 'Model 3', 2),
       ('Nova', 3);
       
-- 03. Many-To-Many Relation
CREATE TABLE exams (
exam_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL
) AUTO_INCREMENT = 101;

CREATE TABLE students(
student_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL
);

CREATE TABLE students_exams(
student_id INT,
exam_id INT,
CONSTRAINT pk_students_exams
PRIMARY KEY (exam_id,student_id),
CONSTRAINT fk_students_exams_exams
FOREIGN KEY (exam_id)
REFERENCES exams(exam_id),
CONSTRAINT fk_exams_students
FOREIGN KEY(student_id)
REFERENCES students(student_id)
);

INSERT INTO students (`name`)
VALUES ('Mila'),
		('Toni'),
        ('Ron');
        
INSERT INTO exams (`name`)
VALUES ('Spring MVC'),
		('Neo4j'),
        ('Oracle 11g');
        
INSERT INTO students_exams (`student_id`, `exam_id`)
VALUES  (1, 101),
		(1, 102),
		(2, 101),
		(3, 103),
		(2, 102),
		(2, 103);
 
 -- 04.Self-Referencing
 USE soft_uni;

 CREATE TABLE teachers(
 teacher_id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(50) NOT NULL ,
 manager_id INT 
 )AUTO_INCREMENT = 101;
 
 INSERT INTO teachers(name,manager_id)
 VALUES ('John',NULL) ,
 ('Maya',106),
 ('Silvia',106),
 ('Ted',105),
 ('Mark',101),
 ('Greta',101);
 
 ALTER TABLE teachers
ADD CONSTRAINT fk_teacher_manager_id
        FOREIGN KEY (manager_id) 
        REFERENCES teachers(teacher_id);
 
 -- 05. Online Store Database
 CREATE TABLE item_types(
 item_type_id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(50) NOT NULL
 );
 
 CREATE TABLE cities(
 city_id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(50)
 );
 
 CREATE TABLE items(
 item_id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(50),
 item_type_id INT,
 CONSTRAINT fk_items_item_type
 FOREIGN KEY (item_type_id)
 REFERENCES item_types(item_type_id)
 );
 
 CREATE TABLE customers(
 customer_id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(50),
 birthday DATE NOT NULL,
 city_id INT ,
 CONSTRAINT fk_customers_city
 FOREIGN KEY (city_id)
 REFERENCES cities(city_id)
 );
 
 CREATE TABLE orders(
 order_id INT PRIMARY KEY AUTO_INCREMENT,
 customer_id INT ,
 CONSTRAINT fk_orders_customers
 FOREIGN KEY (customer_id)
 REFERENCES customers(customer_id)
 );
 
 CREATE TABLE order_items(
 order_id INT ,
 item_id INT ,
 CONSTRAINT PRIMARY KEY ( order_id,item_id),
 CONSTRAINT FOREIGN KEY(order_id)
 REFERENCES orders(order_id) ,
 CONSTRAINT FOREIGN KEY (item_id)
 REFERENCES items(item_id)
 );
 
 
 -- 06. University Database
 CREATE TABLE subjects (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_name VARCHAR(50) NOT NULL
);
 
CREATE TABLE majors (
    major_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);
 
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_number VARCHAR(12) NOT NULL,
    student_name VARCHAR(50) NOT NULL,
    major_id INT,
    CONSTRAINT fk_students_majors FOREIGN KEY (major_id)
        REFERENCES majors (major_id)
);
 
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_date DATE,
    payment_amount DECIMAL(8 , 2 ),
    student_id INT,
    CONSTRAINT fk_payments_students FOREIGN KEY (student_id)
        REFERENCES students (student_id)
);
 
CREATE TABLE agenda (
    student_id INT,
    subject_id INT,
    CONSTRAINT pk_agenda PRIMARY KEY (student_id , subject_id),
    CONSTRAINT fk_agenda_students FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT pk_sagenda_subjects FOREIGN KEY (subject_id)
        REFERENCES subjects (subject_id)
);

-- 07. SoftUni Design
CREATE DATABASE soft_uni;
USE soft_uni;

-- Departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(255) NOT NULL,
    manager_id INT,
    CONSTRAINT fk_departments_manager_id 
        FOREIGN KEY (manager_id) 
        REFERENCES employees(employee_id) 
);

-- Employees table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    department_id INT,
    manager_id INT,
    CONSTRAINT fk_employees_department_id 
        FOREIGN KEY (department_id) 
        REFERENCES departments(department_id),
    CONSTRAINT fk_employees_manager_id 
        FOREIGN KEY (manager_id) 
        REFERENCES employees(employee_id)
);
 
 -- 09. Peaks in Rilla
SELECT 
    m.mountain_range, p.peak_name, p.elevation AS peak_elevation
FROM
    mountains AS m
        JOIN
    peaks AS p ON m.id = p.mountain_id
WHERE
    m.mountain_range = 'Rila'
ORDER BY elevation DESC; 