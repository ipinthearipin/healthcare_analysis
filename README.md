# Healthcare Patient Data Analysis

> End-to-end Patient Demographics, Insurance &amp; Registration Analysis using DuckDB and PowerBI
---

## **Project Overview**

This project focuses on cleaning, validating, analyzing, and visualizing healthcare patient data to generate meaningful insights into patient demographics, insurance providers, geographic distribution, and registration trends.

The project follows an end-to-end data analytics workflow, starting from raw data profiling and cleaning using DuckDB and SQL, followed by exploratory data analysis and visualization using Power BI.

## **Objectives**

- Identify data quality issues in the raw healthcare dataset.
- Clean and standardize inconsistent patient information.
- Validate the cleaned dataset.
- Perform exploratory data analysis (EDA).
- Analyze patient demographics and insurance distribution.
- Analyze patient registration trends.
- Build an interactive Power BI dashboard.
- Present meaningful insights from the cleaned data.

## **Dataset**

The dataset contains approximately 600 synthetic patient records.

The main attributes include:
| Category     | Attributes                 |
| ------------ | -------------------------- |
| Patient      | Patient ID, Full Name      |
| Demographics | Gender, Date of Birth, Age |
| Contact      | Phone, Email               |
| Location     | State, City, ZIP Code      |
| Insurance    | Insurance Provider         |
| Registration | Registration Date          |

## Tools & Technologies
- DuckDB — Data profiling, cleaning, and validation
- SQL — Data transformation and quality checks
- Power Query — Additional transformation and validation
- Power BI — EDA, visualization, and dashboard development
- GitHub — Project documentation and version control

## Project Workflow
```
Raw Dataset
     ↓
Data Profiling
     ↓
Data Cleaning
     ↓
Data Validation
     ↓
Exploratory Data Analysis
     ↓
Data Visualization
     ↓
Power BI Dashboard
     ↓
Insights & Conclusion
```
---
## 1. Data Cleaning
he raw dataset contained several data quality issues, including:

- Missing values
- Duplicate records
- Duplicate patient IDs
- Inconsistent gender values
- Inconsistent insurance provider names
- Inconsistent state and city formatting
- Different date formats
- Invalid date values
- Invalid email formats
- Inconsistent phone number formats
- Inconsistent ZIP code formats

### Cleaning Approach

SQL was used to standardize and transform the raw data.

Examples include:

### Gender Standardization
```
CASE
    WHEN LOWER(TRIM(gender)) IN ('m', 'male') THEN 'Male'
    WHEN LOWER(TRIM(gender)) IN ('f', 'female') THEN 'Female'
    WHEN LOWER(TRIM(gender)) IN ('o', 'other') THEN 'Other'
    ELSE NULL
END AS gender
```
### Phone Number Cleaning
```
regexp_replace(
    TRIM(phone),
    '[^0-9]',
    '',
    'g'
)
```
### Email Standardization

Inconsistent values such as:
```
gmial
gamil
hotmial
outlok
```
were standardized into their corresponding email domains.

### Date Standardization

Different date formats were converted into a consistent date format using DuckDB date parsing functions such as:
```
TRY_STRPTIME()
```
and:
```
STRFTIME()
```
## 2. Data Validation

After cleaning, validation was performed to identify remaining data quality issues.

Examples of validation checks:

### Missing Values
```
SELECT
    COUNT(*) AS total_rows,
    COUNT(date_of_birth) AS non_null_dob
FROM cleaned_patients;
```
### Duplicate Records
```
SELECT *,
       COUNT(*) AS duplicate_count
FROM cleaned_patients
GROUP BY ALL
HAVING COUNT(*) > 1;
Date Validation
```
Patients whose date of birth occurred after their registration date were treated as invalid records for age analysis.
```
Date of Birth > Registration Date
              ↓
          Invalid
              ↓
       Age = NULL
```
### Age Validation

Age values below zero were excluded from demographic analysis.

## 3. Exploratory Data Analysis

EDA was conducted to understand the characteristics and distribution of the cleaned patient data.

The analysis focused on:

### Patient Demographics
- Gender distribution
- Age distribution
- Age groups
### Geographic Distribution
- Patient distribution by state
- Patient distribution by city
### Insurance
- Insurance provider distribution
- Top insurance providers
### Registration
- Patient registrations by year

## 4. Power BI Dashboard

The cleaned dataset was imported into Power BI to create an interactive dashboard.

### Dashboard Components

**KPI Cards**
- Total Patients
- Total States
- Total Cities
- Insurance Providers
- Average Patient Age

**Visualizations**
- Patient Registrations by Year
- Patients by Gender
- Patients by Age Group
- Top 5 Insurance Providers
- Patients by State

**Filters**
- Year
- State
- Age
- Gender
- Insurance Provider

**Dashboard Preview**
![alt text](imageURL)

## 5. Key Insights

**Patient Demographics**
- The dataset contains 600 patients.
- Male patients represent a slightly larger proportion than female patients.
- The largest age group is 45–54 years.
**Insurance**
- The dataset contains 8 insurance providers.
- Medicaid, UnitedHealth, Aetna, Medicare, and BlueCross are among the top insurance providers.
**Registration**
- Patient registrations were relatively stable between 2023 and 2025.
- Registration volume decreased in 2026, although this may be influenced by the dataset's time coverage.

## Project Structure

```
healthcare-patient-analysis/
│
├── data/
│   ├── patients_easy.csv
│   └── cleaned_patients.csv
│
├── sql/
│   ├── 01_profiling.sql
│   ├── 02_cleaning.sql
│   ├── 03_validation.sql
│   └── 04_eda.sql
│
├── powerbi/
│   └── patient_analytics_dashboard.pbix
│
├── images/
│   └── patient-analytics-dashboard.png
│
└── README.md
```

