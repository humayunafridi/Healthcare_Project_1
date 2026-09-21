/* ============================================================
   HHH 1st Project
   Advanced Analysis 03 - Healthcare Cost Components
   NOTE: Reconstructed from the validated project logic/results.
   ============================================================ */

USE HHH_1st_Project;
GO

/* Authoritative cost definition:
   Encounter TOTAL_CLAIM_COST
 + Medication TOTALCOST
 + Procedure BASE_COST
*/
WITH Components AS
(
    SELECT 'Healthcare Visits' AS CostComponent,
           SUM(TotalClaimCost) AS ComponentCost
    FROM dbo.vw_EncounterAnalysis

    UNION ALL

    SELECT 'Medications',
           SUM(TotalCost)
    FROM dbo.vw_MedicationAnalysis

    UNION ALL

    SELECT 'Procedures',
           SUM(BaseCost)
    FROM dbo.vw_ProcedureAnalysis
)
SELECT
    CostComponent,
    CAST(ComponentCost AS DECIMAL(18,2)) AS ComponentCost,
    CAST(ComponentCost * 100.0 /
         NULLIF(SUM(ComponentCost) OVER (),0)
         AS DECIMAL(10,2)) AS CostSharePercent
FROM Components
ORDER BY ComponentCost DESC;
GO

/* Reconciliation */
SELECT
    CAST((SELECT SUM(TotalClaimCost) FROM dbo.vw_EncounterAnalysis)
         AS DECIMAL(18,2)) AS EncounterCost,
    CAST((SELECT SUM(TotalCost) FROM dbo.vw_MedicationAnalysis)
         AS DECIMAL(18,2)) AS MedicationCost,
    CAST((SELECT SUM(BaseCost) FROM dbo.vw_ProcedureAnalysis)
         AS DECIMAL(18,2)) AS ProcedureCost,
    CAST(
        (SELECT SUM(TotalClaimCost) FROM dbo.vw_EncounterAnalysis)
      + (SELECT SUM(TotalCost) FROM dbo.vw_MedicationAnalysis)
      + (SELECT SUM(BaseCost) FROM dbo.vw_ProcedureAnalysis)
         AS DECIMAL(18,2)
    ) AS TotalSyntheticHealthcareCost;
GO

/* Cost by age group */
SELECT
    AgeGroup,
    COUNT(*) AS Patients,
    CAST(SUM(TotalHealthcareCost) AS DECIMAL(18,2)) AS TotalHealthcareCost,
    CAST(AVG(TotalHealthcareCost) AS DECIMAL(18,2)) AS AverageCostPerPatient,
    CAST(SUM(TotalHealthcareCost) * 100.0 /
         NULLIF((SELECT SUM(TotalHealthcareCost)
                 FROM dbo.vw_PatientCostAnalysis),0)
         AS DECIMAL(10,2)) AS CostSharePercent
FROM dbo.vw_PatientCostAnalysis
GROUP BY AgeGroup
ORDER BY TotalHealthcareCost DESC;
GO
