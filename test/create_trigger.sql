PROMPT &&delimiter
PROMPT Script start: create_trigger.sql
PROMPT &&delimiter

CREATE OR REPLACE TRIGGER insert_nation 
BEFORE INSERT ON nation 
FOR EACH ROW 
WHEN (NEW.n_name = 'BELARUS')
BEGIN 
   :NEW.n_name := 'Republic of '||:NEW.n_name;
   dbms_output.put_line('Initial version ---- New name: ' || :NEW.n_name); 
END; 
/ 

PROMPT &&delimiter
PROMPT Script end: create_trigger.sql
PROMPT &&delimiter
