/* Validate AcademicPerformance and load exception records */

INSERT INTO exceptions.AcademicPerformance (
    PerformanceID,
    StudentID,
    Term,
    CourseCode,
    CreditHoursAttempted,
    CreditHoursEarned,
    FinalGrade,
    TermGPA,
    CumulativeGPA,
    AcademicStanding,
    IssueType,
    IssueDescription
)
SELECT
    ap.PerformanceID,
    ap.StudentID,
    ap.Term,
    ap.CourseCode,
    ap.CreditHoursAttempted,
    ap.CreditHoursEarned,
    ap.FinalGrade,
    ap.TermGPA,
    ap.CumulativeGPA,
    ap.AcademicStanding,
    'Orphan StudentID',
    'StudentID does not exist in warehouse.DimStudent'
FROM staging.AcademicPerformance ap
LEFT JOIN warehouse.DimStudent ds
    ON ap.StudentID = ds.StudentID
WHERE ds.StudentID IS NULL;


INSERT INTO exceptions.AcademicPerformance (
    PerformanceID,
    StudentID,
    Term,
    CourseCode,
    CreditHoursAttempted,
    CreditHoursEarned,
    FinalGrade,
    TermGPA,
    CumulativeGPA,
    AcademicStanding,
    IssueType,
    IssueDescription
)
SELECT
    ap.PerformanceID,
    ap.StudentID,
    ap.Term,
    ap.CourseCode,
    ap.CreditHoursAttempted,
    ap.CreditHoursEarned,
    ap.FinalGrade,
    ap.TermGPA,
    ap.CumulativeGPA,
    ap.AcademicStanding,
    'Invalid FinalGrade',
    'FinalGrade is not in the approved reference list'
FROM staging.AcademicPerformance ap
LEFT JOIN reference.FinalGrade fg
    ON ap.FinalGrade = fg.FinalGrade
WHERE fg.FinalGrade IS NULL;


INSERT INTO exceptions.AcademicPerformance (
    PerformanceID,
    StudentID,
    Term,
    CourseCode,
    CreditHoursAttempted,
    CreditHoursEarned,
    FinalGrade,
    TermGPA,
    CumulativeGPA,
    AcademicStanding,
    IssueType,
    IssueDescription
)
SELECT
    ap.PerformanceID,
    ap.StudentID,
    ap.Term,
    ap.CourseCode,
    ap.CreditHoursAttempted,
    ap.CreditHoursEarned,
    ap.FinalGrade,
    ap.TermGPA,
    ap.CumulativeGPA,
    ap.AcademicStanding,
    'Invalid GPA',
    'TermGPA or CumulativeGPA must be between 0.00 and 4.00'
FROM staging.AcademicPerformance ap
WHERE TRY_CONVERT(decimal(4,2), ap.TermGPA) IS NULL
   OR TRY_CONVERT(decimal(4,2), ap.TermGPA) < 0
   OR TRY_CONVERT(decimal(4,2), ap.TermGPA) > 4
   OR TRY_CONVERT(decimal(4,2), ap.CumulativeGPA) IS NULL
   OR TRY_CONVERT(decimal(4,2), ap.CumulativeGPA) < 0
   OR TRY_CONVERT(decimal(4,2), ap.CumulativeGPA) > 4;


INSERT INTO exceptions.AcademicPerformance (
    PerformanceID,
    StudentID,
    Term,
    CourseCode,
    CreditHoursAttempted,
    CreditHoursEarned,
    FinalGrade,
    TermGPA,
    CumulativeGPA,
    AcademicStanding,
    IssueType,
    IssueDescription
)
SELECT
    ap.PerformanceID,
    ap.StudentID,
    ap.Term,
    ap.CourseCode,
    ap.CreditHoursAttempted,
    ap.CreditHoursEarned,
    ap.FinalGrade,
    ap.TermGPA,
    ap.CumulativeGPA,
    ap.AcademicStanding,
    'Invalid Credit Hours',
    'CreditHoursAttempted or CreditHoursEarned is missing, non-numeric, negative, or CreditHoursEarned exceeds CreditHoursAttempted'
FROM staging.AcademicPerformance ap
WHERE TRY_CONVERT(int, ap.CreditHoursAttempted) IS NULL
   OR TRY_CONVERT(int, ap.CreditHoursEarned) IS NULL
   OR TRY_CONVERT(int, ap.CreditHoursAttempted) < 0
   OR TRY_CONVERT(int, ap.CreditHoursEarned) < 0
   OR TRY_CONVERT(int, ap.CreditHoursEarned) > TRY_CONVERT(int, ap.CreditHoursAttempted);


INSERT INTO exceptions.AcademicPerformance (
    PerformanceID,
    StudentID,
    Term,
    CourseCode,
    CreditHoursAttempted,
    CreditHoursEarned,
    FinalGrade,
    TermGPA,
    CumulativeGPA,
    AcademicStanding,
    IssueType,
    IssueDescription
)
SELECT
    ap.PerformanceID,
    ap.StudentID,
    ap.Term,
    ap.CourseCode,
    ap.CreditHoursAttempted,
    ap.CreditHoursEarned,
    ap.FinalGrade,
    ap.TermGPA,
    ap.CumulativeGPA,
    ap.AcademicStanding,
    'Invalid AcademicStanding',
    'AcademicStanding is not in the approved reference list'
FROM staging.AcademicPerformance ap
LEFT JOIN reference.AcademicStanding ast
    ON ap.AcademicStanding = ast.AcademicStanding
WHERE ast.AcademicStanding IS NULL;


INSERT INTO exceptions.AcademicPerformance (
    PerformanceID,
    StudentID,
    Term,
    CourseCode,
    CreditHoursAttempted,
    CreditHoursEarned,
    FinalGrade,
    TermGPA,
    CumulativeGPA,
    AcademicStanding,
    IssueType,
    IssueDescription
)
SELECT
    ap.PerformanceID,
    ap.StudentID,
    ap.Term,
    ap.CourseCode,
    ap.CreditHoursAttempted,
    ap.CreditHoursEarned,
    ap.FinalGrade,
    ap.TermGPA,
    ap.CumulativeGPA,
    ap.AcademicStanding,
    'Duplicate PerformanceID',
    'PerformanceID appears more than once in AcademicPerformance'
FROM staging.AcademicPerformance ap
WHERE ap.PerformanceID IN (
    SELECT PerformanceID
    FROM staging.AcademicPerformance
    GROUP BY PerformanceID
    HAVING COUNT(*) > 1
);


INSERT INTO audit.ValidationSummary (
    TableName,
    IssueType,
    IssueCount
)
SELECT
    'AcademicPerformance',
    IssueType,
    COUNT(*)
FROM exceptions.AcademicPerformance
GROUP BY IssueType;