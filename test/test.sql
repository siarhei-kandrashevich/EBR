PROMPT &&delimiter
PROMPT Script end: test.sql
PROMPT &&delimiter

DECLARE
  l_counter NUMBER := 0;
  l_n_name  VARCHAR2(27) := 'BELARUS';
BEGIN
  LOOP
    l_counter := l_counter + 1;
    DBMS_OUTPUT.PUT_LINE('n_name=' || l_n_name || ': Step=' || l_counter);
    insert_nation(l_n_name);
    commit;
    DBMS_OUTPUT.PUT_LINE(to_char(SYSDATE, 'HH24:MI:SS'));
    sys.DBMS_SESSION.sleep(1);
    DBMS_OUTPUT.PUT_LINE(to_char(SYSDATE, 'HH24:MI:SS'));
    EXIT WHEN l_counter > 30;
  END LOOP;
  dbms_output.put_line( 'After loop: ' || l_counter );
END;
/

PROMPT &&delimiter
PROMPT Script end: test.sql
PROMPT &&delimiter

