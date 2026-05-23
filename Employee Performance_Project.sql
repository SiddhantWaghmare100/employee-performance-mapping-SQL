CREATE DATABASE employee;
USE employee;

CREATE TABLE emp_record_table (
    EMP_ID VARCHAR(10) PRIMARY KEY,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    GENDER VARCHAR(10),
    ROLE VARCHAR(100),
    DEPT VARCHAR(50),
    EXP INT,
    COUNTRY VARCHAR(50),
    CONTINENT VARCHAR(50),
    SALARY DECIMAL(10,2),
    EMP_RATING INT,
    MANAGER_ID VARCHAR(10),
    PROJ_ID VARCHAR(10)
);

CREATE TABLE proj_table (
    PROJECT_ID VARCHAR(10) PRIMARY KEY,
    PROJ_NAME VARCHAR(100),
    DOMAIN VARCHAR(100),
    START_DATE DATE,
    CLOSURE_DATE DATE,
    DEV_QTR VARCHAR(10),
    STATUS VARCHAR(50)
);

CREATE TABLE data_science_team (
    EMP_ID VARCHAR(10) PRIMARY KEY,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    GENDER VARCHAR(10),
    ROLE VARCHAR(100),
    DEPT VARCHAR(50),
    EXP INT,
    COUNTRY VARCHAR(50),
    CONTINENT VARCHAR(50)
);

SELECT * FROM emp_record_table;
SELECT * FROM proj_table;
SELECT * FROM data_science_team;

#Employee Department Details
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT
FROM emp_record_table;

#EMP_RATING Less Than 2
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT,
    EMP_RATING
FROM emp_record_table
WHERE EMP_RATING < 2;

#EMP_RATING Between 2 and 4
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT,
    EMP_RATING
FROM emp_record_table
WHERE EMP_RATING BETWEEN 2 AND 4;

#Concatenate Finance Employee Names
SELECT 
    CONCAT(FIRST_NAME,' ',LAST_NAME) AS NAME
FROM emp_record_table
WHERE DEPT='FINANCE';

#Employees Having Reporters
SELECT 
    e.EMP_ID,
    e.FIRST_NAME,
    e.LAST_NAME,
    COUNT(r.EMP_ID) AS REPORTER_COUNT
FROM emp_record_table e
JOIN emp_record_table r
ON e.EMP_ID = r.MANAGER_ID
GROUP BY e.EMP_ID, e.FIRST_NAME, e.LAST_NAME;

#Healthcare and Finance Employees Using UNION
SELECT *
FROM emp_record_table
WHERE DEPT='HEALTHCARE'

UNION

SELECT *
FROM emp_record_table
WHERE DEPT='FINANCE';

#Department Wise Max Rating
SELECT 
    e.EMP_ID,
    e.FIRST_NAME,
    e.LAST_NAME,
    e.ROLE,
    e.DEPT,
    e.EMP_RATING,
    d.MAX_RATING
FROM emp_record_table e
JOIN (
    SELECT 
        DEPT,
        MAX(EMP_RATING) AS MAX_RATING
    FROM emp_record_table
    GROUP BY DEPT
) d
ON e.DEPT = d.DEPT;

#Minimum and Maximum Salary
SELECT 
    ROLE,
    MIN(SALARY) AS MIN_SALARY,
    MAX(SALARY) AS MAX_SALARY
FROM emp_record_table
GROUP BY ROLE;

#Rank Employees by Experience
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    EXP,
    RANK() OVER(ORDER BY EXP DESC) AS EXP_RANK
FROM emp_record_table;

#Create View
CREATE VIEW high_salary_employees AS
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    COUNTRY,
    SALARY
FROM emp_record_table
WHERE SALARY > 6000;

#Nested Query
SELECT *
FROM emp_record_table
WHERE EMP_ID IN (
    SELECT EMP_ID
    FROM emp_record_table
    WHERE EXP > 10
);

#Stored Procedure
DELIMITER //

CREATE PROCEDURE GetExperiencedEmployees()

BEGIN

    SELECT *
    FROM emp_record_table
    WHERE EXP > 3;

END //

DELIMITER ;

CALL GetExperiencedEmployees();

#Stored Function
DELIMITER //

CREATE FUNCTION check_job_profile(exp_years INT)

RETURNS VARCHAR(100)

DETERMINISTIC

BEGIN

    DECLARE job_profile VARCHAR(100);

    IF exp_years <= 2 THEN
        SET job_profile = 'JUNIOR DATA SCIENTIST';

    ELSEIF exp_years > 2 AND exp_years <= 5 THEN
        SET job_profile = 'ASSOCIATE DATA SCIENTIST';

    ELSEIF exp_years > 5 AND exp_years <= 10 THEN
        SET job_profile = 'SENIOR DATA SCIENTIST';

    ELSEIF exp_years > 10 AND exp_years <= 12 THEN
        SET job_profile = 'LEAD DATA SCIENTIST';

    ELSEIF exp_years > 12 AND exp_years <= 16 THEN
        SET job_profile = 'MANAGER';

    ELSE
        SET job_profile = 'EXECUTIVE';

    END IF;

    RETURN job_profile;

END //

DELIMITER ;

#Use Function
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    EXP,
    ROLE,
    check_job_profile(EXP) AS STANDARD_ROLE
FROM data_science_team;

#Execution Plan
EXPLAIN
SELECT *
FROM emp_record_table
WHERE FIRST_NAME='Eric';

#Create Index
CREATE INDEX idx_first_name
ON emp_record_table(FIRST_NAME);

#Check Execution Plan Again
EXPLAIN
SELECT *
FROM emp_record_table
WHERE FIRST_NAME='Eric';

#Bonus Calculation
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    SALARY,
    EMP_RATING,
    (0.05 * SALARY * EMP_RATING) AS BONUS
FROM emp_record_table;

#Average Salary Distribution
SELECT 
    CONTINENT,
    COUNTRY,
    AVG(SALARY) AS AVG_SALARY
FROM emp_record_table
GROUP BY CONTINENT, COUNTRY;