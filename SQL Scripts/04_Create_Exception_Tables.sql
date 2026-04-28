USE WMU_ETL_Project;
GO

/* =========================================
   EXCEPTION TABLES
   Stores rows that fail validation
   ========================================= */

CREATE TABLE exceptions.StudentMaster (
    ExceptionID      INT IDENTITY(1,1) PRIMARY KEY,
    StudentID        VARCHAR(20),
    FirstName        VARCHAR(50),
    LastName         VARCHAR(50),
    Gender           VARCHAR(20),
    DateOfBirth      VARCHAR(20),
    Nationality      VARCHAR(50),
    State            VARCHAR(20),
    Program          VARCHAR(100),
    Department       VARCHAR(100),
    StudentLevel     VARCHAR(30),
    AdmissionDate    VARCHAR(20),
    StudentStatus    VARCHAR(30),
    IssueType        VARCHAR(100),
    IssueDescription VARCHAR(255),
    LoadDate         DATETIME DEFAULT GETDATE()
);

CREATE TABLE exceptions.StudentEnrollment (
    ExceptionID      INT IDENTITY(1,1) PRIMARY KEY,
    EnrollmentID     VARCHAR(20),
    StudentID        VARCHAR(20),
    Term             VARCHAR(30),
    AcademicYear     VARCHAR(10),
    EnrollmentStatus VARCHAR(30),
    CreditHours      VARCHAR(10),
    ResidencyStatus  VARCHAR(50),
    Campus           VARCHAR(50),
    EnrollmentDate   VARCHAR(20),
    IssueType        VARCHAR(100),
    IssueDescription VARCHAR(255),
    LoadDate         DATETIME DEFAULT GETDATE()
);

CREATE TABLE exceptions.AcademicPerformance (
    ExceptionID           INT IDENTITY(1,1) PRIMARY KEY,
    PerformanceID         VARCHAR(20),
    StudentID             VARCHAR(20),
    Term                  VARCHAR(30),
    CourseCode            VARCHAR(20),
    CreditHoursAttempted  VARCHAR(10),
    CreditHoursEarned     VARCHAR(10),
    FinalGrade            VARCHAR(10),
    TermGPA               VARCHAR(10),
    CumulativeGPA         VARCHAR(10),
    AcademicStanding      VARCHAR(50),
    IssueType             VARCHAR(100),
    IssueDescription      VARCHAR(255),
    LoadDate              DATETIME DEFAULT GETDATE()
);

CREATE TABLE exceptions.FinancialAid (
    ExceptionID      INT IDENTITY(1,1) PRIMARY KEY,
    AidID            VARCHAR(20),
    StudentID        VARCHAR(20),
    AcademicYear     VARCHAR(10),
    AidType          VARCHAR(30),
    AidAmount        VARCHAR(20),
    AidStatus        VARCHAR(30),
    FAFSAFiled       VARCHAR(10),
    PackagingDate    VARCHAR(20),
    IssueType        VARCHAR(100),
    IssueDescription VARCHAR(255),
    LoadDate         DATETIME DEFAULT GETDATE()
);

CREATE TABLE exceptions.StudentAttendance (
    ExceptionID       INT IDENTITY(1,1) PRIMARY KEY,
    AttendanceID      VARCHAR(20),
    StudentID         VARCHAR(20),
    Term              VARCHAR(30),
    ClassesScheduled  VARCHAR(10),
    ClassesAttended   VARCHAR(10),
    LMSLogins         VARCHAR(10),
    AdvisorMeetings   VARCHAR(10),
    EngagementRisk    VARCHAR(20),
    IssueType         VARCHAR(100),
    IssueDescription  VARCHAR(255),
    LoadDate          DATETIME DEFAULT GETDATE()
);

SELECT 
    s.name AS SchemaName,
    t.name AS TableName
FROM sys.tables t
JOIN sys.schemas s
    ON t.schema_id = s.schema_id
WHERE s.name = 'exceptions'
ORDER BY t.name;