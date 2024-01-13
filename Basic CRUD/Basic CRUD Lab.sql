-- 01. Select Employee Information
SELECT id,first_name,last_name,job_title 
FROM employees 
ORDER BY id;

SELECT 
    e.id AS 'No.',
    e.first_name AS 'First Name',
    e.last_name AS 'Last Name',
    e.job_title AS 'Job Title'
FROM
    employees AS e
    ORDER BY id;
    
SELECT 
    CONCAT('#',
            id,
            '-> ',
            first_name,
            ' ',departments
            last_name) AS 'Full Name'
FROM
    employees;
    
SELECT CONCAT_WS(' ',first_name,last_name,job_title) AS 'Info'
FROM employees;

SELECT 
CONCAT(first_name,' ',last_name) AS 'CONCAT',
CONCAT_WS(' ',first_name,last_name) AS 'CONTCAT_WS'
FROM clients; 

-- 02. Select Employees with Filter
SELECT 
    id,
    CONCAT(first_name,' ', last_name) AS 'Full Name',
    job_title,
    salary
FROM
    employees
    WHERE salary > 1000
    ORDER BY id; 
-- 
SELECT DISTINCT first_name
FROM employees;

SELECT 
    *
FROM
    employees
WHERE
salary BETWEEN 1100 AND 2000;

SELECT DISTINCT department_id 
FROM employees 
WHERE salary<1500;

SELECT * 
FROM departments 
WHERE id NOT IN (1,2,3,4);

SELECT * 
FROM employees
WHERE department_id = 4 AND salary >=1000
ORDER BY id DESC;

SELECT *
FROM clients 
WHERE last_name IS  NULL;

-- Defining a view 
CREATE VIEW v_employee_summary AS
    SELECT 
        id,
        CONCAT(first_name, ' ', last_name) AS 'Full Name',
        job_title,
        salary
    FROM
        employees
    WHERE
        salary > 1000
    ORDER BY first_name , last_name; 
    
    SELECT 
    *
FROM
    v_employee_summary
    WHERE salary > 1500;

DROP VIEW v_employee_summary;

CREATE VIEW v_top_paid AS 
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 1;

SELECT*
FROM test_clients;

CREATE TABLE test_clients AS 
SELECT id, first_name, room_id FROM
    clients
    WHERE first_name IS NOT NULL;
    
    DROP TABLE test_clients;
    TRUNCATE TABLE test_clients;
    
INSERT INTO test_clients(first_name,room_id)
SELECT first_name,room_id
FROM clients
WHERE first_name IS NOT NULL;

UPDATE test_clients
SET id = 3,
first_name = CONCAT('Updated',' ',first_name)
WHERE first_name = 'Gosho';


-- 03.Update Salary and Select
UPDATE employees
SET salary = salary + 100
WHERE job_title = 'Manager';
SELECT salary 
FROM  employees;

-- 06. Delete from Table
DELETE FROM employees 
WHERE department_id = 1 OR department_id = 2;

SELECT *
 FROM employees
 ORDER BY id;


UPDATE employees
SET salary = salary + 100
WHERE job_title = 'Manager';

-- 04. Top Paid Employee
CREATE VIEW v_top_paid AS 
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 1;
SELECT*
FROM v_top_paid;

-- 05. Select Employees
SELECT * 
FROM employees 
WHERE department_id = 4 AND salary >= 1000
ORDER BY id;
SELECT*








    