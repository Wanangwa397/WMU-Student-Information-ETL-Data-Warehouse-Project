INSERT INTO warehouse.FactFinancialAid (
    AidID,
    StudentKey,
    StudentID,
    AcademicYear,
    AidType,
    AidAmount,
    AidStatus,
    FAFSAFiled,
    PackagingDate
)
SELECT DISTINCT
    fa.AidID,
    ds.StudentKey,
    fa.StudentID,
    TRY_CONVERT(int, fa.AcademicYear),
    fa.AidType,
    TRY_CONVERT(decimal(12,2), fa.AidAmount),
    fa.AidStatus,
    fa.FAFSAFiled,
    TRY_CONVERT(date, fa.PackagingDate)
FROM staging.FinancialAid fa
INNER JOIN warehouse.DimStudent ds
    ON fa.StudentID = ds.StudentID
WHERE NOT EXISTS (
    SELECT 1
    FROM exceptions.FinancialAid ex
    WHERE ex.AidID = fa.AidID
);