-- 1a Display the first and last names of all actors from the table `actor`.
SELECT first_name,last_name FROM actor;
-- 1b Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT CONCAT(first_name,' ',last_name) AS Actor_Name FROM actor;
-- 2a Find the ID#, first name, and last name of an actor, of whom you know only the first name, "Joe." 
SELECT * FROM actor WHERE first_name LIKE 'Joe%'; 
-- 2b Find all actors whose last name contain the letters `GEN`:
SELECT * FROM actor WHERE last_name LIKE 'GEN%';
-- 2c Find all actors whose last names contain the letters `LI`. This time, order the rows by last name 
SELECT * FROM actor WHERE last_name LIKE '%LI%' order by last_name;
-- 2d Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China
SELECT * FROM Country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
-- 3a Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`
Alter Table actor
ADD middle_name varchar(30) AFTER first_name;
-- 3b You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.
ALTER TABLE actor 
MODIFY COLUMN middle_name BLOB;
-- 3c Now delete the middle_name column.
ALTER TABLE actor
DROP COLUMN middle_name;
-- 4a List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) AS counts
FROM actor
GROUP BY last_name
ORDER BY COUNT(last_name) DESC;
-- 4b List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) counts
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >=2
ORDER BY COUNT(last_name);
-- 4c The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`
SELECT * FROM actor;
UPDATE actor
SET first_name = 'HARPO' 
WHERE actor_id = 172;
UPDATE actor SET first_name ='GROUCHO' WHERE actor_id = 172;
UPDATE actor
SET first_name = 
CASE 
	WHEN first_name = 'HARPO' 
	THEN 'GROUCHO'
    ELSE 'GROUCHO'
END
WHERE actor_id = 172;

-- 5a You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE sakila.address;
-- 6a
SELECT first_name, last_name, address FROM staff 
INNER JOIN address 
    ON staff.address_id = address.address_id;
    
-- 6b total rung up in 2005, table payment and staff
SELECT first_name, last_name, SUM(amount) FROM payment p
INNER JOIN staff s
    ON s.staff_id = p.staff_id
GROUP BY p.staff_id
ORDER BY last_name ASC;

-- 6c list each film and the number of actors in that film, table film & film_actor
SELECT title, count(actor_id) FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY title;
 
-- 6d how many copies of "h" in inventory?
SELECT title, COUNT(inventory_id)
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
WHERE title = "Hunchback Impossible";

-- 6e total paid by each customer and order by customer's last name
SELECT first_name, last_name, SUM(amount) FROM payment p
INNER JOIN customer c ON p.customer_id = c.customer_id
GROUP BY p.customer_id
ORDER BY last_name ASC;
    
-- 7a select starting k & q mSELECT title FROM film
SELECT title FROM film
WHERE language_id in
	(SELECT language_id 
	FROM language
	WHERE name = "English" )
AND (title LIKE "K%") OR (title LIKE "Q%"); 

-- 7b use subquery to request all actors in "", table are film,film_actor and actor
SELECT last_name, first_name FROM actor
WHERE actor_id in
	(SELECT actor_id FROM film_actor
	WHERE film_id in 
		(SELECT film_id FROM film
		WHERE title = "Alone Trip"));
-- 7c email campaign in Canada
SELECT country, last_name, first_name, email FROM country c
LEFT JOIN customer cu ON c.country_id = cu.customer_id
WHERE country = 'Canada';

-- 7d all movies that are Family category
SELECT title, category FROM film_list
WHERE category = 'Family';

-- 7e most frequently rented movies DESC
SELECT i.film_id, f.title, COUNT(r.inventory_id) AS most_rented 
FROM inventory i
INNER JOIN rental r ON i.inventory_id = r.inventory_id
INNER JOIN film_text f ON i.film_id = f.film_id
GROUP BY r.inventory_id
ORDER BY COUNT(r.inventory_id) DESC;

-- 7f how much money each store brought in
SELECT store.store_id, SUM(amount) FROM store
INNER JOIN staff ON store.store_id = staff.store_id
INNER JOIN payment p  ON p.staff_id = staff.staff_id
GROUP BY store.store_id
ORDER BY SUM(amount);

-- 7g 
SELECT s.store_id, city, country FROM store s
INNER JOIN customer cu ON s.store_id = cu.store_id
INNER JOIN staff st ON s.store_id = st.store_id
INNER JOIN address a ON cu.address_id = a.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country coun ON ci.country_id = coun.country_id;

-- 7h the top five genres in gross revenue in descending order
SELECT name, SUM(p.amount) AS gross_revenue FROM category c 
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN inventory i ON i.film_id = fc.film_id
INNER JOIN rental r ON r.inventory_id = i.inventory_id
INNER JOIN payment p ON r.customer_id = p.customer_id
GROUP BY name 
ORDER BY gross_revenue DESC
LIMIT 5;

-- 8a Use the solution above to create a view. 
CREATE VIEW top_five_gross_genres AS 
SELECT name, SUM(p.amount) AS gross_revenue FROM category c 
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN inventory i ON i.film_id = fc.film_id
INNER JOIN rental r ON r.inventory_id = i.inventory_id
INNER JOIN payment p ON r.customer_id = p.customer_id
GROUP BY name 
ORDER BY gross_revenue DESC
LIMIT 5;


-- 8a How would you display the view that you created in 8a?
SELECT * FROM top_five_gross_genres;

-- 8b Write a query to delete top_five_genres
DROP VIEW top_five_gross_genres;
