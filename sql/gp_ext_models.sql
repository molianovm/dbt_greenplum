CREATE SCHEMA IF NOT EXISTS ext;

DROP EXTERNAL TABLE IF EXISTS ext.src_customer;
CREATE READABLE EXTERNAL TABLE ext.src_customer (
    customer_key BIGINT,
    customer_name VARCHAR(25),
    customer_address VARCHAR(40),
    nation_id INTEGER,
    customer_phone VARCHAR(15),
    customer_acctbal NUMERIC(15,2),
    customer_mktsegment CHAR(10),
    customer_comment VARCHAR(117),
    updated_at TIMESTAMP
)
LOCATION ('pxf://src.customer?PROFILE=JDBC&SERVER=pg_source')
FORMAT 'CUSTOM' (FORMATTER='pxfwritable_import');

DROP EXTERNAL TABLE IF EXISTS ext.src_supplier;
CREATE READABLE EXTERNAL TABLE ext.src_supplier (
    supplier_key BIGINT,
    supplier_name VARCHAR(25),
    supplier_address VARCHAR(40),
    nation_id INTEGER,
    supplier_phone VARCHAR(15),
    supplier_acctbal NUMERIC(15,2),
    supplier_comment VARCHAR(101),
    updated_at TIMESTAMP
)
LOCATION ('pxf://src.supplier?PROFILE=JDBC&SERVER=pg_source')
FORMAT 'CUSTOM' (FORMATTER='pxfwritable_import');

DROP EXTERNAL TABLE IF EXISTS ext.dict_nation;
CREATE READABLE EXTERNAL TABLE ext.dict_nation (
    nation_id      INTEGER,
    nation_name    VARCHAR(25),
    region_id      INTEGER,
    nation_comment VARCHAR(152)
)
LOCATION ('pxf://dict.nation?PROFILE=JDBC&SERVER=pg_source')
FORMAT 'CUSTOM' (FORMATTER='pxfwritable_import');

DROP EXTERNAL TABLE IF EXISTS ext.dict_region;
CREATE READABLE EXTERNAL TABLE ext.dict_region (
    region_id      INTEGER,
    region_name    VARCHAR(25),
    region_comment VARCHAR(152)
)
LOCATION ('pxf://dict.region?PROFILE=JDBC&SERVER=pg_source')
FORMAT 'CUSTOM' (FORMATTER='pxfwritable_import');