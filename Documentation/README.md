# HHH 1st Project — Documentation

This folder contains supporting documentation for the healthcare analytics portfolio project.

## Project Workflow

```text
Synthea
  ↓
SQL Server staging
  ↓
Reference/transformation layer
  ↓
Analytical SQL views
  ↓
Advanced SQL analysis
  ↓
Power BI
  ↓
GitHub
```

## Main Documentation Topics

### Data Generation

Synthea is used to generate synthetic patient and clinical records. The generated clinical identifiers are retained to preserve relationships between datasets.

### Geographic Transformation

Synthea's default U.S. geography is not treated as actual Pakistani healthcare data. A separate synthetic KP/Pakistan reference layer is used for analytical presentation.

### SQL Server

SQL Server contains staging tables, reference tables, analytical views and the advanced analysis layer.

### Power BI

Power BI consumes the analytical layer and provides the five-page healthcare analytics dashboard.

### GitHub

GitHub is used to present the project structure, SQL scripts and supporting documentation as a portfolio project.

## Important Analytical Definition

```text
Total Healthcare Cost
= Encounter TOTAL_CLAIM_COST
+ Medication TOTALCOST
+ Procedure BASE_COST
```

## Synthetic Data Disclaimer

All healthcare records and analytical values are synthetic. They do not represent real patients or actual healthcare expenditure in Khyber Pakhtunkhwa or Pakistan.
