-- ================================================
-- Project 1: Brazilian E-Commerce Sales Analysis
-- Sino Safarov | github.com/sino-safarov
-- ================================================

-- 1. Create tables

CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- ================================================
-- ANALYSIS
-- ================================================

-- 2. Total number of orders
SELECT COUNT(*) AS total_orders 
FROM orders;

-- 3. Top 10 cities by number of customers
SELECT customer_city, COUNT(*) AS customers_count
FROM customers
GROUP BY customer_city
ORDER BY customers_count DESC
LIMIT 10;

-- 4. Orders by status
SELECT order_status, COUNT(*) AS count
FROM orders
GROUP BY order_status
ORDER BY count DESC;

-- 5. Average order value and total revenue
SELECT 
    ROUND(AVG(price)::numeric, 2) AS avg_price,
    ROUND(SUM(price)::numeric, 2) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders
FROM order_items;

-- 6. Top 10 product categories by revenue
SELECT 
    p.product_category_name,
    COUNT(oi.order_id) AS orders_count,
    ROUND(SUM(oi.price)::numeric, 2) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;