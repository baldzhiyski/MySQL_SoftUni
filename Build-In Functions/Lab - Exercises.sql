SELECT* FROM books;
-- Tests 
SELECT id,SUBSTRING(title,1,10) 
FROM books;

SELECT SUBSTRING('0123456789',2,5) AS 'Test';

SELECT REPLACE('0123456789','0123','Replacement');

SELECT 
    id, REPLACE(title, 'Murder', '++++++')
FROM
    books;
    
SELECT '  something',RTRIM(LTRIM ('   something     '));

SELECT CHAR_LENGTH('0123'), LENGTH('0123');

SELECT LEFT('012345', 2);

SELECT RIGHT('012345', 2);

SELECT LOWER('HI , My name is'), UPPER('still studying');

SELECT REPEAT('012', 4);

SELECT title 
FROM books 
WHERE LOCATE('The',title) > 0;

SELECT INSERT ('01234',2,0,'ABCD');

SELECT  5/2;
SELECT 5 DIV 2;

SELECT 5 MOD 2;
SELECT 5 % 2;

SELECT POW(3.2);

SELECT CONV(13,10,2);
SELECT CONV(101000101,2,10);

SELECT ROUND(2.356,2),FLOOR(2.356),CEILING(2.356);

SELECT fLOOR(RAND( ) * 11);

SELECT title ,EXTRACT(YEAR FROM year_of_release) AS 'Year of Release'
FROM books;

SELECT ABS(TIMESTAMPDIFF(MONTH,'2023-05-16','2022-05-15'));
SELECT id,first_name , TIMESTAMPDIFF(YEAR,born,NOW())
FROM authors;

SELECT DATE_FORMAT(born,'%d %M %Y')
FROM authors;

SELECT * FROM books
WHERE title REGEXP '^the';

SELECT* FROM authors
WHERE first_name REGEXP '^[^K]{4}$' ;


SELECT* FROM authors
WHERE first_name REGEXP '^(jo|h)' ;

-- EXERCISES : 
-- 01. Find Book Titles
SELECT title FROM books
WHERE  SUBSTRING(title FROM 1 FOR 3) = 'The'
ORDER BY id;

-- 02. Replace Titles 
SELECT REPLACE(title,'The','***') FROM books
WHERE SUBSTRING(title,1,3) = 'The'
ORDER BY id;

-- 03. Sum Cost of All Books
SELECT FORMAT(SUM(`cost`), 2) as "title" FROM `books`;

-- 04. Days Lived
SELECT 
    CONCAT_WS(' ', first_name,last_name) AS 'Full Name',
    TIMESTAMPDIFF(DAY, born, died) AS 'Days Lived'
FROM
    authors;
    
-- 05. Harry Potters Books
SELECT title FROM books
WHERE title REGEXP '^Harry Potter';






