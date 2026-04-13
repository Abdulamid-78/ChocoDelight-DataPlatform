-- =========================
-- RESET (SAFE RE-RUN)
-- =========================
DROP VIEW IF EXISTS revenue_by_product CASCADE;
DROP VIEW IF EXISTS revenue_by_region CASCADE;
DROP VIEW IF EXISTS monthly_trend CASCADE;
DROP VIEW IF EXISTS revenue_segments CASCADE;
DROP VIEW IF EXISTS customer_value CASCADE;
DROP VIEW IF EXISTS revenue_outliers CASCADE;

DROP TABLE IF EXISTS sales CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS stores CASCADE;
DROP TABLE IF EXISTS calendar CASCADE;

-- =========================
-- DIMENSION TABLES
-- =========================

CREATE TABLE customers (
    customer_id VARCHAR PRIMARY KEY,
    age INT,
    gender VARCHAR(10),
    loyalty_member BOOLEAN,
    join_date DATE,
    age_group VARCHAR(20)
);

CREATE TABLE products (
    product_id VARCHAR PRIMARY KEY,
    product_name VARCHAR,
    brand VARCHAR,
    category VARCHAR,
    cocoa_percent INT,
    weight_g INT
);

CREATE TABLE stores (
    store_id VARCHAR PRIMARY KEY,
    store_name VARCHAR,
    city VARCHAR,
    country VARCHAR,
    store_type VARCHAR
);

CREATE TABLE calendar (
    date DATE PRIMARY KEY,
    year INT,
    month INT,
    day INT,
    week INT,
    day_of_week INT
);

-- =========================
-- FACT TABLE
-- =========================

CREATE TABLE sales (
    order_id VARCHAR PRIMARY KEY,
    order_date DATE REFERENCES calendar(date),
    product_id VARCHAR REFERENCES products(product_id),
    customer_id VARCHAR REFERENCES customers(customer_id),
    store_id VARCHAR REFERENCES stores(store_id),
    quantity INT CHECK (quantity > 0),
    revenue NUMERIC(10,2),
    cost NUMERIC(10,2),
    profit NUMERIC(10,2),
    profit_margin NUMERIC(10,4)
);

-- =========================
-- INDEXING
-- =========================

CREATE INDEX idx_sales_date ON sales(order_date);
CREATE INDEX idx_sales_product ON sales(product_id);
CREATE INDEX idx_sales_customer ON sales(customer_id);
CREATE INDEX idx_sales_store ON sales(store_id);

-- =========================
-- ANALYTICS VIEWS
-- =========================

CREATE VIEW revenue_by_product AS
SELECT p.product_name, SUM(s.revenue) AS total_revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

CREATE VIEW revenue_by_region AS
SELECT st.country, st.city, SUM(s.revenue) AS total_revenue
FROM sales s
JOIN stores st ON s.store_id = st.store_id
GROUP BY st.country, st.city
ORDER BY total_revenue DESC;

CREATE VIEW monthly_trend AS
SELECT c.year, c.month, SUM(s.revenue) AS total_revenue
FROM sales s
JOIN calendar c ON s.order_date = c.date
GROUP BY c.year, c.month
ORDER BY c.year, c.month;

CREATE VIEW revenue_segments AS
SELECT 
    order_id,
    revenue,
    CASE 
        WHEN revenue < 20 THEN 'Low'
        WHEN revenue BETWEEN 20 AND 50 THEN 'Medium'
        ELSE 'High'
    END AS revenue_category
FROM sales;

CREATE VIEW customer_value AS
SELECT 
    customer_id,
    SUM(revenue) AS total_spent,
    CASE 
        WHEN SUM(revenue) < 100 THEN 'Low Value'
        WHEN SUM(revenue) BETWEEN 100 AND 500 THEN 'Medium Value'
        ELSE 'High Value'
    END AS customer_segment
FROM sales
GROUP BY customer_id;

CREATE VIEW revenue_outliers AS
SELECT *
FROM sales
WHERE revenue > (
    SELECT AVG(revenue) + 3 * STDDEV(revenue) FROM sales
);
