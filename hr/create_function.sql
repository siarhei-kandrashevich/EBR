PROMPT &&delimiter
PROMPT Script start: create_function.sql
PROMPT &&delimiter

CREATE OR REPLACE FUNCTION fn_avg_salary (in_department_id EMPLOYEES.department_id%TYPE)
RETURN INTEGER
DETERMINISTIC 
IS
   l_salary INTEGER;
BEGIN

SELECT AVG(salary) 
INTO l_salary
FROM EMPLOYEES
WHERE department_id = in_department_id;

RETURN (l_salary);

END;
/

CREATE OR REPLACE FUNCTION up_case(acc_no IN VARCHAR) 
   RETURN VARCHAR
   IS 
   BEGIN 
      
      RETURN(UPPER(acc_no)); 
    END;
/

PROMPT &&delimiter
PROMPT Script end: create_function.sql
PROMPT &&delimiter
