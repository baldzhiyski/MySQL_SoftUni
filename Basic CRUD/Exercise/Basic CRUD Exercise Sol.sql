-- 01. All Information About departments
SELECT *FROM departments
ORDER BY department_id;

-- 02.Find all Department Names
SELECT name FROM departments
ORDER BY department_id;

-- 03. Find Salary of Each Employee
SELECT first_name,last_name,salary FROM employees
ORDER BY employee_id;

-- 04. Find Full Name of Each Employee
SELECT first_name,middle_name,last_name FROM employees
ORDER BY employee_id;

-- 05. Find Email Address of Each Employee
SELECT 
    CONCAT(first_name,
            '.',
            last_name,
            '@softuni.bg') AS full_email_adress
FROM
    employees;
    
-- 06. Find All Different Employee's Salaries
SELECT DISTINCT salary FROM employees;

-- 07. Find all Info About Employees
SELECT*FROM employees
WHERE job_title = 'Sales Representative'
ORDER BY employee_id;

-- 08. Find names of all employees by salary in range
SELECT first_name,last_name,job_title 
FROM employees
WHERE salary BETWEEN 20000 AND 30000
ORDER BY employee_id;

-- 09.Find Names of All Employees
SELECT 
    CONCAT_WS(' ',first_name,
            middle_name,
            last_name) AS 'Full Name'
FROM
    employees
WHERE
    salary IN (25000,14000,12500,23600);
        
-- 10. Find all employees without manager
SELECT first_name,last_name
FROM employees
WHERE manager_id IS NULL;

-- 11. Find all employees with salary more than
SELECT first_name,last_name,salary 
FROM employees
WHERE salary > 50000
ORDER BY salary DESC;

-- 12. Find 5 Best Paid Employees
SELECT first_name,last_name 
FROM employees
ORDER BY salary DESC
LIMIT 5;

-- 13. Find all empl except marketing
SELECT first_name,last_name 
FROM employees 
WHERE department_id != 4;

-- 14. Sort Employees Table
SELECT 
    employee_id,
    first_name AS 'First Name',
    last_name AS 'Last Name',
    middle_name AS 'Middle Name',
    job_title,
    department_id AS 'Dept ID',
    manager_id AS 'Mngr ID',
    hire_date AS 'Hire Date',
    salary,
    address_id
FROM
    employees
ORDER BY salary DESC , first_name , last_name DESC , middle_name;

-- 15. Create View Employees with Salaries
CREATE VIEW v_employees_salaries AS
SELECT first_name,last_name,salary
FROM employees;
SELECT*FROM v_employees_salaries;

-- 16. Create View Employees with Job Titles
CREATE VIEW v_employees_job_titles AS
    SELECT 
        CONCAT_WS(' ', first_name, middle_name, last_name) AS 'full_name',
        job_title
    FROM
        employees;
SELECT * FROM v_employees_job_titles;

-- 17.Distinct Job Titles
SELECT DISTINCT job_title FROM employees
ORDER BY job_title;

-- 18. Find first 10 Started Projects
SELECT *FROM projects
ORDER BY start_date,name LIMIT 10;

-- 19. Last 7 Hired Employees
SELECT first_name,last_name,hire_date
FROM employees
ORDER BY hire_date DESC
LIMIT 7;

-- 20. Increase Salaries
UPDATE employees AS e
SET salary = salary * 1.12
WHERE department_id IN (SELECT 
    department_id
FROM
    departments
WHERE
    name IN ('Engineering' ,'Tool Design',
        'Marketing',
        'Information Services')
);
SELECT salary FROM employees;

-- 21. All Mountain Peeks
SELECT peak_name FROM peaks
ORDER BY peak_name;

-- 22. Biggest Countries by Population
SELECT country_name,population 
FROM countries 
WHERE continent_code = 'EU'
ORDER BY population DESC , country_name 
LIMIT 30;

-- 23. Countries and Currency
SELECT 
    country_name,
    country_code,
    IF(currency_code = 'EUR',
        'Euro',
        'Not Euro') as 'Currency'
FROM
    countries
ORDER BY country_name;

-- 24. All Diablo Chars
SELECT name FROM characters 
ORDER BY name;









