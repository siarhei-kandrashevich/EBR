DEFINE delimiter = '-------------------------------------------------------------'
SET SERVEROUTPUT ON
SPOOL TEST_SCHEMA.LOG

PROMPT Script info:
select sys_context('USERENV', 'MODULE') from dual; 
PROMPT

PROMPT &&delimiter
PROMPT Script end: run.sql
PROMPT &&delimiter
PROMPT

PROMPT &&delimiter
PROMPT Calling create_procedure.sql
PROMPT
@create_procedure.sql
PROMPT

PROMPT &&delimiter
PROMPT Calling test.sql
PROMPT
@test.sql
PROMPT

PROMPT &&delimiter
PROMPT Script end: run.sql
PROMPT &&delimiter

SET SERVEROUTPUT OFF
SPOOL OFF
