CREATE TABLE nation_imp
                   (n_nationkey INTEGER not null,
                    n_name      VARCHAR2(27),
					n_regionkey INTEGER,
					n_comment   VARCHAR2(155) 
                   ) 
     ORGANIZATION EXTERNAL 
     ( 
       TYPE ORACLE_LOADER 
       DEFAULT DIRECTORY EBR_TEST_IMP 
       ACCESS PARAMETERS 
       ( 
         records delimited by newline 
         badfile EBR_TEST_IMP:'empxt%a_%p.bad' 
         logfile EBR_TEST_IMP:'empxt%a_%p.log' 
         fields terminated by '|' 
		 optionally enclosed by '"'
         missing field values are null 
         ( n_nationkey, n_name, n_regionkey, n_comment 
         ) 
       ) 
       LOCATION ('h_nation.dsv') 
     ) 
     PARALLEL 
     REJECT LIMIT UNLIMITED; 