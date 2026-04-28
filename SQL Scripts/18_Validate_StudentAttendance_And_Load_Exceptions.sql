/* Validate StudentAttendance and load exception records */

INSERT INTO exceptions.StudentAttendance (
    AttendanceID,
    StudentID,
    Term,
    ClassesScheduled,
    ClassesAttended,
    LMSLogins,
    AdvisorMeetings,
    EngagementRisk,
    IssueType,
    IssueDescription
)
SELECT
    sa.AttendanceID,
    sa.StudentID,
    sa.Term,
    sa.ClassesScheduled,
    sa.ClassesAttended,
    sa.LMSLogins,
    sa.AdvisorMeetings,
    sa.EngagementRisk,
    'Orphan StudentID',
    'StudentID does not exist in warehouse.DimStudent'
FROM staging.StudentAttendance sa
LEFT JOIN warehouse.DimStudent ds
    ON sa.StudentID = ds.StudentID
WHERE ds.StudentID IS NULL;


INSERT INTO exceptions.StudentAttendance (
    AttendanceID,
    StudentID,
    Term,
    ClassesScheduled,
    ClassesAttended,
    LMSLogins,
    AdvisorMeetings,
    EngagementRisk,
    IssueType,
    IssueDescription
)
SELECT
    sa.AttendanceID,
    sa.StudentID,
    sa.Term,
    sa.ClassesScheduled,
    sa.ClassesAttended,
    sa.LMSLogins,
    sa.AdvisorMeetings,
    sa.EngagementRisk,
    'Invalid Term',
    'Term is not in the approved reference list'
FROM staging.StudentAttendance sa
LEFT JOIN reference.Term t
    ON sa.Term = t.Term
WHERE t.Term IS NULL;


INSERT INTO exceptions.StudentAttendance (
    AttendanceID,
    StudentID,
    Term,
    ClassesScheduled,
    ClassesAttended,
    LMSLogins,
    AdvisorMeetings,
    EngagementRisk,
    IssueType,
    IssueDescription
)
SELECT
    sa.AttendanceID,
    sa.StudentID,
    sa.Term,
    sa.ClassesScheduled,
    sa.ClassesAttended,
    sa.LMSLogins,
    sa.AdvisorMeetings,
    sa.EngagementRisk,
    'Invalid Attendance Values',
    'ClassesScheduled, ClassesAttended, LMSLogins, or AdvisorMeetings contain invalid numeric values'
FROM staging.StudentAttendance sa
WHERE TRY_CONVERT(int, sa.ClassesScheduled) IS NULL
   OR TRY_CONVERT(int, sa.ClassesAttended) IS NULL
   OR TRY_CONVERT(int, sa.LMSLogins) IS NULL
   OR TRY_CONVERT(int, sa.AdvisorMeetings) IS NULL
   OR TRY_CONVERT(int, sa.ClassesScheduled) < 0
   OR TRY_CONVERT(int, sa.ClassesAttended) < 0
   OR TRY_CONVERT(int, sa.LMSLogins) < 0
   OR TRY_CONVERT(int, sa.AdvisorMeetings) < 0
   OR TRY_CONVERT(int, sa.ClassesAttended) > TRY_CONVERT(int, sa.ClassesScheduled);


INSERT INTO exceptions.StudentAttendance (
    AttendanceID,
    StudentID,
    Term,
    ClassesScheduled,
    ClassesAttended,
    LMSLogins,
    AdvisorMeetings,
    EngagementRisk,
    IssueType,
    IssueDescription
)
SELECT
    sa.AttendanceID,
    sa.StudentID,
    sa.Term,
    sa.ClassesScheduled,
    sa.ClassesAttended,
    sa.LMSLogins,
    sa.AdvisorMeetings,
    sa.EngagementRisk,
    'Invalid EngagementRisk',
    'EngagementRisk is not in the approved reference list'
FROM staging.StudentAttendance sa
WHERE sa.EngagementRisk NOT IN ('Low', 'Medium', 'High');


INSERT INTO exceptions.StudentAttendance (
    AttendanceID,
    StudentID,
    Term,
    ClassesScheduled,
    ClassesAttended,
    LMSLogins,
    AdvisorMeetings,
    EngagementRisk,
    IssueType,
    IssueDescription
)
SELECT
    sa.AttendanceID,
    sa.StudentID,
    sa.Term,
    sa.ClassesScheduled,
    sa.ClassesAttended,
    sa.LMSLogins,
    sa.AdvisorMeetings,
    sa.EngagementRisk,
    'Duplicate AttendanceID',
    'AttendanceID appears more than once in StudentAttendance'
FROM staging.StudentAttendance sa
WHERE sa.AttendanceID IN (
    SELECT AttendanceID
    FROM staging.StudentAttendance
    GROUP BY AttendanceID
    HAVING COUNT(*) > 1
);


INSERT INTO audit.ValidationSummary (
    TableName,
    IssueType,
    IssueCount
)
SELECT
    'StudentAttendance',
    IssueType,
    COUNT(*)
FROM exceptions.StudentAttendance
GROUP BY IssueType;