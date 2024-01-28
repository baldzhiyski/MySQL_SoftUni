USE soft_uni;
-- 01. Employee Address
SELECT 
    e.employee_id, e.job_title, e.address_id, a.address_text
FROM
    employees AS e
        JOIN
    addresses AS a ON e.address_id = a.address_id
    LIMIT 5;
    
-- 02. Addresses with towns
SELECT 
     e.first_name,e.last_name,t.name AS 'town',a.address_text
FROM 
    employees AS e
        JOIN
    addresses AS a ON e.address_id = a.address_id
        JOIN
    towns AS t ON a.town_id = t.town_id
    ORDER BY e.first_name,e.last_name
    LIMIT 5;
    
-- 03. Sales Employees
SELECT e.employee_id,e.first_name,e.last_name,d.name
FROM employees AS e
JOIN departments AS d ON e.department_id=d.department_id
WHERE d.name = 'Sales'
ORDER BY e.employee_id DESC;

-- 04. Employee Departments
SELECT e.employee_id,e.first_name,e.salary,
d.name FROM
employees AS e
JOIN departments AS d ON e.department_id = d.department_id
WHERE e.salary > 15000
ORDER BY d.department_id DESC
LIMIT 5;

SELECT*FROM employees;

-- 05. Employees Without Project
-- Here we need those who do not have projects. With left join 
-- we take the whole left table + the inner results. Than we are 
-- making the sort
SELECT 
    e.employee_id, e.first_name
FROM
    employees AS e
    LEFT JOIN employees_projects AS ep
    ON e.employee_id = ep.employee_id
    WHERE ep.project_id IS NULL
ORDER BY employee_id DESC
LIMIT 3;


-- 06. Employees Hired After
SELECT 
    e.first_name, e.last_name, e.hire_date, d.name
FROM
    employees AS e
        JOIN
    departments AS d ON e.department_id = d.department_id
WHERE
    e.hire_date > 1 / 1 / 1999
        AND d.name IN ('Sales' , 'Finance')
ORDER BY e.hire_date;

-- 07. Employees with Project
SELECT 
    e.employee_id, e.first_name, p.name
FROM
    employees AS e
        JOIN
    employees_projects AS ep ON e.employee_id = ep.employee_id
        JOIN
    projects AS p ON ep.project_id = p.project_id
WHERE
    DATE(p.start_date) > '2002-08-13'
        AND p.end_date IS NULL
ORDER BY e.first_name , p.name
LIMIT 5;

-- 08. Employee 24
SELECT 
    e.employee_id,
    e.first_name,
    IF(YEAR(p.start_date) >= 2005 ,NULL,p.name) AS 'project_name'
FROM
    employees AS e
        JOIN
    employees_projects AS ep ON e.employee_id = ep.employee_id
        JOIN
    projects AS p ON p.project_id = ep.project_id
    WHERE e.employee_id = 24
    ORDER BY p.name;

-- 09. Employee Manager
SELECT employee_id, first_name, manager_id, (
    SELECT `first_name` FROM employees AS e
     WHERE e2.manager_id = e.employee_id
     LIMIT 1
    ) AS `manager_name` FROM employees AS e2
WHERE manager_id IN (3, 7)
ORDER BY first_name;
-- Another solution: We need the manager info for each employee
SELECT e1.employee_id, e1.first_name, e1.manager_id, e2.first_name AS manager_name
FROM employees AS e1
JOIN employees AS e2 ON e1.manager_id = e2.employee_id
WHERE e1.manager_id IN (3, 7)
ORDER BY e1.first_name;

-- 10. Employee Summary
-- Self - referenced
-- We imagine manager is another table.
SELECT e.employee_id,
CONCAT_WS(' ',e.first_name,e.last_name) AS 'emplpoyee_name',
CONCAT_WS(' ',m.first_name,m.last_name) AS 'manager_name' ,
d.name
FROM employees AS e
JOIN employees AS m ON e.manager_id = m.employee_id
JOIN departments AS d ON e.department_id = d.department_id
ORDER BY e.employee_id
LIMIT 5;

-- 11. Min Average Salary
SELECT AVG(e.salary) AS 'avr_salary'
FROM employees AS e
GROUP BY e.department_id
ORDER BY `avr_salary`
LIMIT 1;

USE geography;
-- 12. Highest Peaks in Bulgaria
SELECT 
    c.country_code,
    m.mountain_range,
    p.peak_name,
    p.elevation
FROM
    countries AS c
        JOIN
    mountains_countries AS mc ON c.country_code = mc.country_code
    JOIN mountains AS m ON m.id = mc.mountain_id
    JOIN peaks AS p ON p.mountain_id = m.id
    WHERE c.country_name = 'Bulgaria'
    AND p.elevation > 2835
    ORDER BY p.elevation DESC;
    
-- 13. Count Mountain Ranges
    SELECT 
    c.country_code, COUNT(mc.mountain_id) AS 'mountain_range'
FROM
    countries AS c
        JOIN
    mountains_countries AS mc ON c.country_code = mc.country_code
GROUP BY c.country_code
HAVING c.country_code IN ('BG' , 'US', 'RU')
ORDER BY `mountain_range` DESC;
    
-- 14. Countries with Rivers
    SELECT 
    c.country_name, r.river_name
FROM
    countries AS c
        LEFT JOIN
    countries_rivers AS cr ON cr.country_code = c.country_code
        LEFT JOIN
    rivers AS r ON r.id = cr.river_id
WHERE
    c.continent_code = 'AF'
ORDER BY c.country_name
LIMIT 5;
    
-- 15*. Continents and Currencies
SELECT 
    c.continent_code,
    currency_code,
    COUNT(*) AS 'currency_usage'
FROM
    countries AS c
GROUP BY c.continent_code , c.currency_code
HAVING `currency_usage`> 1
    AND `currency_usage` = (SELECT 
        COUNT(*) AS 'count_of_currencies'
    FROM
        countries AS c2
    WHERE
        c2.continent_code = c.continent_code
    GROUP BY c2.currency_code
    ORDER BY `count_of_currencies` DESC
    LIMIT 1)
ORDER BY c.continent_code , c.currency_code;

-- 16. Countries without any Mountains
SELECT*FROM mountains_countries;
SELECT 
    COUNT(*)
FROM
    countries AS c
        LEFT JOIN
    mountains_countries AS mc ON mc.country_code = c.country_code
    WHERE mc.country_code IS NULL;
    
-- 17. Highest Peak and Longest River By Country
SELECT 
    c.country_name,
    MAX(p.elevation) AS 'highest_peak_elevation',
    MAX(r.length) AS 'longest_river_length'
FROM
    countries AS c
       LEFT JOIN
    mountains_countries AS mc ON mc.country_code = c.country_code
       LEFT JOIN
    peaks AS p ON p.mountain_id = mc.mountain_id
        LEFT JOIN
    countries_rivers AS cr ON cr.country_code = c.country_code
       LEFT JOIN
    rivers AS r ON r.id = cr.river_id
GROUP BY c.country_name
ORDER BY `highest_peak_elevation` DESC , `longest_river_length` DESC , c.country_name
LIMIT 5;
    