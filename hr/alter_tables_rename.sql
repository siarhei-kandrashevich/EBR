PROMPT &&delimiter
PROMPT Script start: alter_tables_rename.sql
PROMPT &&delimiter

ALTER TABLE REGIONS RENAME TO REGIONS_TAB;
ALTER TABLE LOCATIONS RENAME TO LOCATIONS_TAB;
ALTER TABLE JOBS RENAME TO JOBS_TAB;
ALTER TABLE JOB_HISTORY RENAME TO JOB_HISTORY_TAB;
ALTER TABLE EMPLOYEES RENAME TO EMPLOYEES_TAB;
ALTER TABLE DEPARTMENTS RENAME TO DEPARTMENTS_TAB;
ALTER TABLE COUNTRIES RENAME TO COUNTRIES_TAB;

PROMPT &&delimiter
PROMPT Script end: alter_tables_rename.sql
PROMPT &&delimiter
