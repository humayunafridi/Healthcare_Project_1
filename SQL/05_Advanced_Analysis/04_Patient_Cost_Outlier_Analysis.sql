/* ============================================================
   HHH 1st Project
   Advanced Analysis 04 - Patient Cost Outlier Analysis
   NOTE: Reconstructed from the validated project logic/results.
   ============================================================ */

USE HHH_1st_Project;
GO

/* IQR-based patient cost outliers */
WITH Quartiles AS
(
    SELECT DISTINCT
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY TotalHealthcareCost) OVER () AS Q1,
        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY TotalHealthcareCost) OVER () AS Q3
    FROM dbo.vw_PatientCostAnalysis
),
Bounds AS
(
    SELECT
        Q1,
        Q3,
        Q3 - Q1 AS IQR,
        Q1 - (1.5 * (Q3 - Q1)) AS LowerBound,
        Q3 + (1.5 * (Q3 - Q1)) AS UpperBound
    FROM Quartiles
)
SELECT
    CAST(Q1 AS DECIMAL(18,2)) AS Q1,
    CAST(Q3 AS DECIMAL(18,2)) AS Q3,
    CAST(IQR AS DECIMAL(18,2)) AS IQR,
    CAST(LowerBound AS DECIMAL(18,2)) AS LowerBound,
    CAST(UpperBound AS DECIMAL(18,2)) AS UpperBound,
    (SELECT COUNT(*) FROM dbo.vw_PatientCostAnalysis) AS TotalPatients,
    (SELECT COUNT(*)
     FROM dbo.vw_PatientCostAnalysis p
     CROSS JOIN Bounds b
     WHERE p.TotalHealthcareCost > b.UpperBound) AS HighCostOutliers,
    CAST(
        (SELECT COUNT(*)
         FROM dbo.vw_PatientCostAnalysis p
         CROSS JOIN Bounds b
         WHERE p.TotalHealthcareCost > b.UpperBound) * 100.0
        / NULLIF((SELECT COUNT(*) FROM dbo.vw_PatientCostAnalysis),0)
        AS DECIMAL(10,2)
    ) AS OutlierRatePercent
FROM Bounds;
GO

/* Outliers by age group */
WITH Quartiles AS
(
    SELECT DISTINCT
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY TotalHealthcareCost) OVER () AS Q1,
        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY TotalHealthcareCost) OVER () AS Q3
    FROM dbo.vw_PatientCostAnalysis
),
Bounds AS
(
    SELECT Q3 + (1.5 * (Q3 - Q1)) AS UpperBound
    FROM Quartiles
)
SELECT
    p.AgeGroup,
    COUNT(*) AS Patients,
    SUM(CASE WHEN p.TotalHealthcareCost > b.UpperBound THEN 1 ELSE 0 END)
        AS HighCostOutliers,
    CAST(
        SUM(CASE WHEN p.TotalHealthcareCost > b.UpperBound THEN 1 ELSE 0 END) * 100.0
        / NULLIF(COUNT(*),0)
        AS DECIMAL(10,2)
    ) AS OutlierRatePercent,
    CAST(SUM(CASE WHEN p.TotalHealthcareCost > b.UpperBound
                 THEN p.TotalHealthcareCost ELSE 0 END)
         AS DECIMAL(18,2)) AS OutlierCost,
    CAST(AVG(CASE WHEN p.TotalHealthcareCost > b.UpperBound
                  THEN p.TotalHealthcareCost END)
         AS DECIMAL(18,2)) AS AverageOutlierCost
FROM dbo.vw_PatientCostAnalysis p
CROSS JOIN Bounds b
GROUP BY p.AgeGroup
ORDER BY OutlierRatePercent DESC;
GO

/* Top 10 districts by outlier cost */
WITH Quartiles AS
(
    SELECT DISTINCT
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY TotalHealthcareCost) OVER () AS Q1,
        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY TotalHealthcareCost) OVER () AS Q3
    FROM dbo.vw_PatientCostAnalysis
),
Bounds AS
(
    SELECT Q3 + (1.5 * (Q3 - Q1)) AS UpperBound
    FROM Quartiles
)
SELECT TOP (10)
    p.District,
    COUNT(*) AS OutlierPatients,
    CAST(SUM(p.TotalHealthcareCost) AS DECIMAL(18,2)) AS OutlierCost,
    CAST(AVG(p.TotalHealthcareCost) AS DECIMAL(18,2)) AS AverageOutlierCost
FROM dbo.vw_PatientCostAnalysis p
CROSS JOIN Bounds b
WHERE p.TotalHealthcareCost > b.UpperBound
GROUP BY p.District
ORDER BY OutlierCost DESC;
GO
