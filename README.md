# CI/CD Pipeline Evaluation for Laravel + React

## Study Description
This Zenodo reproducibility package accompanies a research study evaluating a CI/CD pipeline implementation for a full-stack system built with Laravel (backend), React (frontend), GitHub Actions, and DevContainers.

The package includes the dataset and scripts used to evaluate key delivery outcomes (DORA metrics and test coverage) before and after pipeline adoption.

## Package Contents
- `weekly_dora_metrics.csv`  
  Weekly project metrics used in the paper (Table 4 fields):
  `Week`, `Deployment_Frequency`, `Lead_Time_Days`, `Failure_Rate_Percentage`,
  `MTTR_Hours`, `PHP_Coverage`, `React_Coverage`.
- `analysis.R`  
  Reproducible analysis script for descriptive statistics, pre/post comparison, and optional Welch t-tests.
- `ci-cd.yml`  
  GitHub Actions workflow for Laravel and React CI/CD (test, build, and deploy stages).
- `.devcontainer/devcontainer.json`  
  Development container setup for Laravel 11 + React development.
- `.devcontainer/post-create.sh`  
  Post-create bootstrap script for dependency installation.

## Reproducibility Instructions
1. Clone or download this package.
2. Open the directory in a DevContainer (recommended) or a local environment with R installed.
3. Verify the dataset in `dora_metrics.csv` matches the final paper table values.
4. Run:
   ```bash
   Rscript analysis.R
   ```
5. Review console outputs for:
   - Summary statistics across all weeks
   - Pre-pipeline vs post-pipeline comparison
   - Optional t-test results for each metric

## Project Repository
- GitHub:https://github.com/HTUNLINNKHANT/CI-CD-Pipeline-Evaluation-in-a-Laravel-React-Application.git

## Zenodo DOI
- DOI: `10.5281/zenodo.19641143`

## License
This package is licensed under **CC BY 4.0**.
