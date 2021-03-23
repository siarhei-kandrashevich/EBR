PROMPT &&delimiter
PROMPT Script start: create_function.sql
PROMPT &&delimiter

CREATE OR REPLACE FUNCTION count_nation
RETURN INTEGER
IS
   l_counter INTEGER;
BEGIN

SELECT COUNT(1) 
INTO l_counter
FROM nation
WHERE n_name = 'BELARUS';

RETURN (l_counter);

END;
/
PROMPT &&delimiter
PROMPT Script end: create_function.sql
PROMPT &&delimiter
