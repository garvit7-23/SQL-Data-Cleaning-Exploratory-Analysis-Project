# 📊 SQL Data Cleaning & Exploratory Analysis Project

## 📁 Project Overview

This project focuses on data cleaning and exploratory data analysis
(EDA) using SQL.\
The dataset (layoffs.csv) contains records of global layoffs across
various companies, industries, and locations.\
The project demonstrates how raw, messy data can be transformed into
structured, reliable, and insightful datasets using SQL techniques.

------------------------------------------------------------------------

## ⚙️ Tools & Technologies

-   MySQL 8.0 -- Database engine\
-   SQL Workbench -- Query execution & management\
-   CSV Dataset -- Source file (layoffs.csv)

------------------------------------------------------------------------

## 🛠️ Steps Performed

### 1. Data Staging

-   Created a staging table (`staginglayoffs`) to preserve the raw
    data.\
-   Copied all records from the original dataset into the staging table.

### 2. Removing Duplicates

-   Used `ROW_NUMBER()` with `PARTITION BY` to identify duplicate rows.\
-   Inserted cleaned data into a second staging table
    (`staginglayoffs2`).\
-   Deleted duplicate rows while retaining one unique record per group.

### 3. Standardizing Data

-   Trimmed extra spaces using `TRIM()`.\
-   Fixed inconsistent industry names (e.g., converting all `Crypto%` to
    `Crypto`).\
-   Converted the `date` column from `TEXT` to proper `DATE` format.\
-   Standardized country names (e.g., merging `United States`
    variations).

### 4. Handling Nulls & Blanks

-   Identified rows with `NULL` or blank values.\
-   Deleted rows where both `total_laid_off` and `percentage_laid_off`
    were missing.

### 5. Exploratory Data Analysis (EDA)

Performed multiple queries to extract insights:\
- Date Range of layoffs.\
- Companies with the highest layoffs.\
- Layoffs by industry, country, and stage.\
- Total funds raised vs. layoffs per company.\
- Yearly layoffs trend.\
- Rolling totals of layoffs per month.\
- Company rankings per year (Top 10 by layoffs).

------------------------------------------------------------------------

## 📊 Example Queries

**1. Find companies with the most layoffs**

``` sql
SELECT company, SUM(total_laid_off) 
FROM staginglayoffs2
GROUP BY company
ORDER BY 2 DESC;
```

**2. Rolling total of layoffs by month**

``` sql
WITH Rolling_total AS (
    SELECT SUBSTRING(`date`, 1, 7) AS per_month, SUM(total_laid_off) AS laid_off
    FROM staginglayoffs2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY per_month
)
SELECT per_month, laid_off, 
       SUM(laid_off) OVER (ORDER BY per_month) AS Rolling_total
FROM Rolling_total;
```

------------------------------------------------------------------------

## 📂 Repository Structure

    ├── layoffs.csv                         # Raw dataset
    ├── data cleaning and exploratory project.sql   # SQL script
    └── README.md                           # Project documentation

------------------------------------------------------------------------

## 🚀 How to Run

1.  Import the dataset (`layoffs.csv`) into MySQL.\
2.  Run the SQL script `data cleaning and exploratory project.sql`.\
3.  Explore the cleaned dataset using provided queries.

------------------------------------------------------------------------

## 📌 Key Learnings

-   Data cleaning is crucial before meaningful analysis.\
-   SQL window functions (`ROW_NUMBER()`, `DENSE_RANK()`) are powerful
    for deduplication and rankings.\
-   Proper date formatting and standardization improve query accuracy.\
-   Exploratory analysis helps reveal business insights like **industry
    impact**, **country trends**, and **top affected companies**.
