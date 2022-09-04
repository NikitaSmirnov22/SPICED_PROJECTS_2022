-- Get the names and the quantities in stock for each product.
SELECT product_name, units_in_stock
FROM products;


-- Get a list of current products (Product ID and name).
SELECT product_id, product_name
FROM products;


-- Get a list of the most and least expensive products (name and unit price).
SELECT product_name, unit_price 
FROM Products 
WHERE unit_price > 100 OR unit_price < 5
ORDER BY unit_price DESC;


-- Get products that cost less than $20
SELECT product_name, unit_price
FROM products
WHERE unit_price < 20
ORDER BY unit_price ASC;


-- Get products that cost between $15 and $25.
SELECT product_name, unit_price
FROM products
WHERE unit_price BETWEEN 15 AND 25;


-- Get products above average price.
SELECT product_name, unit_price
FROM products
WHERE unit_price > (
    SELECT AVG(unit_price)
    FROM products
    );


-- Find the ten most expensive products.
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 10;


-- Get a list of discontinued products (Product ID and name).
SELECT product_id, product_name, discontinued
FROM products
WHERE discontinued = 1;


-- Count current and discontinued products.
SELECT discontinued, COUNT(*)
FROM products
GROUP BY discontinued;


-- Find products with less units in stock than the quantity on order.
SELECT units_in_stock, units_in_order
FROM products
WHERE units_in_stock < units_in_order;


-- Find the customer who had the highest order amount
SELECT customer_id, COUNT(*)
FROM orders
GROUP BY customer_id
ORDER BY orders DESC
LIMIT 1;


-- Get orders for a given employee and the according customer
SELECT *
FROM orders
WHERE employee_id = 1;


-- Find the hiring age of each employee
SELECT employee_id, age(hire_date, birth_date) AS "hiring_age"
FROM employees;


-- Create views for some of these queries
CREATE VIEW employee_age AS (
    SELECT employee_id, age(hire_date, birth_date) AS "hiring_age"
    FROM employees
    );


-- Create a view of all the relevant columns from all the tables
CREATE VIEW all_data AS
	(SELECT 
		categories.category_id, categories.category_name,
		products.product_id, products.product_name,products.unit_price,
		order_details.order_id, order_details.quantity,
		orders.customer_id, orders.order_date, orders.ship_country, orders.ship_city,
		customers.city, customers.country
	FROM categories
	JOIN products on products.category_id = categories.category_id
	JOIN order_details on order_details.product_id = products.product_id
	JOIN orders on orders.order_id = order_details.order_id
	JOIN customers on customers.customer_id = orders.customer_id
	);


-- Mark products as expensive of inexpensive
SELECT product_id,
CASE
	WHEN unit_price > 150 THEN 'expensive' 
	ELSE 'inexpensive' END
FROM order_details;


-- Calculate the average order value per country
SELECT 
	AVG(order_details.product_id * order_details.unit_price - order_details.discount) AS order_value,
	orders.ship_country
FROM order_details
JOIN orders on orders.order_id = order_details.order_id
GROUP BY orders.ship_country
ORDER BY order_value DESC;


-- Calculate the total order value per country
SELECT 
	SUM(order_details.product_id * order_details.unit_price - order_details.discount) AS order_value,
	orders.ship_country
FROM order_details
JOIN orders on orders.order_id = order_details.order_id
GROUP BY orders.ship_country
ORDER BY order_value DESC;


-- Calculate the average order value per customer
SELECT 
	AVG(order_details.product_id * order_details.unit_price - order_details.discount) AS order_value,
	orders.customer_id
FROM order_details
JOIN orders on orders.order_id = order_details.order_id
GROUP BY orders.customer_id
ORDER BY order_value DESC;


-- Calculate the average order value by date
SELECT 
	AVG(order_details.product_id * order_details.unit_price - order_details.discount) AS order_value,
	orders.order_date
FROM order_details
JOIN orders on orders.order_id = order_details.order_id
GROUP BY orders.order_date
ORDER BY order_value DESC;


-- Day with the highest order value
SELECT 
	MAX(order_details.product_id * order_details.unit_price - order_details.discount),
	orders.order_date
FROM order_details
JOIN orders on orders.order_id = order_details.order_id
GROUP BY orders.order_date
ORDER BY orders.order_date DESC
LIMIT 1;



SELECT 
	order_details.order_id, SUM(order_details.quantity * order_details.unit_price) AS order_value,
	orders.order_date, orders.ship_country
FROM order_details
JOIN orders on orders.order_id = order_details.order_id
GROUP BY 
    order_details.order_id, 
    orders.order_date, 
    orders.ship_country;