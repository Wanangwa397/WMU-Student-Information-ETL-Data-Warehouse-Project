/* Validate FinancialAid and load exception records */

INSERT INTO exceptions.FinancialAid (
    AidID,
    StudentID,
    AcademicYear,
    AidType,
    AidAmount,
    AidStatus,
    FAFSAFiled,
    PackagingDate,
    IssueType,
    IssueDescription
)
SELECT
    fa.AidID,
    fa.StudentID,
    fa.AcademicYear,
    fa.AidType,
    fa.AidAmount,
    fa.AidStatus,
    fa.FAFSAFiled,
    fa.PackagingDate,
    'Orphan StudentID',
    'StudentID does not exist in warehouse.DimStudent'
FROM staging.FinancialAid fa
LEFT JOIN warehouse.DimStudent ds
    ON fa.StudentID = ds.StudentID
WHERE ds.StudentID IS NULL;


INSERT INTO exceptions.FinancialAid (
    AidID,
    StudentID,
    AcademicYear,
    AidType,
    AidAmount,
    AidStatus,
    FAFSAFiled,
    PackagingDate,
    IssueType,
    IssueDescription
)
SELECT
    fa.AidID,
    fa.StudentID,
    fa.AcademicYear,
    fa.AidType,
    fa.AidAmount,
    fa.AidStatus,
    fa.FAFSAFiled,
    fa.PackagingDate,
    'Invalid AidType',
    'AidType is not in the approved reference list'
FROM staging.FinancialAid fa
LEFT JOIN reference.AidType at
    ON fa.AidType = at.AidType
WHERE at.AidType IS NULL;


INSERT INTO exceptions.FinancialAid (
    AidID,
    StudentID,
    AcademicYear,
    AidType,
    AidAmount,
    AidStatus,
    FAFSAFiled,
    PackagingDate,
    IssueType,
    IssueDescription
)
SELECT
    fa.AidID,
    fa.StudentID,
    fa.AcademicYear,
    fa.AidType,
    fa.AidAmount,
    fa.AidStatus,
    fa.FAFSAFiled,
    fa.PackagingDate,
    'Invalid AidAmount',
    'AidAmount must be numeric and greater than zero'
FROM staging.FinancialAid fa
WHERE TRY_CONVERT(decimal(12,2), fa.AidAmount) IS NULL
   OR TRY_CONVERT(decimal(12,2), fa.AidAmount) <= 0;


INSERT INTO exceptions.FinancialAid (
    AidID,
    StudentID,
    AcademicYear,
    AidType,
    AidAmount,
    AidStatus,
    FAFSAFiled,
    PackagingDate,
    IssueType,
    IssueDescription
)
SELECT
    fa.AidID,
    fa.StudentID,
    fa.AcademicYear,
    fa.AidType,
    fa.AidAmount,
    fa.AidStatus,
    fa.FAFSAFiled,
    fa.PackagingDate,
    'Invalid FAFSAFiled',
    'FAFSAFiled must be Yes or No'
FROM staging.FinancialAid fa
WHERE fa.FAFSAFiled NOT IN ('Yes', 'No');


INSERT INTO exceptions.FinancialAid (
    AidID,
    StudentID,
    AcademicYear,
    AidType,
    AidAmount,
    AidStatus,
    FAFSAFiled,
    PackagingDate,
    IssueType,
    IssueDescription
)
SELECT
    fa.AidID,
    fa.StudentID,
    fa.AcademicYear,
    fa.AidType,
    fa.AidAmount,
    fa.AidStatus,
    fa.FAFSAFiled,
    fa.PackagingDate,
    'Invalid PackagingDate',
    'PackagingDate is invalid or future dated'
FROM staging.FinancialAid fa
WHERE TRY_CONVERT(date, fa.PackagingDate) IS NULL
   OR TRY_CONVERT(date, fa.PackagingDate) > GETDATE();


INSERT INTO exceptions.FinancialAid (
    AidID,
    StudentID,
    AcademicYear,
    AidType,
    AidAmount,
    AidStatus,
    FAFSAFiled,
    PackagingDate,
    IssueType,
    IssueDescription
)
SELECT
    fa.AidID,
    fa.StudentID,
    fa.AcademicYear,
    fa.AidType,
    fa.AidAmount,
    fa.AidStatus,
    fa.FAFSAFiled,
    fa.PackagingDate,
    'Duplicate AidID',
    'AidID appears more than once in FinancialAid'
FROM staging.FinancialAid fa
WHERE fa.AidID IN (
    SELECT AidID
    FROM staging.FinancialAid
    GROUP BY AidID
    HAVING COUNT(*) > 1
);


INSERT INTO audit.ValidationSummary (
    TableName,
    IssueType,
    IssueCount
)
SELECT
    'FinancialAid',
    IssueType,
    COUNT(*)
FROM exceptions.FinancialAid
GROUP BY IssueType;