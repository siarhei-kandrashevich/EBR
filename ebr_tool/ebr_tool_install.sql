DEFINE delimiter = '-------------------------------------------------------------'

DEFINE;

SET TIME ON
SET TIMING ON
SET APPINFO ON
SPOOL ebr_tool_install.LOG

PROMPT &&delimiter
PROMPT Script start: ebr_tool_install.sql
PROMPT &&delimiter

SET SERVEROUTPUT ON

PROMPT Script info:
select sys_context('USERENV', 'MODULE') from dual;
PROMPT
PROMPT &&delimiter
PROMPT Calling create_ebr_tool_tables.sql for logging renaming process
PROMPT
@@install/create_ebr_tool_tables.sql
PROMPT

PROMPT &&delimiter
PROMPT Calling create_ebr_tool_package.pks for rename tables and create views
PROMPT
@@install/create_ebr_tool_package.pks
PROMPT

PROMPT &&delimiter
PROMPT Calling create_ebr_tool_package.pkb
PROMPT
@@install/create_ebr_tool_package.pkb
PROMPT

SET SERVEROUTPUT OFF

PROMPT &&delimiter
PROMPT Script end: ebr_tool_install.sql
PROMPT &&delimiter

SPOOL OFF

exit
