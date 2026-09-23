# Healthcare Project 01

## End-to-End Healthcare Analytics Project

**Synthea Synthetic Healthcare Data → SQL Server → Advanced SQL → Power BI → GitHub**

This project demonstrates an end-to-end healthcare analytics workflow using synthetic healthcare data generated with Synthea, transformed and analyzed in Microsoft SQL Server, and presented through a five-page Power BI dashboard.

> **Important:** The patient and clinical data used in this project are synthetic. They are not real patient records and should not be interpreted as actual healthcare statistics for Pakistan.

## Project Objectives

- Generate a realistic synthetic healthcare dataset using Synthea.
- Load large healthcare CSV files into SQL Server staging tables.
- Build reference and transformation layers for a synthetic Khyber Pakhtunkhwa/Pakistan analytical context.
- Develop reusable analytical SQL views.
- Perform advanced healthcare utilization, cost, outlier and district analysis.
- Build an interactive Power BI dashboard.
- Document the complete analytical workflow for reproducibility and portfolio presentation.

## Architecture

```text
Synthea Synthetic Data
        ↓
SQL Server Staging Layer
        ↓
KP/Pakistan Reference & Transformation Layer
        ↓
Analytical SQL Views
        ↓
Advanced SQL Analysis
        ↓
Power BI Dashboard
        ↓
GitHub Portfolio Repository
```

## Technology Stack

- Synthea
- Java / OpenJDK 17
- Microsoft SQL Server Express
- SQL
- Power BI
- PowerShell
- Visual Studio Code
- Git / GitHub

## Data

The primary synthetic population was generated with Synthea.

The project generated approximately 5,783 patient records and multiple clinical datasets including:

- Patients
- Encounters
- Conditions
- Procedures
- Medications
- Claims
- Organizations
- Providers
- Payers
- Immunizations
- Imaging studies

The project retains the original Synthea patient identifier so that clinical records remain linkable.

Synthea's default geography is Massachusetts/United States. Rather than changing the clinical event history to force a Pakistan geography, the project uses a synthetic KP/Pakistan reference layer for patient names, districts, cities and related demographic presentation.

## SQL Project Structure

```text
SQL/
├── 01_Database_Setup/
├── 02_Staging_Tables/
├── 03_Reference_Tables/
├── 04_Analytic_Views/
└── 05_Advanced_Analysis/
```

### Staging Layer

The main staging tables include:

- `stg_patients`
- `stg_encounters`
- `stg_conditions`
- `stg_procedures`
- `stg_medications`

### Reference Layer

The project includes reference tables for:

- KP locations
- Synthetic patient profiles
- Hospitals
- Procedures/treatment groups
- District population
- District-name normalization

### Analytical Views

The analytical view layer contains reusable SQL views covering:

- Patient demographics
- Healthcare visit/encounter analysis
- Conditions
- Procedures
- Medications
- Patient utilization
- Patient healthcare cost
- District cost and utilization
- Power BI reporting datasets
- Data quality

### Advanced Analysis

Advanced SQL analysis covers:

- Cost concentration
- High-cost patients
- Cost-component contribution
- Patient cost outliers
- District priority analysis
- Data-quality and cost reconciliation

## Healthcare Cost Definition

The project's synthetic healthcare cost is defined as:

```text
Total Healthcare Cost
= Encounter TOTAL_CLAIM_COST
+ Medication TOTALCOST
+ Procedure BASE_COST
```

The validated project totals are approximately:

| Component | Cost |
|---|---:|
| Healthcare visits/encounters | Rs 880.01M |
| Medications | Rs 809.42M |
| Procedures | Rs 860.58M |
| **Total synthetic healthcare cost** | **Rs 2.55B** |

These values are synthetic analytical outputs and are not real Pakistani healthcare expenditure.

## Key Analytical Findings

The completed analysis identified several portfolio-level findings, including:

- 5,783 synthetic patients.
- 355,745 healthcare visits/encounters.
- Overall synthetic healthcare cost of approximately Rs 2.55 billion.
- Average synthetic healthcare cost per patient of approximately Rs 440.95K.
- 476 IQR-based high-cost patient outliers.
- The top 10% of patients account for approximately 57.29% of total synthetic healthcare cost.
- Senior patients account for the largest share of total synthetic healthcare cost in the completed analysis.
- Healthcare visit, medication and procedure costs each contribute roughly one-third of total synthetic cost.

## Power BI Dashboard

The dashboard contains five pages:

1. **Executive Summary**
2. **Healthcare Visits & Utilization**
3. **Healthcare Cost Analysis**
4. **High-Cost & Outlier Analysis**
5. **Patient & Demographic Analysis**

The dashboard includes KPI cards, healthcare visit distributions, cost-component analysis, age/gender analysis, district analysis, utilization rates and outlier analysis.

## Data Quality

The project includes explicit data-quality checks for:

- Orphan clinical records
- Invalid date sequences
- Missing/open-ended medication stop dates
- Reversed medication dates
- Zero-cost procedures
- Patient-level and component-level cost reconciliation

One observed Synthea-derived data-quality issue is a patient profile whose date of birth predates the corresponding admission timeline in the synthetic reference data. Such anomalies are documented rather than silently changed.

## Reproducibility

The project separates:

- Raw/generated source data
- SQL staging
- Reference data
- Analytical views
- Advanced analysis
- Power BI presentation

Large generated Synthea data, CSV/TSV files and SQL Server backup/database files are excluded from GitHub through `.gitignore`.

## Portfolio Skills Demonstrated

- Healthcare data analytics
- SQL Server
- Advanced SQL
- Data modeling
- Data quality and reconciliation
- KPI development
- Outlier analysis
- District-level normalization
- Power BI
- Dashboard design
- Synthetic-data analysis
- Git/GitHub project organization

## Disclaimer

This is an educational/portfolio analytics project using synthetic data. It does not contain real patient records and should not be used for clinical, operational, financial or public-health decision making.
