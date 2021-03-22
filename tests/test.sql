PROMPT &&delimiter
PROMPT Script end: test.sql
PROMPT &&delimiter

DECLARE
  l_counter NUMBER := 0;
BEGIN
  LOOP
    l_counter := l_counter + 1;
	insert_nation('BELARUS');
	commit;
    DBMS_OUTPUT.PUT_LINE(to_char(SYSDATE, 'HH24:MI:SS'));
    sys.DBMS_SESSION.sleep(1);
    DBMS_OUTPUT.PUT_LINE(to_char(SYSDATE, 'HH24:MI:SS'));
    EXIT WHEN l_counter > 60;
    dbms_output.put_line( 'Inside loop: ' || l_counter ) ;
  END LOOP;
  dbms_output.put_line( 'After loop: ' || l_counter );
END;

PROMPT &&delimiter
PROMPT Script end: test.sql
PROMPT &&delimiter

SPOOL OFF