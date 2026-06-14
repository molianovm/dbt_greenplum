CREATE SCHEMA IF NOT EXISTS src;   -- данные
CREATE SCHEMA IF NOT EXISTS dict;  -- справочники

DROP TABLE IF EXISTS dict.region CASCADE;
CREATE TABLE dict.region (
    region_id      INTEGER PRIMARY KEY,
    region_name    VARCHAR(25) NOT NULL,
    region_comment VARCHAR(152)
);

DROP TABLE IF EXISTS dict.nation CASCADE;
CREATE TABLE dict.nation (
    nation_id      INTEGER PRIMARY KEY,
    nation_name    VARCHAR(25) NOT NULL,
    region_id      INTEGER NOT NULL REFERENCES dict.region(region_id),
    nation_comment VARCHAR(152)
);

DROP TABLE IF EXISTS src.supplier CASCADE;
CREATE TABLE src.supplier (
    supplier_key     BIGINT PRIMARY KEY,
    supplier_name    VARCHAR(25) NOT NULL,
    supplier_address VARCHAR(40),
    nation_id        INTEGER NOT NULL REFERENCES dict.nation(nation_id),
    supplier_phone   VARCHAR(15),
    supplier_acctbal NUMERIC(15,2),
    supplier_comment VARCHAR(101),
    updated_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS src.customer CASCADE;
CREATE TABLE src.customer (
    customer_key        BIGINT PRIMARY KEY,
    customer_name       VARCHAR(25) NOT NULL,
    customer_address    VARCHAR(40),
    nation_id           INTEGER NOT NULL REFERENCES dict.nation(nation_id),
    customer_phone      VARCHAR(15),
    customer_acctbal    NUMERIC(15,2),
    customer_mktsegment VARCHAR(10),
    customer_comment    VARCHAR(117),
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);