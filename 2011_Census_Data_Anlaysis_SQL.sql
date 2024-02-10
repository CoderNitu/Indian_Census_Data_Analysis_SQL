SELECT * FROM census_1
SELECT * FROM census_2

----1. # Total number of states and union territories in the dataset---

SELECT state from census_1
GROUP BY state;

---2. # SELECTING THE PARTTICULAR STATES TO VIEW THE DATA---

SELECT * FROM census_1
WHERE state IN ('Assam','Punjab')
ORDER BY state;

---3. # FINDING THE TOTAL POPULATION OF INDIA----

SELECT SUM(population) AS Total_Population FROM census_1

---4. # FINDING THE TOTAL POPULATION OF INDIA (STATEWISE)----

SELECT state,SUM(population) AS Total_Population 
FROM census_1
GROUP BY state
ORDER BY Total_Population DESC;

---5. # FINDING THE AVERAGE POPULATION GROWTH RATE OF INDIA IN LAST 10 YAERS---

SELECT ROUND(AVG(growth),2) AS avg_growth FROM census_2; 

----6. # FINDING THE AVERAGE POPULATION GROWTH RATE OF INDIA(STATEWISE) IN LAST 10 YAERS---

SELECT state,ROUND(AVG(growth),2) AS avg_growth 
FROM census_2
GROUP BY state
ORDER BY avg_growth DESC

----7. # FINDING THE AVERAGE POPULATION GROWTH RATE OF INDIA(ASSAM) IN LAST 10 YAERS---
      
SELECT state,ROUND(AVG(growth),2) AS avg_growth 
FROM census_2
WHERE state='Assam'
GROUP BY state;

----8. # FINDING THE AVERAGE SEX RATIO OF INDIA ---

SELECT AVG(sex_ratio) AS avg_sex_ratio FROM census_2;

----9. # FINDING THE AVERAGE SEX RATIO OF INDIA(STATEWISE) ---

SELECT state,AVG(sex_ratio) AS avg_sex_ratio 
FROM census_2
GROUP BY state
ORDER BY avg_sex_ratio DESC;

----10. # FINDING THE AVERAGE SEX RATIO OF INDIA(ASSAM) ---

SELECT state,AVG(sex_ratio) AS avg_sex_ratio 
FROM census_2
WHERE state='Assam'
GROUP BY state;

----11. # FINDING THE AVERAGE literacy rate OF INDIA ---

SELECT AVG(literacy) AS avg_literacy FROM census_2;

----12. # FINDING THE AVERAGE literacy OF INDIA(STATEWISE) ---

SELECT state,AVG(literacy) AS avg_literacy 
FROM census_2
GROUP BY state
ORDER BY avg_literacy DESC;

----13. # FINDING THE AVERAGE literacy OF INDIA(ASSAM) ---

SELECT state,AVG(literacy) AS avg_literacy 
FROM census_2
WHERE state='Assam'
GROUP BY state

----14. # FINDING THE AVERAGE literacy OF INDIA(STATEWISE)>90 ---

SELECT state,ROUND(AVG(literacy)) AS avg_literacy
FROM census_2
GROUP BY state
HAVING ROUND(AVG(literacy))>90
ORDER BY avg_literacy DESC;

----15. # FINDING THE TOP 3 STATES HAVING HGHEST AVERAGE POPULATION GROWTH RATE IN INDIA -----

SELECT state,ROUND(AVG(growth)) AS High_avg_growth 
FROM census_2
GROUP BY state
ORDER BY High_avg_growth DESC
LIMIT 3;

----16. # FINDING THE TOP 3 STATES HAVING lowest AVERAGE POPULATION GROWTH RATE IN INDIA -----

SELECT state,ROUND(AVG(growth)) AS low_avg_growth 
FROM census_2
GROUP BY state
ORDER BY low_avg_growth
LIMIT 3;

----17. # FINDING THE TOP 3 STATES HAVING HGHEST AVERAGE SEX RATIO IN INDIA -----

SELECT state,ROUND(AVG(sex_ratio)) AS High_avg_sex_ratio
FROM census_2
GROUP BY state
ORDER BY High_avg_sex_ratio DESC
LIMIT 3;

----18. # FINDING THE TOP 3 STATES HAVING lowest AVERAGE SEX RATIO IN INDIA -----

SELECT state,ROUND(AVG(sex_ratio)) AS low_avg_sex_ratio
FROM census_2
GROUP BY state
ORDER BY low_avg_sex_ratio ASC
LIMIT 3;

--- 19. #Combine the top 3 states with highest average sex ratio and top 3 states with lowest average sex ratio
          --- using CTEs(Common Table Expressions) and UNION/UNION ALL operator----
		  
WITH HighSexRatio AS (
    SELECT state, ROUND(AVG(sex_ratio)) AS avg_sex_ratio
    FROM census_2
    GROUP BY state
    ORDER BY avg_sex_ratio DESC
    LIMIT 3
),
LowSexRatio AS (
    SELECT state, ROUND(AVG(sex_ratio)) AS avg_sex_ratio
    FROM census_2
    GROUP BY state
    ORDER BY avg_sex_ratio ASC
    LIMIT 3
)
SELECT 'Top 3 High Sex Ratio' AS category, state, avg_sex_ratio
FROM HighSexRatio

UNION ALL

SELECT 'Top 3 Low Sex Ratio' AS category, state, avg_sex_ratio
FROM LowSexRatio;

--- 20. #Combine the top 3 states with highest average literacy rate and top 3 states with lowest average literacy 
         --- rate using CTEs(Common Table Expressions) and UNION/UNION ALL operator----
		 
WITH High_Literacy AS (
     
	SELECT state,ROUND(AVG(literacy)) AS avg_literacy
	FROM census_2
	GROUP BY state 
	ORDER BY avg_literacy DESC
	LIMIT 3
),

Low_Literacy AS (
	
	SELECT state,ROUND(AVG(literacy)) AS avg_literacy
    FROM census_2
	GROUP BY State
	ORDER BY avg_literacy ASC
	LIMIT 3
)

SELECT 'High_literacy_rate' AS category, state, avg_literacy
FROM High_Literacy

UNION ALL

SELECT 'Low_literacy_rate' AS category, state, avg_literacy
FROM Low_Literacy;


---- # 21. Finding the name of states which starts with 'a' & 'b'

SELECT DISTINCT state FROM census_2 
WHERE state LIKE 'A_sa_' OR state LIKE 'B%';

--- OR (if we want to view unique rows of data in a column, we can use either DINSTINCT or GROUP BY Clause)

SELECT state FROM census_2 
WHERE Lower(state) LIKE 'a%' OR Lower(state) LIKE 'b%'
GROUP BY state;

---- # 22. Finding the name of states which ends with 'a'.

SELECT DISTINCT state FROM census_2
WHERE state LIKE '%a';

---- # 23. Finding out the total number of males and females in the different states of India.(in terms of 
---  populualtion and sex_ratio/gender ratio)

-----# (We can join two or more tables even if without the foreign key, if we have commom expression or atleast 
------ one row of data common in both the table)

--- Since we have only sex_ratio and population columns in our database tables, so we need to do statiscal analysis
--- to derive a formula to find the total no. of males and females in all the states of India.

--- sex_ratio = females/males   -------> (1)
--- population = males+female (disregarding other genders)  ------>(2)
--- females=population-males    -------->(3)

--- substituting (3) into (1)
--- sex_ratio*males=(population-males)
--- sex_ratio*males+males = population
--- population= males(sex_ratio+1)

--- males = population/(sex_ratio+1)  -----(Total males) -----(4)
--- substituting (4) into (3)
--- females = population-population/(sex_ratio+1)
--- females = population(1-1/(sex_ratio+1))
--- feamles = (population*(sex_ratio))/(sex_ratio+1)  --- (Total females)

SELECT d.state,SUM(d.Total_males)AS T_males,SUM(d.Total_females) AS T_females
FROM   
(SELECT c.district,c.state,ROUND(c.population/(c.sex_ratio+1)) Total_males,
ROUND((c.population*(c.sex_ratio))/(c.sex_ratio+1)) Total_females
FROM     (SELECT c1.district,c1.state,c1.sex_ratio/1000 AS sex_ratio,c2.population 
          FROM census_2 AS c1 INNER JOIN census_1 AS c2 ON c1.district=c2.district) AS c)AS d
		  GROUP BY state
		  ORDER BY state;

--- # 24. Finding out the total number of literate and illiterate people in different states of India(in terms of 
---  populualtion and literacy rate)

---- Here also, we will use literacy rate and population column to find out the desired result

--- literacy_rate = total literate people/population
--- total literate people = literacy_rate*population--------(1) -----(T_L_P)
--- total illitearate people = population - total literate people-----(2)
--- Substituting (1) into (2)
--- total illiterate people = population -(literacy_rate*population)
--- Factor out the common term 'population'
--- total illiterate people = population(1-literacy_rate*1)
---  total illiterate people = (1-literacy_rate)*population -----(T_I_P)

SELECT d.state,SUM(d.Total_literate) Total_literateP,SUM(d.Total_illiterate) Total_illiterateP FROM
(SELECT c.district,c.state,ROUND(c.literacy_rate*c.population) AS Total_literate,
ROUND((1-c.literacy_rate)*c.population) AS Total_illiterate
FROM    (SELECT c2.district,c2.state,c2.literacy/100 AS literacy_rate,c1.population 
         FROM census_1 c1 INNER JOIN census_2 c2
          ON c1.district=c2.district ) AS c) AS d 
		  GROUP BY state
		  ORDER BY 2 DESC, 3 DESC;
		  
--- # 25. Finding the previous census poupulation of states in India(in terms of current populualtion and growth rate)

--- Here also we use statistical analysis to find out the desried result by deriving the formula

--- previous_census+growth*previous_census=population
--- previous_census(1+growth)=population
--- previous_census=population/(1+growth)


SELECT q.state,ROUND(AVG(q.g_r)) AS g_r,SUM(q.prev_census_population) p_c_p,SUM(q.current_census_population) c_c_p FROM
(SELECT p.district,p.state,p.growth_rate*100 AS g_r,
 ROUND(p.population/(1+p.growth_rate)) AS prev_census_population,p.population current_census_population FROM
(SELECT c2.district,c2.state,c2.growth/100 growth_rate,c1.population
FROM census_1 c1 INNER JOIN census_2 c2 ON c1.district=c2.district) AS p) AS q
GROUP BY state
ORDER BY 2 DESC;

--- #26.  Finding the total previous census poupulation in India(in terms of current populualtion and growth rate)


SELECT SUM(r.p_c_p) prev_census_population, SUM(r.c_c_p) current_census_population FROM
(SELECT q.state,ROUND(AVG(q.g_r)) AS g_r,SUM(q.prev_census_population) p_c_p,SUM(q.current_census_population) c_c_p FROM
(SELECT p.district,p.state,p.growth_rate*100 AS g_r,
 ROUND(p.population/(1+p.growth_rate)) AS prev_census_population,p.population current_census_population FROM
(SELECT c2.district,c2.state,c2.growth/100 growth_rate,c1.population
FROM census_1 c1 INNER JOIN census_2 c2 ON c1.district=c2.district) AS p) AS q
GROUP BY state
ORDER BY 2 DESC) AS r;

--- #27. Finding out the population density of different states of India

--- population_density = total population of an area/total land area

SELECT c.state,SUM(c.area_km2) area_km2,SUM(c.poulation_density_per_km2) poulation_density_per_km2 FROM
(SELECT district,state,area_km2, population/area_km2 AS poulation_density_per_km2
FROM census_1)AS c
GROUP BY state
ORDER BY 3 DESC;

--- # 28. Finding top 3 districts from each state of India with highest literacy rate
--- (If we have to find/segregated certain value(s) from a group, we can use ranking functions best on your uses cases) 

SELECT n.* FROM
(SELECT district,state,literacy,
RANK() OVER(PARTITION BY state ORDER BY literacy DESC) AS rnk
FROM census_2) n
WHERE rnk IN (1,2,3)
ORDER BY state;

