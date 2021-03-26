REM Example: @hr_migration.sql EBR_HR

DEFINE spool_file = hr_migration.log
SPOOL &spool_file

DEFINE delimiter = '-------------------------------------------------------------'
DEFINE USER_NAME = &&1
DEFINE pass = oracle

connect &USER_NAME/&pass

PROMPT &&delimiter
PROMPT Running renaming tables: alter_tables_rename.sql
PROMPT &&delimiter
@alter_tables_rename

PROMPT &&delimiter
PROMPT Running creating views: create_view.sql
PROMPT &&delimiter
@create_view

PROMPT &&delimiter
PROMPT Running recompiling invalide objects
PROMPT &&delimiter
EXEC DBMS_UTILITY.compile_schema(schema => '&USER_NAME', compile_all => false); 

PROMPT &&delimiter
PROMPT Checking for invalid objects 
PROMPT &&delimiter

SET LINESIZE 100
SELECT owner, object_type, object_name
FROM all_objects
WHERE status = 'INVALID'
AND owner = '&USER_NAME';

SPOOL OFF