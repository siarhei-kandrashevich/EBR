PROMPT &&delimiter
PROMPT Script start: create_table_nation.sql
PROMPT &&delimiter

create table nation
(
  n_nationkey INTEGER not null,
  n_name      VARCHAR2(27),
  n_regionkey INTEGER,
  n_comment   VARCHAR2(155)
);

PROMPT &&delimiter
PROMPT Script end: create_table_nation.sql
PROMPT &&delimiter