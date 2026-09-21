/* ============================================================
   HHH 1st Project
   Advanced Analysis 02 - High-Cost Patient Analysis
   NOTE: Reconstructed from the validated project logic/results.
   ============================================================ */

USE HHH_1st_Project;
GO

/* P90 high-cost threshold */
WITH Threshold AS
(
    SELECT DISTINCT
        PERCENTILE_CONT(0.90)
            WITHIN GROUP (ORDER BY TotalHealthcareCost)
            OVER () AS P90Threshold
    FROM dbo.vw_PatientCostAnalysis
)
SELECT
    CAST(P90Threshold AS DECIMAL(18,2)) AS P90Threshold,
    CAST(MIN(p.TotalHealthcareCost) AS DECIMAL(18,2)) AS MinimumHighCost,
    CAST(MAX(p.TotalHealthcareCost) AS DECIMAL(18,2)) AS MaximumHighCost,
    COUNT(*) AS HighCostPatients
FROM dbo.vw_PatientCostAnalysis p
CROSS JOIN Threshold
WHERE p.TotalHealthcareCost >= Threshold.P90Threshold
GROUP BY P90Threshold;
GO

/* High-cost patients by age group */
WITH Threshold AS
(
    SELECT DISTINCT
        PERCENTILE_CONT(0.90)
            WITHIN GROUP (ORDER BY TotalHealthcareCost)
            OVER () AS P90Threshold
    FROM dbo.vw_PatientCostAnalysis
)
SELECT
    p.AgeGroup,
    COUNT(*) AS HighCostPatients,
    CAST(COUNT(*) * 100.0 /
         NULLIF((SELECT COUNT(*) FROM dbo.vw_PatientCostAnalysis),0)
         AS DECIMAL(10,2)) AS PercentOfAllPatients,
    CAST(SUM(p.TotalHealthcareCost) AS DECIMAL(18,2)) AS TotalHighCost,
    CAST(AVG(p.TotalHealthcareCost) AS DECIMAL(18,2)) AS AverageHighCost
FROM dbo.vw_PatientCostAnalysis p
CROSS JOIN Threshold
WHERE p.TotalHealthcareCost >= Threshold.P90Threshold
GROUP BY p.AgeGroup
ORDER BY TotalHighCost DESC;
GO

/* Top 20 high-cost patients */
WITH Threshold AS
(
    SELECT DISTINCT
        PERCENTILE_CONT(0.90)
            WITHIN GROUP (ORDER BY TotalHealthcareCost)
            OVER () AS P90Threshold
    FROM dbo.vw_PatientCostAnalysis
)
SELECT TOP (20)
    p.PatientID,
    p.FirstName,
    p.LastName,
    p.Gender,
    p.Age,
    p.AgeGroup,
    p.District,
    CAST(p.TotalHealthcareCost AS DECIMAL(18,2)) AS TotalHealthcareCost,
    CAST(p.TotalEncounterClaimCost AS DECIMAL(18,2)) AS TotalEncounterClaimCost,
    CAST(p.TotalMedicationCost AS DECIMAL(18,2)) AS TotalMedicationCost,
    CAST(p.TotalProcedureCost AS DECIMAL(18,2)) AS TotalProcedureCost,
    p.EncounterCount,
    p.MedicationCount,
    p.ProcedureCount
FROM dbo.vw_PatientCostAnalysis p
CROSS JOIN Threshold
WHERE p.TotalHealthcareCost >= Threshold.P90Threshold
ORDER BY p.TotalHealthcareCost DESC;
GO
