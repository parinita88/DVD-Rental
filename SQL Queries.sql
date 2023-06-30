-- Problem statement: identify no of rentals, revenue and see if the DVD store needs more inventory

-- A. Customer Analysis

-- Sort Customers by no of rentals
SELECT 
	CONCAT(c.first_name, ' ', c.last_name) as full_name,
	COUNT(r.rental_id) AS no_of_rentals
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY 1
ORDER BY 2 DESC;

-- Top 10 Customers by no of rentals
SELECT 
	CONCAT(c.first_name, ' ', c.last_name) as full_name,
	COUNT(r.rental_id) AS no_of_rentals
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- Sort Customers by payment amount
SELECT 
	CONCAT(c.first_name, ' ', c.last_name) as full_name,
	SUM(amount) AS total_amount,
	ROUND(AVG(amount),2) AS avg_amount
FROM customer c
LEFT JOIN payment p ON c.customer_id = p.customer_id
GROUP BY 1
ORDER BY 3 DESC;


-- how many items in rental table has been returned by customers
SELECT 
	CONCAT(first_name, ' ', last_name) AS full_name,
	COUNT(rental_id) AS number_items_rented, 
	SUM(CASE WHEN return_date IS NULL THEN 0 ELSE 1 END) AS number_items_returned,
	SUM(CASE WHEN return_date IS NULL THEN 1 ELSE 0 END) AS number_items_not_returned,
	ROUND(AVG(DATE_PART('day', return_date - rental_date)) :: NUMERIC,0) AS avg_days_rented
FROM rental
LEFT JOIN customer USING (customer_id)
GROUP BY 1;


-- if a customer repeats a rental
SELECT 
	title, 
	CONCAT(first_name, ' ', last_name) AS full_name ,
	COUNT(*) AS no_of_rental
FROM rental
LEFT JOIN inventory ON rental.inventory_id = inventory.inventory_id
LEFT JOIN film USING (film_id)
LEFT JOIN customer USING (customer_id)
GROUP BY 1,2
HAVING COUNT(*) >= 2
ORDER BY 3 DESC;


-- Which customer id did not pay for their rentals by month more than twice a month
SELECT  
	EXTRACT(MONTH FROM return_date) , 
	rental.customer_id, 
	COUNT(*)
FROM rental
LEFT JOIN payment USING (rental_id)
WHERE payment_date IS NULL
GROUP BY 1,2
HAVING COUNT(*) >= 2;


-- no of customers who did not pay for two or more items in a month
WITH cust_month_extract AS(
	SELECT  
		EXTRACT(MONTH FROM return_date) AS MONTH, 
		rental.customer_id, 
		COUNT(*) AS number_not_returned
	FROM rental
	LEFT JOIN payment USING (rental_id)
	WHERE payment_date IS null
	GROUP BY 1,2
	HAVING COUNT(*) >= 2
)

-- by month
SELECT 
	customer_id, 
	COALESCE(CASE WHEN MONTH = 2 THEN number_not_returned END, 0) AS number_not_returned_month2,
	COALESCE(CASE WHEN MONTH = 3 THEN number_not_returned END, 0) AS number_not_returned_month3,
	COALESCE(CASE WHEN MONTH = 4 THEN number_not_returned END, 0) AS number_not_returned_month4,
	COALESCE(CASE WHEN MONTH = 5 THEN number_not_returned END, 0) AS number_not_returned_month5,
	COALESCE(CASE WHEN MONTH = 6 THEN number_not_returned END, 0) AS number_not_returned_month6
FROM cust_month_extract
ORDER BY 1;


-- B. Rental Analysis
-- Statistical Analysis of rental_rate
SELECT 
	MIN(rental_rate) AS min_rental_rate, 
	MAX(rental_rate) AS max_rental_rate, 
	ROUND(AVG(rental_rate),2) AS avg_rental_rate, 
	ROUND(STDDEV(rental_rate),2) AS stddev_rental_rate, 
	ROUND(VARIANCE(rental_rate),2) AS var_rental_rate,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rental_rate) AS median_rental_rate
FROM film;

-- list of most rented films in each category
-- no of rentals by films
WITH film_no_of_rental AS(
	SELECT 
		film_id, 
		COUNT(rental_id) AS no_of_rentals
	FROM rental 
	LEFT JOIN inventory USING (inventory_id)
	LEFT JOIN film USING (film_id)
	GROUP BY 1
	ORDER BY 2 DESC),

movie_rank_over_category AS(
	SELECT 
		name, 
		film_id, 
		no_of_rentals, 
		DENSE_RANK() OVER( PARTITION BY name ORDER BY no_of_rentals DESC) movie_rank
	FROM film_no_of_rental
	LEFT JOIN film_category USING (film_id)
	LEFT JOIN category USING (category_id)
	)

SELECT 
	name,
	film_id, 
	no_of_rentals, 
	movie_rank
FROM movie_rank_over_category
WHERE movie_rank <= 3;

-- no of rentals by hour of day
SELECT 
	EXTRACT(HOUR FROM rental_date) AS hour_day, 
	COUNT(rental_id) AS no_of_rental 
FROM rental
GROUP BY 1
ORDER BY 1;

--no of rentals by day of week
SELECT 
	EXTRACT(ISODOW FROM rental_date) AS day_week,
	COUNT(rental_id) AS no_of_rental
FROM RENTAL
GROUP BY 1
ORDER BY 1;

-- average number of days a category was rented
SELECT 
	name, 
	ROUND(AVG(DATE_PART('day', return_date - rental_date)) :: NUMERIC , 1) AS avg_rental_days 
FROM rental
JOIN inventory USING (inventory_id)
JOIN film USING (film_id)
JOIN film_category USING (film_id)
JOIN category USING (category_id)
GROUP BY 1
ORDER BY 2 DESC;

-- average number of days a film title was rented
SELECT 
	title, 
	ROUND(AVG(DATE_PART('day', return_date - rental_date)) :: NUMERIC , 1) AS avg_rental_days 
FROM rental
JOIN inventory USING (inventory_id)
JOIN film USING (film_id)
GROUP BY 1
ORDER BY 2 DESC;


-- C. Revenue Analysis
-- Sum of Payments by Month
SELECT 
	DATE_PART('month', payment_date) AS month_payment_date,
	ROUND(SUM(amount), 2) AS total_payment_amount,
	ROUND(AVG(amount), 2) AS avg_payment_amount
FROM payment
GROUP BY 1
ORDER BY 1;


-- Total Revenue, Avg Revenue, No of transactions on a day-to-day
SELECT 
	DATE_TRUNC('day', payment_date) AS day_payment_date, 
	ROUND(SUM(amount), 2) AS total_revenue, 
	ROUND(AVG(amount), 2) AS avg_revenue,
	COUNT(*) AS no_of_transactions
FROM payment
GROUP BY 1
ORDER BY 1;


-- Month over month revenue
WITH monthly_payment AS (
	SELECT EXTRACT(MONTH FROM payment_date) AS month, 
		AVG(amount) AS avg_amount 
	FROM payment
	GROUP BY 1
	ORDER BY 1)

SELECT 
	current_mon.month, 
	ROUND(current_mon.avg_amount, 2) AS current_month_revenue,
	COALESCE(ROUND(previous_mon.avg_amount, 2),0) AS previous_month_revenue,
	COALESCE(ROUND((current_mon.avg_amount - previous_mon.avg_amount)/current_mon.avg_amount, 2),0) AS percent_monthly_change
FROM monthly_payment current_mon
LEFT JOIN monthly_payment previous_mon ON current_mon.month = previous_mon.month + 1;

-- cumulative revenue for each day of month
SELECT 
	DISTINCT DATE_TRUNC('day', payment_date), 
	SUM(amount) OVER(ORDER BY DATE_TRUNC('day', payment_date) )
FROM payment
ORDER BY 1


-- E.Inventory Analysis

-- Count of inventory by titles
SELECT 
	title, 
	COUNT(i.inventory_id) AS inventory_count
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY 1;

-- No of copies rented by month
SELECT 
	title,  
	EXTRACT(MONTH FROM rental_date) AS month, 
	COUNT(r.rental_id) AS no_of_copies_rented
FROM inventory i
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN film using (film_id)
GROUP BY 1,2
ORDER BY 1,2;

-- No of copies rented by month vs avg no of copies rented by title, filter for months where no of copies rented >
-- avg no of copies rented by title
WITH avg_copies_rented_cte AS (
	SELECT 
		title,  
		EXTRACT(MONTH FROM rental_date) AS month, 
		COUNT(r.rental_id) AS no_of_copies_rented,
		ROUND(AVG(COUNT(r.rental_id)) OVER(Partition by title), 2) as avg_copies_rented_title
	FROM inventory i
	JOIN rental r ON i.inventory_id = r.inventory_id
	JOIN film using (film_id)
	GROUP BY 1,2
	ORDER BY 1,2
	)

SELECT 
	title,  
	month, 
	no_of_copies_rented,
	avg_copies_rented_title
FROM avg_copies_rented_cte
WHERE no_of_copies_rented > avg_copies_rented_title 
ORDER BY 1,2;


-- F. Films with special features
SELECT 
	UNNEST(special_features) AS special_feature, 
	COUNT(*) AS no_of_film 
FROM film
GROUP BY 1;


-- Films by number of special features
SELECT 
	ARRAY_LENGTH(special_features, 1) AS number_special_feature, 
	special_features, 
	COUNT(film_id)
FROM film
GROUP BY 1,2
ORDER BY 1;

describe film

select rating, description
from film











