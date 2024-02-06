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
DELETE players
FROM players
JOIN players_coaches AS pc ON players.id = pc.player_id
JOIN coaches AS c ON c.id = pc.coach_id
WHERE players.first_name = c.first_name AND players.last_name = c.last_name;

DELETE FROM players
WHERE id IN (
    SELECT pc.player_id
    FROM players_coaches AS pc
    JOIN coaches AS c ON pc.coach_id = c.id
);




