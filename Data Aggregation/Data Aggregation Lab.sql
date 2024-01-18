-- Test
SELECT department_id,SUM(salary) AS 'Total salary'
FROM employees
WHERE id in (2,4,6)
GROUP BY department_id;

-- The NULL values are skipped

SELECT department_id,COUNT(department_id) AS 'Count'
FROM employees
GROUP BY department_id;

ALTER TABLE employees
MODIFY COLUMN salary DOUBLE NULL;

UPDATE  employees
SET salary = NULL
WHERE id IN (2,4,6,8);

SELECT COUNT(last_name)
FROM employees;

SELECT * FROM employees;

SELECT SUM(salary)
FROM employees;

SELECT MAX(salary)
FROM employees;

-- 01.Departments Info
SELECT department_id,COUNT(id)
FROM employees
GROUP BY department_id;

-- 02. Average Salary
SELECT 
    department_id, ROUND(AVG(salary), 2) AS 'Average Salary'
FROM
    employees
GROUP BY department_id;

-- HAVING is used after the GROUP BY clause to filter on the aggregated results, whereas
-- the WHERE clause is used before grouping to filter individual rows
-- 03. Minimum Salary
SELECT department_id ,
MIN(salary) AS 'Min Salary'
FROM employees
GROUP BY department_id
HAVING `Min Salary`>800;

-- 04.Appetizers Count
SELECT COUNT(*) FROM products
WHERE category_id = 2 AND price> 8;

-- 05. Menu Prices
SELECT category_id,
ROUND(AVG(price),2) AS 'Average Price',
MIN(price) AS 'Cheapest Product',
MAX(price) AS 'Most Expensive Product'
FROM products
GROUP BY category_id;