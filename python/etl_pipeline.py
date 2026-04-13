import pandas as pd
import os
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

# =========================
# LOAD ENV VARIABLES
# =========================
load_dotenv()

DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

# =========================
# CREATE DB CONNECTION
# =========================
engine = create_engine(
    f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

print("✅ Connected to PostgreSQL")

# =========================
# LOAD CSV FILES
# =========================
sales = pd.read_csv("./data/raw/sales.csv")
customers = pd.read_csv("./data/raw/customers.csv")
products = pd.read_csv("./data/raw/products.csv")
stores = pd.read_csv("./data/raw/stores.csv")
calendar = pd.read_csv("./data/raw/calendar.csv")

print("✅ CSV files loaded")

# =========================
# DATA CLEANING
# =========================

# Convert date columns
sales['order_date'] = pd.to_datetime(sales['order_date'], errors='coerce')
customers['join_date'] = pd.to_datetime(customers['join_date'], errors='coerce')
calendar['date'] = pd.to_datetime(calendar['date'], errors='coerce')

# Convert loyalty_member (0/1 → True/False)
customers['loyalty_member'] = customers['loyalty_member'].astype(bool)

# Remove duplicates
sales.drop_duplicates(inplace=True)
customers.drop_duplicates(inplace=True)
products.drop_duplicates(inplace=True)
stores.drop_duplicates(inplace=True)
calendar.drop_duplicates(inplace=True)

# Drop missing values
sales.dropna(inplace=True)
customers.dropna(inplace=True)

print("✅ Data cleaned")

# =========================
# FEATURE ENGINEERING
# =========================

# Profit margin
sales['profit_margin'] = sales['profit'] / sales['revenue']

# Age segmentation
customers['age_group'] = pd.cut(
    customers['age'],
    bins=[0, 25, 40, 60, 100],
    labels=['Young', 'Adult', 'Mid-age', 'Senior']
)

print("✅ Features engineered")

# =========================
# ALIGN SALES WITH DATABASE SCHEMA
# =========================

sales = sales[[
    'order_id',
    'order_date',
    'product_id',
    'customer_id',
    'store_id',
    'quantity',
    'revenue',
    'cost',
    'profit',
    'profit_margin'
]]

# =========================
# CLEAR EXISTING DATA (SAFE RE-RUN)
# =========================

with engine.connect() as conn:
    conn.execute(text("""
        TRUNCATE TABLE sales, customers, products, stores, calendar CASCADE;
    """))
    conn.commit()

print("🧹 Existing data cleared")

# =========================
# LOAD INTO DATABASE
# =========================

try:
    # Load dimension tables first
    customers.to_sql("customers", engine, if_exists="append", index=False)
    print("✅ Customers loaded")

    products.to_sql("products", engine, if_exists="append", index=False)
    print("✅ Products loaded")

    stores.to_sql("stores", engine, if_exists="append", index=False)
    print("✅ Stores loaded")

    calendar.to_sql("calendar", engine, if_exists="append", index=False)
    print("✅ Calendar loaded")

    # Load fact table last
    sales.to_sql("sales", engine, if_exists="append", index=False)
    print("🚀 Sales loaded successfully")

except Exception as e:
    print("❌ Error during loading:", e)
