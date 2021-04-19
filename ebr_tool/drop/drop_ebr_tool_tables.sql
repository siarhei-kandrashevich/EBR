PROMPT
PROMPT &&delimiter
PROMPT Script start: drop_ebr_tool_tables.sql
PROMPT &&delimiter

PROMPT
PROMPT Dropping ebr_tool_log table...
DROP TABLE ebr_tool_log;
PROMPT &&delimiter
PROMPT Dropping ebr_tool_table table...
DROP TABLE ebr_tool_table;
PROMPT &&delimiter
PROMPT Dropping ebr_tool_bucket table...
DROP TABLE ebr_tool_bucket;

PROMPT
PROMPT &&delimiter
PROMPT Script end: drop_ebr_tool_tables.sql
PROMPT &&delimiter
