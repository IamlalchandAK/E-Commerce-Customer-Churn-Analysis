# 🛒 SQL Project -- E-Commerce Customer Churn Analysis

## 🔍 Project Overview

This project analyzes **customer churn in an e-commerce domain** using
SQL.\
The objective is to understand the **factors driving customer
attrition**, clean and transform raw data, and extract actionable
insights that can help businesses improve **customer retention** and
**profitability**.

It involves:\
- Designing and populating a customer churn dataset\
- Performing **data cleaning** (handling missing values, outliers,
inconsistencies)\
- Executing **data transformation** (new derived columns, renaming,
categorization)\
- Conducting **exploratory analysis** with SQL queries to identify churn
patterns

------------------------------------------------------------------------

## 📂 Project Structure

-   **`DATABASE.sql`** → Creates the database `ecomm` and defines the
    `customer_churn` table with sample data.\
-   **`Project.sql`** → Main script that covers:
    -   Data exploration\
    -   Data cleaning & imputation\
    -   Outlier treatment\
    -   Standardization of values (e.g., "CC" → "Credit Card")\
    -   Derived features (e.g., `ChurnStatus`, `ComplaintReceived`)\
    -   Exploratory analysis queries for churn patterns

------------------------------------------------------------------------

## 🛠️ Key Steps

### 1. **Data Cleaning**

-   Imputed missing values using mean/mode strategies\
-   Removed extreme outliers in distance from warehouse
    (`WarehouseToHome > 100`)\
-   Standardized inconsistent values in `PreferredPaymentMode`,
    `PreferredLoginDevice`, etc.

### 2. **Data Transformation**

-   Added new columns:
    -   `ComplaintReceived` (Yes/No)\
    -   `ChurnStatus` (Churned/Active)\
-   Dropped redundant columns (`Churn`, `Complain`)\
-   Renamed columns for clarity

### 3. **Exploratory Analysis**

Sample insights extracted using SQL queries:\
- Total churned vs. active customers\
- Average tenure & cashback of churned customers\
- Percentage of churned customers who complained\
- Gender distribution of complaints\
- City tier with highest churn (Laptop & Accessory buyers)\
- Most preferred payment mode of active customers\
- Top 3 categories with highest average cashback\
- Distance-based churn analysis (very close, close, moderate, far)\
- Returns & churn linkage using a `customer_returns` table

------------------------------------------------------------------------

## 📈 Business Value

-   Identify **who is most likely to churn** and why\
-   Detect **behavioral patterns** (complaints, payment modes, city
    tiers)\
-   Provide insights for **retention strategies** (loyalty programs,
    complaint resolution)\
-   Help businesses improve **customer lifetime value (CLV)**

------------------------------------------------------------------------

## 🚀 How to Run

1.  Run `DATABASE.sql` to create the database and load the data.\
2.  Execute `Project.sql` step by step in a SQL environment (MySQL,
    MariaDB, etc.).\
3.  Explore queries to understand customer churn behavior.

------------------------------------------------------------------------

## 📌 Future Improvements

-   Add **visualization dashboards** (Power BI/Tableau) for SQL
    insights\
-   Integrate **predictive modeling** using churn probability (via
    Python/R + SQL)\
-   Expand dataset with **real-world e-commerce data**

------------------------------------------------------------------------

👉 This project demonstrates how **SQL can be used for end-to-end data
analysis**: from cleaning and transformation to deriving meaningful
business insights.
