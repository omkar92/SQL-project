-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows

select a.type, count(a.type) from netflix a 
group by a.type;



--2. Find the most common rating for movies and TV shows
with moviecount as 
(select a.type,
a.rating,
count(*),
RANK() OVER(PARTITION BY a.type ORDER BY count(*) desc) as ranking
from netflix a 
group by a.type,a.rating)

select b.type,b.rating from moviecount b where ranking = 1 
;



--3. List all movies released in a specific year (e.g., 2020)

select a.release_year,a.title
from netflix a
where a.type = 'Movie'
and 
release_year = 2020;

--4. Find the top 5 countries with the most content on Netflix

select unnest(string_to_array(country,',') )as new_country,
count(show_id)
from netflix
group by new_country
order by 2 desc
limit 5;



--5. Identify the longest movie

select * from netflix 
where netflix.type = 'Movie'
and
duration = (select max(duration) from netflix) ;

--6. Find content added in the last 5 years

select * ,
to_date(date_added,'Month DD,YYYY') as date_new_added
from netflix
where 
to_date(date_added,'Month DD,YYYY') >= current_date - INTERVAL '5 years';



--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * from netflix where director ilike '%Rajiv Chilaka%';


--8. List all TV shows with more than 5 seasons

select title, 
split_part(duration,' ',1)::INT as seasons
from netflix 
where type = 'TV Show'
and split_part(duration,' ',1)::INT > 5
group by title,duration;



--9. Count the number of content items in each genre

select unnest(string_to_array(listed_in,',')) as category,count(show_id) 
from netflix 
group by category;

--10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

select release_year,
count(*) as no_of_releases,

round(count(*)/(select count(show_id) from netflix where country ='India')::numeric *100,2) as avg_release from netflix 
where country = 'India'
group by release_year
order by 3 desc
limit 5;





--11. List all movies that are documentaries
select * from netflix
where type = 'Movie'
and listed_in ilike '%Documentaries%';

--12. Find all content without a director

select * from netflix
where director is null ;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix
where casts like '%Salman Khan%'
and
release_year > extract(year from current_date ) - 10;


--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select unnest(string_to_array(casts,',')) as actor,count(*) as number_of_movies from netflix
where type = 'Movie'
group by actor
order by 2 desc
limit 10;



/*15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/

select *,
case 
when description ilike '%kill%' or description ilike '%violence%' then 'bad'
else 'good'
end as category


from netflix  
;




