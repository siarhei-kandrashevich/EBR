PROMPT &&delimiter
PROMPT Script end: test.sql
PROMPT &&delimiter

DECLARE
  l_counter NUMBER := 0;
  l_n_name  VARCHAR2(27) := 'UKRAINE';
  l_count_nation  NUMBER := 0;
BEGIN
  LOOP
    l_counter := l_counter + 1;
    DBMS_OUTPUT.PUT_LINE('n_name=' || l_n_name || ': Step= ' || l_counter);
    insert_nation(l_n_name);
    commit;
    DBMS_OUTPUT.PUT_LINE(to_char(SYSDATE, 'HH24:MI:SS'));
    sys.DBMS_SESSION.sleep(1);
    DBMS_OUTPUT.PUT_LINE(to_char(SYSDATE, 'HH24:MI:SS'));
    EXIT WHEN l_counter = 10;
  END LOOP;
  dbms_output.put_line( 'After loop: ' || l_counter );

  SELECT COUNT(1) 
  INTO  l_count_nation 
  FROM nation_view WHERE n_name = l_n_name;
  dbms_output.put_line( 'Count from VIEW for ' || l_n_name || ' = '|| l_counter );

  SELECT count_nation() 
  INTO  l_count_nation 
  FROM DUAL;
  dbms_output.put_line( 'Count from FUNCTION for ' || l_n_name || ' = '|| l_counter );

END;
/

PROMPT &&delimiter
PROMPT Script end: test.sql
PROMPT &&delimiter

