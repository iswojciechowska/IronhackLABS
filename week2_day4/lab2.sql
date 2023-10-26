use sakila;

-- 1. List the number of films per category.

select c.name as name_of_category, COUNT(c.category_id) as 'number_of_films'
from category c
join film_category fc
on c.category_id = fc.category_id
join film f
on fc.film_id = f.film_id
group by c.category_id;

-- 2. Retrieve the store ID, city, and country for each store.

select s.store_id, ct.city, c.country
from store s
join address ad
on s.address_id = ad.address_id
join city ct
on ad.city_id = ct.city_id
join country c
on ct.country_id = c.country_id;

-- 3. Calculate the total revenue generated by each store in dollars.

select i.store_id, concat(sum(p.amount),' $') as total_revenue
from payment p
join rental r on p.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
group by i.store_id;

-- 4. Determine the average running time of films for each category.

select c.name as category_name, avg(f.length) as average_length
from category c
join film_category fc on c.category_id = fc.category_id
join film f on fc.film_id = f.film_id
group by c.name;

-- 5. Identify the film categories with the longest average running time.

select c.name as category_name, round(avg(f.length),2) as average_length
from category c
join film_category fc on c.category_id = fc.category_id
join film f on fc.film_id = f.film_id
group by c.name
order by average_length desc
limit 5;

-- 6. Display the top 10 most frequently rented movies in descending order.

select f.title as movie_title, count(r.rental_id) as times_rented
from film f 
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
group by f.title
order by count(r.rental_id) desc
limit 10;

-- 7. Determine if "Academy Dinosaur" can be rented from Store 1.

select f.title, i.store_id 
from inventory i 
join film f on i.film_id = f.film_id
join rental r on i.inventory_id = r.inventory_id
where f.title = 'Academy Dinosaur'
group by f.title, i.store_id
order by i.store_id ;

--  8 Provide a list of all distinct film titles, along with their availability status in the inventory. Include a column indicating whether
-- each title is 'Available' or 'NOT available.' Note that there are 42 titles that are not in the inventory, and this information
-- can be obtained using a CASE statement combined with IFNULL."

select distinct(f.title),
case
   when i.film_id is null then 'NOT available'
   else 'Available'
end
as 'status'
from film f
left join inventory i
on f.film_id = i.film_id
