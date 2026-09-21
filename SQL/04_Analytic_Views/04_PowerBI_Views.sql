/* ============================================================
   HHH 1st Project - Recovered Analytical Views
   Source: stored view definitions recovered from project records
   ============================================================ */

CREATE OR ALTER VIEW dbo.vw_PowerBI_CostComponents
AS

SELECT
    'Encounter' AS CostComponent,
    SUM(TotalClaimCost) AS CostAmount
FROM dbo.vw_EncounterAnalysis

UNION ALL

SELECT
    'Medication' AS CostComponent,
    SUM(TotalCost) AS CostAmount
FROM dbo.vw_MedicationAnalysis

UNION ALL

SELECT
    'Procedure' AS CostComponent,
    SUM(BaseCost) AS CostAmount
FROM dbo.vw_ProcedureAnalysis;

GO

CREATE OR ALTER VIEW dbo.vw_PowerBI_HighCostOutliersByAgeGroup
AS

WITH PatientCosts AS
(
    SELECT
        PatientID,
        AgeGroup,
        TotalHealthcareCost
    FROM dbo.vw_PatientCostAnalysis
),
Quartiles AS
(
    SELECT DISTINCT
        PERCENTILE_CONT(0.25)
        WITHIN GROUP (ORDER BY TotalHealthcareCost)
        OVER () AS Q1,

        PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY TotalHealthcareCost)
        OVER () AS Q3
    FROM PatientCosts
),
Threshold AS
(
    SELECT
        Q1,
        Q3,
        Q3 - Q1 AS IQR,
        Q3 + (1.5 * (Q3 - Q1)) AS UpperBound
    FROM Quartiles
),
ClassifiedPatients AS
(
    SELECT
        p.PatientID,
        p.AgeGroup,
        p.TotalHealthcareCost,
        CASE
            WHEN p.TotalHealthcareCost > t.UpperBound
            THEN 1
            ELSE 0
        END AS IsHighCostOutlier
    FROM PatientCosts p
    CROSS JOIN Threshold t
)
SELECT
    AgeGroup,
    COUNT(*) AS TotalPatients,
    SUM(IsHighCostOutlier) AS HighCostOutlierPatients,

    CAST(
        SUM(IsHighCostOutlier) * 100.0
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS OutlierRatePercent,

    CAST(
        SUM(
            CASE
                WHEN IsHighCostOutlier = 1
                THEN TotalHealthcareCost
                ELSE 0
            END
        )
        AS DECIMAL(18,2)
    ) AS TotalOutlierHealthcareCost

FROM ClassifiedPatients
GROUP BY
    AgeGroup;

GO

CREATE OR ALTER VIEW dbo.vw_PowerBI_KPI_Master
AS

WITH PatientKPIs AS
(
    SELECT
        COUNT(*) AS TotalPatients,

        SUM(
            CASE
                WHEN PatientStatus = 'Alive' THEN 1
                ELSE 0
            END
        ) AS AlivePatients,

        SUM(
            CASE
                WHEN PatientStatus = 'Deceased' THEN 1
                ELSE 0
            END
        ) AS DeceasedPatients,

        AVG(
            CAST(Age AS DECIMAL(18,2))
        ) AS AverageAge,

        COUNT(DISTINCT District) AS DistrictsRepresented
    FROM dbo.vw_PatientDemographics
),
EncounterKPIs AS
(
    SELECT
        COUNT(*) AS TotalEncounters,
        COUNT(DISTINCT PatientID) AS PatientsWithEncounters,

        SUM(
            CASE
                WHEN EncounterType = 'Emergency'
                THEN 1
                ELSE 0
            END
        ) AS EmergencyEncounters,

        SUM(
            CASE
                WHEN EncounterType = 'Inpatient'
                THEN 1
                ELSE 0
            END
        ) AS InpatientEncounters,

        AVG(
            CAST(EncounterDurationMinutes AS DECIMAL(18,4))
        ) AS AverageEncounterDurationMinutes,

        SUM(TotalClaimCost) AS TotalEncounterCost

    FROM dbo.vw_EncounterAnalysis
),
ConditionKPIs AS
(
    SELECT
        COUNT(*) AS TotalConditionRecords,
        COUNT(DISTINCT PatientID) AS PatientsWithConditions
    FROM dbo.vw_ConditionAnalysis
),
MedicationKPIs AS
(
    SELECT
        COUNT(*) AS TotalMedicationRecords,
        COUNT(DISTINCT PatientID) AS PatientsWithMedications,
        SUM(TotalCost) AS TotalMedicationCost
    FROM dbo.vw_MedicationAnalysis
),
ProcedureKPIs AS
(
    SELECT
        COUNT(*) AS TotalProcedureRecords,
        COUNT(DISTINCT PatientID) AS PatientsWithProcedures,
        SUM(BaseCost) AS TotalProcedureCost
    FROM dbo.vw_ProcedureAnalysis
),
CostKPIs AS
(
    SELECT
        SUM(TotalHealthcareCost) AS TotalHealthcareCost,
        AVG(TotalHealthcareCost) AS AverageHealthcareCostPerPatient
    FROM dbo.vw_PatientCostAnalysis
),
OutlierStats AS
(
    SELECT DISTINCT
        PERCENTILE_CONT(0.25)
        WITHIN GROUP
        (
            ORDER BY TotalHealthcareCost
        ) OVER () AS Q1,

        PERCENTILE_CONT(0.75)
        WITHIN GROUP
        (
            ORDER BY TotalHealthcareCost
        ) OVER () AS Q3

    FROM dbo.vw_PatientCostAnalysis
),
OutlierKPIs AS
(
    SELECT
        COUNT(*) AS HighCostOutlierPatients,
        SUM(TotalHealthcareCost) AS TotalHighCostOutlierCost
    FROM dbo.vw_PatientCostAnalysis p
    CROSS JOIN OutlierStats o
    WHERE p.TotalHealthcareCost >
          o.Q3 + (1.5 * (o.Q3 - o.Q1))
)
SELECT
    p.TotalPatients,
    p.AlivePatients,
    p.DeceasedPatients,

    CAST(
        p.AlivePatients * 100.0 /
        NULLIF(p.TotalPatients,0)
        AS DECIMAL(10,2)
    ) AS AlivePercent,

    CAST(
        p.DeceasedPatients * 100.0 /
        NULLIF(p.TotalPatients,0)
        AS DECIMAL(10,2)
    ) AS DeceasedPercent,

    CAST(
        p.AverageAge AS DECIMAL(10,2)
    ) AS AverageAge,

    p.DistrictsRepresented,

    e.TotalEncounters,
    e.PatientsWithEncounters,

    CAST(
        e.TotalEncounters * 1.0 /
        NULLIF(p.TotalPatients,0)
        AS DECIMAL(18,2)
    ) AS EncountersPerPatient,

    e.EmergencyEncounters,
    e.InpatientEncounters,

    CAST(
        e.EmergencyEncounters * 100.0 /
        NULLIF(e.TotalEncounters,0)
        AS DECIMAL(10,2)
    ) AS EmergencyEncounterRatePercent,

    CAST(
        e.AverageEncounterDurationMinutes
        AS DECIMAL(18,2)
    ) AS AverageEncounterDurationMinutes,

    c.TotalConditionRecords,
    c.PatientsWithConditions,

    CAST(
        c.PatientsWithConditions * 100.0 /
        NULLIF(p.TotalPatients,0)
        AS DECIMAL(10,2)
    ) AS ConditionPatientRatePercent,

    m.TotalMedicationRecords,
    m.PatientsWithMedications,

    CAST(
        m.PatientsWithMedications * 100.0 /
        NULLIF(p.TotalPatients,0)
        AS DECIMAL(10,2)
    ) AS MedicationPatientRatePercent,

    pr.TotalProcedureRecords,
    pr.PatientsWithProcedures,

    CAST(
        pr.PatientsWithProcedures * 100.0 /
        NULLIF(p.TotalPatients,0)
        AS DECIMAL(10,2)
    ) AS ProcedurePatientRatePercent,

    CAST(e.TotalEncounterCost AS DECIMAL(18,2))
        AS TotalEncounterCost,

    CAST(m.TotalMedicationCost AS DECIMAL(18,2))
        AS TotalMedicationCost,

    CAST(pr.TotalProcedureCost AS DECIMAL(18,2))
        AS TotalProcedureCost,

    CAST(k.TotalHealthcareCost AS DECIMAL(18,2))
        AS TotalHealthcareCost,

    CAST(k.AverageHealthcareCostPerPatient AS DECIMAL(18,2))
        AS AverageHealthcareCostPerPatient,

    o.HighCostOutlierPatients,

    CAST(
        o.HighCostOutlierPatients * 100.0 /
        NULLIF(p.TotalPatients,0)
        AS DECIMAL(10,2)
    ) AS HighCostOutlierRatePercent,

    CAST(
        o.TotalHighCostOutlierCost AS DECIMAL(18,2)
    ) AS TotalHighCostOutlierCost

FROM PatientKPIs p
CROSS JOIN EncounterKPIs e
CROSS JOIN ConditionKPIs c
CROSS JOIN MedicationKPIs m
CROSS JOIN ProcedureKPIs pr
CROSS JOIN CostKPIs k
CROSS JOIN OutlierKPIs o;

GO

