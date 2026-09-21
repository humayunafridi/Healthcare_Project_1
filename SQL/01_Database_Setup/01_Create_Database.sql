/* ============================================================
   HHH 1st Project
   Database Setup
   ============================================================ */

IF DB_ID('HHH_1st_Project') IS NULL
BEGIN
    CREATE DATABASE HHH_1st_Project;
END;
GO

USE HHH_1st_Project;
GO

SELECT
    DB_NAME() AS CurrentDatabase;
GO