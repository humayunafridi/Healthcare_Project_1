/* ============================================================
   HHH 1st Project
   Advanced Analysis 05 - District Priority Analysis
   NOTE: Reconstructed from the validated project logic/results.
   ============================================================ */

USE HHH_1st_Project;
GO

/* Priority is based on three district-level indicators:
   1. Encounters per 100K above the district average
   2. Synthetic cost per 100K above the district average
   3. Patient outlier rate above the district average

   Score: 3 = Critical, 2 = High, 1 = Moderate, 0 = Low.
*/
WITH DistrictBase AS
(
    SELECT
        StandardDistrict,
        Population2023,
        EncounterRecords,
        UniquePatients,
        EncountersPer100K,
        TotalSyntheticCost,
        SyntheticCostPer100K
    FROM dbo.vw_DistrictCostUtilization
),
OutlierBounds AS
(
    SELECT DISTINCT
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY TotalHealthcareCost) OVER () AS Q1,
        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY TotalHealthcareCost) OVER () AS Q3
    FROM dbo.vw_PatientCostAnalysis
),
DistrictOutliers AS
(
    SELECT
        COALESCE(m.PopulationDistrict, p.District) AS StandardDistrict,
        COUNT(*) AS Patients,
        SUM(CASE
                WHEN p.TotalHealthcareCost >
                     (b.Q3 + (1.5 * (b.Q3 - b.Q1)))
                THEN 1 ELSE 0
            END) AS Outliers,
        CAST(
            SUM(CASE
                    WHEN p.TotalHealthcareCost >
                         (b.Q3 + (1.5 * (b.Q3 - b.Q1)))
                    THEN 1 ELSE 0
                END) * 100.0 / NULLIF(COUNT(*),0)
            AS DECIMAL(18,4)
        ) AS OutlierRatePercent
    FROM dbo.vw_PatientCostAnalysis p
    LEFT JOIN dbo.ref_district_mapping m
        ON p.District = m.ProjectDistrict
    CROSS JOIN OutlierBounds b
    GROUP BY COALESCE(m.PopulationDistrict, p.District)
),
Benchmarks AS
(
    SELECT
        AVG(EncountersPer100K) AS AvgEncountersPer100K,
        AVG(SyntheticCostPer100K) AS AvgCostPer100K,
        AVG(OutlierRatePercent) AS AvgOutlierRatePercent
    FROM DistrictBase d
    LEFT JOIN DistrictOutliers o
        ON d.StandardDistrict = o.StandardDistrict
),
Scored AS
(
    SELECT
        d.*,
        ISNULL(o.OutlierRatePercent,0) AS OutlierRatePercent,
        b.AvgEncountersPer100K,
        b.AvgCostPer100K,
        b.AvgOutlierRatePercent,
        CASE WHEN d.EncountersPer100K > b.AvgEncountersPer100K
             THEN 1 ELSE 0 END
        +
        CASE WHEN d.SyntheticCostPer100K > b.AvgCostPer100K
             THEN 1 ELSE 0 END
        +
        CASE WHEN ISNULL(o.OutlierRatePercent,0) > b.AvgOutlierRatePercent
             THEN 1 ELSE 0 END AS PriorityScore
    FROM DistrictBase d
    LEFT JOIN DistrictOutliers o
        ON d.StandardDistrict = o.StandardDistrict
    CROSS JOIN Benchmarks b
)
SELECT
    StandardDistrict,
    Population2023,
    EncounterRecords,
    UniquePatients,
    CAST(EncountersPer100K AS DECIMAL(18,2)) AS EncountersPer100K,
    CAST(TotalSyntheticCost AS DECIMAL(18,2)) AS TotalSyntheticCost,
    CAST(SyntheticCostPer100K AS DECIMAL(18,2)) AS SyntheticCostPer100K,
    CAST(OutlierRatePercent AS DECIMAL(10,2)) AS OutlierRatePercent,
    CAST(AvgEncountersPer100K AS DECIMAL(18,2)) AS AvgEncountersPer100K,
    CAST(AvgCostPer100K AS DECIMAL(18,2)) AS AvgCostPer100K,
    CAST(AvgOutlierRatePercent AS DECIMAL(10,2)) AS AvgOutlierRatePercent,
    PriorityScore,
    CASE PriorityScore
        WHEN 3 THEN 'Critical'
        WHEN 2 THEN 'High'
        WHEN 1 THEN 'Moderate'
        ELSE 'Low'
    END AS PriorityCategory
FROM Scored
ORDER BY PriorityScore DESC, SyntheticCostPer100K DESC;
GO

/* Existing four-quadrant district classification used in Power BI */
SELECT *
FROM dbo.vw_DistrictCostUtilizationCategory
ORDER BY StandardDistrict;
GO
