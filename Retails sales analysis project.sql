CREATE TABLE RetailSales (
    TransactionID INT PRIMARY KEY,
    Date DATE NOT NULL,
    CustomerID VARCHAR(50) NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    Age INT NOT NULL,
    ProductCategory VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    PricePerUnit INT NOT NULL,
    TotalAmount INT NOT NULL
);


SELECT * FROM RetailSales;

SELECT COUNT(*) FROM RetailSales;

--Creating new table for demonstrating the joins


CREATE TABLE customer_details (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    loyalty_points INT
);

INSERT INTO customer_details (customer_id, customer_name, city, loyalty_points) VALUES
('CUST001', 'John Doe', 'Toronto', 500),
('CUST002', 'Jane Smith', 'Montreal', 1200),
('CUST003', 'Robert Brown', 'Vancouver', 300),
('CUST004', 'Michael Davis', 'Calgary', 800),
('CUST005', 'William Wilson', 'Ottawa', 150),
('CUST006', 'Emily Johnson', 'Edmonton', 950),
('CUST007', 'Sophia Martinez', 'Winnipeg', 1100),
('CUST008', 'Olivia Anderson', 'Quebec City', 600),
('CUST009', 'James Taylor', 'Halifax', 700),
('CUST010', 'Emma Moore', 'Victoria', 400);

SELECT * FROM customer_details;

SELECT * FROM RetailSales;


--Find the total sales amount for each product category

SELECT productcategory, SUM(totalamount) AS total_sales FROM RetailSales
GROUP BY productcategory;


--Which city has the highest total loyalty points

SELECT city, SUM(loyalty_points) AS total_loyaltypoints FROM customer_details
GROUP BY city
ORDER BY total_loyaltypoints DESC
LIMIT 1;


--Find the top 3 customers who spent the most

SELECT customerid, SUM(totalamount) AS total_spent
FROM RetailSales
GROUP BY customerid
ORDER BY total_spent DESC
LIMIT 3;


--Calculate the average age of the customers by gender
SELECT AVG(age) AS avg_age, gender
FROM RetailSales
GROUP BY gender; 


--Retrive all the transactions where customers spent more than 1000

SELECT * FROM RetailSales
WHERE totalamount > 1000;

--List customers and their loyalty points for all transactions.
SELECT rs.customerid, rs.totalamount, cd.loyalty_points
FROM RetailSales rs
LEFT JOIN customer_details cd
ON rs.customerid = cd.customer_id; 


--What is the average quantity sold per product category?
SELECT AVG(quantity) AS avg_quantity, productcategory
FROM RetailSales
GROUP BY productcategory
ORDER BY avg_quantity;

-- Find the total sales amount for each city.

SELECT SUM(rs.totalamount) AS total_sales, cd.city
FROM RetailSales rs
INNER JOIN customer_details cd
ON rs.customerid = cd.customer_id
GROUP BY cd.city
ORDER BY total_sales;


-- Which product category has the highest average unit price?

SELECT productcategory, AVG(priceperunit) AS avg_unitprice
FROM RetailSales
GROUP BY productcategory
ORDER BY avg_unitprice DESC
LIMIT 1;


--Show all customers who have more than 500 loyalty points.
SELECT * FROM customer_details
WHERE loyalty_points > 500;

--Rank customers by total spending.

SELECT customerid, SUM(totalamount) AS total_spent,
RANK() OVER(ORDER BY SUM(totalamount) DESC) AS rank
FROM RetailSales
GROUP BY customerid; 


--Identify the most popular product category based on quantity sold.

SELECT productcategory, SUM(quantity) AS total_quantity_sold
FROM RetailSales
GROUP BY productcategory
ORDER BY total_quantity_sold DESC
LIMIT 1;

--Find the cumulative sales for each customer.
SELECT customerid, totalamount,
SUM(totalamount) OVER (PARTITION BY customerid ORDER BY transactionid DESC) AS cumulative_sales
FROM RetailSales;

--Calculate the difference in loyalty points between the highest and lowest in each city.

SELECT city, MIN(loyalty_points) - MAX(loyalty_points) AS difference
FROM customer_details
GROUP BY city;

--Retrieve customers who made purchases in more than 1 product category.

SELECT customerid
FROM RetailSales
GROUP BY customerid
HAVING COUNT(DISTINCT productcategory) > 1;