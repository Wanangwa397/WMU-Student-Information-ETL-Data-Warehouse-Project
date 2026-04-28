INSERT INTO warehouse.DimStudent (
    StudentID,
    FirstName,
    LastName,
    Gender,
    DateOfBirth,
    Nationality,
    State,
    Program,
    Department,
    StudentLevel,
    AdmissionDate,
    StudentStatus
)
SELECT DISTINCT
    sm.StudentID,
    sm.FirstName,
    sm.LastName,
    sm.Gender,
    TRY_CONVERT(date, sm.DateOfBirth),
    sm.Nationality,
    sm.State,
    sm.Program,
    sm.Department,
    sm.StudentLevel,
    TRY_CONVERT(date, sm.AdmissionDate),
    sm.StudentStatus
FROM staging.StudentMaster sm
WHERE NOT EXISTS (
    SELECT 1
    FROM exceptions.StudentMaster ex
    WHERE ex.StudentID = sm.StudentID
);