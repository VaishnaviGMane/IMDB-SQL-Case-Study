USE imdb;

SELECT * FROM movie;
SELECT * FROM director_mapping;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
-- ====================================================================================

/* PROJECT FLOW: -

*/
-- ======================================================================================
	/* 2. Data Exploration: - 
-- =======================================================================================
-- 1. Missing values: - 
/*MOVIES - GROSS_INCOME, PRODUCTION 
*/
-- director_mapping table: -
SELECT COUNT(*) FROM director_mapping
WHERE movie_id IS NULL;

SELECT COUNT(*) FROM director_mapping
WHERE NAME_id IS NULL;

-- MOVIES: -
SELECT COUNT(WORLWIDE_GROSS_INCOME) AS "missing_VAL" FROM MOVIE
WHERE WORLWIDE_GROSS_INCOME IS NULL;


-- 2. SHAPE OF THE DATA

SELECT COUNT(*) FROM MOVIE;
SELECT COUNT(*) FROM director_mapping;
SELECT COUNT(*) FROM genre;

-- 3. Checking for Data Integrity: -
DESCRIBE movie;
DESCRIBE director_mapping;
DESCRIBE genre;
DESCRIBE names;
DESCRIBE ratings;
DESCRIBE role_mapping;

-- there are no dupliates available as primar key constraint have been applied.


-- 4. Descriptive stats: - 

-- Mean & Median - NUMERICAL

-- MEAN - Movie Table:

SELECT AVG(WORLWIDE_GROSS_INCOME), AVG(DURATION) FROM MOVIE;

SELECT MAX(WORLWIDE_GROSS_INCOME), MAX(DURATION) FROM MOVIE;

SELECT MIN(WORLWIDE_GROSS_INCOME), MIN(DURATION) FROM MOVIE;

-- MEDIAN CALCULATION
SELECT (COUNT(*)+1)/2
FROM MOVIE;



-- MEDIAN INDEX - 3999
-- VALUE - 24648318

SELECT DURATION,WORLWIDE_GROSS_INCOME FROM MOVIE;


SELECT DURATION,WORLWIDE_GROSS_INCOME,
ROW_NUMBER() OVER() AS "ROW"
FROM MOVIE
ORDER BY WORLWIDE_GROSS_INCOME;


select * from movie;
-- data type
-- i want replace dollar with empty space and then convert it into float

SET SQL_SAFE_UPDATES = 0;

UPDATE MOVIE
SET WORLWIDE_GROSS_INCOME = REPLACE(WORLWIDE_GROSS_INCOME,"$","");

UPDATE MOVIE
SET WORLWIDE_GROSS_INCOME = REPLACE(WORLWIDE_GROSS_INCOME,"INR","");

ALTER TABLE MOVIE
MODIFY COLUMN WORLWIDE_GROSS_INCOME BIGINT;

SELECT COUNT(*) FROM MOVIE; -- 7997
SELECT COUNT(*) FROM MOVIE
WHERE WORLWIDE_GROSS_INCOME IS NULL; -- 3724

SELECT (3725/7997)*100 AS "PER_MISS_VAL" ;

-- DESCRIPTIVE STATISTICS - WE HANDLE MISSING VALUES USING MEAN OF COL "WORLWIDE_GROSS_INCOME"
 -- MEAN
 SELECT AVG(WORLWIDE_GROSS_INCOME) AS "MEAN" FROM MOVIE;
  
  -- UPDATING MEAN AT MISSING VALUES
  
UPDATE MOVIE
SET WORLWIDE_GROSS_INCOME = 24648317.6801
WHERE WORLWIDE_GROSS_INCOME IS NULL;

UPDATE MOVIE
SET DURATION = 99
WHERE DURATION IS NULL;

SET SQL_SAFE_UPDATES = 0;


SELECT * FROM MOVIE
WHERE TITLE IS NULL;

SELECT * FROM MOVIE
WHERE COUNTRY IS NULL;

UPDATE MOVIE
SET COUNTRY = "NOT DEFINED"
WHERE COUNTRY IS NULL;

SELECT * FROM MOVIE
WHERE LANGUAGES IS NULL;

UPDATE MOVIE
SET LANGUAGES = "NOT DEFINED"
WHERE LANGUAGES IS NULL;

SELECT COUNT(*) FROM MOVIE
WHERE PRODUCTION_COMPANY IS NULL;

UPDATE MOVIE
SET PRODUCTION_COMPANY = "NOT DEFINED"
WHERE PRODUCTION_COMPANY IS NULL;

SELECT * FROM names;

SET SQL_SAFE_UPDATES = 0;

UPDATE names
SET date_of_birth = "1878-01-01" -- IF DATE OF BIRTH IS NA THEN WRITE 1 JAN DATE
where date_of_birth IS NULL;

UPDATE names
SET known_for_movies = "No data"
WHERE known_for_movies IS NULL;


SELECT * FROM movie;

-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*) FROM
 movie;






-- Q2. Which columns in the movie table have null values?
-- Type your code below:









-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

SELECT* FROM MOVIE;

SELECT 
	monthname(date_published) AS "Name of the Month"
	, COUNT(ID) as "Number_of_Movies" FROM movie 
GROUP BY monthname(date_published)
ORDER BY COUNT(ID) desc ;

-- March --> 824



/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:










/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT YEAR(date_published) AS "Date Published", COUNT(id) as "Numbr of Movies",country 
FROM movie
WHERE (COUNTRY = "India" OR COUNTRY = "USA") and YEAR(date_published) = 2019
GROUP BY YEAR(date_published), country;









/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT genre FROM genre
GROUP BY genre;








/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre, COUNT(movie_id) FROM genre
GROUP BY genre
ORDER BY  COUNT(movie_id) DESC
LIMIT 1;










/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT genre, COUNT(movie_id) AS "Number of Movies" FROM genre
GROUP BY genre
ORDER BY  COUNT(movie_id) DESC;








/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

SELECT * FROM MOVIE;
SELECT * FROM GENRE;

SELECT g.genre, AVG(m.duration) as "Average Duration"
FROM genre g
INNER JOIN movie m
ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY AVG(m.duration) desc;



/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:









/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT genre, COUNT(movie_id) as "Number of Movies",
RANK() OVER( order by COUNT(movie_id) desc) AS "genre_rank"
FROM genre
group by genre;








/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT
    MIN(avg_rating)    AS min_avg_rating,
    MAX(avg_rating)    AS max_avg_rating,
    MIN(total_votes)   AS min_total_votes,
    MAX(total_votes)   AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

SELECT
    m.title AS movie_name,
    r.avg_rating
FROM ratings r
JOIN movie m
    ON r.movie_id = m.id
ORDER BY r.avg_rating DESC
LIMIT 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT
    median_rating,
    COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
    production_company,
    movie_count,
    prod_company_rank
FROM (
    SELECT
        m.production_company,
        COUNT(m.id) AS movie_count,
        RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_company_rank
    FROM movies m
    JOIN ratings r
        ON m.id = r.movie_id
    WHERE r.avg_rating > 8
      AND m.production_company IS NOT NULL
    GROUP BY m.production_company
) ranked_companies
WHERE prod_company_rank = 1;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
    g.genre,
    COUNT(m.id) AS movie_count
FROM movie m
JOIN ratings r
    ON m.id = r.movie_id
JOIN genre g
    ON m.id = g.movie_id
WHERE r.total_votes > 1000
  AND m.country = 'USA'
  AND YEAR(m.date_published) = 2017
  AND MONTH(m.date_published) = 3
GROUP BY g.genre
ORDER BY movie_count DESC;


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT
    m.title,
    r.avg_rating,
    g.genre
FROM movie m
JOIN ratings r
    ON m.id = r.movie_id
JOIN genre g
    ON m.id = g.movie_id
WHERE m.title LIKE 'The%'
  AND r.avg_rating > 8
ORDER BY g.genre, r.avg_rating DESC;









-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT
    COUNT(m.id) AS movie_count
FROM movie m
JOIN ratings r
    ON m.id = r.movie_id
WHERE r.median_rating = 8
  AND m.date_published BETWEEN '2018-04-01' AND '2019-04-01';
  
  
-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT
    m.country,
    SUM(r.total_votes) AS total_votes
FROM movie m
JOIN ratings r
    ON m.id = r.movie_id
WHERE m.country IN ('Germany', 'Italy')
GROUP BY m.country;


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH hit_movies AS (
    SELECT
        m.id,
        m.title,
        r.avg_rating
    FROM movie m
    JOIN ratings r
        ON m.id = r.movie_id
    WHERE r.avg_rating > 8
),

top_genres AS (
    SELECT
        g.genre,
        COUNT(hm.id) AS movie_count
    FROM hit_movies hm
    JOIN genre g
        ON hm.id = g.movie_id
    GROUP BY g.genre
    ORDER BY movie_count DESC
    LIMIT 3
),

director_movie_counts AS (
    SELECT
        n.name AS director_name,
        COUNT(hm.id) AS movie_count
    FROM hit_movies hm
    JOIN genre g
        ON hm.id = g.movie_id
    JOIN director_mapping dm
        ON hm.id = dm.movie_id
    JOIN names n
        ON dm.name_id = n.id
    WHERE g.genre IN (SELECT genre FROM top_genres)
    GROUP BY n.name
)

SELECT
    director_name,
    movie_count
FROM director_movie_counts
ORDER BY movie_count DESC
LIMIT 3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:


+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
    n.name AS actor_name,
    COUNT(m.id) AS movie_count
FROM movie m
JOIN ratings r
    ON m.id = r.movie_id
JOIN role_mapping rm
    ON m.id = rm.movie_id
JOIN names n
    ON rm.name_id = n.id
WHERE r.median_rating >= 8
  AND rm.category = 'actor'
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
    production_company,
    vote_count,
    prod_comp_rank
FROM (
    SELECT
        m.production_company,
        SUM(r.total_votes) AS vote_count,
        RANK() OVER (ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
    FROM movie m
    JOIN ratings r
        ON m.id = r.movie_id
    WHERE m.production_company IS NOT NULL
    GROUP BY m.production_company
) ranked_prod_companies
WHERE prod_comp_rank <= 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH indian_actor_movies AS (
    SELECT
        n.name AS actor_name,
        r.avg_rating,
        r.total_votes
    FROM movie m
    JOIN ratings r
        ON m.id = r.movie_id
    JOIN role_mapping rm
        ON m.id = rm.movie_id
    JOIN names n
        ON rm.name_id = n.id
    WHERE m.country = 'India'
      AND rm.category = 'actor'
      AND r.total_votes IS NOT NULL
),

actor_stats AS (
    SELECT
        actor_name,
        SUM(total_votes) AS total_votes,
        COUNT(*) AS movie_count,
        ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actor_avg_rating
    FROM indian_actor_movies
    GROUP BY actor_name
    HAVING COUNT(*) >= 5
),

ranked_actors AS (
    SELECT
        actor_name,
        total_votes,
        movie_count,
        actor_avg_rating,
        RANK() OVER (
            ORDER BY actor_avg_rating DESC, total_votes DESC
        ) AS actor_rank
    FROM actor_stats
)

SELECT *
FROM ranked_actors
ORDER BY actor_rank;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
    mc.actor_name AS actress_name,
    SUM(m.votes) AS total_votes,
    COUNT(*) AS movie_count,
    ROUND(SUM(m.rating * m.votes) / SUM(m.votes), 2) AS actress_avg_rating,
    RANK() OVER (
        ORDER BY ROUND(SUM(m.rating * m.votes) / SUM(m.votes), 2) DESC,
                 SUM(m.votes) DESC
    ) AS actress_rank
FROM movie m
JOIN movie_cast mc ON m.movie_id = mc.movie_id
WHERE m.language = 'Hindi' 
  AND m.country = 'India'
GROUP BY mc.actor_name
HAVING COUNT(*) >= 3
ORDER BY actress_avg_rating DESC, total_votes DESC
LIMIT 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:

-- Assuming table movie_genre(movie_id, genre)
SELECT 
    m.title AS movie_name,
    CASE
        WHEN r.avg_rating > 8 THEN 'Superhit'
        WHEN r.avg_rating >= 7 AND r.avg_rating <= 8 THEN 'Hit'
        WHEN r.avg_rating >= 5 AND r.avg_rating < 7 THEN 'One-time-watch'
        ELSE 'Flop'
    END AS movie_category
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE r.total_votes >= 25000
ORDER BY r.avg_rating DESC;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
    g.genre,
    ROUND(AVG(m.duration), 2) AS avg_duration,
    ROUND(
        SUM(AVG(m.duration)) OVER (
            ORDER BY g.genre
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 2
    ) AS running_total_duration,
    ROUND(
        AVG(AVG(m.duration)) OVER (
            ORDER BY g.genre
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2
    ) AS moving_avg_duration
FROM movie m
JOIN genre g ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY g.genre;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- Step 1: Find top 3 genres with most movies
WITH top_genres AS (
    SELECT genre
    FROM genre
    GROUP BY genre
    ORDER BY COUNT(*) DESC
    LIMIT 3
),

-- Step 2: Select movies from top genres with year and gross
genre_movies AS (
    SELECT 
        g.genre,
        m.title AS movie_name,
        m.year,
        m.WORLWIDE_GROSS_INCOME
    FROM movie m
    JOIN genre g ON m.id = g.movie_id
    WHERE g.genre IN (SELECT genre FROM top_genres)
),

-- Step 3: Rank movies per genre per year by gross
ranked_movies AS (
    SELECT
        genre,
        year,
        movie_name,
        WORLWIDE_GROSS_INCOME,
        ROW_NUMBER() OVER (
            PARTITION BY genre, year
            ORDER BY WORLWIDE_GROSS_INCOME DESC
        ) AS movie_rank
    FROM genre_movies
)

-- Step 4: Select top 5 per genre per year
SELECT
    genre,
    year,
    movie_name,
    WORLWIDE_GROSS_INCOME,
    movie_rank
FROM ranked_movies
WHERE movie_rank <= 5
ORDER BY genre, year, movie_rank;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

-- Q27: Top 2 production houses with highest number of hits among multilingual movies

-- Q27: Top 2 production houses with highest number of hits among multilingual movies

WITH prod_hits AS (
    SELECT
        m.production_company,
        COUNT(*) AS movie_count
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    WHERE r.median_rating >= 8          -- Hit movies
      AND m.languages LIKE '%,%'        -- Multilingual movies (comma-separated languages)
    GROUP BY m.production_company
),

ranked_prod AS (
    SELECT
        production_company,
        movie_count,
        DENSE_RANK() OVER (ORDER BY movie_count DESC) AS prod_comp_rank
    FROM prod_hits
)

SELECT
    production_company,
    movie_count,
    prod_comp_rank
FROM ranked_prod
WHERE prod_comp_rank <= 2
ORDER BY prod_comp_rank;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:

-- Q28: Top 3 actresses based on number of Superhit Drama movies

-- Q28: Top 3 actresses based on number of Superhit Drama movies

WITH RECURSIVE exploded_movies AS (
    -- Anchor: get first movie_id from known_for_movies
    SELECT
        name AS actress_name,
        TRIM(SUBSTRING_INDEX(known_for_movies, ',', 1)) AS movie_id,
        -- Remaining string
        CASE 
            WHEN INSTR(known_for_movies, ',') > 0 
            THEN SUBSTRING(known_for_movies, INSTR(known_for_movies, ',') + 1)
            ELSE NULL
        END AS rest_movies
    FROM names
    WHERE known_for_movies IS NOT NULL AND known_for_movies <> ''

    UNION ALL

    -- Recursive part: get next movie_id
    SELECT
        actress_name,
        TRIM(SUBSTRING_INDEX(rest_movies, ',', 1)) AS movie_id,
        CASE 
            WHEN INSTR(rest_movies, ',') > 0 
            THEN SUBSTRING(rest_movies, INSTR(rest_movies, ',') + 1)
            ELSE NULL
        END AS rest_movies
    FROM exploded_movies
    WHERE rest_movies IS NOT NULL
),

superhit_drama AS (
    -- Only Drama movies with avg_rating > 8
    SELECT m.id AS movie_id, r.avg_rating, r.total_votes
    FROM movie m
    JOIN genre g ON m.id = g.movie_id
    JOIN ratings r ON m.id = r.movie_id
    WHERE g.genre = 'Drama'
      AND r.avg_rating > 8
),

actress_movies AS (
    -- Join exploded movies with superhit drama movies
    SELECT
        e.actress_name,
        s.avg_rating,
        s.total_votes
    FROM exploded_movies e
    JOIN superhit_drama s ON e.movie_id = s.movie_id
),

actress_stats AS (
    -- Aggregate stats per actress
    SELECT
        actress_name,
        COUNT(*) AS movie_count,
        SUM(total_votes) AS total_votes,
        ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 4) AS actress_avg_rating
    FROM actress_movies
    GROUP BY actress_name
)

-- Final output with ranking
SELECT
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    RANK() OVER (
        ORDER BY movie_count DESC, total_votes DESC, actress_name ASC
    ) AS actress_rank
FROM actress_stats
ORDER BY actress_rank
LIMIT 3;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH RECURSIVE exploded_movies AS (
    SELECT
        name AS director_name,
        id AS director_id,
        TRIM(SUBSTRING_INDEX(known_for_movies, ',', 1)) AS movie_id,
        CASE
            WHEN INSTR(known_for_movies, ',') > 0
            THEN SUBSTRING(known_for_movies, INSTR(known_for_movies, ',') + 1)
            ELSE NULL
        END AS rest_movies
    FROM names
    WHERE known_for_movies IS NOT NULL AND known_for_movies <> ''

    UNION ALL

    SELECT
        director_name,
        director_id,
        TRIM(SUBSTRING_INDEX(rest_movies, ',', 1)) AS movie_id,
        CASE
            WHEN INSTR(rest_movies, ',') > 0
            THEN SUBSTRING(rest_movies, INSTR(rest_movies, ',') + 1)
            ELSE NULL
        END AS rest_movies
    FROM exploded_movies
    WHERE rest_movies IS NOT NULL
),

director_movies AS (
    SELECT
        e.director_id,
        e.director_name,
        m.id AS movie_id,
        m.date_published,
        m.duration,
        r.avg_rating,
        r.total_votes
    FROM exploded_movies e
    JOIN movie m ON e.movie_id = m.id
    LEFT JOIN ratings r ON m.id = r.movie_id
),

movie_gaps AS (
    -- Calculate gap between consecutive movies for each director
    SELECT
        director_id,
        director_name,
        movie_id,
        date_published,
        duration,
        avg_rating,
        total_votes,
        DATEDIFF(
            date_published,
            LAG(date_published) OVER (PARTITION BY director_id ORDER BY date_published)
        ) AS gap_days
    FROM director_movies
),

director_stats AS (
    -- Aggregate per director
    SELECT
        director_id,
        director_name,
        COUNT(movie_id) AS number_of_movies,
        ROUND(AVG(gap_days), 2) AS avg_inter_movie_days,
        ROUND(AVG(avg_rating), 2) AS avg_rating,
        SUM(total_votes) AS total_votes,
        MIN(avg_rating) AS min_rating,
        MAX(avg_rating) AS max_rating,
        SUM(duration) AS total_duration
    FROM movie_gaps
    GROUP BY director_id, director_name
)

SELECT *
FROM director_stats
ORDER BY number_of_movies DESC, director_name ASC
LIMIT 9;





