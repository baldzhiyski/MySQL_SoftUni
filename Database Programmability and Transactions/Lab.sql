 -- Test Some Functions
 DELIMITER $$
 CREATE FUNCTION ufn_select_employees()
 RETURNS INT 
 DETERMINISTIC
 BEGIN 
   RETURN (SELECT 5);
 END$$
 
 DELIMITER ;
 SELECT ufn_select_employees();
 
 DELIMITER $$
 CREATE FUNCTION ufn_select_second(str VARCHAR(50))
 RETURNS VARCHAR(75)
 DETERMINISTIC
 BEGIN 
   RETURN CONCAT('Funktion ',str);
 END$$
 
 DELIMITER ;
 ;
 
 DELIMITER $$
 CREATE FUNCTION ufn_return_var()
 RETURNS INT
 DETERMINISTIC
 BEGIN 
	DECLARE result INT;
	SET result := 10;
    RETURN result;
 END$$
 
 SELECT ufn_return_var()$$ 
 
 -- Elementary procedure
 DELIMITER $$
 CREATE PROCEDURE usp_select_employees(max_id INT)
 BEGIN
 SELECT* FROM employees WHERE employee_id < max_id;
 END$$
 
 DELIMITER ;
 ;
 CALL usp_select_employees(10);

 -- Exercises 
 -- 01. Count Employees by Town
 DELIMITER $$
 CREATE FUNCTION ufn_count_employees_by_town(`town_name` VARCHAR(50))
 RETURNS INT
 DETERMINISTIC
 BEGIN
         RETURN (
          SELECT COUNT(*)
 FROM employees AS e
 JOIN addresses AS a ON e.address_id = a.address_id
 JOIN towns AS t ON a.town_id = t.town_id
 WHERE t.name = `town_name`
         );
 END$$
 DELIMITER ;
 ;
 


--  Employees Promotion Demo
-- With the out we wanna see what is actually the diff 
-- We need to increase the salaries of the employees
DELIMITER $$
CREATE PROCEDURE usp_raise_salaries_demo(percent DECIMAL(3,2),
OUT total_increace DECIMAL(19,4))
BEGIN
     DECLARE actual_percent DECIMAL(19,4);
     DECLARE local_increase DECIMAL(19,4);
     
     SET actual_percent = 1 + percent;
     
     SET local_increase = (SELECT ABS(SUM(salary)- SUM(salary)* 
     actual_percent) FROM
employees);
     SET total_increace = local_increase;
     
UPDATE employees 
SET 
    salary = salary * actual_percent;
END$$
DELIMITER ;
;

-- -- 02. Employees Promotion
-- The right solution for our task
DELIMITER $$
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(50))
BEGIN
UPDATE employees  AS e
JOIN departments AS d ON e.department_id = d.department_id
SET e.salary = 1.05*e.salary
WHERE d.name = department_name;
END$$
DELIMITER ;
;

CALL usp_raise_salaries('Finance');

-- Demo Transactions
DELIMITER $$
CREATE PROCEDURE usp_transaction()
BEGIN
	-- Initial State
    START TRANSACTION;
    UPDATE employees SET first_name = 'Changed';
    UPDATE towns SET name = 'Changed';
    ROLLBACK; -- Return to initial State
    -- COMMIT; -- Move to new state with changes applied
END$$
DELIMITER ;
;

-- 03. Employees Promotion By ID
DELIMITER //
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
  DECLARE employee_id_count INT;
  SET employee_id_count := (SELECT COUNT(*) FROM employees WHERE
  employee_id = id);
  
  IF(employee_id_count = 1)
  THEN
     UPDATE employees SET salary = salary * 1.05 WHERE employee_id = id;
  END IF;
END//

-- 04. Triggered
CREATE TABLE deleted_employees(
employee_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50),
last_name VARCHAR(50),
middle_name VARCHAR(50),
job_title VARCHAR(50),
department_id INT,
salary DECIMAL(19,4)
);

DELIMITER //
CREATE TRIGGER tr_after_delete_employees
AFTER DELETE 
ON employees
FOR EACH ROW
BEGIN
     INSERT INTO deleted_employees
     (first_name,last_name,middle_name,job_title,department_id,salary)
     VALUES(
     OLD.first_name,
     OLD.last_name,
     OLD.middle_name,
     OLD.job_title,
	 OLD.department_id,
     OLD.salary);
END//
DELIMITER ;
;

-- TEST
CREATE TABLE deleted_employees(
employee_id INT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
job_title VARCHAR(50),
department_name VARCHAR(50),
hire_date TIMESTAMP(6),
fire_date TIMESTAMP(6)
);
DELIMITER //
CREATE TRIGGER tr_after_delete_employees
AFTER DELETE 
ON employees
FOR EACH ROW
BEGIN
     INSERT INTO deleted_employees
     VALUES(OLD.employee_id,
     OLD.first_name,
     OLD.middle_name,
     OLD.job_title,
     (SELECT name FROM departments
     WHERE departments_id = OLD.department_id LIMIT 1),
     OLD.salary);
END//
DELIMITER ;
;


 
 
 
 
 
 
