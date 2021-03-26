PROMPT &&delimiter
PROMPT Script start: create_function_ebr.sql
PROMPT &&delimiter

CREATE OR REPLACE FUNCTION fn_avg_salary (in_manager_id EMPLOYEES.manager_id%TYPE)
RETURN INTEGER
DETERMINISTIC 
IS
   l_salary INTEGER;
BEGIN

SELECT AVG(salary) 
INTO l_salary
FROM EMPLOYEES
WHERE manager_id = in_manager_id;

RETURN (l_salary);

END;
/
PROMPT &&delimiter
PROMPT Script end: create_function_ebr.sql
PROMPT &&delimiter
