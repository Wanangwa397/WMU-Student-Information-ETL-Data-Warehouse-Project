INSERT INTO warehouse.FactStudentAttendance (
    AttendanceID,
    StudentKey,
    StudentID,
    Term,
    ClassesScheduled,
    ClassesAttended,
    LMSLogins,
    AdvisorMeetings,
    EngagementRisk
)
SELECT DISTINCT
    sa.AttendanceID,
    ds.StudentKey,
    sa.StudentID,
    sa.Term,
    TRY_CONVERT(int, sa.ClassesScheduled),
    TRY_CONVERT(int, sa.ClassesAttended),
    TRY_CONVERT(int, sa.LMSLogins),
    TRY_CONVERT(int, sa.AdvisorMeetings),
    sa.EngagementRisk
FROM staging.StudentAttendance sa
INNER JOIN warehouse.DimStudent ds
    ON sa.StudentID = ds.StudentID
WHERE NOT EXISTS (
    SELECT 1
    FROM exceptions.StudentAttendance ex
    WHERE ex.AttendanceID = sa.AttendanceID
);