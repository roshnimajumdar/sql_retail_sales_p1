--PROJECT RETAIL SALES ANALYSIS
drop table if exists retail_sales

CREATE TABLE retail_sales
(
transactions_id INT PRIMARY KEY, --no duplicate/null value, only 1 primary key in a table,
sale_date DATE,
sale_time TIME,
customer_id	INT,
gender VARCHAR(15),
age	INT,
category VARCHAR(15),
quantiy	INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT,
)
select * from retail_sales

INSERT INTO retail_sales
SELECT *
FROM dbo.[SQL - Retail Sales Analysis_utf]

select COUNT(*) from retail_sales

select TOP 10 * from retail_sales

--DATA CLEANING

SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE 
(transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR 
customer_id IS NULL
OR 
gender IS NULL
OR 
category IS NULL
OR 
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL)

DELETE FROM retail_sales
WHERE 
(transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR 
customer_id IS NULL
OR 
gender IS NULL
OR 
category IS NULL
OR 
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL)


--DATA EXPLORATION
--how many sales do we have?
SELECT COUNT (*) AS TOTAL_SALE from retail_sales

--how many unique customers do we have?
SELECT COUNT (DISTINCT customer_id) as Total_Customers from retail_sales 

--how many unique categories do we have?
SELECT COUNT (DISTINCT category) as Total_Category from retail_sales 


--DATA ANALYSIS
--My Analysis & Findings

--Q1. Write a SQL query to retrieve all columns for sales made on ‘2022-11-05’.

SELECT *
FROM retail_sales
WHERE
sale_date = '2022-11-05'

--Q2. Write a SQL query to retrieve all transactions where the category is ‘Clothing’ and the quantity sold is more than 4 in the month of Nov-2022.
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND sale_date >= '2022-11-01'
AND sale_date < '2022-12-01'
AND quantiy >=4      


--Q3. Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT * FROM retail_sales

SELECT category, 
sum (total_sale) as Net_Sales
FROM retail_sales
GROUP BY category


--Q4. Write a SQL query to find the average age of customers who purchased items from the ‘Beauty’ category.

SELECT AVG(age) as Average_Age
FROM retail_sales
WHERE category = 'Beauty'

--Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM retail_sales
WHERE total_sale > 1000

--Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT gender,
category,
COUNT(transactions_id) as Total_Count
FROM retail_sales
GROUP BY gender, category
ORDER BY category


--Q7. Write a SQL query to calculate the average sale for each month. Find the best-selling month in each year.

SELECT *
FROM (
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank_no
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE rank_no = 1
ORDER BY year, avg_sale DESC



-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT TOP 5 customer_id,
SUM (total_sale) as net_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY net_sales DESC


--Q9. Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category, COUNT(DISTINCT(customer_id)) as Count
FROM retail_sales
GROUP BY category

--Q10. Write a SQL query to create each shift and number of orders using the following criteria:

--* Morning: <= 12
--* Afternoon: Between 12 and 17
--* Evening: > 17

WITH hourly_sale AS
(
    SELECT *,
        CASE
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)

SELECT
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift

--End of project