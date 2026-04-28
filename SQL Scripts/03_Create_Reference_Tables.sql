USE WMU_ETL_Project;
GO

/* =========================================
   REFERENCE TABLES
   Official allowed values for validation
   ========================================= */

CREATE TABLE reference.Gender (
    Gender VARCHAR(20) PRIMARY KEY
);

INSERT INTO reference.Gender VALUES
('Male'),
('Female'),
('Other');


CREATE TABLE reference.StudentLevel (
    StudentLevel VARCHAR(30) PRIMARY KEY
);

INSERT INTO reference.StudentLevel VALUES
('Undergraduate'),
('Graduate');


CREATE TABLE reference.StudentStatus (
    StudentStatus VARCHAR(30) PRIMARY KEY
);

INSERT INTO reference.StudentStatus VALUES
('Active'),
('Inactive'),
('Graduated');


CREATE TABLE reference.Term (
    Term VARCHAR(30) PRIMARY KEY
);

INSERT INTO reference.Term VALUES
('Fall 2023'),
('Spring 2024'),
('Fall 2024'),
('Spring 2025'),
('Fall 2025');


CREATE TABLE reference.EnrollmentStatus (
    EnrollmentStatus VARCHAR(30) PRIMARY KEY
);

INSERT INTO reference.EnrollmentStatus VALUES
('Enrolled'),
('Withdrawn'),
('Completed');


CREATE TABLE reference.ResidencyStatus (
    ResidencyStatus VARCHAR(50) PRIMARY KEY
);

INSERT INTO reference.ResidencyStatus VALUES
('In-State'),
('Out-of-State'),
('International');


CREATE TABLE reference.Campus (
    Campus VARCHAR(50) PRIMARY KEY
);

INSERT INTO reference.Campus VALUES
('Main Campus'),
('Online'),
('Regional Campus');


CREATE TABLE reference.FinalGrade (
    FinalGrade VARCHAR(10) PRIMARY KEY
);

INSERT INTO reference.FinalGrade VALUES
('A'),
('B'),
('C'),
('D'),
('F'),
('W');


CREATE TABLE reference.AcademicStanding (
    AcademicStanding VARCHAR(50) PRIMARY KEY
);

INSERT INTO reference.AcademicStanding VALUES
('Good Standing'),
('Probation'),
('Dean''s List');


CREATE TABLE reference.AidType (
    AidType VARCHAR(30) PRIMARY KEY
);

INSERT INTO reference.AidType VALUES
('Grant'),
('Scholarship'),
('Loan'),
('Work Study'),
('None');


CREATE TABLE reference.AidStatus (
    AidStatus VARCHAR(30) PRIMARY KEY
);

INSERT INTO reference.AidStatus VALUES
('Awarded'),
('Accepted'),
('Declined'),
('Disbursed');


CREATE TABLE reference.FAFSAFiled (
    FAFSAFiled VARCHAR(10) PRIMARY KEY
);

INSERT INTO reference.FAFSAFiled VALUES
('Yes'),
('No');


CREATE TABLE reference.EngagementRisk (
    EngagementRisk VARCHAR(20) PRIMARY KEY
);

INSERT INTO reference.EngagementRisk VALUES
('Low'),
('Medium'),
('High');


SELECT 
    s.name AS SchemaName,
    t.name AS TableName
FROM sys.tables t
JOIN sys.schemas s
    ON t.schema_id = s.schema_id
WHERE s.name = 'reference'
ORDER BY t.name;