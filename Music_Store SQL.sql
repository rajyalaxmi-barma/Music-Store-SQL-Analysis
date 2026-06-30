-- Create Database
create database Music_Store_data;
use Music_Store_data;

desc employee;
select *from employee;
-- 1.Who is the senior most employee based on job title?
select *from employee order by levels desc limit 1;

-- 2.Which countires have the most invoices?
select billing_country, COUNT(invoice_id) as total_invoices
from Invoice
group by billing_country
order by total_invoices DESC;

-- 3.What are the top 3 values of total invoice?
select billing_country, COUNT(invoice_id) as total_invoices
from Invoice
group by billing_country
order by total_invoices DESC
limit 3;

-- 4.-- Which city has the best customers? - We would like to throw a promotional Music Festival inthe city we made the most money. Write a query that returns one city that has the highest sum ofinvoice totals. Return both the city name & sum of all invoice totals
select billing_city,SUM(total) as total_revenue
from Invoice
group by billing_city
order by total_revenue DESC
limit 2;

-- 5.-- Who is the best customer? - The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money
select c.first_name,c.last_name,sum(i.total) as money_spent
from customer as c 
join invoice as i
on c.customer_id=i.customer_id
group by c.customer_id,c.first_name,c.last_name
order by money_spent desc
limit 1;

-- 6. Write a query to return the email, first name, last name, & Genre of all Rock Music listeners.Return your list ordered alphabetically by email starting with A
select c.email, c.first_name,c.last_name,g.name
from customer as c
join invoice as i
on c.customer_id=i.customer_id
join invoice_line as il
on i.invoice_id=il.invoice_id
join track as t
on il.track_id=t.track_id
join genre as g
on t.genre_id=g.genre_id
where g.name="Rock"
order by c.email asc;

-- 7. Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands
select a.name,count(t.track_id) as total_track
from artist as a
join album as b
on a.artist_id=b.artist_id
join track as t
on b.album_id=t.album_id
join genre as g
on t.genre_id=g.genre_id
where g.name="Rock"
group by a.artist_id,a.name
order by total_track desc
limit 10;

-- 8. Return all the track names that have a song length longer than the average song length.-Return the Name and Milliseconds for each track. Order by the song length, with the longestsongs listed first
select name,milliseconds
from track
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc
limit 10;

-- 9.Find how much amount is spent by each customer on artists? Write a query to return customer name, artist name and total spent
select c.first_name,c.last_name,ar.name,sum(il.unit_price * il.quantity) as money_price
from customer as c
join invoice as i
on c.customer_id=i.customer_id
join invoice_line as il
on i.invoice_id=il.invoice_id
join track as t
on il.track_id=t.track_id
join album as al
on t.album_id=al.album_id
join artist as ar
on al.artist_id=ar.artist_id
group by ar.artist_id,c.customer_id,c.first_name,c.last_name,ar.name
limit 5;

-- 10.We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returnseach country along with the top Genre. For countries where the maximum number of purchasesis shared, return all Genres
select g.name,c.country,count(il.quantity) as highest_purchases
from customer as c
join invoice as i
on c.customer_id=i.customer_id
join invoice_line as il
on i.invoice_id=il.invoice_id
join track as t
on il.track_id=t.track_id
join genre as g
on t.genre_id=g.genre_id
group by g.genre_id,g.name,c.country
order by highest_purchases desc
limit 10;

-- 11.
select country,first_name,last_name,total_spent
from (
    select c.country,c.first_name,c.last_name,SUM(i.total) AS total_spent,
           RANK() OVER (
               PARTITION BY c.country
               order by SUM(i.total) desc
           ) as spending_rank
    from Customer c
    join Invoice i
	on c.customer_id = i.customer_id
    group by c.country, c.customer_id, c.first_name, c.last_name
) ranked_customers
where spending_rank = 1
order by country
limit 5;

