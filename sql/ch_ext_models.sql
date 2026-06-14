CREATE DATABASE IF NOT EXISTS ext;

DROP TABLE IF EXISTS ext.customers_by_region;
CREATE TABLE ext.customers_by_region
ENGINE = PostgreSQL('gpdb:5432', 'test', 'customers_by_region', 'postgres', 'postgres', 'mart');

DROP TABLE IF EXISTS ext.suppliers_by_region;
CREATE TABLE ext.suppliers_by_region
ENGINE = PostgreSQL('gpdb:5432', 'test', 'suppliers_by_region', 'postgres', 'postgres', 'mart');