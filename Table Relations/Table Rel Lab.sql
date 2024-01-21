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

 SELECT * FROM peaks;
 
 -- 02. Trip Organization
 