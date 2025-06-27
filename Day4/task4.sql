create database Employees;
use Employees;

CREATE TABLE sales (
    id INTEGER PRIMARY KEY,
    product TEXT,
    category TEXT,
    quantity INTEGER,
    price REAL,
    region TEXT
);


INSERT INTO sales (id, product, category, quantity, price, region) VALUES
(1, 'Keyboard', 'Hardware', 10, 25.00, 'East'),
(2, 'Mouse', 'Hardware', 15, 15.00, 'West'),
(3, 'Software A', 'Software', 5, 50.00, 'East'),
(4, 'Keyboard', 'Hardware', 20, 25.00, 'West'),
(5, 'Software B', 'Software', 8, 60.00, 'East'),
(6, 'Monitor', 'Hardware', 7, 120.00, 'East'),
(7, 'Software A', 'Software', 4, 50.00, 'West');

SELECT *FROM sales;

SELECT product, SUM(quantity) AS total_quantity
FROM sales
GROUP BY product;

SELECT category, AVG(price) AS average_price
FROM sales
GROUP BY category;

SELECT region, COUNT(*) AS num_sales
FROM sales
GROUP BY region;

SELECT category, SUM(quantity * price) AS total_sales
FROM sales
GROUP BY category;


SELECT category, SUM(quantity * price) AS total_sales
FROM sales
GROUP BY category
HAVING total_sales > 1000;
