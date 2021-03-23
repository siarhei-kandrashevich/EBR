PROMPT &&delimiter
PROMPT Script start: create_trigger_ebr.sql
PROMPT &&delimiter

CREATE OR REPLACE TRIGGER insert_nation 
BEFORE INSERT ON nation 
FOR EACH ROW 
BEGIN 
   dbms_output.put_line('EBR_version --- Real name: ' || :NEW.n_name); 
END; 
/ 

PROMPT &&delimiter
PROMPT Script end: create_trigger_ebr.sql
PROMPT &&delimiter
