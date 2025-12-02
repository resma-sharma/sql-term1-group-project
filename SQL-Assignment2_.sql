#Q1 — Rentals per film + quartiles
With film_rentals As(
Select i.film_id, COUNT(*) As rental_count
From rental r
Join inventory i ON r.inventory_id = i.inventory_id
Group by  i.film_id
)
Select f.title,
    fr.rental_count,
      NTILE(4) OVER (ORDER BY fr.rental_count) AS quartile
      From film_rentals fr
      Join film f ON f.film_id = fr.film_id
      Order by fr.rental_count DESC,f.title;

#Q2 — Films with rental_rate above their category average
Select *
from( Select c.name As category_name, 
f.title  As film_title,
f.rental_rate,
Avg(f.rental_rate) over (partition BY c.category_id) As category_avg_rate
from film f
join film_category fc ON fc.film_id = f.film_id
join category c  ON c.category_id = fc.category_id
)t
where t.rental_rate > t.category_avg_rate
order by t.category_name,t.rental_rate DESC,t.film_title;

#Q3 — Rank films by replacement cost within each language (desc)
SELECT 
f.title As  film_title,
l.name As language_name,
 f.replacement_cost,
 Dense_rank() Over(partition by f.language_id
 order by f.replacement_cost DESC )
 As cost_rank_in_language
 from film f join language l ON l.language_id = f.language_id
 order by l.name, cost_rank_in_language,f.title;     
       

#Q4 — Days between consecutive rentals per customer
WITH rentals AS (
  SELECT
    r.customer_id,
    r.rental_id,
    r.rental_date,
    LAG(r.rental_date) OVER (
      PARTITION BY r.customer_id
      ORDER BY r.rental_date, r.rental_id   -- tie-breaker for same-day rentals
    ) AS prev_rental_date
  FROM rental r
)
SELECT
  t.customer_id,
  CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
  t.rental_id,
  t.rental_date,
  t.prev_rental_date AS previous_rental_date,
  DATEDIFF(t.rental_date, t.prev_rental_date) AS days_since_previous
FROM rentals t
JOIN customer c ON c.customer_id = t.customer_id
WHERE t.prev_rental_date IS NOT NULL
ORDER BY t.customer_id, t.rental_date;

#Q5 — Top 10 categories by total rental count
SELECT c.name AS category_name,
       COUNT(*) AS total_rentals
FROM rental r
JOIN inventory i     ON i.inventory_id = r.inventory_id
JOIN film f          ON f.film_id = i.film_id
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c       ON c.category_id = fc.category_id
GROUP BY c.category_id, c.name
ORDER BY total_rentals DESC, c.name
LIMIT 10;


