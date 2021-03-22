
PROMPT
PROMPT &&delimiter
PROMPT Script start: drop_objects.sql
PROMPT &&delimiter
 
DEFINE SCHEMA_NAME = &&1

connect &SCHEMA_NAME/oracle

PROMPT
PROMPT Dropping nation_imp table...
DROP TABLE nation_imp;

disconnect

PROMPT
PROMPT &&delimiter
PROMPT Script end: drop_objects.sql
PROMPT &&delimiter

UNDEFINE DIR_NAME

