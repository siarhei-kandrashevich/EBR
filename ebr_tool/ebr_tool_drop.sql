DEFINE delimiter = '-------------------------------------------------------------'

DEFINE;

SET TIME ON
SET TIMING ON
SET APPINFO ON
SPOOL ebr_tool_drop.LOG

PROMPT &&delimiter
PROMPT Script start: ebr_tool_drop.sql
PROMPT &&delimiter

SET SERVEROUTPUT ON

PROMPT &&delimiter
PROMPT Start script: ebr_tool_drop.sql
PROMPT &&delimiter

PROMPT Script info:
select sys_context('USERENV', 'MODULE') from dual;
PROMPT
PROMPT &&delimiter
PROMPT Calling drop_ebr_tool_package.sql
PROMPT
@drop/drop_ebr_tool_package.sql
PROMPT

PROMPT &&delimiter
PROMPT Calling drop_ebr_tool_tables.sql
PROMPT
@drop/drop_ebr_tool_tables.sql
PROMPT

SET SERVEROUTPUT OFF

SPOOL OFF

exit
