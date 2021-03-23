PROMPT &&delimiter
PROMPT Script start: create_view_ebr.sql
PROMPT &&delimiter

CREATE OR REPLACE VIEW nation_view AS 
SELECT   
    n_nationkey,
    n_name,
    n_regionkey,
    n_comment
FROM nation
WHERE n_name = 'UKRAINE';
/

PROMPT &&delimiter
PROMPT Script end: create_view_ebr.sql
PROMPT &&delimiter
