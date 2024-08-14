CREATE DATABASE sql_project_p2;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10;

SELECT 
	COUNT(*)
FROM retail_sales;


-- Identification of the null rows 
SELECT *
FROM retail_sales
WHERE transaction_id IS NULL
		OR
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR
		customer_id IS NULL
		OR
		age IS NULL
		OR
		category IS NULL
		OR
		quantity IS NULL
;

-- Total row count which has null values (13)
SELECT 
COUNT(*) as null_count
FROM retail_sales
WHERE transaction_id IS NULL
		OR
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR
		customer_id IS NULL
		OR
		age IS NULL
		OR
		category IS NULL
		OR
		quantity IS NULL
;


-- Bifrucation of the null values based on the gender category
-- Analysing whether to remove or manipluate the data
SELECT gender,
COUNT(gender) 
FROM retail_sales
WHERE age IS NULL		
GROUP BY gender
;

-- Removing the null values for better analysis of the data.
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    age IS NULL
    OR
    quantity IS NULL;

SELECT COUNT(*) FROM retail_sales;

-- Data Exploration

SELECT * FROM retail_sales LIMIT 10;

-- total sales
-- gender wise sales
-- caetgory wise sales
-- finding unique customers


-- Total sales wrt gender and category 

SELECT SUM(total_sale),
		gender,
		category
FROM retail_sales
GROUP BY gender, category
ORDER BY 2 DESC
;

-- unique customers

SELECT 
	COUNT(DISTINCT customer_id) as UNI_CUSTOMER
FROM retail_sales;

-- unique categories

SELECT DISTINCT(category) FROM retail_sales;

-- Data Analysis from the avaliable Table

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is 
-- more than 4 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
		AND TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
		AND quantity >= 4
ORDER BY 2,3 ASC;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT SUM(total_sale),
		category
FROM retail_sales
GROUP BY category
ORDER BY 2 DESC
;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
	gender,
	ROUND(AVG(age),2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY gender
;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM retail_sales
WHERE total_sale >= 1000
;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
	gender,	
	category,
	COUNT(transaction_id) as total_transcation
FROM retail_sales
GROUP BY gender, category
ORDER BY 3 DESC
;
	
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT month,
year,
avg_sales
FROM 
(
	SELECT 
		EXTRACT(YEAR from sale_date) as year,
		TO_CHAR(sale_date, 'Month') as month,
		AVG(total_sale) as avg_sales,
		RANK() OVER(PARTITION BY EXTRACT(YEAR from sale_date) ORDER BY AVG(total_sale) DESC) as rn
	FROM retail_sales
	GROUP BY 1,2
) as t1
WHERE rn =1 ;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
	customer_id,
	total_sale
FROM 
(
SELECT customer_id,
	SUM(total_sale) as total_sale,
	RANK() OVER(ORDER BY SUM(total_sale) DESC ) as rn
FROM retail_sales
GROUP BY customer_id
) as x1
WHERE rn<= 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

SELECT shift,
	COUNT(*) as total_order
FROM 
(
SELECT *,
CASE 
	WHEN EXTRACT(HOUR from sale_time) <12 THEN 'Morning'
	WHEN EXTRACT(HOUR from sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
END AS shift
FROM retail_sales
) as x1
GROUP BY shift;

