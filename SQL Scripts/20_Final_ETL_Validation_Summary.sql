SELECT 'DimStudent' AS TblName, COUNT(*) AS TotalRows
FROM warehouse.DimStudent

UNION ALL

SELECT 'FactEnrollment', COUNT(*)
FROM warehouse.FactEnrollment

UNION ALL

SELECT 'FactAcademicPerformance', COUNT(*)
FROM warehouse.FactAcademicPerformance

UNION ALL

SELECT 'FactFinancialAid', COUNT(*)
FROM warehouse.FactFinancialAid

UNION ALL

SELECT 'FactStudentAttendance', COUNT(*)
FROM warehouse.FactStudentAttendance

UNION ALL

SELECT 'StudentMaster Exceptions', COUNT(*)
FROM exceptions.StudentMaster

UNION ALL

SELECT 'StudentEnrollment Exceptions', COUNT(*)
FROM exceptions.StudentEnrollment

UNION ALL

SELECT 'AcademicPerformance Exceptions', COUNT(*)
FROM exceptions.AcademicPerformance

UNION ALL

SELECT 'FinancialAid Exceptions', COUNT(*)
FROM exceptions.FinancialAid

UNION ALL

SELECT 'StudentAttendance Exceptions', COUNT(*)
FROM exceptions.StudentAttendance;