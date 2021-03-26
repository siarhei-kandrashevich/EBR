REM Example: @hr_enable_ebr.sql EBR_HR

DEFINE delimiter = '-------------------------------------------------------------'
DEFINE USER_NAME = &&1
DEFINE pass = oracle

PROMPT &delimiter
PROMPT Connect as system user
PROMPT &delimiter
connect system/&pass

PROMPT &delimiter
PROMPT Grants section
PROMPT &delimiter

GRANT CREATE ANY EDITION TO &&USER_NAME;
GRANT DROP ANY EDITION TO &&USER_NAME;

PROMPT &delimiter
PROMPT Enabling editions for user : &&USER_NAME
PROMPT &delimiter
--ALTER USER &&USER_NAME ENABLE EDITIONS;

alter user &&USER_NAME enable editions force;

