/* ============================================================
   HHH 1st Project - Recovered Analytical Views
   Source: stored view definitions recovered from project records
   ============================================================ */

CREATE OR ALTER VIEW dbo.vw_PatientDemographics
AS
SELECT
    PatientKey,
    PatientID,

    FirstName,
    MiddleName,
    LastName,

    Gender,
    DateOfBirth,
    DeathDate,

    A.Age,

    CASE
        WHEN A.Age < 1 THEN 'Infant'
        WHEN A.Age BETWEEN 1 AND 17 THEN 'Child'
        WHEN A.Age BETWEEN 18 AND 39 THEN 'Young Adult'
        WHEN A.Age BETWEEN 40 AND 59 THEN 'Middle Age'
        ELSE 'Senior'
    END AS AgeGroup,

    District,
    City,
    Province,
    PostalCode,

    Latitude,
    Longitude,

    HealthcareExpenses,
    HealthcareCoverage,
    Income,

    CASE
        WHEN DeathDate IS NULL THEN 'Alive'
        ELSE 'Deceased'
    END AS PatientStatus

FROM dbo.dim_patient

CROSS APPLY
(
    SELECT
        DATEDIFF(
            YEAR,
            DateOfBirth,
            ISNULL(DeathDate, CAST(GETDATE() AS DATE))
        )
        -
        CASE
            WHEN DATEADD(
                YEAR,
                DATEDIFF(
                    YEAR,
                    DateOfBirth,
                    ISNULL(DeathDate, CAST(GETDATE() AS DATE))
                ),
                DateOfBirth
            )
            >
            ISNULL(DeathDate, CAST(GETDATE() AS DATE))
            THEN 1
            ELSE 0
        END AS Age
) A;

GO

CREATE OR ALTER VIEW dbo.vw_EncounterAnalysis
AS
SELECT
    e.Id AS EncounterID,

    e.PATIENT AS PatientID,

    p.PatientKey,

    p.FirstName,
    p.MiddleName,
    p.LastName,

    p.Gender,
    p.Age,
    p.AgeGroup,

    p.District,
    p.City,
    p.Province,

    e.START AS EncounterStart,
    e.STOP AS EncounterEnd,

    -- Encounter duration in minutes
    CASE
        WHEN e.STOP IS NOT NULL
             AND e.START IS NOT NULL
        THEN DATEDIFF(MINUTE, e.START, e.STOP)
        ELSE NULL
    END AS EncounterDurationMinutes,

    e.ENCOUNTERCLASS AS EncounterType,

    e.CODE AS EncounterCode,

    e.DESCRIPTION AS EncounterDescription,

    e.BASE_ENCOUNTER_COST AS BaseEncounterCost,

    e.TOTAL_CLAIM_COST AS TotalClaimCost,

    e.PAYER_COVERAGE AS PayerCoverage,

    e.REASONCODE AS ReasonCode,

    e.REASONDESCRIPTION AS ReasonDescription

FROM dbo.stg_encounters e

INNER JOIN dbo.vw_PatientDemographics p
    ON e.PATIENT = p.PatientID;

GO

CREATE OR ALTER VIEW dbo.vw_ConditionAnalysis
AS
SELECT
    c.PATIENT AS PatientID,

    p.PatientKey,

    p.FirstName,
    p.MiddleName,
    p.LastName,

    p.Gender,
    p.Age,
    p.AgeGroup,

    p.District,
    p.City,
    p.Province,

    c.ENCOUNTER AS EncounterID,

    c.START AS ConditionStart,
    c.STOP AS ConditionEnd,

    CASE
        WHEN c.STOP IS NOT NULL
             AND c.START IS NOT NULL
             AND c.STOP >= c.START
        THEN DATEDIFF(DAY, c.START, c.STOP)
        ELSE NULL
    END AS ConditionDurationDays,

    c.CODE AS ConditionCode,

    c.DESCRIPTION AS ConditionDescription

FROM dbo.stg_conditions c

INNER JOIN dbo.vw_PatientDemographics p
    ON c.PATIENT = p.PatientID;

GO

CREATE OR ALTER VIEW dbo.vw_ProcedureAnalysis
AS
SELECT
    pr.PATIENT AS PatientID,
    p.PatientKey,
    p.FirstName,
    p.MiddleName,
    p.LastName,
    p.Gender,
    p.Age,
    p.AgeGroup,
    p.District,
    p.City,
    p.Province,

    pr.ENCOUNTER AS EncounterID,

    pr.START AS ProcedureStart,
    pr.STOP AS ProcedureEnd,

    CASE
        WHEN pr.STOP IS NOT NULL
             AND pr.START IS NOT NULL
             AND pr.STOP >= pr.START
        THEN DATEDIFF(DAY, pr.START, pr.STOP)
        ELSE NULL
    END AS ProcedureDurationDays,

    pr.CODE AS ProcedureCode,
    pr.DESCRIPTION AS ProcedureDescription,

    pr.BASE_COST AS BaseCost,

    pr.REASONCODE AS ReasonCode,
    pr.REASONDESCRIPTION AS ReasonDescription

FROM dbo.stg_procedures pr

INNER JOIN dbo.vw_PatientDemographics p
    ON pr.PATIENT = p.PatientID;

GO

CREATE OR ALTER VIEW dbo.vw_MedicationAnalysis
AS
SELECT
    m.PATIENT AS PatientID,
    p.PatientKey,
    p.FirstName,
    p.MiddleName,
    p.LastName,
    p.Gender,
    p.Age,
    p.AgeGroup,
    p.District,
    p.City,
    p.Province,

    m.ENCOUNTER AS EncounterID,

    m.START AS MedicationStart,
    m.STOP AS MedicationEnd,

    CASE
        WHEN m.STOP IS NULL THEN 'Active / No Stop Date'
        WHEN m.STOP >= m.START THEN 'Completed / Stopped'
        WHEN m.STOP < m.START THEN 'Invalid Duration'
        ELSE 'Unknown'
    END AS MedicationStatus,

    CASE
        WHEN m.STOP IS NOT NULL
             AND m.STOP >= m.START
        THEN DATEDIFF(DAY, m.START, m.STOP)
        ELSE NULL
    END AS MedicationDurationDays,

    m.CODE AS MedicationCode,
    m.DESCRIPTION AS MedicationDescription,

    m.BASE_COST AS BaseCost,
    m.PAYER_COVERAGE AS PayerCoverage,
    m.DISPENSES AS Dispenses,
    m.TOTALCOST AS TotalCost,

    m.PAYER AS PayerID,
    m.REASONCODE AS ReasonCode,
    m.REASONDESCRIPTION AS ReasonDescription

FROM dbo.stg_medications m

INNER JOIN dbo.vw_PatientDemographics p
    ON m.PATIENT = p.PatientID;

GO

