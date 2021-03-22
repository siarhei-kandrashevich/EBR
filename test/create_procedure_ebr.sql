PROMPT &&delimiter
PROMPT Script start: create_procedure_ebr.sql
PROMPT &&delimiter

CREATE OR REPLACE PROCEDURE insert_nation (v_n_name IN VARCHAR2) AS
BEGIN

    INSERT INTO NATION (n_nationkey, n_name,n_regionkey, n_comment)
    VALUES (200,'UKRAINE',1,'Second version');

END insert_nation;
/
PROMPT &&delimiter
PROMPT Script end: create_procedure_ebr.sql
PROMPT &&delimiter
