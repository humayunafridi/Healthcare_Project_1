# GitHub Publishing Guide — HHH 1st Project

## 1. Purpose

This guide documents the process for publishing the HHH 1st Project from the local Windows project folder to GitHub.

## 2. Local Project Folder

```text
D:\HHH 1st Project
```

The project contains SQL, Power BI and documentation assets.

## 3. Git Concepts

- **Git** — local version-control system.
- **GitHub** — online hosting and portfolio platform.
- **Repository** — the Git-tracked project.
- **Commit** — a saved version/checkpoint.
- **Staging** — selecting files for the next commit.
- **Push** — uploading local commits to GitHub.
- **`.gitignore`** — tells Git which files should not be tracked.
- **Remote/origin** — the name used for the GitHub repository.
- **main** — the primary branch.

## 4. Files Intentionally Excluded

The project generates large files that should not be placed in the repository:

- `Synthea/`
- CSV files
- TSV files
- SQL Server database/backup files
- Power BI temporary/cache files

The `.gitignore` file contains the corresponding rules.

## 5. Repository

The intended GitHub repository is:

`humayunafridi/HHH-1st-Project`

Remote:

```text
git@github.com:humayunafridi/HHH-1st-Project.git
```

## 6. Recommended Publishing Sequence

From PowerShell:

```powershell
cd "D:\HHH 1st Project"
git status
```

Review the files before staging.

Then:

```powershell
git add .
git status
```

Review the staged files carefully.

Create the first commit:

```powershell
git commit -m "Initial project setup and documentation"
```

Check the branch:

```powershell
git branch
```

Set the GitHub remote if necessary:

```powershell
git remote add origin git@github.com:humayunafridi/HHH-1st-Project.git
```

Verify:

```powershell
git remote -v
```

Finally:

```powershell
git push -u origin main
```

## 7. Important Safety Check

Before `git push`, verify:

- Synthea generated data is not staged.
- `raw data.csv` is not staged.
- SQL Server backup files are not staged.
- No credentials, passwords or private information are present.
- Only intended project files are staged.

## 8. Large Power BI File

The final PBIX is approximately 49 MB. GitHub can accept files below its 100 MB per-file limit, but GitHub may warn about files above approximately 50 MB. If the PBIX grows substantially, use Git LFS or keep the PBIX outside the repository and publish screenshots/PDF documentation instead.

## 9. Portfolio Principle

The repository should make the analytical workflow understandable to another analyst:

```text
Data generation
→ data loading
→ transformation
→ SQL analysis
→ validation
→ dashboard
→ documentation
```

The GitHub repository should not contain the large raw Synthea dataset.
