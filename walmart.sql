-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;


-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- Data cleaning
SELECT
	*
FROM sales;


-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);


-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;


-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- Data cleaning
SELECT
	*
FROM sales;

-- ----------------------------------------------------------------------------------------------------------------------------------------------- --
-- ------------------------------------------------------------FEATURE ENGINEERING---------------------------------------------------------------- --

-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server
UPDATE sales
SET time_of_day = (
	CASE
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);


-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);


-- Add month_name column 
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- --------------------------------------------------------Exploratory Data Analysis--------------------------------------------------------------
-- ----------Generic------------ --
-- How many unique cities does the data have
SELECT DISTINCT city
FROM sales;

-- How many branches does the data have
SELECT DISTINCT branch
FROM sales;

-- Which city are the branches in
SELECT 
	DISTINCT city,
	branch
FROM sales;

-- --------Product--------- --
-- How many unique product line does the data have?
SELECT
	COUNT(DISTINCT product_line)
FROM sales;

-- What is the most commom type of payment method?
SELECT
	payment_method,
	COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;

-- What is the most selling product line
SELECT
	product_line,
	COUNT(product_line) AS cnt_product
FROM sales
GROUP BY product_line
ORDER BY cnt_product DESC;

-- What is the total revenue by month
SELECT
	month_name,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- What month had the largest cogs?
SELECT 
	month_name,
    SUM(cogs) AS monthly_cogs
FROM sales
GROUP BY month_name
order by monthly_cogs DESC;

-- What product line has the largest revenue
SELECT
	product_line,
	SUM(total) as top_product
FROM sales
GROUP BY product_line
ORDER BY top_product DESC;

-- What city with the largest revenue
SELECT
	branch,
	city,
	SUM(total) as top_city
FROM sales
GROUP BY city, branch
ORDER BY top_city DESC;

-- What product line had the largest VAT
SELECT
	product_line,
	AVG(VAT) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- For each product line add a column to those product line showing "Good", "Bad". Good if it is greater than avverage sales


-- What branch sold more product than the average product sold? 
SELECT
	branch,
    SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT 
							AVG(quantity)
						FROM sales);
                        
-- What is the most common product line by gender?
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- What is the averge rating of each product line?
SELECT
    ROUND(AVG(rating), 2) as avg_rating,
	product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- What is the unit price of each product line?
SELECT
	product_line,
    AVG(unit_price) as avg_price
FROM sales
GROUP BY product_line
ORDER BY avg_price DESC;

-- -----------Sales------------ --
-- Number of sales made in each time of the day per weekday
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = 'Monday'
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Which of the customer type brings the most revenue?
SELECT
	customer_type,
    SUM(total) AS revenue
FROM sales
GROUP BY customer_type
ORDER BY revenue DESC;

-- Which city has the largest tax percent/VAT (Value Added Tax)?
SELECT
	city,
    AVG(VAT) AS tax
FROM sales
GROUP BY city
ORDER BY tax DESC;

-- which customer type pays the most in VAT?
SELECT
	customer_type,
    AVG(VAT) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;


-- ------------Customer-------------- --
-- How many unique customer type does this data have?
SELECT 
	DISTINCT customer_type
FROM sales;

-- How many unique payment method does this data have?
SELECT 
	payment_method,
    COUNT(payment_method) AS payment
FROM sales
GROUP BY payment_method
ORDER BY payment DESC;

-- What is the most common customer type?
SELECT 
	customer_type,
    COUNT(customer_type) AS customer
FROM sales
GROUP BY customer_type
ORDER BY customer DESC; 

-- What customer type buys the most?
SELECT 
	customer_type,
    COUNT(*) AS customer_cnt
FROM sales
GROUP BY customer_type;

-- What is the gender of most customers?
SELECT
	gender,
    COUNT(*) AS gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per brannch?
SELECT
	gender,
    branch,
    COUNT(*) AS gender_cnt
FROM sales
GROUP BY gender, branch
ORDER BY branch, gender_cnt DESC;

-- What time of the day do customers give most ratimgs?
SELECT
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- What time of the day do customers give most ratimgs per branch?
SELECT
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = 'A'
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which day of the week has the best average rating?
SELECT
	day_name,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Which day of the week has the best average rating per branch?
SELECT
	day_name,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = 'A'
GROUP BY day_name
ORDER BY avg_rating DESC;

-- What time of the day has more cogs sold?
SELECT
	time_of_day,
    SUM(cogs) AS cogs_sold
FROM sales
GROUP BY time_of_day
ORDER BY cogs_sold DESC;

-- What time of the day has more cogs sold per branch?
SELECT
	time_of_day,
    SUM(cogs) AS cogs_sold
FROM sales
WHERE branch = 'A'
GROUP BY time_of_day
ORDER BY cogs_sold DESC;

-- What day of the week has more cogs sold?
SELECT
	day_name,
    SUM(cogs) AS cogs_sold
FROM sales
GROUP BY day_name
ORDER BY cogs_sold DESC;

-- What day of the week has more cogs sold per branch?
SELECT
	day_name,
    SUM(cogs) AS cogs_sold
FROM sales
WHERE branch = 'A'
GROUP BY day_name
ORDER BY cogs_sold DESC;


-- ----------Income and Margins----------- --
-- What month has the highest avg gross income?
SELECT
	month_name,
    AVG(gross_income) AS ag_income
FROM sales
GROUP BY month_name
ORDER BY avg_income DESC;

-- What month has the highest avg gross income per branch?
SELECT
	month_name,
    AVG(gross_income) AS avg_income
FROM sales
WHERE branch = 'B'
GROUP BY month_name
ORDER BY avg_income DESC;

-- What is the average gross margin for eanch month?
SELECT
	month_name,
    AVG(gross_margin_pct) AS avg_margin
FROM sales
GROUP BY month_name
ORDER BY avg_margin DESC;