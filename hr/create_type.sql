PROMPT &&delimiter

PROMPT Script start: create_type.sql

PROMPT &&delimiter



CREATE TYPE test_typ1 AS OBJECT 

   (

     field varchar2(10),

     MEMBER FUNCTION work_period(emp_id integer) RETURN integer 

   ); 

/

 

CREATE TYPE BODY test_typ1 IS   

      MEMBER FUNCTION work_period (emp_id integer) RETURN integer deterministic

	 IS 

	work_period integer;

         BEGIN 

	  select end_date - start_date 

	  into work_period 

          from job_history

	  where employee_id in (emp_id);

             RETURN work_period;

         END; 

      END; 

/



PROMPT &&delimiter

PROMPT Script end: create_type.sql

PROMPT &&delimiter