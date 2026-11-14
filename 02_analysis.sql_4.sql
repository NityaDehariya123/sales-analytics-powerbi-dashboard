CREATE DATABASE sales_analytics;
USE sales_analytics;
SET SQL_SAFE_UPDATES = 0;

CREATE TABLE orders (
  `Row ID` INT,
  `Order ID` TEXT,
  `Order Date` TEXT,
  `Ship Date` TEXT,
  `Ship Mode` TEXT,
  `Customer ID` TEXT,
  `Customer Name` TEXT,
  `Segment` TEXT,
  `Country` TEXT,
  `City` TEXT,
  `State` TEXT,
  `Postal Code` TEXT,
  `Region` TEXT,
  `Product ID` TEXT,
  `Category` TEXT,
  `Sub-Category` TEXT,
  `Product Name` TEXT,
  `Sales` DOUBLE,
  order_date_clean DATE,
  ship_date_clean DATE
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/train.csv'
INTO TABLE orders
CHARACTER SET latin1
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(`Row ID`, `Order ID`, `Order Date`, `Ship Date`, `Ship Mode`,
 `Customer ID`, `Customer Name`, `Segment`, `Country`, `City`,
 `State`, `Postal Code`, `Region`, `Product ID`, `Category`,
 `Sub-Category`, `Product Name`, `Sales`);


UPDATE orders
SET order_date_clean = STR_TO_DATE(`Order Date`, '%d/%m/%Y'),
    ship_date_clean = STR_TO_DATE(`Ship Date`, '%d/%m/%Y');
    
SELECT COUNT(*) AS total_rows,
       SUM(order_date_clean IS NULL) AS missing_dates,
       MIN(order_date_clean) AS first_order,
       MAX(order_date_clean) AS last_order,
       ROUND(SUM(Sales), 2) AS total_sales
FROM orders;

USE sales_analytics;


SELECT Region,
       COUNT(DISTINCT `Order ID`) AS total_orders,
       ROUND(SUM(Sales), 2) AS total_sales
FROM orders
GROUP BY Region
ORDER BY total_sales DESC;

SELECT Category,
       COUNT(DISTINCT `Order ID`) AS total_orders,
       ROUND(SUM(Sales), 2) AS total_sales,
       ROUND(SUM(Sales) * 100 / (SELECT SUM(Sales) FROM orders), 1) AS pct_of_total
FROM orders
GROUP BY Category
ORDER BY total_sales DESC;

SELECT DATE_FORMAT(order_date_clean, '%Y-%m') AS month,
       ROUND(SUM(Sales), 2) AS total_sales
FROM orders
GROUP BY DATE_FORMAT(order_date_clean, '%Y-%m')
ORDER BY month;

SELECT `Customer Name`,
       COUNT(DISTINCT `Order ID`) AS total_orders,
       ROUND(SUM(Sales), 2) AS total_sales
FROM orders
GROUP BY `Customer Name`
ORDER BY total_sales DESC
LIMIT 10;

SELECT `Product Name`,
       Category,
       ROUND(SUM(Sales), 2) AS total_sales
FROM orders
GROUP BY `Product Name`, Category
ORDER BY total_sales DESC
LIMIT 10;

SELECT Segment,
       COUNT(DISTINCT `Customer ID`) AS customers,
       ROUND(SUM(Sales), 2) AS total_sales
FROM orders
GROUP BY Segment
ORDER BY total_sales DESC;

 
