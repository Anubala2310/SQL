create database movies;
use movies;
-- import tables
show tables;
-- Q.1 Write a SQL query to find when the movie 'American Beauty' released. Return movie release year.
select *
from movie
where mov_title = 'American Beauty';

-- Q.2 Write a SQL query to find those movies, which were released before 1998. Return movie title.
select *
from movie
where mov_year < 1998;

-- Q.3 Write a query where it should contain all the data of the movies which were released after 1995 and their movie duration was greater than 120.
select *
from movie
where mov_year > 1995 and mov_time > 120;

-- Q.4 Write a query to determine the Top 7 movies which were released in United Kingdom. Sort the data in ascending order of the movie year.
select *
from movie
where mov_rel_country = 'UK'
order by mov_year asc
limit 7;

-- Q.5 Set the language of movie language as 'Chinese' for the movie which has its existing language as Japanese and the movie year was 2001.
select *
from movie
where mov_lang = 'Chinese' and mov_year = 2001;

update movie
set mov_lang = 'Japanese' 
where mov_lang = 'Chinese' and mov_year = 2001;

-- Q.6 Write a SQL query to find name of all the reviewers who rated the movie 'Slumdog Millionaire'.
select *
from reviewer r
join ratings s
using (rev_id)
join movie m
using(mov_id)
where mov_title like '%Slum%';

-- Q.7 Write a query which fetch the first name, last name & role played by the actor where output should all exclude Male actors.
select act_fname, act_lname, role, act_gender
from movie m
join cast c
using (mov_id)
right join  actor a
using (act_id)
where act_gender = 'F';

select act_gender, count(*)
from actor
group by act_gender;

select *
from actor
where act_gender = 'F';

-- Q.8 Write a SQL query to find the actors who played a role in the movie 'Annie Hall'. Fetch all the fields of actor table. (Hint: Use the IN operator).
select a.*
from movie m
join cast c
using (mov_id)
right join  actor a
using (act_id)
where mov_title in ('Annie Hall');

/*  Q.9 Write a SQL query to find those movies that have been released in countries other than the United Kingdom. 
Return movie title, movie year, movie time, and date of release, releasing country. */
select *
from movie
where mov_rel_country not in ('Uk');

-- Q.10 Print genre title, maximum movie duration and the count the number of movies in each genre. (HINT: By using inner join)
select gen_title, max(mov_time) as max_mov_time, count(gen_title) as genre
from movie m
join movie_genres g
using (mov_id)
join genres ge
using (gen_id)
group by gen_title;

-- Q.11 Create a view which should contain the first name, last name, title of the movie & role played by particular actor.
create view info
as (select act_fname, act_lname, mov_title, role from cast c join actor a using (act_id) join movie using (mov_id));

select *
from info;

-- Q.12 Write a SQL query to find the movies with the lowest ratings
select *
from movie m
join ratings r
using (mov_id)
order by rev_stars asc;