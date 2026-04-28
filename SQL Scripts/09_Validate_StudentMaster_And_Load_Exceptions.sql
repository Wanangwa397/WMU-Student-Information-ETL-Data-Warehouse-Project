/* Validate StudentMaster and load exception records */

INSERT INTO exceptions.StudentMaster (
    StudentID, FirstName, LastName, Gender, DateOfBirth, Nationality, State,
    Program, Department, StudentLevel, AdmissionDate, StudentStatus,
    IssueType, IssueDescription
)
SELECT
    sm.StudentID, sm.FirstName, sm.LastName, sm.Gender, sm.DateOfBirth, sm.Nationality, sm.State,
    sm.Program, sm.Department, sm.StudentLevel, sm.AdmissionDate, sm.StudentStatus,
    'Invalid Gender',
    'Gender is not in the approved reference list'
FROM staging.StudentMaster sm
LEFT JOIN reference.Gender g
    ON sm.Gender = g.Gender
WHERE g.Gender IS NULL;


INSERT INTO exceptions.StudentMaster (
    StudentID, FirstName, LastName, Gender, DateOfBirth, Nationality, State,
    Program, Department, StudentLevel, AdmissionDate, StudentStatus,
    IssueType, IssueDescription
)
SELECT
    sm.StudentID, sm.FirstName, sm.LastName, sm.Gender, sm.DateOfBirth, sm.Nationality, sm.State,
    sm.Program, sm.Department, sm.StudentLevel, sm.AdmissionDate, sm.StudentStatus,
    'Duplicate StudentID',
    'StudentID appears more than once in StudentMaster'
FROM staging.StudentMaster sm
WHERE sm.StudentID IN (
    SELECT StudentID
    FROM staging.StudentMaster
    GROUP BY StudentID
    HAVING COUNT(*) > 1
);


INSERT INTO exceptions.StudentMaster (
    StudentID, FirstName, LastName, Gender, DateOfBirth, Nationality, State,
    Program, Department, StudentLevel, AdmissionDate, StudentStatus,
    IssueType, IssueDescription
)
SELECT
    sm.StudentID, sm.FirstName, sm.LastName, sm.Gender, sm.DateOfBirth, sm.Nationality, sm.State,
    sm.Program, sm.Department, sm.StudentLevel, sm.AdmissionDate, sm.StudentStatus,
    'Invalid Date',
    'DateOfBirth or AdmissionDate is invalid, future dated, or DateOfBirth is after AdmissionDate'
FROM staging.StudentMaster sm
WHERE TRY_CONVERT(date, sm.DateOfBirth) IS NULL
   OR TRY_CONVERT(date, sm.AdmissionDate) IS NULL
   OR TRY_CONVERT(date, sm.DateOfBirth) > GETDATE()
   OR TRY_CONVERT(date, sm.AdmissionDate) > GETDATE()
   OR TRY_CONVERT(date, sm.DateOfBirth) > TRY_CONVERT(date, sm.AdmissionDate);


INSERT INTO exceptions.StudentMaster (
    StudentID, FirstName, LastName, Gender, DateOfBirth, Nationality, State,
    Program, Department, StudentLevel, AdmissionDate, StudentStatus,
    IssueType, IssueDescription
)
SELECT
    sm.StudentID, sm.FirstName, sm.LastName, sm.Gender, sm.DateOfBirth, sm.Nationality, sm.State,
    sm.Program, sm.Department, sm.StudentLevel, sm.AdmissionDate, sm.StudentStatus,
    'Invalid StudentLevel',
    'StudentLevel is not in the approved reference list'
FROM staging.StudentMaster sm
LEFT JOIN reference.StudentLevel sl
    ON sm.StudentLevel = sl.StudentLevel
WHERE sl.StudentLevel IS NULL;


INSERT INTO exceptions.StudentMaster (
    StudentID, FirstName, LastName, Gender, DateOfBirth, Nationality, State,
    Program, Department, StudentLevel, AdmissionDate, StudentStatus,
    IssueType, IssueDescription
)
SELECT
    sm.StudentID, sm.FirstName, sm.LastName, sm.Gender, sm.DateOfBirth, sm.Nationality, sm.State,
    sm.Program, sm.Department, sm.StudentLevel, sm.AdmissionDate, sm.StudentStatus,
    'Invalid StudentStatus',
    'StudentStatus is not in the approved reference list'
FROM staging.StudentMaster sm
LEFT JOIN reference.StudentStatus ss
    ON sm.StudentStatus = ss.StudentStatus
WHERE ss.StudentStatus IS NULL;


/* THIS IS THE NEW PART FOR STATE */

INSERT INTO exceptions.StudentMaster (
    StudentID, FirstName, LastName, Gender, DateOfBirth, Nationality, State,
    Program, Department, StudentLevel, AdmissionDate, StudentStatus,
    IssueType, IssueDescription
)
SELECT
    sm.StudentID, sm.FirstName, sm.LastName, sm.Gender, sm.DateOfBirth, sm.Nationality, sm.State,
    sm.Program, sm.Department, sm.StudentLevel, sm.AdmissionDate, sm.StudentStatus,
    'Invalid State',
    'State must be a standard 2-letter abbreviation'
FROM staging.StudentMaster sm
WHERE LEN(sm.State) <> 2;


/* Audit Summary */

INSERT INTO audit.ValidationSummary (
    TableName, IssueType, IssueCount
)
SELECT
    'StudentMaster',
    IssueType,
    COUNT(*)
FROM exceptions.StudentMaster
GROUP BY IssueType;