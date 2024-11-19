EXEC sp_rename 'dbo.netflix_titles.type', 'Type(Movie/TV Show)', 'COLUMN';
EXEC sp_rename 'dbo.netflix_titles.show_id', 'Show_ID', 'COLUMN';
EXEC sp_rename 'dbo.netflix_titles.title', 'Title', 'COLUMN';
EXEC sp_rename 'dbo.netflix_titles.director', 'Director', 'COLUMN';
EXEC sp_rename 'dbo.netflix_titles.cast', 'Cast', 'COLUMN';
EXEC sp_rename 'dbo.netflix_titles.country', 'Country', 'COLUMN';
EXEC sp_rename 'dbo.netflix_titles.date_added', 'Release_Date', 'COLUMN';
EXEC sp_rename 'dbo.netflix_titles.release_year', 'Release_Year', 'COLUMN';
EXEC sp_rename 'dbo.netflix_titles.rating', 'Rating', 'COLUMN';
EXEC sp_rename 'dbo.netflix_titles.duration', 'Duration', 'COLUMN';
EXEC sp_rename 'dbo.netflix_titles.listed_in', 'Listed_on', 'COLUMN';
EXEC sp_rename 'dbo.netflix_titles.description', 'Story_Plot', 'COLUMN';



