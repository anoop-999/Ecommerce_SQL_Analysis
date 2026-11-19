# E-Commerce Data Analysis using MySQL

## Project Overview
This project focuses on analyzing an e-commerce business dataset using MySQL. The objective is to identify trends in sales performance, customer behaviour, product performance, order activity, and payment patterns.

## Tools Used
- MySQL 8.4
- MySQL Workbench
- SQL

## Dataset
The dataset contains five CSV files representing different aspects of the e-commerce business:

- `customers.csv`
- `products.csv`
- `orders.csv`
- `order_items.csv`
- `payments.csv`

The dataset contains 2025 e-commerce records.

## Database Tables
1. Customers
2. Products
3. Orders
4. Order Items
5. Payments

## Analysis Performed

### 1. Data Quality Analysis
- Identified duplicate customer records.
- Checked missing values across all tables.
- Checked referential integrity between related tables.
- Identified invalid quantities and prices.

### 2. Order Analysis
- Analyzed order status distribution.
- Examined order counts by customer.

### 3. Sales and Revenue Analysis
- Analyzed revenue by order status.
- Identified the highest revenue-generating category.
- Compared revenue across products and cities.
- Ranked top customers by revenue.

### 4. Customer Analysis
- Identified the top 10 customers by revenue.
- Analyzed repeat and one-time customers.

### 5. Product Analysis
- Identified the most popular product in each category.
- Ranked the top five products by revenue within each category.

### 6. Payment Analysis
- Analyzed payment methods and transaction counts.
- Examined payment status distribution.
- Calculated refunded amounts and transactions.

### 7. Monthly Performance Analysis
- Analyzed monthly order volume.
- Tracked monthly revenue.
- Calculated monthly Average Order Value (AOV).
- Analyzed monthly payment amounts and transactions.

## Key Findings

- Total revenue recorded: ₹13,45,933.
- Total orders: 250.
- Total customers: 81 records.
- Total order items: 426.
- Total payment records: 250.
- Electronics was the highest revenue-generating category, contributing ₹7,67,970.
- Headphones generated the highest product revenue at ₹2,42,973.
- November recorded the highest monthly revenue at ₹1,82,636.
- November also recorded the highest monthly AOV at approximately ₹7,024.46.
- 66 customers were repeat customers, compared with 9 one-time customers.
- Net Banking recorded the highest payment amount at ₹3,91,333.

## Project Files
- `ecommerce_analysis.sql` – SQL queries used for data quality checks and business analysis.
- CSV files – Source dataset used for the analysis.

## Conclusion
This project demonstrates the use of SQL to perform data quality checks, join multiple tables, aggregate business data, analyze trends, and generate insights that support business decision-making.