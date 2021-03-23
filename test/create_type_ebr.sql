PROMPT &&delimiter
PROMPT Script start: create_type_ebr.sql
PROMPT &&delimiter

DROP TYPE cake_t;
DROP TYPE dessert_t;
DROP TYPE food_t;

CREATE OR REPLACE TYPE food_t AS OBJECT
(
   name VARCHAR2 (100),
   food_group VARCHAR2 (100),
   grown_in VARCHAR2 (100),
   /* Generic foods cannot have a price, but we can
      insist that all subtypes DO implement a price
      function. */
   NOT INSTANTIABLE MEMBER FUNCTION price RETURN NUMBER
)
   NOT FINAL NOT INSTANTIABLE;
/

CREATE OR REPLACE TYPE dessert_t UNDER food_t (
      contains_chocolate CHAR (1),
      year_created NUMBER (4),
      OVERRIDING MEMBER FUNCTION price RETURN NUMBER
   )
   NOT FINAL;
/

CREATE OR REPLACE TYPE BODY dessert_t
IS
   OVERRIDING MEMBER FUNCTION price RETURN NUMBER
   IS
      multiplier   NUMBER := 1;
   BEGIN
      DBMS_OUTPUT.put_line ('Dessert price!');

      IF self.contains_chocolate = 'Y'
      THEN
         multiplier := 2;
      END IF;

      IF self.year_created < 1900
      THEN
         multiplier := multiplier + 0.5;
      END IF;

      RETURN (15.00 * multiplier);
   END;
END;
/

CREATE OR REPLACE TYPE cake_t UNDER dessert_t (
      diameter NUMBER,
      inscription VARCHAR2 (200),
      /* Inscription and diameter determine the price */
      OVERRIDING MEMBER FUNCTION price RETURN NUMBER
   );
/

CREATE OR REPLACE TYPE BODY cake_t
IS
   OVERRIDING MEMBER FUNCTION price
      RETURN NUMBER
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('Cake price!');
      RETURN (15.00 + 0.25 * (LENGTH (self.inscription)) + 0.150 * diameter);
   END;
END;
/

PROMPT &&delimiter
PROMPT Script end: create_type_ebr.sql
PROMPT &&delimiter