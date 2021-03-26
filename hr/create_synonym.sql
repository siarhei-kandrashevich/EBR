PROMPT &&delimiter
PROMPT Script start: create_synonym.sql
PROMPT &&delimiter

create or replace synonym location_syn for countries;
/

PROMPT &&delimiter
PROMPT Script end: create_synonym.sql
PROMPT &&delimiter