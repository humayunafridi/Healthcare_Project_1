/* ============================================================
   HHH 1st Project
   Staging Tables
   ============================================================ */

USE HHH_1st_Project;
GO


/* ============================================================
   1. Patients
   ============================================================ */

CREATE TABLE dbo.stg_patients
(
    Id                    VARCHAR(36),
    BIRTHDATE             DATE,
    DEATHDATE             DATE NULL,
    SSN                   VARCHAR(20) NULL,
    DRIVERS               VARCHAR(30) NULL,
    PASSPORT              VARCHAR(30) NULL,
    PREFIX                VARCHAR(20) NULL,
    FIRST                 VARCHAR(100),
    MIDDLE                VARCHAR(100) NULL,
    LAST                  VARCHAR(100),
    SUFFIX                VARCHAR(20) NULL,
    MAIDEN                VARCHAR(100) NULL,
    MARITAL               VARCHAR(10) NULL,
    RACE                  VARCHAR(50) NULL,
    ETHNICITY             VARCHAR(50) NULL,
    GENDER                VARCHAR(10),
    BIRTHPLACE            VARCHAR(200) NULL,
    ADDRESS               VARCHAR(300) NULL,
    CITY                  VARCHAR(100) NULL,
    STATE                 VARCHAR(100) NULL,
    COUNTY                VARCHAR(100) NULL,
    FIPS                  VARCHAR(20) NULL,
    ZIP                   VARCHAR(20) NULL,
    LAT                   DECIMAL(10,7) NULL,
    LON                   DECIMAL(10,7) NULL,
    HEALTHCARE_EXPENSES   DECIMAL(18,2) NULL,
    HEALTHCARE_COVERAGE   DECIMAL(18,2) NULL,
    INCOME                DECIMAL(18,2) NULL
);
GO


/* ============================================================
   2. Encounters
   ============================================================ */

CREATE TABLE dbo.stg_encounters
(
    Id                    VARCHAR(36),
    [START]               DATETIME2,
    [STOP]                DATETIME2 NULL,
    PATIENT               VARCHAR(36),
    ORGANIZATION          VARCHAR(36) NULL,
    PROVIDER              VARCHAR(36) NULL,
    PAYER                 VARCHAR(36) NULL,
    ENCOUNTERCLASS        VARCHAR(50),
    CODE                  VARCHAR(50),
    DESCRIPTION           VARCHAR(500),
    BASE_ENCOUNTER_COST   DECIMAL(18,2) NULL,
    TOTAL_CLAIM_COST      DECIMAL(18,2) NULL,
    PAYER_COVERAGE        DECIMAL(18,2) NULL,
    REASONCODE            VARCHAR(50) NULL,
    REASONDESCRIPTION     VARCHAR(500) NULL
);
GO


/* ============================================================
   3. Conditions
   ============================================================ */

CREATE TABLE dbo.stg_conditions
(
    [START DATE]          DATE,
    [STOP DATE]           DATE NULL,
    PATIENT               VARCHAR(36),
    ENCOUNTER             VARCHAR(36),
    CODE                  VARCHAR(50),
    DESCRIPTION           VARCHAR(500)
);
GO


/* ============================================================
   4. Procedures
   ============================================================ */

CREATE TABLE dbo.stg_procedures
(
    [START DATE]          DATETIME2,
    [STOP DATE]           DATETIME2 NULL,
    PATIENT               VARCHAR(36),
    ENCOUNTER             VARCHAR(36),
    CODE                  VARCHAR(50),
    DESCRIPTION           VARCHAR(500),
    BASE_COST             DECIMAL(18,2) NULL,
    REASONCODE            VARCHAR(50) NULL,
    REASONDESCRIPTION     VARCHAR(500) NULL
);
GO


/* ============================================================
   5. Medications
   ============================================================ */

CREATE TABLE dbo.stg_medications
(
    [START DATE]          DATETIME2,
    [STOP]                DATETIME2 NULL,
    PATIENT               VARCHAR(36),
    PAYER                 VARCHAR(36) NULL,
    ENCOUNTER             VARCHAR(36),
    CODE                  VARCHAR(50),
    DESCRIPTION           VARCHAR(500),
    BASE_COST             DECIMAL(18,2) NULL,
    PAYER_COVERAGE        DECIMAL(18,2) NULL,
    DISPENSES             DECIMAL(18,2) NULL,
    TOTALCOST             DECIMAL(18,2) NULL,
    REASONCODE            VARCHAR(50) NULL,
    REASONDESCRIPTION     VARCHAR(500) NULL
);
GO