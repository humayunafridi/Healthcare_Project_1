/* ============================================================
   HHH 1st Project - Recovered Analytical Views
   Source: stored view definitions recovered from project records
   ============================================================ */

CREATE OR ALTER VIEW dbo.vw_DistrictCostAnalysis
AS

WITH EncounterCosts AS
(
    SELECT
        COALESCE(m.PopulationDistrict, e.District) AS StandardDistrict,
        SUM(e.TotalClaimCost) AS EncounterCost
    FROM dbo.vw_EncounterAnalysis e
    LEFT JOIN dbo.ref_district_mapping m
        ON e.District = m.ProjectDistrict
    GROUP BY
        COALESCE(m.PopulationDistrict, e.District)
),

MedicationCosts AS
(
    SELECT
        COALESCE(m.PopulationDistrict, md.District) AS StandardDistrict,
        SUM(md.TotalCost) AS MedicationCost
    FROM dbo.vw_MedicationAnalysis md
    LEFT JOIN dbo.ref_district_mapping m
        ON md.District = m.ProjectDistrict
    GROUP BY
        COALESCE(m.PopulationDistrict, md.District)
),

ProcedureCosts AS
(
    SELECT
        COALESCE(m.PopulationDistrict, pr.District) AS StandardDistrict,
        SUM(pr.BaseCost) AS ProcedureCost
    FROM dbo.vw_ProcedureAnalysis pr
    LEFT JOIN dbo.ref_district_mapping m
        ON pr.District = m.ProjectDistrict
    GROUP BY
        COALESCE(m.PopulationDistrict, pr.District)
),

CombinedDistrictCosts AS
(
    SELECT
        COALESCE(e.StandardDistrict, m.StandardDistrict, p.StandardDistrict)
            AS StandardDistrict,

        ISNULL(e.EncounterCost, 0) AS EncounterCost,
        ISNULL(m.MedicationCost, 0) AS MedicationCost,
        ISNULL(p.ProcedureCost, 0) AS ProcedureCost

    FROM EncounterCosts e

    FULL OUTER JOIN MedicationCosts m
        ON e.StandardDistrict = m.StandardDistrict

    FULL OUTER JOIN ProcedureCosts p
        ON COALESCE(e.StandardDistrict, m.StandardDistrict)
           = p.StandardDistrict
)

SELECT
    StandardDistrict,

    CAST(EncounterCost AS DECIMAL(18,2))
        AS EncounterCost,

    CAST(MedicationCost AS DECIMAL(18,2))
        AS MedicationCost,

    CAST(ProcedureCost AS DECIMAL(18,2))
        AS ProcedureCost,

    CAST(
        EncounterCost
        + MedicationCost
        + ProcedureCost
        AS DECIMAL(18,2)
    ) AS TotalSyntheticCost,

    RANK() OVER
    (
        ORDER BY
            EncounterCost
            + MedicationCost
            + ProcedureCost DESC
    ) AS CostRank,

    CAST(
        (
            EncounterCost
            + MedicationCost
            + ProcedureCost
        ) * 100.0
        /
        SUM(
            EncounterCost
            + MedicationCost
            + ProcedureCost
        ) OVER ()
        AS DECIMAL(10,2)
    ) AS CostSharePercent

FROM CombinedDistrictCosts;

GO

CREATE OR ALTER VIEW dbo.vw_DistrictCostPer100K
AS
SELECT
    d.StandardDistrict,
    p.Population2023,

    CAST(
        d.TotalSyntheticCost
        AS DECIMAL(18,2)
    ) AS TotalSyntheticCost,

    CAST(
        (
            CAST(d.TotalSyntheticCost AS FLOAT)
            / NULLIF(CAST(p.Population2023 AS FLOAT), 0)
        ) * 100000.0
        AS DECIMAL(18,2)
    ) AS SyntheticCostPer100K,

    d.CostRank,

    CAST(
        d.CostSharePercent
        AS DECIMAL(10,2)
    ) AS CostSharePercent

FROM dbo.vw_DistrictCostAnalysis d

INNER JOIN dbo.ref_kp_population p
    ON d.StandardDistrict = p.District;

GO

CREATE OR ALTER VIEW dbo.vw_DistrictCostUtilization
AS

SELECT
    u.StandardDistrict,
    u.Population2023,

    u.EncounterRecords,
    u.UniquePatients,
    u.AvgEncountersPerPatient,
    u.EncountersPer100K,
    u.PatientsPer100K,

    c.TotalSyntheticCost,
    c.SyntheticCostPer100K,
    c.CostRank,

    RANK() OVER
    (
        ORDER BY u.EncountersPer100K DESC
    ) AS UtilizationRank,

    RANK() OVER
    (
        ORDER BY c.SyntheticCostPer100K DESC
    ) AS CostPer100KRank,

    CAST(
        c.CostSharePercent
        AS DECIMAL(10,2)
    ) AS CostSharePercent

FROM dbo.vw_DistrictUtilizationPer100K u

INNER JOIN dbo.vw_DistrictCostPer100K c
    ON u.StandardDistrict = c.StandardDistrict;

GO

CREATE OR ALTER VIEW dbo.vw_DistrictCostUtilizationCategory
AS

WITH DistrictMetrics AS
(
    SELECT
        StandardDistrict,
        Population2023,
        EncounterRecords,
        UniquePatients,
        AvgEncountersPerPatient,
        EncountersPer100K,
        PatientsPer100K,
        TotalSyntheticCost,
        SyntheticCostPer100K
    FROM dbo.vw_DistrictCostUtilization
),

OverallAverages AS
(
    SELECT
        AVG(
            CAST(EncountersPer100K AS DECIMAL(38,6))
        ) AS AvgUtilizationPer100K,

        AVG(
            CAST(SyntheticCostPer100K AS DECIMAL(38,6))
        ) AS AvgCostPer100K

    FROM DistrictMetrics
)

SELECT
    d.StandardDistrict,
    d.Population2023,

    d.EncounterRecords,
    d.UniquePatients,

    d.AvgEncountersPerPatient,

    d.EncountersPer100K,
    d.PatientsPer100K,

    d.TotalSyntheticCost,
    d.SyntheticCostPer100K,

    CAST(
        a.AvgUtilizationPer100K
        AS DECIMAL(18,2)
    ) AS OverallAvgUtilizationPer100K,

    CAST(
        a.AvgCostPer100K
        AS DECIMAL(18,2)
    ) AS OverallAvgCostPer100K,

    CASE
        WHEN d.EncountersPer100K >= a.AvgUtilizationPer100K
         AND d.SyntheticCostPer100K >= a.AvgCostPer100K
            THEN 'High Utilization / High Cost'

        WHEN d.EncountersPer100K >= a.AvgUtilizationPer100K
         AND d.SyntheticCostPer100K < a.AvgCostPer100K
            THEN 'High Utilization / Low Cost'

        WHEN d.EncountersPer100K < a.AvgUtilizationPer100K
         AND d.SyntheticCostPer100K >= a.AvgCostPer100K
            THEN 'Low Utilization / High Cost'

        ELSE
            'Low Utilization / Low Cost'
    END AS DistrictCategory

FROM DistrictMetrics d

CROSS JOIN OverallAverages a;

GO

CREATE OR ALTER VIEW dbo.vw_DistrictDisorderRate
AS
SELECT
    COALESCE(m.PopulationDistrict, c.District) AS StandardDistrict,
    pop.Population2023,
    COUNT(*) AS DisorderRecords,
    COUNT(DISTINCT c.PatientID) AS UniquePatients,

    CAST(
        COUNT(*) * 100000.0
        / NULLIF(pop.Population2023, 0)
        AS DECIMAL(10,2)
    ) AS DisorderRecordsPer100K

FROM dbo.vw_ConditionAnalysis c

LEFT JOIN dbo.ref_district_mapping m
    ON c.District = m.ProjectDistrict

INNER JOIN dbo.ref_kp_population pop
    ON pop.District =
       COALESCE(m.PopulationDistrict, c.District)

WHERE c.ConditionDescription LIKE '%(disorder)%'

GROUP BY
    COALESCE(m.PopulationDistrict, c.District),
    pop.Population2023;

GO

CREATE OR ALTER VIEW dbo.vw_DistrictEncounterAnalysis
AS
SELECT
    COALESCE(mapp.PopulationDistrict, e.District) AS StandardDistrict,

    COUNT(*) AS EncounterRecords,

    COUNT(DISTINCT e.PatientID) AS UniquePatients,

    CAST(
        COUNT(*) * 1.0
        / NULLIF(COUNT(DISTINCT e.PatientID), 0)
        AS DECIMAL(10,2)
    ) AS AvgEncountersPerPatient,

    CAST(
        SUM(e.TotalClaimCost)
        AS DECIMAL(18,2)
    ) AS TotalClaimCost,

    CAST(
        SUM(e.TotalClaimCost) * 1.0
        / NULLIF(COUNT(DISTINCT e.PatientID), 0)
        AS DECIMAL(18,2)
    ) AS AvgClaimCostPerPatient

FROM dbo.vw_EncounterAnalysis e

LEFT JOIN dbo.ref_district_mapping mapp
    ON e.District = mapp.ProjectDistrict

GROUP BY
    COALESCE(mapp.PopulationDistrict, e.District);

GO

CREATE OR ALTER VIEW dbo.vw_DistrictMedicationAnalysis
AS
SELECT
    COALESCE(mapp.PopulationDistrict, m.District) AS StandardDistrict,

    COUNT(*) AS MedicationRecords,

    COUNT(DISTINCT m.PatientID) AS UniquePatients,

    CAST(
        COUNT(*) * 1.0
        / NULLIF(COUNT(DISTINCT m.PatientID), 0)
        AS DECIMAL(10,2)
    ) AS AvgMedicationRecordsPerPatient,

    CAST(
        SUM(m.TotalCost) AS DECIMAL(18,2)
    ) AS TotalMedicationCost,

    CAST(
        SUM(m.BaseCost) AS DECIMAL(18,2)
    ) AS TotalBaseCost,

    CAST(
        SUM(m.PayerCoverage) AS DECIMAL(18,2)
    ) AS TotalPayerCoverage

FROM dbo.vw_MedicationAnalysis m

LEFT JOIN dbo.ref_district_mapping mapp
    ON m.District = mapp.ProjectDistrict

GROUP BY
    COALESCE(mapp.PopulationDistrict, m.District);

GO

CREATE OR ALTER VIEW dbo.vw_DistrictUtilizationPer100K
AS

WITH DistrictUtilization AS
(
    SELECT
        COALESCE(m.PopulationDistrict, e.District) AS StandardDistrict,

        COUNT(*) AS EncounterRecords,

        COUNT(DISTINCT e.PatientID) AS UniquePatients,

        CAST(
            COUNT(*) * 1.0
            / COUNT(DISTINCT e.PatientID)
            AS DECIMAL(10,2)
        ) AS AvgEncountersPerPatient

    FROM dbo.vw_EncounterAnalysis e

    LEFT JOIN dbo.ref_district_mapping m
        ON e.District = m.ProjectDistrict

    GROUP BY
        COALESCE(m.PopulationDistrict, e.District)
)

SELECT
    u.StandardDistrict,
    p.Population2023,

    u.EncounterRecords,
    u.UniquePatients,
    u.AvgEncountersPerPatient,

    CAST(
        u.EncounterRecords * 100000.0
        / p.Population2023
        AS DECIMAL(18,2)
    ) AS EncountersPer100K,

    CAST(
        u.UniquePatients * 100000.0
        / p.Population2023
        AS DECIMAL(18,2)
    ) AS PatientsPer100K

FROM DistrictUtilization u

INNER JOIN dbo.ref_kp_population p
    ON u.StandardDistrict = p.District;

GO

