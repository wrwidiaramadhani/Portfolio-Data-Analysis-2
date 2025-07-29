-- CREATE TABLE coffee_shop_sales
CREATE TABLE coffee_shop_sales(
	transaction_id NUMERIC,
	transaction_date TIMESTAMP,
	transaction_time TIMESTAMP,
	months VARCHAR(25),
	days VARCHAR(25),
	transaction_qty NUMERIC,
	store_id NUMERIC,
	store_location VARCHAR(225),
	product_id NUMERIC,
	unit_price NUMERIC,
	revenue NUMERIC,
	product_category VARCHAR(225),
	product_type VARCHAR(225),
	product_detail VARCHAR(225)
);


ALTER TABLE coffee_shop_sales
ALTER COLUMN transaction_date TYPE DATE,
ALTER COLUMN transaction_time TYPE TIME


-- Set Datestyle from 'YMD' TO 'MDY'
SET datestyle TO 'MDY'


-- Import Coffe Shop Sales Dataset
COPY coffee_shop_sales(
	transaction_id,
	transaction_date,
	transaction_time,
	months,
	days,
	transaction_qty,
	store_id,
	store_location,
	product_id,
	unit_price,
	revenue,
	product_category,
	product_type,
	product_detail
)
FROM 'D:\Data Analysis\Analysis Data with Microsoft Excel\Portofolio\coffee_shop_sales.csv'
CSV
HEADER


-- Check dataset had been imported
SELECT *
FROM coffee_shop_sales



-- 1. Monthly Sales Performance
SELECT 
	months,
	SUM(revenue) AS total_revenue
FROM coffee_shop_sales
GROUP BY 1
ORDER BY 2 DESC

SELECT *
FROM coffee_shop_sales



-- 2. Monthly Sales Performance by Store's Location
-- Showing highest revenue of store's location per month
SELECT 
	store_location,
	months,
	SUM(revenue) AS revenue_store_per_month
FROM coffee_shop_sales
GROUP BY 1,2
ORDER BY 1,3 DESC



-- 3. Store's Location with Highest Revenue per Month
-- Showing which store's location that have highest revenue in given month
SELECT 
	months,
	store_location,
	SUM(revenue) AS revenue_store_per_month
FROM coffee_shop_sales
GROUP BY 1,2
ORDER BY 1,3 DESC



-- 4. Daily Sales Performance
-- Showing days with highest to lowest revenue
SELECT 
	days,
	SUM(revenue) AS total_revenue,
	SUM(transaction_qty) AS total_quantity_order
FROM coffee_shop_sales
GROUP BY 1
ORDER BY 2 DESC



-- 5. Daily Sales Performance by Store's Location
-- Showing sales performance with highest to lowest revene per store's location
SELECT 
	store_location,
	days,
	SUM(revenue) AS total_revenue
FROM coffee_shop_sales
GROUP BY 1,2
ORDER BY 1,3 DESC



-- 6. Total Sales per Store's Location
-- Showing locations with the best sales performance
SELECT 
	store_location,
	SUM(revenue) AS total_revenue,
	SUM(transaction_qty) AS total_quantity_order
FROM coffee_shop_sales
GROUP BY 1
ORDER BY 2 DESC



-- 7. Bussiest Transaction Time
-- Showing the busiest and peak sales times
SELECT 
	EXTRACT(HOUR FROM transaction_time) AS hours,
	SUM(transaction_qty) AS total_quantity_order,
	SUM(revenue) AS total_revenue
FROM coffee_shop_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5



-- 8. Top 3 Product Detail Every Month
-- Showing top 3 revenue of product detail every month
WITH total_revenue AS (
	SELECT 
		months,
		product_detail,
		SUM(revenue) AS total_revenue,
		SUM(transaction_qty) AS total_quantity_order
	FROM coffee_shop_sales
	GROUP BY 1,2 
	ORDER BY 1,3 DESC
),
ranked_revenue_product_detail AS (
	SELECT 
		months,
		product_detail,
		total_revenue,
		total_quantity_order,
		ROW_NUMBER() OVER(PARTITION BY months ORDER BY total_revenue DESC, months DESC) AS
		rank_product_detail
	FROM total_revenue
)
	SELECT *
	FROM ranked_revenue_product_detail
	WHERE rank_product_detail <= 3



-- 9. Top 3 Product Category Every Month
-- Showing top 3 revenue of product category every month

WITH total_revenue AS (
	SELECT 
		months,
		product_category,
		SUM(revenue) AS total_revenue,
		SUM(transaction_qty) AS total_quantity_order
	FROM coffee_shop_sales
	GROUP BY 1,2
	ORDER BY 1,3 DESC
),
ranked_revenue_product_category AS (	
	SELECT 
		months,
		product_category,
		total_revenue,
		total_quantity_order,
		ROW_NUMBER() OVER(PARTITION BY months ORDER BY total_revenue DESC, months DESC)
		AS rank_product_category
	FROM total_revenue
)
	SELECT *
	FROM ranked_revenue_product_category
	WHERE rank_product_category <= 3



-- 10. Top 5 Product Category Sales Performance
-- Showing top 5 revenue of product category 

-- Cara 1 with Limit
SELECT 
	product_category,
	SUM(revenue) AS total_revenue,
	SUM(transaction_qty) AS total_quantity_order
FROM coffee_shop_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Cara 2 with CTE & Row Number
WITH total_revenue AS (
	SELECT 
		product_category,
		SUM(revenue) AS total_revenue,
		SUM(transaction_qty) AS total_quantity_order
	FROM coffee_shop_sales
	GROUP BY 1
	ORDER BY 2 DESC
),
ranked_revenue_product_category AS (
	SELECT 
		product_category,
		total_revenue,
		total_quantity_order,
		ROW_NUMBER() OVER(ORDER BY total_revenue DESC)
		AS ranked_product_category
	FROM total_revenue
)
	SELECT *
	FROM ranked_revenue_product_category
	WHERE ranked_product_category <= 5



-- 11. Bottom 5 Product Category Sales Performance
-- Showing bottom 5 revenue of product category 

-- Cara 1 with Limit
SELECT 
	product_category,
	SUM(revenue) AS total_revenue,
	SUM(transaction_qty) AS total_quantity_order
FROM coffee_shop_sales
GROUP BY 1
ORDER BY 2 ASC
LIMIT 5

-- Cara 2 with CTE & Row Number
WITH total_revenue AS (
	SELECT 
		product_category,
		SUM(revenue) AS total_revenue,
		SUM(transaction_qty) AS total_quantity_order
	FROM coffee_shop_sales
	GROUP BY 1
	ORDER BY 2 ASC
),
ranked_revenue_product_category AS (
	SELECT 
		product_category,
		total_revenue,
		total_quantity_order,
		ROW_NUMBER() OVER(ORDER BY total_revenue ASC)
		AS ranked_product_category
	FROM total_revenue
)
	SELECT *
	FROM ranked_revenue_product_category
	WHERE ranked_product_category <= 5



-- 12. Top 5 Product Type Sales Performance
-- Showing top 5 revenue of product Type 

-- Cara 1 with Limit
SELECT 
	product_type,
	SUM(revenue) AS total_revenue,
	SUM(transaction_qty) AS total_quantity_order
FROM coffee_shop_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Cara 2 with CTE & Row Number
WITH total_revenue AS (
	SELECT 
		product_type,
		SUM(revenue) AS total_revenue,
		SUM(transaction_qty) AS total_quantity_order
	FROM coffee_shop_sales
	GROUP BY 1
	ORDER BY 2 DESC
),
ranked_revenue_product_type AS (
	SELECT 
		product_type,
		total_revenue,
		total_quantity_order,
		ROW_NUMBER() OVER(ORDER BY total_revenue DESC)
		AS ranked_product_type
	FROM total_revenue
)
	SELECT *
	FROM ranked_revenue_product_type
	WHERE ranked_product_type <= 5 



-- 13. Bottom 5 Product Type Sales Performance
-- Showing bottom 5 revenue of product Type 

-- Cara 1 with Limit
SELECT 
	product_type,
	SUM(revenue) AS total_revenue,
	SUM(transaction_qty) AS total_quantity_order
FROM coffee_shop_sales
GROUP BY 1
ORDER BY 2 ASC
LIMIT 5

-- Cara 2 with CTE & Row Number
WITH total_revenue AS (
	SELECT 
		product_type,
		SUM(revenue) AS total_revenue,
		SUM(transaction_qty) AS total_quantity_order
	FROM coffee_shop_sales
	GROUP BY 1
	ORDER BY 2 ASC
),
ranked_revenue_product_type AS (
	SELECT 
		product_type,
		total_revenue,
		total_quantity_order,
		ROW_NUMBER() OVER(ORDER BY total_revenue ASC)
		AS ranked_product_type
	FROM total_revenue
)
	SELECT *
	FROM ranked_revenue_product_type
	WHERE ranked_product_type <= 5



-- 14. Top 5 Product Detail Sales Performance
-- Showing top 3 revenue of product detail for whole store's location

-- Cara 1 with Limit
SELECT 
	product_detail,
	SUM(revenue) AS total_revenue,
	SUM(transaction_qty) AS toal_quantity_order
FROM coffee_shop_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3

-- Cara 2 with CTE & Row Number
WITH total_revenue AS (
	SELECT 
		product_detail,
		SUM(revenue) AS total_revenue,
		SUM(transaction_qty) AS total_quantity_order
	FROM coffee_shop_sales
	GROUP BY 1
	ORDER BY 2 DESC
),
ranked_revenue_product_detail AS (
	SELECT 
		product_detail,
		total_revenue,
		total_quantity_order,
		ROW_NUMBER() OVER(ORDER BY total_revenue DESC) 
		AS ranked_product_detail
	FROM total_revenue
)
	SELECT *
	FROM ranked_revenue_product_detail
	WHERE ranked_product_detail <=3



-- 15. Bottom 5 Product Detail Sales Performance
-- Showing bottom 3 revenue of product detail for whole store's location

-- Cara 1 with Limit
SELECT 
	product_detail,
	SUM(revenue) AS total_revenue,
	SUM(transaction_qty) AS toal_quantity_order
FROM coffee_shop_sales
GROUP BY 1
ORDER BY 2 ASC
LIMIT 3

-- Cara 2 with CTE & Row Number
WITH total_revenue AS (
	SELECT 
		product_detail,
		SUM(revenue) AS total_revenue,
		SUM(transaction_qty) AS total_quantity_order
	FROM coffee_shop_sales
	GROUP BY 1
	ORDER BY 2 ASC
),
ranked_revenue_product_detail AS (
	SELECT 
		product_detail,
		total_revenue,
		total_quantity_order,
		ROW_NUMBER() OVER(ORDER BY total_revenue ASC) 
		AS ranked_product_detail
	FROM total_revenue
)
	SELECT *
	FROM ranked_revenue_product_detail
	WHERE ranked_product_detail <=3


-- 16. Top 5 Product Detail by Store's Location
WITH total_revenue AS (
	SELECT 
		store_location,
		product_detail,
		SUM(revenue) AS total_revenue
	FROM coffee_shop_sales
	GROUP BY 1,2
	ORDER BY 3 DESC
),
ranked_product_detail AS(
	SELECT 
		store_location,
		product_detail,
		total_revenue,
		ROW_NUMBER() OVER(PARTITION BY store_location ORDER BY total_revenue DESC)
		AS top_product_detail
	FROM total_revenue
)
	SELECT *
	FROM ranked_product_detail
	WHERE top_product_detail <=5



-- 17. Bottom 5 Product Detail by Store's Location
WITH total_revenue AS (
	SELECT 
		store_location,
		product_detail,
		SUM(revenue) AS total_revenue
	FROM coffee_shop_sales
	GROUP BY 1,2
	ORDER BY 3 ASC
),
ranked_product_detail AS(
	SELECT 
		store_location,
		product_detail,
		total_revenue,
		ROW_NUMBER() OVER(PARTITION BY store_location ORDER BY total_revenue ASC)
		AS top_product_detail
	FROM total_revenue
)
	SELECT *
	FROM ranked_product_detail
	WHERE top_product_detail <=5


-- 18. Top 5 Product Category by Store's Location
WITH total_revenue AS (
	SELECT 
		store_location,
		product_category,
		SUM(revenue) AS total_revenue
	FROM coffee_shop_sales
	GROUP BY 1,2
	ORDER BY 3 DESC
),
ranked_product_category AS(
	SELECT 
		store_location,
		product_category,
		total_revenue,
		ROW_NUMBER() OVER(PARTITION BY store_location ORDER BY total_revenue DESC)
		AS top_product_category
	FROM total_revenue
)
	SELECT *
	FROM ranked_product_category
	WHERE top_product_category <=5



-- 19. Bottom 5 Product Category by Store's Location
WITH total_revenue AS (
	SELECT 
		store_location,
		product_category,
		SUM(revenue) AS total_revenue
	FROM coffee_shop_sales
	GROUP BY 1,2
	ORDER BY 3 ASC
),
ranked_product_category AS(
	SELECT 
		store_location,
		product_category,
		total_revenue,
		ROW_NUMBER() OVER(PARTITION BY store_location ORDER BY total_revenue ASC)
		AS top_product_category
	FROM total_revenue
)
	SELECT *
	FROM ranked_product_category
	WHERE top_product_category <=5
	
	