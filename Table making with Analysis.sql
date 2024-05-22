/* Make Raw Table with suitable length and Data type*/
CREATE TABLE [dbo].[netflix_raw](
	[show_id] [varchar](10) primary key,
	[type] [varchar](10) NULL,
	[title] [nvarchar](200) NULL,
	[director] [varchar](250) NULL,
	[cast] [varchar](1000) NULL,
	[country] [varchar](150) NULL,
	[date_added] [varchar](20) NULL,
	[release_year] [int] NULL,
	[rating] [varchar](10) NULL,
	[duration] [varchar](10) NULL,
	[listed_in] [varchar](100) NULL,
	[description] [varchar](500) NULL
) 
GO

/* Make original table after cleaning */
with cte as(
select *
, ROW_NUMBER()over(partition by title, type order by show_id) as rn
from netflix_raw
)
select show_id, type,title, cast(date_added as date) as date_added, release_year, rating,
case when duration is null then rating else duration end as duration
,description
into netflix
from cte

/* Make different tables for columns which has more than 1 value */
select show_id, trim(value) as genre
into netflix_genre
from netflix_raw
cross apply string_split(listed_in,',')

select show_id, trim(value) as director
into netflix_directors
from netflix_raw
cross apply string_split(director,',')

select show_id, trim(value) as cast
into netflix_cast
from netflix_raw
cross apply string_split(cast,',')

select show_id, trim(value) as country
into netflix_country
from netflix_raw
cross apply string_split(country,',')

/*1 for each director, count the no of movies and tv shows created by them in separate columns, 
for directors who have created tv shows and movies both */
select nd.director
, COUNT(Distinct(case when n.type = 'Movie' then n.show_id end)) as no_of_movies
, COUNT(Distinct(case when n.type = 'TV Show' then n.show_id end)) as no_of_tvshow
from netflix n
inner join netflix_directors nd 
on n.show_id = nd.show_id
group by nd.director
having count(distinct n.type) > 1
order by no_of_movies desc 

/*2 Which country has highest number of comedy movies? */
select top 1 nc.country, count(distinct ng.show_id) as no_of_movies
from netflix_genre ng
inner join netflix_country nc
on ng.show_id = nc.show_id
inner join netflix n
on ng.show_id = n.show_id
where ng.genre = 'Comedies'
and n.type = 'Movie'
group by nc.country
order by no_of_movies desc

/*3 For each year (as per date added to netflix), which director has maximum number of movies released */
with cte as(
select  nd.director, YEAR(date_added) as date_year,  count(distinct n.show_id) as no_of_movies
from netflix n
inner join netflix_directors nd
on n.show_id = nd.show_id
where n.type =  'Movie'
group by nd.director,YEAR(date_added)
),
cte2 as (
select * 
, ROW_NUMBER() over(partition by date_year order by no_of_movies desc, director) as rn
from cte
)
select* from cte2 where rn = 1

/*4 What is average duration of Movies in each genre? */
select ng.genre , avg(cast(replace(duration,' min','')as int))as avg_duration_in_mins
from netflix n
inner join netflix_genre ng 
on n.show_id = ng.show_id
where type = 'Movie'
group by ng.genre
order by 2 desc

/*5 Find the list of directors who have created horror and comedy movies both.
Display director names along with numbers of comedy and horror movies directed by them. */
select nd.director
, count(distinct case when ng.genre = 'Comedies' then n.show_id end) as no_of_comedy
, count(distinct case when ng.genre = 'Horror Movies' then n.show_id end) as no_of_horror
from netflix n
inner join netflix_genre ng 
on n.show_id = ng.show_id
inner join netflix_directors nd
on n.show_id = nd.show_id
where type = 'Movie' and ng.genre in ('Comedies', 'Horror Movies')
group by nd.director
having COUNT(distinct ng.genre) = 2