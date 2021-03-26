PROMPT &&delimiter
PROMPT Script start: create_package.sql
PROMPT &&delimiter

CREATE OR REPLACE PACKAGE test_pack AS
    PROCEDURE test_proc (
        emp_id IN NUMBER
    );

    FUNCTION fn_avg_salary (
        in_department_id employees.department_id%TYPE
    ) RETURN INTEGER DETERMINISTIC;

    package_version CONSTANT VARCHAR2(20) := 'version 1';
END test_pack;
/

CREATE OR REPLACE PACKAGE BODY test_pack AS

    PROCEDURE test_proc (
        emp_id NUMBER
    ) IS
    BEGIN
        INSERT INTO job_history
            SELECT
                employee_id,
                TO_DATE('2020-01-12', 'yyyy-mm-dd') AS start_date,
                TO_DATE('2021-01-12', 'yyyy-mm-dd') AS end_date,
                job_id,
                department_id from
                employees
            WHERE
                employee_id IN (
                    emp_id
                );

    END test_proc;

    FUNCTION fn_avg_salary (
        in_department_id employees.department_id%TYPE
    )

  RETURN INTEGER
        DETERMINISTIC
    IS
        l_salary INTEGER;
    BEGIN
        SELECT
            AVG(salary)
        INTO l_salary
        FROM
            employees
        WHERE
            department_id = in_department_id;

        RETURN(l_salary);
    END;

END test_pack;
/

PROMPT &&delimiter
PROMPT Script end: create_package.sql
PROMPT &&delimiter