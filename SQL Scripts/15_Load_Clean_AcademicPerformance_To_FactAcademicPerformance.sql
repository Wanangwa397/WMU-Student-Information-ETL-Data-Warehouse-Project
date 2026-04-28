INSERT INTO warehouse.FactAcademicPerformance (
    PerformanceID,
    StudentKey,
    StudentID,
    CourseCode,
    Term,
    CreditHoursAttempted,
    CreditHoursEarned,
    FinalGrade,
    TermGPA,
    CumulativeGPA,
    AcademicStanding
)
SELECT DISTINCT
    ap.PerformanceID,
    ds.StudentKey,
    ap.StudentID,
    ap.CourseCode,
    ap.Term,
    TRY_CONVERT(int, ap.CreditHoursAttempted),
    TRY_CONVERT(int, ap.CreditHoursEarned),
    ap.FinalGrade,
    TRY_CONVERT(decimal(4,2), ap.TermGPA),
    TRY_CONVERT(decimal(4,2), ap.CumulativeGPA),
    ap.AcademicStanding
FROM staging.AcademicPerformance ap
INNER JOIN warehouse.DimStudent ds
    ON ap.StudentID = ds.StudentID
WHERE NOT EXISTS (
    SELECT 1
    FROM exceptions.AcademicPerformance ex
    WHERE ex.PerformanceID = ap.PerformanceID
);