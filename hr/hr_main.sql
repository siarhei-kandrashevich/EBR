rem

rem Header: hr_main.sql 2015/03/19 10:23:26 smtaylor Exp $

rem

rem Copyright (c) 2001, 2016, Oracle and/or its affiliates. 

rem All rights reserved.

rem 

rem Permission is hereby granted, free of charge, to any person obtaining

rem a copy of this software and associated documentation files (the

rem "Software"), to deal in the Software without restriction, including

rem without limitation the rights to use, copy, modify, merge, publish,

rem distribute, sublicense, and/or sell copies of the Software, and to

rem permit persons to whom the Software is furnished to do so, subject to

rem the following conditions:

rem 

rem The above copyright notice and this permission notice shall be

rem included in all copies or substantial portions of the Software.

rem 

rem THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,

rem EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF

rem MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND

rem NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE

rem LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION

rem OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION

rem WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

rem

rem Owner  : ahunold

rem

rem NAME

rem   hr_main.sql - Main script for HR schema

rem

rem DESCRIPTON

rem   HR (Human Resources) is the smallest and most simple one 

rem   of the Sample Schemas

rem   

rem NOTES

rem   Run as SYS or SYSTEM

rem

rem MODIFIED   (MM/DD/YY)

rem   celsbern  03/10/16 - removing grant to sys.dbms_stats

rem   dmatisha  10/09/15 - added check to see if hr user exists 

rem       before dropping the hr user.

rem   dmatisha  10/08/15 - removed connect string, sys password, 

rem       changed to use alter session current_schema=hr instead

rem       of reconnecting. You now MUST be connected as sys 

rem       prior to running this script. Modified log parameter 

rem       from &log_path.hr_main.log to &log_path/hr_main.log 

rem   smtaylor  03/19/15 - added parameter 6, connect_string

rem   smtaylor  03/19/15 - added @&connect_string to CONNECT

rem   jmadduku  02/18/11 - Grant Unlimited Tablespace priv with RESOURCE

rem   celsbern  06/17/10 - fixing bug 9733839

rem   pthornto  07/16/04 - obsolete 'connect' role 

rem   hyeh      08/29/02 - hyeh_mv_comschema_to_rdbms

rem   ahunold   08/28/01 - roles

rem   ahunold   07/13/01 - NLS Territory

rem   ahunold   04/13/01 - parameter 5, notes, spool

rem   ahunold   03/29/01 - spool

rem   ahunold   03/12/01 - prompts

rem   ahunold   03/07/01 - hr_analz.sql

rem   ahunold   03/03/01 - HR simplification, REGIONS table

rem   ngreenbe  06/01/00 - created



SET ECHO OFF

SET VERIFY OFF



PROMPT

DEFINE delimiter = '-------------------------------------------------------------'

DEFINE USER_NAME = &&1

DEFINE log_path = &&2

DEFINE TBS_LOCATION = &&3

DEFINE tbs = &&USER_NAME._DATA

DEFINE ttbs = TEMP

DEFINE pass     = oracle



PROMPT &&delimiter

PROMPT User name USER_NAME=&&USER_NAME

PROMPT User password for &&USER_NAME: =&pass

PROMPT User tablespeace location for &&USER_NAME: =&TBS_LOCATION

PROMPT Default tablespeace for &&USER_NAME: &tbs

PROMPT Temporary tablespace for &&USER_NAME: &ttbs

PROMPT Log path log_path: &log_path

PROMPT &&delimiter



DEFINE spool_file = &log_path/hr_main.log

SPOOL &spool_file



REM =======================================================

REM cleanup section

REM =======================================================



DECLARE

vcount INTEGER :=0;

BEGIN

select count(1) into vcount from dba_users where username = 'EBR_HR';

IF vcount != 0 THEN

EXECUTE IMMEDIATE ('DROP USER EBR_HR CASCADE');

END IF;

END;

/



REM =======================================================

REM Tablespace section

REM =======================================================

PROMPT &&delimiter

PROMPT Calling hr_tablespaces.sql for data tablespace

PROMPT

@hr_tablespaces.sql &&USER_NAME &&TBS_LOCATION DATA 

PROMPT





REM =======================================================

REM create user

REM three separate commands, so the create user command 

REM will succeed regardless of the existence of the 

REM DEMO and TEMP tablespaces 

REM =======================================================



CREATE USER &&USER_NAME IDENTIFIED BY &pass;



ALTER USER &&USER_NAME DEFAULT TABLESPACE &tbs

              QUOTA UNLIMITED ON &tbs;



ALTER USER &&USER_NAME TEMPORARY TABLESPACE &ttbs;



GRANT CREATE SESSION, CREATE VIEW, ALTER SESSION, CREATE SEQUENCE TO &&USER_NAME;

GRANT CREATE SYNONYM, CREATE DATABASE LINK, RESOURCE , UNLIMITED TABLESPACE TO &&USER_NAME;

GRANT CREATE PROCEDURE TO &USER_NAME;

GRANT CREATE TABLE TO &USER_NAME;

GRANT CREATE TYPE TO &USER_NAME;

GRANT CREATE TRIGGER TO &USER_NAME;

GRANT CREATE ANY DIRECTORY TO &USER_NAME;

GRANT CREATE ANY EDITION TO &&USER_NAME;

GRANT DROP ANY EDITION TO &&USER_NAME;

GRANT CREATE ANY VIEW TO &&USER_NAME;

GRANT ALTER DATABASE TO &&USER_NAME;



ALTER USER &&USER_NAME ENABLE EDITIONS;



GRANT READ ON DIRECTORY &USER_NAME._IMP TO &USER_NAME; 

GRANT WRITE ON DIRECTORY &USER_NAME._IMP TO &USER_NAME;



REM =======================================================

REM create &&USER_NAME schema objects

REM =======================================================



ALTER SESSION SET CURRENT_SCHEMA=&&USER_NAME;



ALTER SESSION SET NLS_LANGUAGE=American;

ALTER SESSION SET NLS_TERRITORY=America;



--

-- create tables, sequences and constraint

--



@hr_cre



-- 

-- populate tables

--



@hr_popul



--

-- create indexes

--



@hr_idx



--

-- create procedural objects

--



@hr_code



--

-- add comments to tables and columns

--



@hr_comnt



--

-- gather schema statistics

--



@hr_analz



spool off