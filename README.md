# ChocoDelight Data Platform Optimization and Analytics

## Project Overview

This project focuses on redesigning and optimizing a chocolate sales data platform for ChocoDelight International, a premium chocolate company experiencing rapid growth.

The original dataset was stored in a flat structure, which resulted in data redundancy, poor query performance, limited analytical capability, and weak data integrity. This project transforms the system into a high-performance relational database and enables business intelligence reporting.

---

## Objectives

* Apply Second Normal Form (2NF) to eliminate redundancy
* Enforce data integrity using constraints
* Improve performance through indexing
* Develop a Python-based ETL pipeline
* Generate analytical insights using SQL views
* Implement customer and sales segmentation

---

## Data Architecture

### Data Model

The system is designed using a star schema consisting of one fact table and multiple dimension tables.

### Fact Table

* sales

  * order_id (Primary Key)
  * order_date (Foreign Key)
  * product_id (Foreign Key)
  * customer_id (Foreign Key)
  * store_id (Foreign Key)
  * quantity
  * revenue
  * cost
  * profit
  * profit_margin

### Dimension Tables

* customers
* products
* stores
* calendar

This structure improves query performance, reduces redundancy, and supports scalable analytics.

---

## Technologies Used

* PostgreSQL for database design, constraints, and indexing
* Python (Pandas, SQLAlchemy, dotenv) for ETL processes
* SQL for data modeling and analytics
* GitHub for version control and documentation

---

## ETL Pipeline

### Data Cleaning

* Removed duplicate records
* Handled missing values
* Standardized data formats
* Converted date columns to appropriate formats

### Feature Engineering

* Calculated profit margin
* Created customer age groups
* Converted loyalty indicators to boolean format

### Data Loading

* Loaded cleaned data into PostgreSQL
* Maintained referential integrity across tables
* Ensured safe re-execution using table truncation

---

## Database Optimization

### Constraints

* Primary keys for uniqueness
* Foreign keys for referential integrity
* Check constraints for data validation

### Indexing

Indexes were created on:

* order_date
* product_id
* customer_id
* store_id

These optimizations improve query performance significantly.

---

## Business Analytics

The following SQL views were created to support business insights:

* Revenue by product
* Revenue by region
* Monthly sales trends

---

## Segmentation

* Revenue categorization (low, medium, high)
* Customer value segmentation
* Outlier detection using statistical thresholds

---

## Project Structure

```
ChocoDelight_CapstoneProject2/
│
├── data/
│   └── raw/
│       ├── sales.csv
│       ├── customers.csv
│       ├── products.csv
│       ├── stores.csv
│       └── calendar.csv
│
├── python/
│   └── etl_pipeline.py
│
├── sql/
│   └── schema_final.sql
│
├── .env
├── .gitignore
└── README.md
```

---

## How to Run the Project

### Step 1: Create Database

```
psql -U postgres
CREATE DATABASE chocodelight;
```

### Step 2: Run Schema

```
psql -U postgres -d chocodelight -f sql/schema_final.sql
```

### Step 3: Configure Environment Variables

Create a `.env` file in the root directory:

```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=chocodelight
DB_USER=postgres
DB_PASSWORD=your_password
```

### Step 4: Run ETL Pipeline

```
python python/etl_pipeline.py
```

### Step 5: Verify Data

```
SELECT COUNT(*) FROM sales;
SELECT * FROM revenue_by_product LIMIT 5;
```

---

## Skills Demonstrated

* Data modeling using normalization and star schema
* SQL optimization and indexing
* ETL pipeline development
* Data cleaning and transformation
* Debugging real-world data issues
* Analytical query design

---

## Key Insights

* Identification of top-performing products
* Analysis of regional sales performance
* Customer segmentation based on spending behavior
* Detection of outliers for further investigation

---

## Future Improvements

* Integration with visualization tools such as Power BI or Tableau
* Implementation of automated workflows using Apache Airflow
* Migration to cloud data warehouses such as Snowflake or BigQuery
* Development of real-time data pipelines

---

## Author

Adekunle Abdulamid
Data Engineer | Real Estate Consultant | Tech Enthusiast

---

## Support

If you find this project useful, consider starring the repository and sharing feedback.
