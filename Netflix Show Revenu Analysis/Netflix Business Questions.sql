-- 15 Business Problems & Solutions

1. Count the number of Movies vs TV Shows 
2. Find the most common rating for movies and TV shows
3. List all movies released in a specific yeaSr (e.g., 2020) 
4. Find the top 5 countries with the most content on Netflix
5. Identify the longest movie 
6. Find content added in the last 5 years 
7. Find all the movies/TV shows by director 'Rajiv Chilaka'! 
8. List all TV shows with more than 5 seasons 
9. CountS the number of content items in each genre 
10.Find each yearS and the average numbers of content release in India on netflix. 
return top 5 yearS with highest avg content release!
11. List all movies that are documentaries
12. Find all content without a director 
13. Find how many movies actor 'Salman Khan' appeared in last 10 years! 
14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. CountS how many items fall into each category.



1. Count the number of Movies vs TV Shows?
SELECT 
SUM(CASE WHEN (Movie)='Movie' then 1 ELSE 0 END) as MOVIE_COUNT,
SUM(CASE WHEN (Movie)='TV Show' then 1 ELSE 0 END) as TV_SHOW_COUNT
FROM dbo.netflix_titles;


2. Find the most common rating for movies and TV shows

SELECT 
COUNT(DISTINCT Rating) as r
FROM dbo.netflix_titles 
GROUP BY r

SELECT 
SUM(Rating) OVER()
from dbo.netflix_titles 
GROUP BY Rating

3. List all movies released in a specific year (e.g., 2020)
--A.Basic Where clause for filtering data
select 
Title
FROM dbo.netflix_titles 
where Release_Year= 2020 AND Movie='Movie'

--B.Using Sub-query
Select 
title 
From ( 
select 
Title
FROM dbo.netflix_titles 
where Release_Year= 2020 AND Movie='Movie'
) t

4. Find the top 5 countries with the most content on Netflix?

Select 
TOP 5 Countries,
COUNT(*) AS Content_Prouduced_country
FROM(
select 
*,
TRIM(value) as Countries
from 
dbo.netflix_titles
cross apply 
STRING_SPLIT(Country,',')
) T
GROUP BY Countries
ORDER BY Content_Prouduced_country DESC

5. Identify the longest movie

--A.Using Sub-Query
SELECT Title ,MAX(cast(tym as INT)) as val
FROM (
Select 
Title,
SUBSTRING(Duration, 1, CHARINDEX(' min', Duration)) as tym
FROM  dbo.netflix_titles
) t
GROUP BY Title
ORDER BY val desc

--B.Using CASE Statement
	SELECT 
    Title,
    CASE 
        WHEN CHARINDEX(' min', Duration) > 0 
        THEN CAST(SUBSTRING(Duration, 1, CHARINDEX(' min', Duration) - 1) AS INT)
        ELSE NULL
    END AS TYM
FROM 
    dbo.netflix_titles
	where Movie='Movie'
	order by TYM DESC

6. Find content added in the last 5 years

Select 
COUNT(*) AS Total_Movies_5_Years
From dbo.netflix_titles
WHERE Release_Date >=DATEADD(YEAR,-5,GETDATE())


7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

--A.Using where clause
select 
*
FROM dbo.netflix_titles
WHERE Director LIKE '%Rajiv Chilaka%'

--B.Using Substring method

SELECT 
    *
FROM 
    dbo.netflix_titles
WHERE 
    SUBSTRING(Director, CHARINDEX('Rajiv Chilaka', Director), LEN('Rajiv Chilaka')) = 'Rajiv Chilaka'

--C.Using String slpit method

select 
*
FROM (
SELECT 
Title,
value as Director_names
FROM dbo.netflix_titles
CROSS APPLY 
    STRING_SPLIT(Director, ',')
)t
WHERE Director_names='Rajiv Chilaka'


8. List all TV shows with more than 5 seasons
--A.Using Substring method
select 
Title,
CAST(SUBSTRING(Duration,1,charindex(' ',Duration)) AS INT) as Seasons5
FROM dbo.netflix_titles
WHERE CAST(SUBSTRING(Duration,1,charindex(' ',Duration)) AS INT) > 5 AND Movie='TV Show'

--B.Using Sub_Query
SELECT
Seasons5,Title
FROM ( select 
Title,
CAST(SUBSTRING(Duration,1,charindex(' ',Duration)) AS INT) as Seasons5
FROM dbo.netflix_titles
) t
WHERE t.Seasons5 >5
GROUP BY Title

9. Count the number of content items in each genre?

SELECT 
COUNT(*) as total_genre,
Genre
FROM ( 
SELECT Title,
TRIM(value) as Genre
FROM dbo.netflix_titles
CROSS APPLY
STRING_SPLIT(Listed_on,',')
)t
GROUP BY Genre
Order by total_genre desc;

--Genre corresponding to movie Title
SELECT 
  Genre,
  COUNT(*) OVER(PARTITION BY Genre) AS TOTAL_GEN,
    Title
FROM (
    SELECT 
        Title,
        TRIM(value) AS Genre
    FROM 
        dbo.netflix_titles
    CROSS APPLY 
        STRING_SPLIT(Listed_on, ',')
) AS t
order by TOTAL_GEN DESC


10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

SELECT 
  TOP 5  Release_Year, 
    AVG(content_count) AS avg_content_release
FROM (
    SELECT 
        Release_Year, 
        COUNT(Title) AS content_count
    FROM dbo.netflix_titles
    WHERE Country = 'India'
    GROUP BY Release_Year
) AS yearly_content
GROUP BY Release_Year
ORDER BY avg_content_release DESC

11. List all movies that are documentaries/docuseries
--A.Using like
SELECT 
Title
FROM dbo.netflix_titles
WHERE Listed_on LIKE '%documentaries%'

--B.Using String split method

SELECT 
* 
FROM ( 
SELECT Title,
Listed_on,
value as extraction
FROM dbo.netflix_titles
CROSS APPLY
STRING_SPLIT(Listed_on,',')
)t
where extraction='Docuseries'

12. Find all content without a director

SELECT *
FROM dbo.netflix_titles
WHERE Director is null

13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
EXEC sp_rename 'dbo.netflix_titles.Cast', 'Actors', 'COLUMN';
--A.Using LIKE
SELECT 
*
FROM dbo.netflix_titles
WHERE  Actors LIKE '%Salman Khan%'

--B.Using CTE and Sub_Query

SELECT 
Title 
FROM (
select 
Title,
Release_Year,
TRIM(value) as actor_name
from dbo.netflix_titles
cross apply  --give me list of all actors worked in a single movie
STRING_SPLIT(Actors,',') ) t
where actor_name ='Salman Khan'
AND Release_Year > YEAR(GETDATE()) - 10;    


14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
Select 
TOP 10 Indian_Actors,
COUNT(*) AS TOTAL_ACTOR
FROM(
select 
*,
TRIM(value) as Indian_Actors
from 
dbo.netflix_titles
cross apply 
STRING_SPLIT(Actors,',')
) T
GROUP BY Indian_Actors
ORDER BY TOTAL_ACTOR DESC

15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. CountS how many items fall into each category. 

--A.Using CASE Statement,string split to find list the words kill/violence and Sub_Query
SELECT 
    Distinct(COUNT(*))AS content_count,
    Movie,
    CASE 
        WHEN CRIME = 'kill' OR CRIME = 'violence' THEN 'Bad'
        ELSE 'Good'
    END AS category
FROM (
    SELECT 
        Movie,
        TRIM(value) AS CRIME
    FROM dbo.netflix_titles
    CROSS APPLY STRING_SPLIT(Story_Plot, ',')
) AS t
GROUP BY Movie,
CASE 
        WHEN CRIME = 'kill' OR CRIME = 'violence' THEN 'Bad'
        ELSE 'Good'
    END 

--B.Using case statement and sub_query
Select 
    category,
    Movie,
    COUNT(*) AS content_count
FROM (
    SELECT 
        *,
        CASE 
            WHEN LOWER(Story_Plot) LIKE '%kill%' OR LOWER(Story_Plot) LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM dbo.netflix_titles
) AS categorized_content
GROUP BY category, Movie
ORDER BY Movie

--C.Using Nested Aggreation case statement
SELECT 
    Movie,
    SUM(CASE WHEN LOWER(Story_Plot) LIKE '%kill%' OR LOWER(Story_Plot) LIKE '%violence%' THEN 1 ELSE 0 END) AS Bad_Count,
    SUM(CASE WHEN LOWER(Story_Plot) NOT LIKE '%kill%' AND LOWER(Story_Plot) NOT LIKE '%violence%' THEN 1 ELSE 0 END) AS Good_Count
FROM dbo.netflix_titles
GROUP BY Movie
ORDER BY Movie;
