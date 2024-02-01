SET GLOBAL log_bin_trust_function_creators = 1;
SET SQL_SAFE_UPDATES = 0;

-- 01. Employees with Salary Above 35000
DELIMITER // 
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
	SELECT first_name,last_name FROM
    employees
    WHERE salary > 35000
    ORDER BY first_name,last_name,employee_id;
END//
DELIMITER ;
CALL usp_get_employees_salary_above_35000;

-- 02. Employees With Salary Above Number
DELIMITER //
CREATE PROCEDURE usp_get_employees_salary_above(given_number DECIMAL(19,4))
BEGIN

     SELECT first_name,last_name
     FROM employees
     WHERE salary >= given_number
     ORDER BY first_name,last_name,employee_id;
END//
DELIMITER ;
CALL usp_get_employees_salary_above(45000);

-- 03. Town Names Starting With
DELIMITER //
CREATE PROCEDURE usp_get_towns_starting_with(str VARCHAR(10))
BEGIN

    SELECT name
    FROM towns
    WHERE name REGEXP CONCAT('^',str)
    ORDER BY name;
END//
DELIMITER ;
CALL usp_get_towns_starting_with('b');

-- 04. Employees from Town
DELIMITER  //
CREATE PROCEDURE usp_get_employees_from_town(town_name VARCHAR(50))
BEGIN
  SELECT e.first_name,e.last_name
  FROM employees AS e
  JOIN addresses AS a ON e.address_id = a.address_id
  JOIN towns AS t ON t.town_id = a.town_id
  WHERE t.name = town_name
  ORDER BY e.first_name,e.last_name,e.employee_id;
END //
DELIMITER ;
CALL sp_get_employees_from_town('Sofia');

-- 05. Salary Level Function
DELIMITER //
CREATE FUNCTION ufn_get_salary_level(salary_of_empl DECIMAL(19,4))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE level_to_return VARCHAR(50);
    CASE 
      WHEN salary_of_empl < 30000 THEN SET level_to_return := 'Low';
      WHEN salary_of_empl BETWEEN 30000 AND 50000 THEN SET level_to_return := 'Average';
      ELSE SET level_to_return := 'High';
      
	END CASE;
    RETURN level_to_return;
END//
DELIMITER .
SELECT ufn_get_salary_level(43300);

-- Second Solution
DELIMITER %%
CREATE FUNCTION ufn_get_salary_level(salary DOUBLE(19,4))
RETURNS VARCHAR(7)
RETURN (
    CASE 
        WHEN salary < 30000 THEN 'Low'
        WHEN salary <= 50000 THEN 'Average'
        ELSE 'High'
    END
);
DELIMITER ;

-- 06. Employees By Salary Level
DELIMITER //
CREATE PROCEDURE usp_get_employees_by_salary_level(level_of_sal VARCHAR(7))
BEGIN
   SELECT e.first_name,
   e.last_name
   FROM employees AS e
   WHERE ufn_get_salary_level(e.salary) = level_of_sal 
   ORDER BY e.first_name DESC, e.last_name DESC;
END//
DELIMITER ;
CALL  usp_get_employees_by_salary_level('High');

-- 07. Define Function
DELIMITER //
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS INT
BEGIN
	RETURN
       word REGEXP CONCAT('^[',set_of_letters,']+$');
END//
DELIMITER ;
SELECT ufn_is_word_comprised('bobr','Rob');

-- 08. Find Full Name
DELIMITER //
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
   SELECT CONCAT_WS(' ',first_name,last_name) AS 'full_name'
   FROM  account_holders
   ORDER BY `full_name`,id;
END//
DELIMITER ;

-- 09.  People With Balance Higher Than
DELIMITER //
CREATE PROCEDURE  usp_get_holders_with_balance_higher_than(money DECIMAL(19,4))
BEGIN
    SELECT ah.first_name,ah.last_name
    FROM account_holders AS ah
    JOIN accounts AS a ON a.account_holder_id = ah.id
    GROUP BY  ah.id
    HAVING SUM(a.balance) > money
    ORDER BY a.account_holder_id ASC;
END//
DELIMITER ;
CALL  usp_get_holders_with_balance_higher_than(7000);

-- 10. Future Value Function
DELIMITER //
CREATE FUNCTION ufn_calculate_future_value(sum DECIMAL(19,4),
interest_rate DOUBLE , number_of_years INT)
RETURNS DECIMAL(19,4)
BEGIN 
  DECLARE FV DECIMAL(19,4);

  SET FV := sum * POW((1 + interest_rate),number_of_years);
  RETURN FV;
END //
DELIMITER ;
SELECT ufn_calculate_future_value(1000,0.5,5);

-- 11. Calculating Interest
DELIMITER //
CREATE PROCEDURE usp_calculate_future_value_for_account(
id_of_account INT , interest_rate DECIMAL(19,4))
BEGIN
	SELECT a.id AS 'account_id',
    ah.first_name,
    ah.last_name,
    a.balance AS 'current_balance',
    (SELECT ufn_calculate_future_value(a.balance,interest_rate,5) ) AS 'balance_in_5_years'
    FROM accounts AS a
    JOIN account_holders AS ah ON a.account_holder_id = ah.id
    WHERE a.id = id_of_account;
END//
DELIMITER ;
CALL usp_calculate_future_value_for_account(1,0.1);

 -- 12. Deposit Money
 DELIMITER //
 CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL (19,4))
 BEGIN
 IF money_amount > 0
      THEN START TRANSACTION;
UPDATE `accounts` AS a 
SET 
    a.balance = a.balance + money_amount
WHERE
    a.id = account_id;
     -- Check how much money left
     IF(SELECT a.balance
     FROM accounts AS a
     WHERE a.id = account_id) < 0
        THEN ROLLBACK;
     ELSE
       COMMIT;
     END IF;
	END IF;
 END//
 DELIMITER ;
 
 -- 13. Withdraw Money
 DELIMITER //
 CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL (19,4))
 BEGIN
 IF money_amount > 0
      THEN START TRANSACTION;
UPDATE `accounts` AS a 
SET 
    a.balance = a.balance - money_amount
WHERE
    a.id = account_id;
     -- Check how much money left
     IF(SELECT a.balance
     FROM accounts AS a
     WHERE a.id = account_id) < 0
        THEN ROLLBACK;
     ELSE
       COMMIT;
     END IF;
	END IF;
 END//
 DELIMITER ;
 
 -- 14. Money Transfer
 DELIMITER //
 CREATE PROCEDURE usp_transfer_money(
 from_account_id INT, to_account_id INT, amount DECIMAL(19,4))
 BEGIN
    IF amount > 0
    AND from_account_id != to_account_id
    AND (SELECT id FROM accounts WHERE id = from_account_id) IS NOT NULL
    AND (SELECT id FROM accounts WHERE id = to_account_id) IS NOT NULL
    THEN 
    START TRANSACTION;
    
    UPDATE accounts AS a
    SET balance = balance + amount
    WHERE id = to_account_id;
    
    UPDATE accounts AS a
    SET balance = balance - amount
    WHERE id = from_account_id;
    
     IF (SELECT a.balance 
            FROM `accounts` AS a 
            WHERE a.id = from_account_id) < 0
            THEN ROLLBACK;
        ELSE
            COMMIT;
        END IF;
    END IF;
 END//
 DELIMITER ;
 
 -- 15. Log Accounts Trigger
 CREATE TABLE `logs`(
 log_id INT PRIMARY KEY AUTO_INCREMENT,
 account_id INT NOT NULL,
 old_sum DECIMAL(19,4) NOT NULL,
 new_sum DECIMAL(19,4) NOT NULL
 );
 
 DELIMITER //
 CREATE TRIGGER account_trigger
 AFTER UPDATE ON accounts
 FOR EACH ROW
 BEGIN
    IF OLD.balance != NEW.balance THEN
    INSERT INTO logs(account_id,old_sum,new_sum)
    VALUES (OLD.id,OLD.balance,NEW.balance);
    END IF;
 END//
 DELIMITER ;
 
  -- 16. Emails Trigger
  CREATE TABLE notification_emails(
  id INT PRIMARY KEY AUTO_INCREMENT,
  recipient INT NOT NULL,
  subject VARCHAR(50) NOT NULL,
  body VARCHAR(255) NOT NULL 
  );
  
  DELIMITER //
  CREATE TRIGGER notifications_trigger
  AFTER INSERT ON logs 
  FOR EACH ROW
  BEGIN
    INSERT INTO `notification_emails` 
        (`recipient`, `subject`, `body`)
    VALUES (
        NEW.account_id, 
        CONCAT('Balance change for account: ', NEW.account_id), 
        CONCAT('On ', DATE_FORMAT(NOW(), '%b %d %Y at %r'), ' your balance was changed from ', ROUND(NEW.old_sum, 2), ' to ', ROUND(NEW.new_sum, 2), '.'));
END //
DELIMITER ;