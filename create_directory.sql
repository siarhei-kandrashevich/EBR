
PROMPT
PROMPT &&delimiter
PROMPT Script: create_directory.sql
PROMPT &&delimiter
 
DEFINE DIR_NAME = &&1._IMP
DEFINE DIR_PATH = &&2

PROMPT
PROMPT Creating import directory &&DIR_NAME...
CREATE OR REPLACE DIRECTORY &&DIR_NAME AS '&&DIR_PATH';
 
PROMPT &&delimiter
PROMPT Script end: create_directory.sql
PROMPT &&delimiter

UNDEFINE DIR_NAME
UNDEFINE DIR_PATH

