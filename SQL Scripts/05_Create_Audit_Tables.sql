USE WMU_ETL_Project;
GO

/* =========================================
   AUDIT TABLES
   ETL tracking and validation summary
   ========================================= */

CREATE TABLE audit.ETLRun (
    RunID            INT IDENTITY(1,1) PRIMARY KEY,
    RunDate          DATETIME DEFAULT GETDATE(),
    TableName        VARCHAR(100),
    TotalRows        INT,
    ValidRows        INT,
    InvalidRows      INT,
    Status           VARCHAR(50)
);

CREATE TABLE audit.ValidationSummary (
    ValidationID     INT IDENTITY(1,1) PRIMARY KEY,
    ValidationDate   DATETIME DEFAULT GETDATE(),
    TableName        VARCHAR(100),
    IssueType        VARCHAR(100),
    IssueCount       INT
);

SELECT 
    s.name AS SchemaName,
    t.name AS TableName
FROM sys.tables t
JOIN sys.schemas s
    ON t.schema_id = s.schema_id
WHERE s.name = 'audit'
ORDER BY t.name;