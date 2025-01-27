 /* --------------------
   Case Study Questions
   --------------------*/
-- 1. How many pizzas were ordered?
-- 2. How many unique customer orders were made?
-- 3. How many successful orders were delivered by each runner?
-- 4. How many of each type of pizza was delivered?
-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
-- 6. What was the maximum number of pizzas delivered in a single order?
-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
-- 8. How many pizzas were delivered that had both exclusions and extras?
-- 9. What was the total volume of pizzas ordered for each hour of the day?
-- 10.What was the volume of orders for each day of the week?

-- Select table Query:

SELECT 
* 
FROM runners;
SELECT 
* 
FROM customer_orders;
SELECT 
* 
FROM runner_orders;
SELECT 
* 
FROM pizza_names;
SELECT
* 
FROM pizza_recipes;
SELECT 
* 
FROM pizza_toppings;



-- 1.How many pizzas were ordered?

   SELECT 
   COUNT(*) as Pizza_ordered
   FROM Customer_orders

-- 2.How many unique customer orders were made?

SELECT
COUNT(DISTINCT order_id) as Unique_customer_orders
FROM customer_orders



-- 3.How many successful orders were delivered by each runner?
SELECT 
runner_id,
COUNT(DISTINCT ro.order_id) as delivered_order
FROM customer_orders as co
INNER JOIN runner_orders as ro on co.order_id = ro.order_id
WHERE pickup_time <> 'null'
GROUP BY runner_id



-- 4.How many of each type of pizza was delivered?

SELECT 
  pn.pizza_name,
  co.pizza_id
FROM runner_orders AS ro
INNER JOIN customer_orders AS co ON ro.order_id = co.order_id
INNER JOIN pizza_names AS pn ON co.pizza_id = pn.pizza_id
WHERE pickup_time <> 'null'

SELECT  
  CONVERT(NVARCHAR(MAX), pn.pizza_name) AS pizza_name,
  COUNT(co.pizza_id) AS pizza_count
FROM runner_orders AS ro
INNER JOIN customer_orders AS co ON ro.order_id = co.order_id
INNER JOIN pizza_names AS pn ON co.pizza_id = pn.pizza_id
WHERE CONVERT(NVARCHAR(MAX), ro.pickup_time) IS NOT NULL  
GROUP BY CONVERT(NVARCHAR(MAX), pn.pizza_name);  




-- 5.How many Vegetarian and Meatlovers were ordered by each customer?


SELECT  
  co.customer_id,
  CONVERT(NVARCHAR(MAX), pn.pizza_name) AS pizza_name,  -- Converting to NVARCHAR
  COUNT(co.pizza_id) AS pizza_ordered
FROM customer_orders AS co
INNER JOIN pizza_names AS pn ON co.pizza_id = pn.pizza_id
GROUP BY co.customer_id,
  CONVERT(NVARCHAR(MAX), pn.pizza_name);  -- Grouping by converted pizza_name





-- 6.What was the maximum number of pizzas delivered in a single order?

SELECT TOP 1
order_id,
COUNT(pizza_id) as pizza_ordered
FROM customer_orders
GROUP BY order_id
ORDER BY COUNT(pizza_id) DESC

-- 7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT
    co.customer_id,
    SUM(CASE
        WHEN (
               (exclusions IS NOT NULL AND exclusions <> 'null' AND LEN(exclusions) > 0)
            OR (extras IS NOT NULL AND extras <> 'null' AND LEN(extras) > 0)
        ) THEN 1
        ELSE 0
    END) AS changes,
    SUM(CASE
        WHEN (
               (exclusions IS NOT NULL AND exclusions <> 'null' AND LEN(exclusions) > 0)
            OR (extras IS NOT NULL AND extras <> 'null' AND LEN(extras) > 0)
        ) THEN 1
        ELSE 0
    END) AS [no changes]  
FROM customer_orders AS co
INNER JOIN runner_orders AS ro ON co.order_id = ro.order_id
WHERE ro.pickup_time IS NOT NULL  -
GROUP BY co.customer_id;






-- 8.How many pizzas were delivered that had both exclusions and extras?


SELECT
    SUM(CASE
        WHEN (
            exclusions IS NOT NULL AND exclusions <> 'null' AND LEN(exclusions) > 0
            AND extras IS NOT NULL AND extras <> 'null' AND LEN(extras) > 0
        ) THEN 1
        ELSE 0
    END) AS pizzas_with_exclusions_and_extras
FROM customer_orders AS co
INNER JOIN runner_orders AS ro ON co.order_id = ro.order_id
WHERE ro.pickup_time IS NOT NULL;  -- Ensure pickup_time is not NULL

-- 9.What was the total volume of pizzas ordered for each hour of the day?
SELECT
    DATEPART(HOUR, order_time) AS hours,  
    COUNT(pizza_id) AS pizzas_ordered    
FROM customer_orders
GROUP BY DATEPART(HOUR, order_time);  

--10.What was the volume of orders for each day of the week?
SELECT
    DATEPART(WEEKDAY, order_time) AS hours,  -- Extracts the hour part from order_time
	DATENAME (WEEKDAY,order_time) AS day2,
    COUNT(pizza_id) AS pizzas_ordered    -- Counts the number of pizza_ids for each hour
FROM customer_orders
GROUP BY DATEPART(WEEKDAY, order_time),
DATENAME(WEEKDAY,order_time);

