-- HHH 1st Project
-- Step 6.2.6: Load unique procedure / treatment-group reference data
-- 46 unique procedure mappings

INSERT INTO dbo.ref_procedures
    (Procedure_Name, Treatment_Group)
VALUES
    (N'Total Knee Replacement', N'Orthopaedic'),
    (N'Myringotomy with Grommet Insertion', N'Ear'),
    (N'Craniotomy', N'Neurosurgery'),
    (N'Peritoneal Dialysis', N'Nephrology'),
    (N'Adenoidectomy', N'Throat'),
    (N'Vitrectomy', N'Ophthalmology'),
    (N'Cystoscopy', N'Urology'),
    (N'Pterygium Excision', N'Ophthalmology'),
    (N'Phacoemulsification Cataract Surgery', N'Ophthalmology'),
    (N'Chemotherapy Session', N'Oncology'),
    (N'Radiation Therapy', N'Oncology'),
    (N'Acute Fever & Infection Care', N'Medical Cases'),
    (N'Rhinoplasty', N'Nose'),
    (N'Kidney Failure Management', N'Nephrology'),
    (N'Tympanoplasty', N'Ear'),
    (N'Hypertension & Diabetes Management', N'Medical Cases'),
    (N'General Consultation & Management', N'Medical Cases'),
    (N'Coronary Angiography', N'Cardiology'),
    (N'Percutaneous Coronary Intervention (Stenting)', N'Cardiology'),
    (N'Lower Segment C-Section (LSCS)', N'Gynaecology'),
    (N'Normal Vaginal Delivery (NVD)', N'Gynaecology'),
    (N'Tonsillectomy', N'Throat'),
    (N'Laryngoscopy', N'Throat'),
    (N'Renal Biopsy', N'Nephrology'),
    (N'Hysterectomy', N'Gynaecology'),
    (N'Ventriculoperitoneal (VP) Shunt', N'Neurosurgery'),
    (N'Laminectomy', N'Neurosurgery'),
    (N'Stapedectomy', N'Ear'),
    (N'Mastoidectomy', N'Ear'),
    (N'Transurethral Resection of the Prostate (TURP)', N'Urology'),
    (N'Lithotripsy (Kidney Stone)', N'Urology'),
    (N'Hernia Repair', N'General Surgery'),
    (N'Electrocardiogram & Stress Testing', N'Cardiology'),
    (N'Coronary Artery Bypass Grafting (CABG)', N'Cardiac Surgery'),
    (N'Heart Valve Replacement', N'Cardiac Surgery'),
    (N'Ovarian Cystectomy', N'Gynaecology'),
    (N'Turbinate Reduction', N'Nose'),
    (N'Gastroenteritis Management', N'Medical Cases'),
    (N'Fracture Cast & Reduction', N'Orthopaedic'),
    (N'Open Reduction Internal Fixation (ORIF)', N'Orthopaedic'),
    (N'Thyroidectomy', N'Throat'),
    (N'Ureteroscopy', N'Urology'),
    (N'Echocardiogram', N'Cardiology'),
    (N'Arthroscopy', N'Orthopaedic'),
    (N'Hemodialysis', N'Nephrology'),
    (N'Abcess Drainage', N'General Surgery');

-- Verification
SELECT COUNT(*) AS ProcedureCount
FROM dbo.ref_procedures;

SELECT *
FROM dbo.ref_procedures
ORDER BY ProcedureID;