-- Write SQL queries to perform the following tasks using the Sakila database:
use sakila;

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
select count(i.film_id) as number_of_copies
from inventory i
where i.film_id = (select f.film_id
				   from film f
                   where f.title = "Hunchback Impossible");
                   
-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
select f1.title as longer_as_average
from film f1
where f1.length > (select avg(f2.length)
				   from film f2);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
select *
from actor a
where a.actor_id in (select fa.actor_id
					from film_actor fa
                    where fa.film_id = (select f.film_id
										from film f
										where f.title = "Alone Trip"));


-------- Bonus: -------------

-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. 
-- Identify all movies categorized as family films.
select f.title as title_of_family_film
from film f
where f.film_id in (select fc.film_id
				   from film_category fc
				   where fc.category_id = (select c.category_id
										   from category c
										   where c.name = 'Family'));

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. 
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.
select cu.first_name, cu.last_name, cu.email
from customer cu
where cu.address_id in (select a.address_id
						from address a 
						where a.city_id in (select ci.city_id
											from city ci
											where ci.country_id = (select co.country_id
																   from country co
																   where co.country = 'Canada')));

select cu.first_name, cu.last_name, cu.email
from customer cu
join address a  on cu.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id
where co.country = 'Canada';

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. 
-- A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the 
-- different films that he or she starred in.
select f.title
from film f
where f.film_id in (select fa.film_id
					from film_actor fa
					where fa.actor_id = (select a.actor_id
										 from actor a
										 join film_actor fa on a.actor_id = fa.actor_id
										 group by a.actor_id
						                  order by count(fa.film_id) desc
										 limit 1));



----------------------------------------------------------------------------------

-- 7.Find the films rented by the most profitable customer in the Sakila database.
-- You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made
-- the largest sum of payments.

SELECT f.film_id, f.title, c.customer_id
FROM sakila.customer AS c
JOIN sakila.rental AS r USING (customer_id)
JOIN sakila.inventory AS i USING (inventory_id)
JOIN sakila.film AS f USING (film_id)
WHERE c.customer_id = (
    SELECT c.customer_id
    FROM sakila.customer AS c
    JOIN sakila.payment AS p USING (customer_id)
    GROUP BY c.customer_id
    ORDER BY SUM(p.amount) DESC
    LIMIT 1
);

-- 8.Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount
-- spent by each client. You can use subqueries to accomplish this.

SELECT c.customer_id AS client_id, SUM(p.amount) AS total_amount_spent
FROM sakila.customer AS c
JOIN sakila.payment AS p USING (customer_id)
GROUP BY c.customer_id
HAVING SUM(p.amount) > (SELECT AVG(total_amount_spent) AS average_total_amount
                       FROM (
                           SELECT c.customer_id, SUM(p.amount) AS total_amount_spent
                           FROM sakila.customer AS c
                           JOIN sakila.payment AS p USING (customer_id)
                           GROUP BY c.customer_id) AS customer_total_amount);