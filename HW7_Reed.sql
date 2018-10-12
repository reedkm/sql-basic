/*
Kenneth Reed
HW7 - SQL
*/

use sakila;

-- 1a. Display the first and last names of all actors from the table `actor`.

select first_name, last_name
from actor;

/*
code to output .csv in sq, no column header; ran once for output
*/

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-1a.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.

select upper(concat(a.first_name, ' ', a.last_name)) as 'Actor Name'
from actor as a;

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-1b.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

-- If the actor is definitely JOE:

select actor_id, first_name, last_name
from actor
where first_name = 'JOE';

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-2a1.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- In case the actor is listed as 'JOSEPH' or some other spelling:

select actor_id, first_name, last_name
from actor
where first_name like 'JO%';

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-2a2.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 2b. Find all actors whose last name contain the letters `GEN`:

select actor_id, first_name, last_name
from actor
where last_name like '%GEN%';

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-2b.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:

select actor_id, first_name, last_name
from actor
where last_name like '%LI%'
order by last_name, first_name;

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-2c.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:

select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-2d.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).

alter table actor
add description blob;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.

alter table actor
drop description;

-- 4a. List the last names of actors, as well as how many actors have that last name.

select last_name, count(last_name) as 'Last Name Count w/Same Name'
from actor
group by last_name;

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-4a.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.

select last_name, count(last_name) as 'Last Name Count Over 1'
from actor
group by last_name
having count(last_name) > 1;

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-4b.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.

update actor
set first_name = 'HARPO'
where (first_name = 'GROUCHO') and (last_name = 'WILLIAMS');

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.

update actor
set first_name = 'GROUCHO'
where (first_name = 'HARPO') and (last_name = 'WILLIAMS');

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?

describe address;

-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

select a.first_name, a.last_name, b.address, b.address2, c.city, b.postal_code
from staff as a
inner join address b on a.address_id = b.address_id
inner join city c on b.city_id = c.city_id;

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-6a.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.

select a.last_name as 'Staff', sum(b.amount) as 'Total Aug 2005'
from staff as a
inner join payment b on a.staff_id = b.staff_id
where date_format(b.payment_date, '%Y-%m') = '2005-08'
group by a.last_name;

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-6b.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

select a.title as 'Title', count(b.actor_id) as 'Actor Count'
from film as a
inner join film_actor b on a.film_id = b.film_id
group by a.title;

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-6c.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

select a.title as 'Title', count(b.inventory_id) as 'Inventory Count'
from film as a
inner join inventory b on a.film_id = b.film_id
where a.title = 'Hunchback Impossible';

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-6d.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:

select a.first_name, a.last_name, sum(b.amount) as 'Total Amount Paid'
from customer as a
inner join payment b on a.customer_id = b.customer_id
group by a.first_name, a.last_name
order by a.last_name;

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-6e.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.

select a.title
from film as a
where (a.title like 'K%') or (a.title like 'Q%') and (a.language_id) in
(
	select b.language_id
    from language as b
    where b.name = 'English'
);

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-7a.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

select a.first_name, a.last_name
from actor as a
where actor_id in
(
	select b.actor_id
	from film_actor as b
	where film_id in
	(
		select c.film_id
		from film as c
		where title = 'Alone Trip'
	)
);

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-7b.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

select a.first_name, a.last_name, a.email, d.country
from customer as a
inner join address b on a.address_id = b.address_id
inner join city c on b.city_id = c.city_id
inner join country d on c.country_id = d.country_id
where d.country = 'Canada';

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-7c.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.

select a.title, c.name
from film as a
inner join film_category as b on a.film_id = b.film_id
inner join category as c on b.category_id = c.category_id
where c.name = 'Family';

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-7d.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 7e. Display the most frequently rented movies in descending order.

select a.title, count(c.rental_id) as 'Top Rented'
from film as a
inner join inventory as b on a.film_id = b.film_id
inner join rental as c on b.inventory_id = c.inventory_id
group by a.title
order by count(c.rental_id) desc;

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-7e.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 7f. Write a query to display how much business, in dollars, each store brought in.

select a.store_id, sum(d.amount) as 'Total Sales'
from store as a
inner join inventory as b on a.store_id = b.store_id
inner join rental as c on b.inventory_id = c.inventory_id
inner join payment as d on c.rental_id = d.rental_id
group by a.store_id;

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-7f.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 7g. Write a query to display for each store its store ID, city, and country.

select a.store_id, c.city, d.country
from store as a
inner join address as b on a.address_id = b.address_id
inner join city as c on b.city_id = c.city_id
inner join country as d on c.country_id = d.country_id;

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-7g.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select a.name, sum(e.amount) as 'Top 5 Genres'
from category as a
inner join film_category as b on a.category_id = b.category_id
inner join inventory as c on b.film_id = c.film_id
inner join rental as d on c.inventory_id = d.inventory_id
inner join payment as e on d.rental_id = e.rental_id
group by a.name
order by sum(e.amount) desc limit 5;

/*
into outfile '/Users/ken_r/Documents/secureOutput/HW7-7h.csv'
fields terminated by ','
lines terminated by '\n';
*/

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

create view top5genreView as
(
select a.name, sum(e.amount) as 'Top 5 Genres'
from category as a
inner join film_category as b on a.category_id = b.category_id
inner join inventory as c on b.film_id = c.film_id
inner join rental as d on c.inventory_id = d.inventory_id
inner join payment as e on d.rental_id = e.rental_id
group by a.name
order by sum(e.amount) desc limit 5
);

-- 8b. How would you display the view that you created in 8a?

select * from sakila.top5genreview;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.

drop view sakila.top5genreview;


