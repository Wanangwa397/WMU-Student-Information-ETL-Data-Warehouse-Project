USE WMU_ETL_Project;
GO

/* =========================================
   WAREHOUSE TABLES
   Clean trusted reporting layer
   ========================================= */

CREATE TABLE warehouse.DimStudent (
    StudentKey       INT IDENTITY(1,1) PRIMARY KEY,
    StudentID        VARCHAR(20) NOT NULL UNIQUE,
    FirstName        VARCHAR(50),
    LastName         VARCHAR(50),
    Gender           VARCHAR(20),
    DateOfBirth      DATE,
    Nationality      VARCHAR(50),
    State            CHAR(2),
    Program          VARCHAR(100),
    Department       VARCHAR(100),
    StudentLevel     VARCHAR(30),
    AdmissionDate    DATE,
    StudentStatus    VARCHAR(30)
);

CREATE TABLE warehouse.FactEnrollment (
    EnrollmentKey      INT IDENTITY(1,1) PRIMARY KEY,
    EnrollmentID       VARCHAR(20) NOT NULL UNIQUE,
    StudentKey         INT NOT NULL,
    StudentID          VARCHAR(20) NOT NULL,
    Term               VARCHAR(30),
    AcademicYear       INT,
    EnrollmentStatus   VARCHAR(30),
    CreditHours        INT,
    ResidencyStatus    VARCHAR(50),
    Campus             VARCHAR(50),
    EnrollmentDate     DATE,

    CONSTRAINT FK_FactEnrollment_DimStudent
        FOREIGN KEY (StudentKey)
        REFERENCES warehouse.DimStudent(StudentKey)
);

CREATE TABLE warehouse.FactAcademicPerformance (
    PerformanceKey         INT IDENTITY(1,1) PRIMARY KEY,
    PerformanceID          VARCHAR(20) NOT NULL UNIQUE,
    StudentKey             INT NOT NULL,
    StudentID              VARCHAR(20) NOT NULL,
    Term                   VARCHAR(30),
    CourseCode             VARCHAR(20),
    CreditHoursAttempted   INT,
    CreditHoursEarned      INT,
    FinalGrade             VARCHAR(10),
    TermGPA                DECIMAL(3,2),
    CumulativeGPA          DECIMAL(3,2),
    AcademicStanding       VARCHAR(50),

    CONSTRAINT FK_FactAcademicPerformance_DimStudent
        FOREIGN KEY (StudentKey)
        REFERENCES warehouse.DimStudent(StudentKey)
);

CREATE TABLE warehouse.FactFinancialAid (
    AidKey         INT IDENTITY(1,1) PRIMARY KEY,
    AidID          VARCHAR(20) NOT NULL UNIQUE,
    StudentKey     INT NOT NULL,
    StudentID      VARCHAR(20) NOT NULL,
    AcademicYear   INT,
    AidType        VARCHAR(30),
    AidAmount      DECIMAL(12,2),
    AidStatus      VARCHAR(30),
    FAFSAFiled     VARCHAR(10),
    PackagingDate  DATE,

    CONSTRAINT FK_FactFinancialAid_DimStudent
        FOREIGN KEY (StudentKey)
        REFERENCES warehouse.DimStudent(StudentKey)
);

CREATE TABLE warehouse.FactStudentAttendance (
    AttendanceKey      INT IDENTITY(1,1) PRIMARY KEY,
    AttendanceID       VARCHAR(20) NOT NULL UNIQUE,
    StudentKey         INT NOT NULL,
    StudentID          VARCHAR(20) NOT NULL,
    Term               VARCHAR(30),
    ClassesScheduled   INT,
    ClassesAttended    INT,
    LMSLogins          INT,
    AdvisorMeetings    INT,
    EngagementRisk     VARCHAR(20),

    CONSTRAINT FK_FactStudentAttendance_DimStudent
        FOREIGN KEY (StudentKey)
        REFERENCES warehouse.DimStudent(StudentKey)
);

SELECT 
    s.name AS SchemaName,
    t.name AS TableName
FROM sys.tables t
JOIN sys.schemas s
    ON t.schema_id = s.schema_id
WHERE s.name = 'warehouse'
ORDER BY t.name;