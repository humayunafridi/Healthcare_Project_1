-- HHH 1st Project
-- Step 6.3.1: Expand KP location reference table
-- Adds the remaining districts represented in ref_patient_profiles.
-- Coordinates are district/headquarter-level reference coordinates for synthetic analytics.

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Lakki Marwat'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Lakki Marwat', N'Lakki Marwat', NULL, 32.607, 70.911);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Khyber'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Khyber', N'Landi Kotal', NULL, 34.097, 71.142);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Orakzai'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Orakzai', N'Kalaya', NULL, 33.8718, 70.543);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Malakand'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Malakand', N'Batkhela', NULL, 34.6167, 71.9714);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Swabi'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Swabi', N'Swabi', NULL, 34.1247, 72.4691);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Bajaur'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Bajaur', N'Khar', NULL, 34.584, 71.93);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Hangu'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Hangu', N'Hangu', NULL, 33.5311, 71.059);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Buner'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Buner', N'Daggar', NULL, 34.3943, 72.6151);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Haripur'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Haripur', N'Haripur', NULL, 33.9978, 72.934);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Allai'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Allai', N'Allai Valley', NULL, 34.9, 72.5);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Kurram'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Kurram', N'Parachinar', NULL, 33.8997, 70.1);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Lower Dir'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Lower Dir', N'Timergara', NULL, 34.8265, 71.844);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Upper Kohistan'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Upper Kohistan', N'Dasu', NULL, 35.2917, 73.29);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Upper Swat'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Upper Swat', N'Matta', NULL, 35.0, 72.315);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Upper South Waziristan'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Upper South Waziristan', N'Ladha', NULL, 32.9, 69.55);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Lower South Waziristan'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Lower South Waziristan', N'Wana', NULL, 32.304, 69.57);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Upper Chitral'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Upper Chitral', N'Booni', NULL, 36.26, 72.18);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'North Waziristan'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'North Waziristan', N'Miranshah', NULL, 32.975, 70.065);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Lower Chitral'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Lower Chitral', N'Chitral', NULL, 35.851, 71.786);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Upper Dir'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Upper Dir', N'Dir', NULL, 35.207, 71.876);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Torghar'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Torghar', N'Judba', NULL, 34.773, 72.97);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Lower Kohistan'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Lower Kohistan', N'Pattan', NULL, 35.27, 73.55);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Battagram'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Battagram', N'Battagram', NULL, 34.678, 73.026);
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.ref_kp_locations
    WHERE District = N'Karak'
)
BEGIN
    INSERT INTO dbo.ref_kp_locations
        (District, MainCity, PostalCode, Latitude, Longitude)
    VALUES
        (N'Karak', N'Karak', NULL, 33.116, 71.093);
END;

-- Verification: total location rows
SELECT COUNT(*) AS LocationCount
FROM dbo.ref_kp_locations;

-- Verification: districts represented in patient reference data but missing from locations
SELECT DISTINCT p.District
FROM dbo.ref_patient_profiles p
LEFT JOIN dbo.ref_kp_locations l
    ON p.District = l.District
WHERE l.District IS NULL
ORDER BY p.District;