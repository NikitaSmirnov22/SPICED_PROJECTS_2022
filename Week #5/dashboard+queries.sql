"""
The following file contains some of the queries used 
in creating the Metabase dashboard for the project in week 5.
"""

#!pip install sqlalchemy
#!pip install psycopg2-binary
import sqlalchemy as db
from sqlalchemy import create_engine
import pandas as pd

# Setup
uri = 'postgres://user:pw@localhost/northwind'
engine = create_engine(uri, echo=False)

# Test query - select all data from the products table
query = "SELECT * FROM products;"

df = pd.read_sql(query, engine)
print(df.head())


# 1. Get the names and the quantities in stock for each product.
query1 = 
SELECT product_name, units_in_stock
FROM products;

pd.read_sql(query1, engine)


# 2. Get a list of current products (Product ID and name).
query2 =
SELECT product_id, product_name
FROM products;

pd.read_sql(query2, engine)


# 3. Get a list of the most and least expensive products (name and unit price).
query3 = 
SELECT product_name, unit_price 
FROM Products 
WHERE unit_price > 100 OR unit_price < 5
ORDER BY unit_price DESC;

pd.read_sql(query3, engine)


# 4. Get products that cost less than $20
query4 = 
SELECT product_name, unit_price
FROM products
WHERE unit_price < 20
ORDER BY unit_price ASC;

pd.read_sql(query4, engine)


# 5. Get products that cost between $15 and $25.
query5 = 
SELECT product_name, unit_price
FROM products
WHERE unit_price BETWEEN 15 AND 25;

pd.read_sql(query5, engine)


# 6. Get products above average price.
query6 = 
SELECT product_name, unit_price
FROM products
WHERE unit_price > (
    SELECT AVG(unit_price)
    FROM products
    );

pd.read_sql(query6, engine)


# 7. Find the ten most expensive products.
query7 = 
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 10;

pd.read_sql(query7, engine)


# 8. Get a list of discontinued products (Product ID and name).
query8 = 
SELECT product_id, product_name, discontinued
FROM products
WHERE discontinued = 1;

pd.read_sql(query8, engine)


# 9. Count current and discontinued products.
query9 = 
SELECT discontinued, COUNT(*)
FROM products
GROUP BY discontinued;

pd.read_sql(query9, engine)


# 10. Find products with less units in stock than the quantity on order.
query10 = 
SELECT units_in_stock, units_in_order
FROM products
WHERE units_in_stock < units_in_order;

pd.read_sql(query10, engine)


# 11. Find the customer who had the highest order amount
query11 = 
SELECT customer_id, COUNT(*)
FROM orders
GROUP BY customer_id
ORDER BY orders DESC
LIMIT 1;

pd.read_sql(query11, engine)


# 12. Get orders for a given employee and the according customer
query12 =
SELECT *
FROM orders
WHERE employee_id = 1;

pd.read_sql(query12, engine)


# 13. Find the hiring age of each employee
query13 = 
SELECT employee_id, age(hire_date, birth_date) AS "hiring_age"
FROM employees;

pd.read_sql(query13, engine)


# 14. Create views for some of these queries
view13 = 
CREATE VIEW employee_age AS (
    SELECT employee_id, age(hire_date, birth_date) AS "hiring_age"
    FROM employees
    );



# Create a view of all the relevant columns from all the tables
view_all = 
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



# Mark products as expensive of inexpensive
query14 = 
SELECT product_id,
CASE
	WHEN unit_price > 150 THEN 'expensive' 
	ELSE 'inexpensive' END
FROM order_details;

pd.read_sql(query14, engine)


# Calculate the average order value per country
query15 = 
SELECT 
	AVG(order_details.product_id * order_details.unit_price - order_details.discount) AS order_value,
	orders.ship_country
FROM order_details
JOIN orders on orders.order_id = order_details.order_id
GROUP BY orders.ship_country
ORDER BY order_value DESC;

pd.read_sql(query15, engine)


# Calculate the total order value per country
query16 = 
SELECT 
	SUM(order_details.product_id * order_details.unit_price - order_details.discount) AS order_value,
	orders.ship_country
FROM order_details
JOIN orders on orders.order_id = order_details.order_id
GROUP BY orders.ship_country
ORDER BY order_value DESC;

pd.read_sql(query16, engine)


# Calculate the average order value per customer
query17 = 
SELECT 
	AVG(order_details.product_id * order_details.unit_price - order_details.discount) AS order_value,
	orders.customer_id
FROM order_details
JOIN orders on orders.order_id = order_details.order_id
GROUP BY orders.customer_id
ORDER BY order_value DESC;

pd.read_sql(query17, engine)


# Calculate the average order value by date
query18 = 
SELECT 
	AVG(order_details.product_id * order_details.unit_price - order_details.discount) AS order_value,
	orders.order_date
FROM order_details
JOIN orders on orders.order_id = order_details.order_id
GROUP BY orders.order_date
ORDER BY order_value DESC;



# Day with the highest order value
query19 = 
SELECT 
	MAX(order_details.product_id * order_details.unit_price - order_details.discount),
	orders.order_date
FROM order_details
JOIN orders on orders.order_id = order_details.order_id
GROUP BY orders.order_date
ORDER BY orders.order_date DESC
LIMIT 1;


query20 = 
SELECT 
	order_details.order_id, SUM(order_details.quantity * order_details.unit_price) AS order_value,
	orders.order_date, orders.ship_country
FROM order_details
JOIN orders on orders.order_id = order_details.order_id
GROUP BY 
    order_details.order_id, 
    orders.order_date, 
    orders.ship_country;
