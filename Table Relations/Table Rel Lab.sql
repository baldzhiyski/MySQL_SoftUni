 -- Test
  SELECT peaks.id,peaks.name,mountains.name FROM peaks
 JOIN mountains ON 
 peaks.mountain_id = mountains.id;

  DELETE FROM mountains 
    WHERE id = 1;
    
    DROP TABLE peaks;
    DROP TABLE mountains;
    

DELETE FROM peaks WHERE id = 2;
DELETE FROM mountains WHERE id = 2;

SELECT*FROM mountains;
 
 -- 01. Mountains and Peaks
 CREATE DATABASE mountains;
 
 CREATE TABLE mountains (
 id INT AUTO_INCREMENT NOT NULL,
 `name` VARCHAR(100) NOT NULL,
 CONSTRAINT pk_mountains_id PRIMARY KEY (id)
 );
 
 CREATE TABLE peaks(
 id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
 `name` VARCHAR(100) NOT NULL,
 mountain_id INT NOT NULL,
 CONSTRAINT fk_peaks_id_mountains_id 
 FOREIGN KEY (mountain_id) 
 REFERENCES mountains(id)
 ); 

 SELECT * FROM vehicles;
 
 -- 02. Trip Organization
 SELECT 
    driver_id,
    vehicle_type,
    CONCAT_WS(' ', first_name, last_name) AS 'driver_name'
FROM
    vehicles
        JOIN
    campers ON driver_id = campers.id;
    
    -- 03. SoftUni Hiking
   SELECT 
    starting_point,
    end_point,
    leader_id,
    CONCAT(first_name, ' ', last_name) AS leader_name
FROM
    routes
        JOIN
    campers ON routes.leader_id = campers.id;
    
    -- 04. Delete mountains
    CREATE TABLE mountains (
 id INT AUTO_INCREMENT NOT NULL,
 `name` VARCHAR(100) NOT NULL,
 CONSTRAINT pk_mountains_id PRIMARY KEY (id)
 );
 
 CREATE TABLE peaks(
 id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
 `name` VARCHAR(100) NOT NULL,
 mountain_id INT NOT NULL,
 CONSTRAINT fk_peaks_id_mountains_id 
 FOREIGN KEY (mountain_id) 
 REFERENCES mountains(id)
 ON DELETE CASCADE
 ); 
 
 DELETE FROM peaks WHERE id = 2;
DELETE FROM mountains WHERE id = 2;

SELECT*FROM peaks;

-- 05. Reading Diagramm
 CREATE TABLE clients(
 id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
 client_name VARCHAR(100)
 );

CREATE TABLE projects(
id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
client_id INT,
project_lead_id INT,
CONSTRAINT fk_project_client_id_clients_id
FOREIGN KEY (client_id)
REFERENCES clients(id)
);

CREATE TABLE employees(
id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
first_name VARCHAR(30),
last_name VARCHAR(30),
project_id INT ,
CONSTRAINT fk_employees_id_projects_id
FOREIGN KEY (project_id)
REFERENCES projects(id)
);

ALTER TABLE projects
ADD CONSTRAINT fk_projects_project_lead_id_employees_id
FOREIGN KEY (project_lead_id)
REFERENCES employees(id);


