PROMPT &&delimiter
PROMPT Script start: create_view.sql
PROMPT &&delimiter

CREATE OR REPLACE VIEW EMPLOYEES
AS
SELECT
    employee_id,
    first_name,
    last_name,
    email,
    phone_number,
    hire_date,
    job_id,
    salary,
    commission_pct,
    manager_id,
    department_id,
    avg_salary
FROM
    employees_tab;

CREATE OR REPLACE VIEW countries
AS
SELECT
    country_id,
    country_name,
    region_id
FROM
    countries_tab;

CREATE OR REPLACE VIEW departments
AS
SELECT
    department_id,
    department_name,
    manager_id,
    location_id
FROM
    departments_tab; 

CREATE OR REPLACE VIEW employees
AS
SELECT
    employee_id,
    first_name,
    last_name,
    email,
    phone_number,
    hire_date,
    job_id,
    salary,
    commission_pct,
    manager_id,
    department_id,
    avg_salary
FROM
    employees_tab;  

CREATE OR REPLACE VIEW job_history
AS    
SELECT
    employee_id,
    start_date,
    end_date,
    job_id,
    department_id
FROM
    job_history_tab;   

CREATE OR REPLACE VIEW jobs
AS    
SELECT
    job_id,
    job_title,
    min_salary,
    max_salary
FROM
    jobs_tab;  

CREATE OR REPLACE VIEW locations
AS    
SELECT
    location_id,
    street_address,
    postal_code,
    city,
    state_province,
    country_id
FROM
    locations_tab;

CREATE OR REPLACE VIEW regions
AS    
SELECT
    region_id,
    region_name
FROM
    regions_tab;

PROMPT &&delimiter
PROMPT Script end: create_view.sql
PROMPT &&delimiter
