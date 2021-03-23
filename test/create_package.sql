PROMPT &&delimiter
PROMPT Script start: create_package.sql
PROMPT &&delimiter

CREATE OR REPLACE package test_pack AS
PROCEDURE pack_proc(v_n_name IN VARCHAR2);
package_version CONSTANT VARCHAR2(20) :='version1';
END test_pack;
/

CREATE OR REPLACE package body test_pack AS
  PROCEDURE pack_proc (v_n_name IN VARCHAR2) AS
  BEGIN
  INSERT INTO NATION (n_nationkey, n_name,n_regionkey, n_comment)
      VALUES (400,'package body',0,'First version');
  END pack_proc;
END test_pack;
/

PROMPT &&delimiter
PROMPT Script end: create_package.sql
PROMPT &&delimiter
