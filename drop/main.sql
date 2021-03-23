DEFINE delimiter = '-------------------------------------------------------------'

SET TIME ON
SET TIMING ON
SET APPINFO ON
SPOOL DROP_SCHEMA.LOG

DEFINE USER_NAME = &&1

SET SERVEROUTPUT ON

PROMPT &&delimiter
PROMPT Start script: main.sql
PROMPT &&delimiter

PROMPT Script info:
select sys_context('USERENV', 'MODULE') from dual; 
PROMPT
PROMPT Username to drop: &&USER_NAME
PROMPT
PROMPT &&delimiter
PROMPT Calling drop_tablespace.sql for data tablespace
PROMPT
@drop_tablespace.sql &&USER_NAME DATA 
PROMPT

PROMPT &&delimiter
PROMPT Calling drop_tablespace.sql for index tablespace
PROMPT
@drop_tablespace.sql &&USER_NAME IDX 
PROMPT

PROMPT &&delimiter
PROMPT Calling drop_direcory.sql
PROMPT
@drop_directory.sql &&USER_NAME
PROMPT

PROMPT &&delimiter
PROMPT Calling drop_schema.sql
PROMPT
@drop_schema.sql &&USER_NAME
PROMPT

PROMPT &&delimiter
PROMPT Script end: main.sql
PROMPT &&delimiter

SET SERVEROUTPUT OFF

UNDEFINE USER_NAME

SPOOL OFF
