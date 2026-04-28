INSERT INTO audit.ETLRun (
    RunDate,
    TableName,
    TotalRows,
    ValidRows,
    InvalidRows,
    Status
)
VALUES (
    GETDATE(),
    'Full ETL Process',

    (SELECT COUNT(*) FROM staging.StudentMaster)
    + (SELECT COUNT(*) FROM staging.StudentEnrollment)
    + (SELECT COUNT(*) FROM staging.AcademicPerformance)
    + (SELECT COUNT(*) FROM staging.FinancialAid)
    + (SELECT COUNT(*) FROM staging.StudentAttendance),

    (SELECT COUNT(*) FROM warehouse.DimStudent)
    + (SELECT COUNT(*) FROM warehouse.FactEnrollment)
    + (SELECT COUNT(*) FROM warehouse.FactAcademicPerformance)
    + (SELECT COUNT(*) FROM warehouse.FactFinancialAid)
    + (SELECT COUNT(*) FROM warehouse.FactStudentAttendance),

    (SELECT COUNT(*) FROM exceptions.StudentMaster)
    + (SELECT COUNT(*) FROM exceptions.StudentEnrollment)
    + (SELECT COUNT(*) FROM exceptions.AcademicPerformance)
    + (SELECT COUNT(*) FROM exceptions.FinancialAid)
    + (SELECT COUNT(*) FROM exceptions.StudentAttendance),

    'Success'
);