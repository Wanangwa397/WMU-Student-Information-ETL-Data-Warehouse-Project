INSERT INTO warehouse.FactEnrollment (
    EnrollmentID,
    StudentKey,
    StudentID,
    Term,
    AcademicYear,
    EnrollmentStatus,
    CreditHours,
    ResidencyStatus,
    Campus,
    EnrollmentDate
)
SELECT DISTINCT
    se.EnrollmentID,
    ds.StudentKey,
    se.StudentID,
    se.Term,
    TRY_CONVERT(int, se.AcademicYear),
    se.EnrollmentStatus,
    TRY_CONVERT(int, se.CreditHours),
    se.ResidencyStatus,
    se.Campus,
    TRY_CONVERT(date, se.EnrollmentDate)
FROM staging.StudentEnrollment se
INNER JOIN warehouse.DimStudent ds
    ON se.StudentID = ds.StudentID
WHERE NOT EXISTS (
    SELECT 1
    FROM exceptions.StudentEnrollment ex
    WHERE ex.EnrollmentID = se.EnrollmentID
);