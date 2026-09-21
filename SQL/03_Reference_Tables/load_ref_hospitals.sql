-- HHH 1st Project
-- Step 6.2.4: Load unique synthetic KP hospital reference data
-- 63 unique hospitals

INSERT INTO dbo.ref_hospitals
    (Hospital_Name, Hospital_District, Hospital_Type)
VALUES
    (N'Mansehra Healthcare Centre', N'Mansehra', N'Private'),
    (N'Lakki Marwat Medical Care', N'Lakki Marwat', N'Private'),
    (N'Khyber Medical & Diagnostic Centre', N'Khyber', N'Private'),
    (N'Cantt Medical Centre', N'Peshawar', N'Private'),
    (N'Mardan Healthcare Centre', N'Mardan', N'Private'),
    (N'Swabi Medical Complex', N'Swabi', N'Private'),
    (N'Bajaur Medical Care', N'Bajaur', N'Private'),
    (N'Bannu Government Hospital', N'Bannu', N'Public'),
    (N'Hangu Medical Center', N'Hangu', N'Private'),
    (N'Peshawar Health Centre', N'Peshawar', N'Private'),
    (N'Haripur Mecical Complex', N'Haripur', N'Private'),
    (N'Peshawar Government Hospital', N'Peshawar', N'Public'),
    (N'Kurram Medical Centre', N'Kurram', N'Private'),
    (N'Orakzai DHQ Hospital', N'Orakzai', N'Public'),
    (N'Lower Dir Specialty Hospital', N'Lower Dir', N'Private'),
    (N'DHQ Hospital Upper Kohistan', N'Upper Kohistan', N'Public'),
    (N'Miandam DHQ Hospital', N'Upper Swat', N'Public'),
    (N'Peshawar Community Hospital', N'Peshawar', N'Private'),
    (N'Peshawar Medical & Diagnostic Centre', N'Peshawar', N'Private'),
    (N'Kohat General Hospital', N'Kohat', N'Private'),
    (N'Bajaur Community Hospital', N'Bajaur', N'Private'),
    (N'Bannu Medical & Diagnostic Centre', N'Bannu', N'Private'),
    (N'Khyber DHQ Hospital', N'Khyber', N'Public'),
    (N'Wana DHQ Hospital', N'Upper South Waziristan', N'Public'),
    (N'Waziristan Medical Center', N'Lower South Waziristan', N'Private'),
    (N'DIK Medical Complex', N'Dera Ismail Khan', N'Private'),
    (N'Peshawar Healthcare Complex', N'Peshawar', N'Private'),
    (N'Hayatabad General Government Hospital', N'Peshawar', N'Public'),
    (N'Mardan Community Hospital', N'Mardan', N'Private'),
    (N'Swat Medical Care Complex', N'Swat', N'Private'),
    (N'Charsadda Shifa Center', N'Charsadda', N'Private'),
    (N'Mardan Medical Complex', N'Mardan', N'Private'),
    (N'Charsadda Medical Complex', N'Charsadda', N'Private'),
    (N'Lower Dir District Hospital', N'Lower Dir', N'Private'),
    (N'Peshawar Health Services Hospital', N'Peshawar', N'Private'),
    (N'Dera Medical Care', N'Dera Ismail Khan', N'Private'),
    (N'Kohat Medical Hospital', N'Kohat', N'Private'),
    (N'Abbottabad Medical & Diagnostic Centre', N'Abbottabad', N'Private'),
    (N'Mardan Government Hospital', N'Mardan', N'Public'),
    (N'Swabi Government Hospital', N'Swabi', N'Public'),
    (N'Swat Medical Centre', N'Swat', N'Private'),
    (N'Khyber Health Centre', N'Khyber', N'Private'),
    (N'City General Hospital', N'Peshawar', N'Private'),
    (N'DHQ Hospital, Allai', N'Allai', N'Public'),
    (N'Peshawar Specialty Hospital', N'Peshawar', N'Private'),
    (N'Mansehra General Hospital', N'Mansehra', N'Private'),
    (N'DIK Shifa Center', N'Dera Ismail Khan', N'Private'),
    (N'Mardan Medical Centre', N'Mardan', N'Private'),
    (N'Charsadda Healthcare Centre', N'Charsadda', N'Private'),
    (N'Swabi Health Care Centre', N'Swabi', N'Private'),
    (N'Wana Medical Complex', N'Upper South Waziristan', N'Private'),
    (N'Swabi Health Complex', N'Swabi', N'Private'),
    (N'Saidu Government General Hospital', N'Swat', N'Public'),
    (N'Mardan Specialty Hospital', N'Mardan', N'Private'),
    (N'Bajaur Health Services Hospital', N'Bajaur', N'Private'),
    (N'Nowshera Government Hospital', N'Nowshera', N'Public'),
    (N'Abbottabad Government Hospital', N'Abbottabad', N'Public'),
    (N'Khwazakhela General Hospital', N'Upper Swat', N'Private'),
    (N'Kohat Government Hospital', N'Kohat', N'Public'),
    (N'Swabi General Hospital', N'Swabi', N'Private'),
    (N'Lakki Marwat Healthcare Centre', N'Lakki Marwat', N'Private'),
    (N'Abbottabad Medical Centre', N'Abbottabad', N'Private'),
    (N'DHQ Hospital, Upper Dir', N'Upper Dir', N'Public');

-- Verification
SELECT COUNT(*) AS HospitalCount
FROM dbo.ref_hospitals;

SELECT TOP 20 *
FROM dbo.ref_hospitals
ORDER BY HospitalID;