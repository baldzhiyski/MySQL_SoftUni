-- Test
SELECT e.first_name,d.department_id
FROM employees AS e
JOIN departments  AS d ON e.department_id = d.department_id;

SELECT name FROM departments 
UNION
SELECT first_name FROM employees;

SELECT name,
CONCAT(first_name,' ',last_name) AS 'full_name'
FROM departments  AS d
JOIN employees AS e ON e.employee_id = d.manager_id
WHERE name = 'Sales' OR name = 'Marketing';

SELECT 
    name, CONCAT(first_name, ' ', last_name) AS 'full_name'
FROM
    departments AS d
        JOIN
    employees AS e ON e.employee_id = d.manager_id
WHERE
    d.department_id IN (SELECT 
            department_id
        FROM
            departments
        WHERE
            name = 'Sales' OR name = 'Marketing');
            
SELECT 
    e.employee_id, e.first_name, e.last_name, p.name
FROM
    employees AS e
        JOIN
    employees_projects AS ep ON e.employee_id = ep.employee_id
        JOIN
    projects AS p ON ep.project_id = p.project_id
    ORDER BY e.employee_id;


-- 01.Managers
SELECT 
    employee_id,
    CONCAT(first_name, ' ', last_name) AS 'full_name',
    d.department_id,
    name AS 'deaprtment_name'
FROM
    departments AS d
        JOIN
    employees AS e ON d.manager_id = e.employee_id
ORDER BY employee_id
LIMIT 5;

-- 02. Towns and Addresses
SELECT 
    a.town_id, t.name AS 'town_name', a.address_text
FROM
    addresses AS a
        INNER JOIN
    towns AS t ON a.town_id = t.town_id
        AND t.name IN ('San Francisco' , 'Sofia', 'Carnation')
ORDER BY town_id , address_id;

-- 03. Employees Without Managers
SELECT employee_id,
first_name,
last_name,
department_id,
salary
FROM employees
WHERE manager_id IS NULL;

-- 04. High Salary
SELECT COUNT(*) FROM 
employees
WHERE salary > (
SELECT AVG(salary) 
FROM employees 
);