USE sakila;

# Create a query or queries to extract the information you think may be relevant for building the prediction model. It should include some film features and some rental features.

SELECT 	F.film_id, 
		F.release_year, 
        F.rental_duration, 
        F.rental_rate, 
        F.replacement_cost,
        F.length, 
        F.rating, 
        COUNT(R.rental_id) as num_rentals
FROM film F
LEFT JOIN inventory I USING (film_id)
LEFT JOIN rental R USING (inventory_id)
GROUP BY F.film_id; 

# Create a query to get the list of films and a boolean indicating if it was rented last month. This would be our target variable.

-- Example that works in MySQL but not Python
SELECT 	
	date_format(CONVERT(R.rental_date, date), '%Y') as rental_year,
	date_format(CONVERT(R.rental_date, date), '%M') as rental_month, 
	COUNT(rental_id) AS num_rentals
FROM film F
LEFT JOIN inventory I USING (film_id)
LEFT JOIN rental R USING (inventory_id)
GROUP BY rental_year, rental_month;


-- Example that works
WITH max_date as (SELECT 	F.film_id, 
        MAX(R.rental_date) as max_rental_date
FROM film F
LEFT JOIN inventory I USING (film_id)
LEFT JOIN rental R USING (inventory_id)
WHERE R.rental_date BETWEEN "2005-05-01 00:00:00" AND "2006-03-01 00:00:00"
GROUP BY F.film_id)
SELECT F.film_id, MD.max_rental_date AS rents_feb_2006
FROM (	SELECT film_id, max_rental_date 
		FROM max_date 
        WHERE max_rental_date BETWEEN "2006-02-01 00:00:00" AND "2006-03-01 00:00:00") 
        AS MD
RIGHT JOIN film F
USING (film_id);


SELECT * FROM rental;

-- this example doen't work as it doesn't count any of the null values
SELECT film_id, MONTH(rental_date) AS month, YEAR(rental_date) AS year
FROM film F
LEFT JOIN inventory I USING (film_id)
LEFT JOIN rental R USING (inventory_id)
WHERE MONTH(rental_date) = 02 
AND YEAR(rental_date) = 2006;