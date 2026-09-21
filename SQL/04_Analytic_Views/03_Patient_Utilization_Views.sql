/* ============================================================
   HHH 1st Project - Recovered Analytical Views
   Source: stored view definitions recovered from project records
   ============================================================ */

CREATE OR ALTER VIEW dbo.vw_AgeGroupEncounterAnalysis
AS
SELECT
    AgeGroup,

    COUNT(*) AS EncounterRecords,

    COUNT(DISTINCT PatientID) AS UniquePatients,

    CAST(
        COUNT(*) * 1.0
        / NULLIF(COUNT(DISTINCT PatientID), 0)
        AS DECIMAL(10,2)
    ) AS AvgEncountersPerPatient,

    CAST(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS EncounterSharePercent,

    CAST(
        AVG(
            CAST(EncounterDurationMinutes AS DECIMAL(18,2))
        )
        AS DECIMAL(10,2)
    ) AS AvgDurationMinutes,

    CAST(
        SUM(TotalClaimCost)
        AS DECIMAL(18,2)
    ) AS TotalClaimCost,

    CAST(
        SUM(TotalClaimCost) * 1.0
        / NULLIF(COUNT(DISTINCT PatientID), 0)
        AS DECIMAL(18,2)
    ) AS AvgClaimCostPerPatient

FROM dbo.vw_EncounterAnalysis

GROUP BY AgeGroup;

GO

CREATE OR ALTER VIEW dbo.vw_AgeGroupProcedureAnalysis
AS
SELECT
    AgeGroup,

    COUNT(*) AS ProcedureRecords,

    COUNT(DISTINCT PatientID) AS UniquePatients,

    CAST(
        COUNT(*) * 1.0
        / NULLIF(COUNT(DISTINCT PatientID), 0)
        AS DECIMAL(10,2)
    ) AS AvgProceduresPerPatient,

    CAST(
        SUM(BaseCost)
        AS DECIMAL(18,2)
    ) AS TotalProcedureCost,

    CAST(
        SUM(BaseCost) * 1.0
        / NULLIF(COUNT(DISTINCT PatientID), 0)
        AS DECIMAL(18,2)
    ) AS AvgProcedureCostPerPatient

FROM dbo.vw_ProcedureAnalysis

GROUP BY AgeGroup;

GO

CREATE OR ALTER VIEW dbo.vw_EncounterTypeAnalysis
AS
SELECT
    EncounterType,

    COUNT(*) AS EncounterRecords,

    COUNT(DISTINCT PatientID) AS UniquePatients,

    CAST(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS EncounterSharePercent,

    CAST(
        AVG(
            CAST(EncounterDurationMinutes AS DECIMAL(18,2))
        )
        AS DECIMAL(10,2)
    ) AS AvgDurationMinutes,

    CAST(
        SUM(TotalClaimCost)
        AS DECIMAL(18,2)
    ) AS TotalClaimCost,

    CAST(
        AVG(
            CAST(TotalClaimCost AS DECIMAL(18,2))
        )
        AS DECIMAL(18,2)
    ) AS AvgClaimCostPerEncounter,

    CAST(
        SUM(TotalClaimCost) * 100.0
        / NULLIF(
            SUM(SUM(TotalClaimCost)) OVER (),
            0
        )
        AS DECIMAL(10,2)
    ) AS ClaimCostSharePercent

FROM dbo.vw_EncounterAnalysis

GROUP BY EncounterType;

GO

CREATE OR ALTER VIEW dbo.vw_HighUtilizationPatients
AS
SELECT
    p.PatientID,
    p.Gender,
    p.Age,
    p.AgeGroup,
    p.District,

    ISNULL(e.EncounterCount, 0) AS EncounterCount,
    ISNULL(c.ConditionCount, 0) AS ConditionCount,
    ISNULL(m.MedicationCount, 0) AS MedicationCount,
    ISNULL(pr.ProcedureCount, 0) AS ProcedureCount,

    (
        ISNULL(e.EncounterCount, 0)
        + ISNULL(c.ConditionCount, 0)
        + ISNULL(m.MedicationCount, 0)
        + ISNULL(pr.ProcedureCount, 0)
    ) AS UtilizationScore

FROM dbo.vw_PatientDemographics p

LEFT JOIN
(
    SELECT
        PatientID,
        COUNT(*) AS EncounterCount
    FROM dbo.vw_EncounterAnalysis
    GROUP BY PatientID
) e
    ON p.PatientID = e.PatientID

LEFT JOIN
(
    SELECT
        PatientID,
        COUNT(*) AS ConditionCount
    FROM dbo.vw_ConditionAnalysis
    GROUP BY PatientID
) c
    ON p.PatientID = c.PatientID

LEFT JOIN
(
    SELECT
        PatientID,
        COUNT(*) AS MedicationCount
    FROM dbo.vw_MedicationAnalysis
    GROUP BY PatientID
) m
    ON p.PatientID = m.PatientID

LEFT JOIN
(
    SELECT
        PatientID,
        COUNT(*) AS ProcedureCount
    FROM dbo.vw_ProcedureAnalysis
    GROUP BY PatientID
) pr
    ON p.PatientID = pr.PatientID;

GO

CREATE OR ALTER VIEW dbo.vw_ProcedureUtilizationAnalysis
AS
SELECT
    ProcedureDescription,

    COUNT(*) AS ProcedureRecords,

    COUNT(DISTINCT PatientID) AS UniquePatients,

    CAST(
        COUNT(*) * 1.0
        / NULLIF(COUNT(DISTINCT PatientID), 0)
        AS DECIMAL(10,2)
    ) AS AvgRecordsPerPatient,

    CAST(
        SUM(BaseCost)
        AS DECIMAL(18,2)
    ) AS TotalProcedureCost,

    CAST(
        AVG(
            CAST(BaseCost AS DECIMAL(18,2))
        )
        AS DECIMAL(18,2)
    ) AS AvgProcedureCost,

    CAST(
        SUM(BaseCost) * 1.0
        / NULLIF(COUNT(DISTINCT PatientID), 0)
        AS DECIMAL(18,2)
    ) AS AvgCostPerPatient

FROM dbo.vw_ProcedureAnalysis

GROUP BY ProcedureDescription;

GO

CREATE OR ALTER VIEW dbo.vw_UtilizationBandAnalysis
AS
SELECT
    CASE
        WHEN UtilizationScore < 100 THEN 'Low Utilization'
        WHEN UtilizationScore BETWEEN 100 AND 499 THEN 'Moderate Utilization'
        WHEN UtilizationScore BETWEEN 500 AND 999 THEN 'High Utilization'
        ELSE 'Very High Utilization'
    END AS UtilizationBand,

    COUNT(*) AS PatientCount,

    CAST(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS PatientSharePercent,

    CAST(
        AVG(CAST(UtilizationScore AS DECIMAL(18,2)))
        AS DECIMAL(10,2)
    ) AS AvgUtilizationScore

FROM dbo.vw_HighUtilizationPatients

GROUP BY
    CASE
        WHEN UtilizationScore < 100 THEN 'Low Utilization'
        WHEN UtilizationScore BETWEEN 100 AND 499 THEN 'Moderate Utilization'
        WHEN UtilizationScore BETWEEN 500 AND 999 THEN 'High Utilization'
        ELSE 'Very High Utilization'
    END;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
(24 rows affected)

GO

