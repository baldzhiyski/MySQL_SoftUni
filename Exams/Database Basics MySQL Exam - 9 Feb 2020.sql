CREATE DATABASE fsd;
USE fsd;


-- 01. Database Design
CREATE TABLE coaches (
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(10) NOT NULL,
last_name VARCHAR(20) NOT NULL,
salary DECIMAL(10,2) DEFAULT 0 NOT NULL,
coach_level INT DEFAULT 0 NOT NULL
);

CREATE TABLE countries(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(45) NOT NULL
);

CREATE TABLE towns(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(45) NOT NULL,
country_id INT NOT NULL,
CONSTRAINT fk_towns_country FOREIGN KEY  (country_id)
REFERENCES countries(id)
);

CREATE TABLE stadiums(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(45) NOT NULL,
capacity INT NOT NULL,
town_id INT NOT NULL,
CONSTRAINT fk_stadium_town FOREIGN KEY (town_id)
REFERENCES towns(id)
);

CREATE TABLE teams(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(45) NOT NULL,
established DATE NOT NULL,
fan_base BIGINT DEFAULT 0 NOT NULL,
stadium_id INT NOT NULL,
CONSTRAINT fk_team_stadium FOREIGN KEY(stadium_id)
REFERENCES stadiums(id)
);

CREATE TABLE skills_data(
id INT PRIMARY KEY AUTO_INCREMENT,
dribbling INT DEFAULT 0,
pace INT DEFAULT 0,
passing INT DEFAULT 0,
shooting INT DEFAULT 0,
speed INT DEFAULT 0,
strength INT DEFAULT 0
);

CREATE TABLE players(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(10) NOT NULL,
last_name VARCHAR(20) NOT NULL,
age INT DEFAULT 0 NOT NULL,
position CHAR(1) NOT NULL,
CONSTRAINT chk_position CHECK (position IN ('A', 'M', 'D')),
salary DECIMAL(10,2) DEFAULT 0 NOT NULL,
hire_date DATETIME ,
skills_data_id INT  NOT NULL,
CONSTRAINT fk_player_skill FOREIGN KEY (skills_data_id)
REFERENCES skills_data(id),
team_id INT,
CONSTRAINT fk_player_team FOREIGN KEY(team_id)
REFERENCES teams(id)
);

CREATE TABLE players_coaches(
player_id INT ,
coach_id INT ,
CONSTRAINT PRIMARY KEY(player_id,coach_id),
CONSTRAINT FOREIGN KEY (player_id)
REFERENCES players(id),
CONSTRAINT FOREIGN KEY(coach_id)
REFERENCES coaches(id)
);

-- 02.Insert
INSERT INTO coaches(first_name,last_name,salary,coach_level)
SELECT 
first_name,
last_name,
salary + salary,
LENGTH(first_name)
FROM players 
WHERE age >= 45 ;

-- 03. Update
UPDATE coaches AS c
SET c.coach_level = c.coach_level + 1
WHERE LOWER(c.first_name) REGEXP '^a'
AND c.id IN (
    SELECT coach_id
    FROM players_coaches
    GROUP BY coach_id
    HAVING COUNT(*) >= 1
);

-- 04. Delete
DELETE FROM players
WHERE age >= 45;

-- 05. Players
SELECT 
first_name,age,salary
FROM players 
ORDER BY salary DESC;

-- 06. Young offense players without contract
SELECT
p.id,
CONCAT_WS(' ',p.first_name,p.last_name) AS 'full_name',
p.age,p.position,p.hire_date
FROM players AS p
JOIN skills_data AS sk ON sk.id = p.skills_data_id
WHERE hire_date IS NULL AND 
age<23 AND position = 'A' 
AND sk.strength > 50
ORDER BY salary;

-- 07. Detail info for all teams
SELECT 
    t.name AS team_name,
    t.established,
    t.fan_base,
    COUNT(p.id) AS players_count
FROM
    teams AS t
       LEFT JOIN
    players AS p ON p.team_id = t.id
GROUP BY t.id
ORDER BY `players_count` DESC,t.fan_base DESC;

-- 08. The fastest player by towns
SELECT 
    MAX(sd.speed) AS 'max_speed', tw.name AS 'town_name'
FROM
    towns AS tw
        LEFT JOIN
    stadiums AS s ON tw.id = s.town_id
        LEFT JOIN
    teams AS t ON s.id = t.stadium_id
        LEFT JOIN
    players AS p ON t.id = p.team_id
        LEFT JOIN
    skills_data AS sd ON p.skills_data_id = sd.id
WHERE
    t.name <> 'Devify'
GROUP BY tw.id
ORDER BY `max_speed` DESC , tw.name;

-- 09. Total salaries and players by country
SELECT 
    c.name,
    COUNT(p.id) AS 'total_count_of_players',
    SUM(p.salary) AS 'total_sum_of_salaries '
FROM
    countries AS c
        LEFT JOIN
    towns AS t ON c.id = t.country_Id
        LEFT JOIN
    stadiums AS s ON t.id = s.town_id
        LEFT JOIN
    teams AS tw ON tw.stadium_id = s.id
        LEFT JOIN
    players AS p ON p.team_id = tw.id
GROUP BY c.name
ORDER BY `total_count_of_players` DESC , c.name;

-- 10. Find all players in the stadium
DELIMITER //
CREATE FUNCTION  udf_stadium_players_count (stadium_name VARCHAR(30))
RETURNS VARCHAR(45)
DETERMINISTIC
BEGIN
  RETURN(SELECT COUNT(p.id)
  FROM players AS p
  LEFT JOIN teams AS t ON p.team_id = t.id
  JOIN stadiums AS s ON s.id = t.stadium_id
  WHERE s.name = stadium_name
  );
END//
DELIMITER ;

SELECT udf_stadium_players_count ('Jaxworks') as `count`; 

-- 11. Find good playmaker by teams
DELIMITER //
CREATE PROCEDURE udp_find_playmaker(min_dribble_points INT, team_name VARCHAR(45))
BEGIN
   SELECT 
   CONCAT_WS(' ', p.first_name, p.last_name) AS full_name,
   p.age,
   p.salary,
   sd.dribbling,
   sd.speed,
   t.name AS team_name
   FROM players AS p
   JOIN skills_data AS sd ON p.skills_data_id = sd.id
   JOIN teams AS t ON t.id = p.team_id
   WHERE sd.dribbling > min_dribble_points
   AND t.name = team_name AND 
   sd.speed >  (SELECT AVG(sdd.speed)
   FROM players AS pp
   JOIN skills_data AS sdd ON pp.skills_data_id = sdd.id)
   ORDER BY sd.speed DESC
   LIMIT 1;
END
//
DELIMITER  ;
drop procedure udp_find_playmaker;

CALL udp_find_playmaker(20, 'Skyble');