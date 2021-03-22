--drop table region;
create table region
(
  r_regionkey INTEGER,
  r_name      VARCHAR2(25),
  r_comment   VARCHAR2(152)
);


--drop table nation;
create table nation
(
  n_nationkey INTEGER not null,
  n_name      VARCHAR2(27),
  n_regionkey INTEGER,
  n_comment   VARCHAR2(155)
);


--drop table supplier;
create table supplier
(
  s_suppkey   INTEGER not null,
  s_name      VARCHAR2(25),
  s_address   VARCHAR2(40),
  s_nationkey INTEGER,
  s_phone     VARCHAR2(15),
  s_acctbal   FLOAT,
  s_comment   VARCHAR2(101)
);


--drop table orders;
create table orders
(
  o_orderkey      INTEGER not null,
  o_custkey       INTEGER not null,
  o_orderstatus   VARCHAR2(1),
  o_totalprice    FLOAT,
  o_orderdate     DATE,
  o_orderpriority VARCHAR2(15),
  o_clerk         VARCHAR2(15),
  o_shippriority  INTEGER,
  o_comment       VARCHAR2(79)
);


--drop table partsupp;
create table partsupp
(
  ps_partkey    INTEGER not null,
  ps_suppkey    INTEGER not null,
  ps_availqty   INTEGER,
  ps_supplycost FLOAT not null,
  ps_comment    VARCHAR2(199)
);


--drop table part;
create table part
(
  p_partkey     INTEGER not null,
  p_name        VARCHAR2(55),
  p_mfgr        VARCHAR2(25),
  p_brand       VARCHAR2(10),
  p_type        VARCHAR2(25),
  p_size        INTEGER,
  p_container   VARCHAR2(10),
  p_retailprice INTEGER,
  p_comment     VARCHAR2(23)
);


--drop table customer;
create table customer
(
  c_custkey    INTEGER not null,
  c_name       VARCHAR2(25),
  c_address    VARCHAR2(40),
  c_nationkey  INTEGER,
  c_phone      VARCHAR2(15),
  c_acctbal    FLOAT,
  c_mktsegment VARCHAR2(10),
  c_comment    VARCHAR2(117)
);


--drop table lineitem;
create table lineitem
(
  l_orderkey      INTEGER not null,
  l_partkey       INTEGER not null,
  l_suppkey       INTEGER not null,
  l_linenumber    INTEGER not null,
  l_quantity      INTEGER not null,
  l_extendedprice FLOAT not null,
  l_discount      FLOAT not null,
  l_tax           FLOAT not null,
  l_returnflag    VARCHAR2(1),
  l_linestatus    VARCHAR2(1),
  l_shipdate      DATE,
  l_commitdate    DATE,
  l_receiptdate   DATE,
  l_shipinstruct  VARCHAR2(25),
  l_shipmode      VARCHAR2(10),
  l_comment       VARCHAR2(44)
);