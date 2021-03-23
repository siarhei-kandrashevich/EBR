PROMPT &&delimiter
PROMPT Script start: create_view.sql
PROMPT &&delimiter

CREATE OR REPLACE VIEW nation_view AS 
SELECT
    n_nationkey,
    n_name,
    n_regionkey,
    n_comment 
FROM nation
WHERE n_name = 'BELARUS';
/

PROMPT &&delimiter
PROMPT Script end: create_view.sql
PROMPT &&delimiter
