USE master;
GO

CREATE DATABASE WMU_ETL_Project;
GO

USE WMU_ETL_Project;
GO

/* =========================================
   CREATE SCHEMAS / FOLDERS
   ========================================= */

CREATE SCHEMA staging;
GO

CREATE SCHEMA reference;
GO

CREATE SCHEMA exceptions;
GO

CREATE SCHEMA audit;
GO

CREATE SCHEMA warehouse;
GO

/* =========================================
   CONFIRM SCHEMAS CREATED
   ========================================= */

SELECT name AS SchemaName
FROM sys.schemas
WHERE name IN ('staging', 'reference', 'exceptions', 'audit', 'warehouse')
ORDER BY name;