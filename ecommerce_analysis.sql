
/*
====================================================
PROJECT: E-Commerce Data Analysis
TOOL: MySQL
DATASET: E-Commerce Dataset (2025)
====================================================

OBJECTIVE:
Analyze customer behaviour, sales performance,
product performance, order trends, and payment patterns.

TABLES:
1. customers
2. products
3. orders
4. order_items
5. payments

====================================================
*/


-- 1. DATA QUALITY ANALYSIS

-- Duplicate customer records
select customer_id, count(customer_id) - 1 as duplicate_records
from customers
group by customer_id
having count(customer_id) - 1 >= 1;

-- Duplicate orders
select order_id, count(order_id) from orders
group by order_id
having count(order_id) > 1;

-- Missing values in customers
select count(*) - count(customer_id) as missing_customer_id,
count(*) - count(customer_name) as missing_customer_name,
count(*) - count(city) as missing_city,
count(*) - count(state) as missing_state,
count(*) - count(signup_date) as missing_date
from customers;

-- Missing values in products
select count(*) - count(product_id) as missing_product_id,
count(*) - count(product_name) as missing_product_name,
count(*) - count(category) as missing_category,
count(*) - count(unit_price) as missing_unit_price
from products;

-- Missing values in orders
select count(*) - count(order_id) as missing_order_id,
count(*) - count(customer_id) as missing_customer_id,
count(*) - count(order_date) as missing_order_date,
count(*) - count(order_status) as missing_status,
count(*) - count(shipping_city) as missing_shipping_city
from orders;

-- Missing values in order_items
select count(*) - count(order_item_id) as missing_order_item,
count(*) - count(order_id) as missing_order_id,
count(*) - count(product_id) as missing_product_id,
count(*) - count(quantity) as missing_quantity,
count(*) - count(unit_price) as missing_unit_price
from order_items;

-- Missing values in payments
select count(*) - count(payment_id) as missing_payment_id,
count(*) - count(order_id) as missing_order_id,
count(*) - count(payment_method) as missing_payment_method,
count(*) - count(payment_status) as missing_payment_status,
count(*) - count(amount) as missing_amount
from payments;

-- Referential integrity: Orders to Customers
select order_id from orders
where customer_id not in (select customer_id from customers);

-- Referential integrity: Order Items to Products
select order_item_id from order_items
where product_id not in (select product_id from products);

-- Referential integrity: Order Items to Orders
select order_id from order_items
where order_id not in (select order_id from orders);

-- Referential integrity: Payments to Orders
select order_id from payments
where order_id not in (select order_id from orders);

-- Invalid quantity
select order_item_id from order_items
where quantity <= 0;

-- Invalid product price
select product_id from products
where unit_price <= 0;

-- Invalid order item price
select order_item_id from order_items
where unit_price <= 0;

-- Invalid payment amount
select payment_id from payments
where amount <= 0;


-- 2. ORDER ANALYSIS

-- Order status distribution
select order_status, count(order_status) as total_orders from orders
group by order_status
order by total_orders desc;

-- Orders by customer
select customer_id, count(order_id) as total_orders from orders
group by customer_id
order by total_orders desc;


-- 3. SALES AND REVENUE ANALYSIS

-- Revenue by order status
select o.order_status, sum(order_items.quantity*order_items.unit_price) as total_revenue, count(distinct(o.order_id)) as total_orders
from orders o join order_items on o.order_id=order_items.order_id
group by o.order_status
order by total_revenue desc;

-- Highest revenue-generating category
with x as 
(select p.category, sum(order_items.quantity*order_items.unit_price) as total_revenue 
from products p join order_items on p.product_id = order_items.product_id
group by p.category)
select category, total_revenue from x
where total_revenue = (select max(total_revenue) from x);

-- Revenue by individual product
select p.product_name, sum(order_items.quantity*order_items.unit_price) as total_revenue 
from products p join order_items on p.product_id = order_items.product_id
group by p.product_name
order by total_revenue desc;

-- Revenue by city
select c.city, sum(order_items.quantity*order_items.unit_price) as city_revenue from customers c join orders o on 
c.customer_id=o.customer_id join order_items on order_items.order_id = o.order_id
group by c.city
order by city_revenue desc;


-- 4. CUSTOMER ANALYSIS

-- Top 10 customers by revenue
select c.customer_id, c.customer_name, sum(order_items.quantity*order_items.unit_price) as total_revenue
from customers c join orders o on c.customer_id=o.customer_id
join order_items on o.order_id=order_items.order_id
group by c.customer_id, c.customer_name
order by total_revenue desc
limit 10;

-- Repeat vs one-time customers
with x as 
(select customer_id, count(order_id) as total_orders from orders
group by customer_id)
select case when total_orders > 1 then 'Repeat Customers'
when total_orders = 1 then 'One Time Customers' end as customer_type,
count(customer_id) as total_customers from x
group by customer_type;


-- 5. PRODUCT ANALYSIS

-- Most popular product in each category
with x as 
(select p.category, p.product_id, p.product_name, order_items.quantity from products p 
join order_items on p.product_id=order_items.product_id),
y as 
(select category, product_name, sum(quantity) over (partition by category,product_name) as total_quantity_sold from x),
z as 
(select category, product_name, total_quantity_sold, dense_rank() over (partition by category order by total_quantity_sold desc) as ranked_amount
from y)
select distinct category, product_name, total_quantity_sold from z
where ranked_amount=1;

-- Top 5 products by revenue in each category
with x as 
(select p.category, p.product_id, p.product_name, order_items.quantity, order_items.unit_price from products p 
join order_items on p.product_id=order_items.product_id),
y as 
(select category, product_name, sum(quantity*unit_price) over (partition by category,product_name) as total_amount from x),
z as 
(select category, product_name, total_amount, dense_rank() over (partition by category order by total_amount desc) as ranked_amount
from y)
select distinct category, product_name, total_amount from z
where ranked_amount <= 5;


-- 6. PAYMENT ANALYSIS

-- Revenue and transactions by payment method
select payment_method, sum(amount) as total_amount, count(payment_id) as total_transactions from payments
group by payment_method
order by total_amount desc;

-- Payment status distribution
select payment_status, count(payment_id) as total_transactions from payments
group by payment_status
order by total_transactions desc;

-- Refund analysis
select payment_status, sum(amount) as total_refunded_amount, count(payment_id) as total_refunded_transactions
from payments
where payment_status='refunded'
group by payment_status;


-- 7. MONTHLY PERFORMANCE ANALYSIS

-- Monthly order volume
select month(order_date) as month, count(order_id) as no_of_orders from orders
group by month 
order by month;

-- Monthly revenue
select month(o.order_date) as month, sum(order_items.quantity*order_items.unit_price) as total_amount
from orders o join order_items on o.order_id=order_items.order_id
group by month
order by month;

-- Monthly Average Order Value
with x as 
(select month(o.order_date) as month, sum(order_items.quantity*order_items.unit_price) as total_amount, count(distinct(order_items.order_id)) as no_of_orders
from orders o join order_items on o.order_id=order_items.order_id
group by month)
select month, (total_amount/no_of_orders) as avg_amount from x
order by month;

-- Monthly payment amount and transactions
select month(o.order_date) as month, sum(p.amount) as total_payment_amount, count(payment_id) as total_transactions
from orders o join payments p on o.order_id=p.order_id
group by month 
order by month;
