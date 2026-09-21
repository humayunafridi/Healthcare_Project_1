/* ============================================================
   HHH 1st Project
   Advanced Analysis 01 - Cost Concentration
   NOTE: Reconstructed from the validated project logic/results.
   ============================================================ */

USE HHH_1st_Project;
GO

/* Top 10% of patients by total healthcare cost */
WITH RankedPatients AS
(
    SELECT
        PatientID,
        TotalHealthcareCost,
        NTILE(10) OVER (ORDER BY TotalHealthcareCost DESC) AS CostDecile
    FROM dbo.vw_PatientCostAnalysis
),
Summary AS
(
    SELECT
        COUNT(*) AS TotalPatients,
        SUM(CASE WHEN CostDecile = 1 THEN 1 ELSE 0 END) AS Top10PercentPatients,
        SUM(CASE WHEN CostDecile = 1 THEN TotalHealthcareCost ELSE 0 END) AS Top10PercentCost,
        SUM(TotalHealthcareCost) AS TotalHealthcareCost
    FROM RankedPatients
)
SELECT
    TotalPatients,
    Top10PercentPatients,
    CAST(Top10PercentPatients * 100.0 / NULLIF(TotalPatients,0) AS DECIMAL(10,2))
        AS Top10PercentOfPatients,
    CAST(Top10PercentCost AS DECIMAL(18,2)) AS Top10PercentCost,
    CAST(TotalHealthcareCost AS DECIMAL(18,2)) AS TotalHealthcareCost,
    CAST(Top10PercentCost * 100.0 / NULLIF(TotalHealthcareCost,0) AS DECIMAL(10,2))
        AS Top10PercentCostSharePercent
FROM Summary;
GO

/* P90 threshold and high-cost population */
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
    COUNT(*) AS HighCostPatients,
    CAST(COUNT(*) * 100.0 /
         NULLIF((SELECT COUNT(*) FROM dbo.vw_PatientCostAnalysis),0)
         AS DECIMAL(10,2)) AS HighCostPatientPercent,
    CAST(SUM(p.TotalHealthcareCost) AS DECIMAL(18,2)) AS HighCostTotalCost,
    CAST(AVG(p.TotalHealthcareCost) AS DECIMAL(18,2)) AS HighCostAverageCost
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
