/* Validate StudentEnrollment and load exception records */

INSERT INTO exceptions.StudentEnrollment (
    EnrollmentID, StudentID, Term, AcademicYear, EnrollmentStatus,
    CreditHours, ResidencyStatus, Campus, EnrollmentDate,
    IssueType, IssueDescription
)
SELECT
    se.EnrollmentID, se.StudentID, se.Term, se.AcademicYear, se.EnrollmentStatus,
    se.CreditHours, se.ResidencyStatus, se.Campus, se.EnrollmentDate,
    'Orphan StudentID',
    'StudentID does not exist in warehouse.DimStudent'
FROM staging.StudentEnrollment se
LEFT JOIN warehouse.DimStudent ds
    ON se.StudentID = ds.StudentID
WHERE ds.StudentID IS NULL;


INSERT INTO exceptions.StudentEnrollment (
    EnrollmentID, StudentID, Term, AcademicYear, EnrollmentStatus,
    CreditHours, ResidencyStatus, Campus, EnrollmentDate,
    IssueType, IssueDescription
)
SELECT
    se.EnrollmentID, se.StudentID, se.Term, se.AcademicYear, se.EnrollmentStatus,
    se.CreditHours, se.ResidencyStatus, se.Campus, se.EnrollmentDate,
    'Invalid Term',
    'Term is not in the approved reference list'
FROM staging.StudentEnrollment se
LEFT JOIN reference.Term t
    ON se.Term = t.Term
WHERE t.Term IS NULL;


INSERT INTO exceptions.StudentEnrollment (
    EnrollmentID, StudentID, Term, AcademicYear, EnrollmentStatus,
    CreditHours, ResidencyStatus, Campus, EnrollmentDate,
    IssueType, IssueDescription
)
SELECT
    se.EnrollmentID, se.StudentID, se.Term, se.AcademicYear, se.EnrollmentStatus,
    se.CreditHours, se.ResidencyStatus, se.Campus, se.EnrollmentDate,
    'Invalid EnrollmentStatus',
    'EnrollmentStatus is not in the approved reference list'
FROM staging.StudentEnrollment se
LEFT JOIN reference.EnrollmentStatus es
    ON se.EnrollmentStatus = es.EnrollmentStatus
WHERE es.EnrollmentStatus IS NULL;


INSERT INTO exceptions.StudentEnrollment (
    EnrollmentID, StudentID, Term, AcademicYear, EnrollmentStatus,
    CreditHours, ResidencyStatus, Campus, EnrollmentDate,
    IssueType, IssueDescription
)
SELECT
    se.EnrollmentID, se.StudentID, se.Term, se.AcademicYear, se.EnrollmentStatus,
    se.CreditHours, se.ResidencyStatus, se.Campus, se.EnrollmentDate,
    'Invalid CreditHours',
    'CreditHours must be numeric and between 1 and 18'
FROM staging.StudentEnrollment se
WHERE TRY_CONVERT(int, se.CreditHours) IS NULL
   OR TRY_CONVERT(int, se.CreditHours) < 1
   OR TRY_CONVERT(int, se.CreditHours) > 18;


INSERT INTO exceptions.StudentEnrollment (
    EnrollmentID, StudentID, Term, AcademicYear, EnrollmentStatus,
    CreditHours, ResidencyStatus, Campus, EnrollmentDate,
    IssueType, IssueDescription
)
SELECT
    se.EnrollmentID, se.StudentID, se.Term, se.AcademicYear, se.EnrollmentStatus,
    se.CreditHours, se.ResidencyStatus, se.Campus, se.EnrollmentDate,
    'Invalid ResidencyStatus',
    'ResidencyStatus is not in the approved reference list'
FROM staging.StudentEnrollment se
LEFT JOIN reference.ResidencyStatus rs
    ON se.ResidencyStatus = rs.ResidencyStatus
WHERE rs.ResidencyStatus IS NULL;


INSERT INTO exceptions.StudentEnrollment (
    EnrollmentID, StudentID, Term, AcademicYear, EnrollmentStatus,
    CreditHours, ResidencyStatus, Campus, EnrollmentDate,
    IssueType, IssueDescription
)
SELECT
    se.EnrollmentID, se.StudentID, se.Term, se.AcademicYear, se.EnrollmentStatus,
    se.CreditHours, se.ResidencyStatus, se.Campus, se.EnrollmentDate,
    'Invalid Campus',
    'Campus is not in the approved reference list'
FROM staging.StudentEnrollment se
LEFT JOIN reference.Campus c
    ON se.Campus = c.Campus
WHERE c.Campus IS NULL;


INSERT INTO exceptions.StudentEnrollment (
    EnrollmentID, StudentID, Term, AcademicYear, EnrollmentStatus,
    CreditHours, ResidencyStatus, Campus, EnrollmentDate,
    IssueType, IssueDescription
)
SELECT
    se.EnrollmentID, se.StudentID, se.Term, se.AcademicYear, se.EnrollmentStatus,
    se.CreditHours, se.ResidencyStatus, se.Campus, se.EnrollmentDate,
    'Invalid EnrollmentDate',
    'EnrollmentDate is invalid or future dated'
FROM staging.StudentEnrollment se
WHERE TRY_CONVERT(date, se.EnrollmentDate) IS NULL
   OR TRY_CONVERT(date, se.EnrollmentDate) > GETDATE();


INSERT INTO exceptions.StudentEnrollment (
    EnrollmentID, StudentID, Term, AcademicYear, EnrollmentStatus,
    CreditHours, ResidencyStatus, Campus, EnrollmentDate,
    IssueType, IssueDescription
)
SELECT
    se.EnrollmentID, se.StudentID, se.Term, se.AcademicYear, se.EnrollmentStatus,
    se.CreditHours, se.ResidencyStatus, se.Campus, se.EnrollmentDate,
    'Duplicate EnrollmentID',
    'EnrollmentID appears more than once in StudentEnrollment'
FROM staging.StudentEnrollment se
WHERE se.EnrollmentID IN (
    SELECT EnrollmentID
    FROM staging.StudentEnrollment
    GROUP BY EnrollmentID
    HAVING COUNT(*) > 1
);


INSERT INTO audit.ValidationSummary (
    TableName, IssueType, IssueCount
)
SELECT
    'StudentEnrollment',
    IssueType,
    COUNT(*)
FROM exceptions.StudentEnrollment
GROUP BY IssueType;