/* ============================================================
   HHH 1st Project - Recovered Analytical Views
   Source: stored view definitions recovered from project records
   ============================================================ */

CREATE OR ALTER VIEW dbo.vw_DataQualitySummary
AS
SELECT
    'Orphan Encounters' AS CheckName,
    (
        SELECT COUNT(*)
        FROM dbo.stg_encounters e
        LEFT JOIN dbo.dim_patient p
            ON e.PATIENT = p.PatientID
        WHERE p.PatientID IS NULL
    ) AS IssueCount

UNION ALL

SELECT
    'Orphan Conditions',
    (
        SELECT COUNT(*)
        FROM dbo.stg_conditions c
        LEFT JOIN dbo.dim_patient p
            ON c.PATIENT = p.PatientID
        WHERE p.PatientID IS NULL
    )

UNION ALL

SELECT
    'Orphan Procedures',
    (
        SELECT COUNT(*)
        FROM dbo.stg_procedures pr
        LEFT JOIN dbo.dim_patient p
            ON pr.PATIENT = p.PatientID
        WHERE p.PatientID IS NULL
    )

UNION ALL

SELECT
    'Orphan Medications',
    (
        SELECT COUNT(*)
        FROM dbo.stg_medications m
        LEFT JOIN dbo.dim_patient p
            ON m.PATIENT = p.PatientID
        WHERE p.PatientID IS NULL
    )

UNION ALL

SELECT
    'Invalid Encounter Dates',
    (
        SELECT COUNT(*)
        FROM dbo.stg_encounters
        WHERE START IS NOT NULL
          AND STOP IS NOT NULL
          AND STOP < START
    )

UNION ALL

SELECT
    'Invalid Condition Dates',
    (
        SELECT COUNT(*)
        FROM dbo.stg_conditions
        WHERE START IS NOT NULL
          AND STOP IS NOT NULL
          AND STOP < START
    )

UNION ALL

SELECT
    'Invalid Procedure Dates',
    (
        SELECT COUNT(*)
        FROM dbo.stg_procedures
        WHERE START IS NOT NULL
          AND STOP IS NOT NULL
          AND STOP < START
    )

UNION ALL

SELECT
    'Invalid Medication Dates',
    (
        SELECT COUNT(*)
        FROM dbo.stg_medications
        WHERE START IS NOT NULL
          AND STOP IS NOT NULL
          AND STOP < START
    );

GO

