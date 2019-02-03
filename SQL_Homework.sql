USE sakila;

-- 1a.
SELECT first_name, last_name
FROM actor;

-- 1b.
SELECT CONCAT(first_name, ' ' , last_name) as 'Actor Name'
FROM actor;

-- 2a.
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

-- 2b.
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name like '%GEN%';

-- 2c.
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name like '%LI%'
ORDER BY last_name, first_name;

-- 2d.
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a.
SELECT * FROM actor;
ALTER TABLE actor
ADD COLUMN description VARCHAR(50) AFTER last_name;
ALTER TABLE actor
MODIFY COLUMN description BLOB;

-- 3b.
ALTER TABLE actor
DROP COLUMN description;

-- 4a.
SELECT last_name, COUNT(*) AS 'number_of_actors'
FROM actor
GROUP BY last_name;

-- 4b.
SELECT last_name, COUNT(*) AS 'number_of_actors'
FROM actor
GROUP BY last_name
HAVING COUNT(*) >= 2;

-- 4c.
UPDATE actor
SET first_name = 'HARPO'
WHERE last_name = 'WILLIAMS' AND first_name = 'GROUCHO';

SELECT last_name, first_name
FROM actor
WHERE last_name = 'WILLIAMS' AND first_name = 'HARPO';

-- 4d.
UPDATE actor
SET first_name = 'GROUCHO'
WHERE last_name = 'WILLIAMS' AND first_name = 'HARPO';

SELECT last_name, first_name
FROM actor
WHERE last_name = 'WILLIAMS' AND first_name = 'GROUCHO';

-- 5a.
DESCRIBE sakila.address;

-- 6a.
SELECT first_name, last_name, address
FROM staff s
JOIN address a
ON s.address_id = a.address_id;

-- 6b.
SELECT payment.staff_id, staff.first_name, staff.last_name, payment.payment_date, payment.amount
FROM staff
INNER JOIN payment
ON staff.staff_id = payment.staff_id AND payment_date LIKE '2005-08%';

-- 6c.
SELECT f.title AS 'film_title', COUNT(a.actor_id) AS `number_of_actors`
FROM film_actor a
INNER JOIN film f 
ON f.film_id = a.film_id
GROUP BY f.title;

-- 6d.
SELECT title, (SELECT COUNT(*) FROM inventory WHERE film.film_id = inventory.film_id) AS 'number_of_copies'
FROM film
WHERE title = "Hunchback Impossible";

-- 6e.
SELECT p.customer_id, c.last_name, SUM(amount) AS `total_amount_paid`
FROM payment p
JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY customer_id
ORDER BY c.last_name;

-- 7a.
SELECT f.title, l.name
FROM film f
JOIN language l
ON l.language_id = f.language_id
WHERE l.language_id = 1 AND title LIKE 'K%' OR 'Q%';

-- 7b.
SELECT * FROM film WHERE title = 'Alone Trip';
SELECT * FROM film_actor;
SELECT * FROM actor;
SELECT f.title, a.actor_id, x.first_name, x.last_name
FROM film_actor a
JOIN film f ON a.film_id = f.film_id
JOIN actor x ON a.actor_id = x.actor_id
WHERE title = 'Alone Trip';

-- 7c.
SELECT * FROM address;
SELECT * FROM city;
SELECT * FROM country;
SELECT * FROM customer;

SELECT c.first_name, c.last_name, c.email, country.country
FROM city
JOIN country ON city.country_id = country.country_id
JOIN address a ON city.city_id = a.city_id
JOIN customer c ON a.address_id = c.address_id
WHERE country.country = 'Canada';

-- 7d.
SELECT * FROM category;
SELECT * FROM film;
SELECT * FROM film_category;

SELECT c.name, film.title
FROM category c
JOIN film_category f ON c.category_id = f.category_id
JOIN film ON f.film_id = film.film_id
WHERE c.name = "Family";

-- 7e.
SELECT f.title, COUNT(rental_id) AS 'total_rented'
FROM rental r
JOIN inventory i ON (r.inventory_id = i.inventory_id)
JOIN film f ON (i.film_id = f.film_id)
GROUP BY f.title
ORDER BY `total_rented` DESC;

-- 7f.
SELECT s.store_id, SUM(amount) AS 'total_sales'
FROM payment p
JOIN rental r ON (p.rental_id = r.rental_id)
JOIN inventory i ON (i.inventory_id = r.inventory_id)
JOIN store s ON (s.store_id = i.store_id)
GROUP BY s.store_id; 

-- 7g.
SELECT s.store_id, city.city, country.country 
FROM store s
JOIN address a ON (s.address_id = a.address_id)
JOIN city ON (city.city_id = a.city_id)
JOIN country ON (country.country_id = city.country_id);

-- 7h.
SELECT c.name AS 'genre', SUM(p.amount) AS 'gross_revenue' 
FROM category c
JOIN film_category f  ON (c.category_id = f.category_id)
JOIN inventory i  ON (f.film_id = i.film_id)
JOIN rental r  ON (i.inventory_id = r.inventory_id)
JOIN payment p ON (r.rental_id = p.rental_id)
GROUP BY c.name ORDER BY gross_revenue LIMIT 5;

-- 8a.
CREATE VIEW top_five_generes_gross_revenue AS
SELECT c.name AS 'genre', SUM(p.amount) AS 'gross_revenue' 
FROM category c
JOIN film_category f ON (c.category_id = f.category_id)
JOIN inventory i ON (f.film_id = i.film_id)
JOIN rental r ON (i.inventory_id = r.inventory_id)
JOIN payment p ON (r.rental_id = p.rental_id)
GROUP BY c.name ORDER BY gross_revenue LIMIT 5;

-- 8b.
SELECT * FROM top_five_genres_gross_revenue

-- 8c.
DROP VIEW top_five_genres_gross_revenue