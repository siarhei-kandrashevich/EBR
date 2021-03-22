
PROMPT
PROMPT &&delimiter
PROMPT Script start: drop_directory.sql
PROMPT &&delimiter
 
DEFINE DIR_NAME = &&1._IMP

PROMPT
PROMPT Dropping import directory &&DIR_NAME...
DROP DIRECTORY &&DIR_NAME;

PROMPT
PROMPT &&delimiter
PROMPT Script end: drop_directory.sql
PROMPT &&delimiter

UNDEFINE DIR_NAME

