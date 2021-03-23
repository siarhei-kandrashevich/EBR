PROMPT &&delimiter
PROMPT Script end: test.sql
PROMPT &&delimiter

DECLARE
  l_counter NUMBER := 0;
  l_n_name  VARCHAR2(27) := 'UKRAINE';
  l_count_nation  NUMBER := 0;
  l_pack_version VARCHAR2(20) := '';
  l_edition_name  VARCHAR2(30);
BEGIN
  SELECT SYS_CONTEXT('USERENV', 'SESSION_EDITION_NAME') AS edition 
  INTO l_edition_name
  FROM dual;
  
  LOOP
    l_counter := l_counter + 1;
    --DBMS_OUTPUT.PUT_LINE('n_name=' || l_n_name || ': Step= ' || l_counter);
    insert_nation(l_n_name);
    commit;
    --DBMS_OUTPUT.PUT_LINE(to_char(SYSDATE, 'HH24:MI:SS'));
    sys.DBMS_SESSION.sleep(1);
    --DBMS_OUTPUT.PUT_LINE(to_char(SYSDATE, 'HH24:MI:SS'));
    EXIT WHEN l_counter = 10;
  END LOOP;
  dbms_output.put_line(l_edition_name|| ' : After loop: ' || l_counter );

  SELECT COUNT(1) 
  INTO  l_count_nation 
  FROM nation_view WHERE n_name = l_n_name;
  dbms_output.put_line(l_edition_name||' : Count from VIEW for ' || l_n_name || ' = '|| l_counter );

  SELECT test_pack.package_version
  INTO  l_pack_version
  FROM dual ;
  dbms_output.put_line(l_edition_name||' : Current Package version is ' || l_pack_version );

  SELECT count_nation() 
  INTO  l_count_nation 
  FROM DUAL;
  dbms_output.put_line(l_edition_name||' : Count from FUNCTION for ' || l_n_name || ' = '|| l_counter );

END;
/

DECLARE
   l_edition_name  VARCHAR2(30);
   last_resort_dessert   dessert_t
                            := dessert_t ('Jello',
                                          'PROTEIN',
                                          'bowl',
                                          'N',
                                          1887);
   heavenly_cake         cake_t
                            := cake_t ('Marzepan Delight',
                                       'CARBOHYDRATE',
                                       'bakery',
                                       'N',
                                       1634,
                                       8,
                                       'Happy Birthday!');
BEGIN
  SELECT SYS_CONTEXT('USERENV', 'SESSION_EDITION_NAME') AS edition 
  INTO l_edition_name
  FROM dual;
   DBMS_OUTPUT.put_line (l_edition_name||' : '||last_resort_dessert.price);
   DBMS_OUTPUT.put_line (l_edition_name||' : '||heavenly_cake.price);
END;
/

/* Demonstration of dynamic polymorphism */

DECLARE
   l_edition_name  VARCHAR2(30);
   TYPE foodstuffs_nt IS TABLE OF food_t;

   fridge_contents   foodstuffs_nt
                        := foodstuffs_nt (dessert_t ('Strawberries and cream',
                                                     'FRUIT',
                                                     'Backyard',
                                                     'N',
                                                     2001),
                                          cake_t ('Chocolate Supreme',
                                                  'CARBOHYDATE',
                                                  'Kitchen',
                                                  'Y',
                                                  2001,
                                                  8,
                                                  'Happy Birthday, Veva'));
BEGIN
  SELECT SYS_CONTEXT('USERENV', 'SESSION_EDITION_NAME') AS edition 
  INTO l_edition_name
  FROM dual;
  
   FOR indx IN fridge_contents.FIRST .. fridge_contents.LAST
   LOOP
      DBMS_OUTPUT.put_line (l_edition_name||' : '||
            'Price of '
         || fridge_contents (indx).name
         || ' = '
         || fridge_contents (indx).price);
   END LOOP;
END;
/

PROMPT &&delimiter
PROMPT Script end: test.sql
PROMPT &&delimiter

