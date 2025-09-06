SELECT * 
FROM layoffs ;

CREATE TABLE staginglayoffs
LIKE layoffs ;

INSERT INTO staginglayoffs 
SELECT * 
FROM layoffs ;

SELECT * 
FROM staginglayoffs ;

#REMOVING DUPLICATES 

SELECT * ,
ROW_NUMBER() OVER(PARTITION BY company , location , industry , total_laid_off ,percentage_laid_off ,'date', stage, country, funds_raised_millions) AS row_num 
FROM staginglayoffs ;


WITH remdup AS(SELECT * ,
ROW_NUMBER() OVER(PARTITION BY company , location , industry , total_laid_off ,percentage_laid_off ,'date', stage, country, funds_raised_millions) AS row_num 
FROM staginglayoffs)
 SELECT * 
 FROM remdup 
 WHERE row_num > 1 ;
 
CREATE TABLE `staginglayoffs2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  row_num INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM staginglayoffs2  ;


INSERT INTO staginglayoffs2
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY company , location , industry , total_laid_off ,percentage_laid_off ,'date', stage, country, funds_raised_millions) AS row_num 
FROM staginglayoffs;


DELETE 
FROM staginglayoffs2
 WHERE row_num > 1 ;
 
# STANDARDIZING THE DATA ;

UPDATE staginglayoffs2 
SET company = TRIM(company) ;

UPDATE staginglayoffs2 
SET location = TRIM(location) ;

UPDATE staginglayoffs2 
SET industry = TRIM(industry) ;

UPDATE staginglayoffs2 
SET total_laid_off = TRIM(total_laid_off) ;

UPDATE staginglayoffs2 
SET percentage_laid_off = TRIM(percentage_laid_off) ;

UPDATE staginglayoffs2 
SET date = TRIM('date') ;

UPDATE staginglayoffs2 
SET stage = TRIM(stage) ;

UPDATE staginglayoffs2 
SET country = TRIM(country) ;

UPDATE staginglayoffs2 
SET funds_raised_millions= TRIM(funds_raised_millions) ;

SELECT DISTINCT company 
FROM staginglayoffs2 ;

SELECT DISTINCT industry
FROM staginglayoffs2 
ORDER BY 1 ;

SELECT * 
FROM staginglayoffs2  
WHERE industry LIKE 'crypto%' ;

UPDATE staginglayoffs2 
SET industry = 'Crypto'
WHERE industry LIKE  'Crypto%' ;

UPDATE staginglayoffs2 
SET `date` = STR_TO_DATE(`date` , '%m/%d/%Y ' ) ;

ALTER TABLE staginglayoffs2 
MODIFY `date` DATE ;

SELECT DISTINCT Country
FROM staginglayoffs2 
ORDER BY 1 ;

UPDATE staginglayoffs2 
SET Country  = 'United States'
WHERE Country LIKE  'United States%' ;

# REMOVING BLANKS AND NULLS ;

SELECT * 
FROM staginglayoffs2 
WHERE industry IS NULL
OR industry = ' ' ;


SELECT * 
FROM staginglayoffs2 
WHERE company = 'Bally''s Interactive' ;

# REMOVING UNECESSARY ROWS AND COLS ;

SELECT * 
FROM staginglayoffs2 
WHERE total_laid_off IS NULL 
AND  percentage_laid_off IS NULL  ;

DELETE 
FROM staginglayoffs2 
WHERE total_laid_off IS NULL 
AND  percentage_laid_off IS NULL  ;

ALTER TABLE staginglayoffs2 
DROP COLUMN row_num ;

# EXPLORATORY DATA ANALYSIS ;

SELECT * 
FROM staginglayoffs2  ;

SELECT MAX(`date`) , MIN(`date`)
FROM staginglayoffs2  ;

SELECT company , SUM(total_laid_off) 
FROM staginglayoffs2 
GROUP BY company 
ORDER BY 2 DESC ;

SELECT country , Location  ,  SUM(total_laid_off) ,
dense_rank() OVER(PARTITION BY country ORDER BY SUM(total_laid_off)) AS location_rank
FROM staginglayoffs2 
GROUP BY location , country;

SELECT industry   ,  SUM(total_laid_off) 
FROM staginglayoffs2 
GROUP BY industry 
ORDER BY 2 DESC ;

SELECT stage  ,  SUM(total_laid_off) 
FROM staginglayoffs2 
GROUP BY stage
ORDER BY 2 DESC ;

SELECT country  ,  SUM(total_laid_off) 
FROM staginglayoffs2 
GROUP BY country 
ORDER BY 2 DESC ;

SELECT company , SUM(funds_raised_millions) ,  SUM(total_laid_off) 
FROM staginglayoffs2 
GROUP BY company
ORDER BY 2 DESC ;

SELECT YEAR(`date`) , SUM(total_laid_off)
FROM staginglayoffs2 
WHERE YEAR(`date`)  IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY YEAR(`date`) ;

WITH Rolling_total AS (
SELECT substring(`date` , 1,7) AS per_month, SUM(total_laid_off) AS laid_off 
FROM staginglayoffs2 
WHERE  substring(`date` , 1,7)  IS NOT NULL
GROUP BY  `per_month`
ORDER BY  per_month  )

SELECT per_month , laid_off  , SUM(laid_off ) OVER(ORDER BY per_month) AS Rolling_total
FROM  Rolling_total ;

WITH company_rankings AS
(
SELECT YEAR(`date`) AS year_ , company ,SUM(total_laid_off) AS laid_off ,
dense_rank() OVER(PARTITION BY YEAR(`date`) ORDER BY SUM(total_laid_off) DESC ) AS yearly_ranked 
FROM staginglayoffs2 
WHERE YEAR(`date`)   IS NOT NULL
GROUP BY YEAR(`date`) , company 
ORDER BY YEAR(`date`) 
)
SELECT year_ ,company ,laid_off ,yearly_ranked 
FROM company_rankings
WHERE yearly_ranked < 11 ;









  







