DEFINE delimiter = '-------------------------------------------------------------'

SET TIME ON
SET TIMING ON
SET APPINFO ON
SPOOL INSTALL_SCHEMA.LOG

PROMPT &&delimiter
PROMPT Script start: install.sql
PROMPT &&delimiter

DEFINE USER_NAME = &&1
DEFINE TBS_LOCATION = &&2
DEFINE IMP_LOCATION = &&3
SET SERVEROUTPUT ON

PROMPT Script info:
select sys_context('USERENV', 'MODULE') from dual; 
PROMPT
PROMPT Username to create: &&USER_NAME
PROMPT Path of datafile location: &&TBS_LOCATION
PROMPT
PROMPT &&delimiter
PROMPT Calling create_tablespaces.sql for data tablespace
PROMPT
@create_tablespaces.sql &&USER_NAME &&TBS_LOCATION DATA 
PROMPT

PROMPT &&delimiter
PROMPT Calling create_tablespaces.sql for index tablespace
PROMPT
@create_tablespaces.sql &&USER_NAME &&TBS_LOCATION IDX 
PROMPT

PROMPT &&delimiter
PROMPT Calling create_schema.sql
PROMPT
@create_schema.sql &&USER_NAME oracle &&USER_NAME._DATA &&USER_NAME._IDX
PROMPT

PROMPT &&delimiter
PROMPT Calling create_directory.sql
PROMPT
@create_directory.sql &&USER_NAME &&IMP_LOCATION
PROMPT

PROMPT &&delimiter
PROMPT Calling grants.sql
PROMPT
@grants.sql &&USER_NAME
PROMPT

SET SERVEROUTPUT OFF

UNDEFINE USER_NAME
UNDEFINE TBS_LOCATION

PROMPT &&delimiter
PROMPT Script end: install.sql
PROMPT &&delimiter

SPOOL OFF