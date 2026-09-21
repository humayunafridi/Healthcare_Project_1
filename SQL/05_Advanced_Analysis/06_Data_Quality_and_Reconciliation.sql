/* ============================================================
   HHH 1st Project
   Advanced Analysis 06 - Data Quality & Reconciliation
   NOTE: Reconstructed from the validated project logic/results.
   ============================================================ */

USE HHH_1st_Project;
GO

/* Core record counts */
SELECT 'Patients' AS Dataset, COUNT(*) AS RecordCount
FROM dbo.stg_patients
UNION ALL
SELECT 'Encounters', COUNT(*) FROM dbo.stg_encounters
UNION ALL
SELECT 'Conditions', COUNT(*) FROM dbo.stg_conditions
UNION ALL
SELECT 'Procedures', COUNT(*) FROM dbo.stg_procedures
UNION ALL
SELECT 'Medications', COUNT(*) FROM dbo.stg_medications;
GO

/* Orphan checks */
SELECT 'Encounters without patient' AS CheckName, COUNT(*) AS IssueCount
FROM dbo.stg_encounters e
LEFT JOIN dbo.stg_patients p ON e.PATIENT = p.Id
WHERE p.Id IS NULL
UNION ALL
SELECT 'Conditions without patient', COUNT(*)
FROM dbo.stg_conditions c
LEFT JOIN dbo.stg_patients p ON c.PATIENT = p.Id
WHERE p.Id IS NULL
UNION ALL
SELECT 'Procedures without patient', COUNT(*)
FROM dbo.stg_procedures pr
LEFT JOIN dbo.stg_patients p ON pr.PATIENT = p.Id
WHERE p.Id IS NULL
UNION ALL
SELECT 'Medications without patient', COUNT(*)
FROM dbo.stg_medications m
LEFT JOIN dbo.stg_patients p ON m.PATIENT = p.Id
WHERE p.Id IS NULL;
GO

/* Encounter date-quality checks */
SELECT
    COUNT(*) AS TotalEncounters,
    SUM(CASE WHEN START IS NULL THEN 1 ELSE 0 END) AS MissingStartDate,
    SUM(CASE WHEN STOP IS NULL THEN 1 ELSE 0 END) AS MissingStopDate,
    SUM(CASE WHEN STOP IS NOT NULL AND STOP < START THEN 1 ELSE 0 END)
        AS InvalidDateOrder
FROM dbo.stg_encounters;
GO

/* Medication duration-quality checks */
SELECT
    COUNT(*) AS MedicationRecords,
    SUM(CASE WHEN STOP IS NULL THEN 1 ELSE 0 END) AS OpenEndedMedications,
    SUM(CASE WHEN STOP IS NOT NULL AND STOP < [START DATE]
             THEN 1 ELSE 0 END) AS ReversedMedicationDates
FROM dbo.stg_medications;
GO

/* Procedure cost-quality checks */
SELECT
    COUNT(*) AS ProcedureRecords,
    SUM(CASE WHEN BASE_COST IS NULL THEN 1 ELSE 0 END) AS MissingBaseCost,
    SUM(CASE WHEN BASE_COST = 0 THEN 1 ELSE 0 END) AS ZeroCostRecords,
    MIN(BASE_COST) AS MinimumBaseCost,
    MAX(BASE_COST) AS MaximumBaseCost
FROM dbo.stg_procedures;
GO

/* Healthcare-cost reconciliation */
SELECT
    CAST((SELECT SUM(TotalClaimCost)
          FROM dbo.vw_EncounterAnalysis) AS DECIMAL(18,2)) AS EncounterCost,
    CAST((SELECT SUM(TotalCost)
          FROM dbo.vw_MedicationAnalysis) AS DECIMAL(18,2)) AS MedicationCost,
    CAST((SELECT SUM(BaseCost)
          FROM dbo.vw_ProcedureAnalysis) AS DECIMAL(18,2)) AS ProcedureCost,
    CAST(
        (SELECT SUM(TotalClaimCost) FROM dbo.vw_EncounterAnalysis)
      + (SELECT SUM(TotalCost) FROM dbo.vw_MedicationAnalysis)
      + (SELECT SUM(BaseCost) FROM dbo.vw_ProcedureAnalysis)
        AS DECIMAL(18,2)
    ) AS TotalSyntheticHealthcareCost;
GO

/* Patient-level reconciliation */
SELECT
    COUNT(*) AS PatientCount,
    CAST(SUM(TotalHealthcareCost) AS DECIMAL(18,2)) AS PatientLevelTotalCost,
    CAST(AVG(TotalHealthcareCost) AS DECIMAL(18,2)) AS AveragePatientCost,
    CAST(MIN(TotalHealthcareCost) AS DECIMAL(18,2)) AS MinimumPatientCost,
    CAST(MAX(TotalHealthcareCost) AS DECIMAL(18,2)) AS MaximumPatientCost
FROM dbo.vw_PatientCostAnalysis;
GO
