SELECT * 
FROM sys.objects 
WHERE name = 'TV';

IF OBJECT_ID('TV', 'U') IS NOT NULL  -- 'U' is for tables; use 'V' for views
BEGIN
    DROP TABLE TV;
END;

WITH TV_SHOWS AS (
select *
from dbo.netflix_titles as n
where n.Movie = 'TV Show'
)

SELECT * INTO TV FROM TV_SHOWS