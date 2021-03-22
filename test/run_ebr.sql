DEFINE delimiter = '-------------------------------------------------------------'
DEFINE EDITION_NAME = &&1

SET SERVEROUTPUT ON
SPOOL TEST_SCHEMA_EBR.LOG

PROMPT &&delimiter
PROMPT Edition name: &&EDITION_NAME
PROMPT Creating Edition: &&EDITION_NAME
CREATE EDITION &&EDITION_NAME;
COMMIT;
ALTER SESSION SET EDITION = &&EDITION_NAME;
ALTER DATABASE DEFAULT EDITION = &&EDITION_NAME;
PROMPT &&delimiter

SELECT SYS_CONTEXT('USERENV', 'SESSION_EDITION_NAME') AS edition FROM dual;

PROMPT Script info:
select sys_context('USERENV', 'MODULE') from dual; 
PROMPT

PROMPT &&delimiter
PROMPT Script end: run_ebr.sql
PROMPT &&delimiter
PROMPT

PROMPT &&delimiter
PROMPT Calling create_procedure_ebr.sql
PROMPT
@@create_procedure_ebr.sql
PROMPT

PROMPT &&delimiter
PROMPT Calling test_ebr.sql
PROMPT
@@test_ebr.sql
PROMPT

PROMPT &&delimiter
PROMPT Script end: run_ebr.sql
PROMPT &&delimiter

SET SERVEROUTPUT OFF
SPOOL OFF

