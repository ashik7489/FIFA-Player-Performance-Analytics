ALTER USER 'root'@'localhost'
IDENTIFIED WITH mysql_native_password
BY 'root123';
FLUSH PRIVILEGES;
SHOW DATABASES;
CREATE DATABASE fifa_db;

USE fifa_db;
SELECT COUNT(*) FROM players_clean;
select * from players_clean;




-- BASIC SQL QUESTIONS (Beginner)

-- Sabhi players ke name, age, nationality show karo
select name,age,nationality from players_clean;
-- Unique nationalities ki list nikalo
select distinct(nationality) from players_clean;
-- Total number of players count karo
select distinct(count(*)) from players_clean;
-- Age 18 se kam players find karo
select * from players_clean where age<18;
-- Age 30 se zyada players find karo
select *  from players_clean
where age>30;
-- Players ka average age calculate karo
select avg(age) from players_clean;
alter table players_clean rename column overall to Rating_overall;
alter table players_clean rename column Rating_overall to overall_rating;

-- Maximum overall rating kya hai?
select max(rating_overall) from players_clean;
-- Minimum overall rating kya hai?
select min(overall_rating) from players_clean; 
-- Players jinka preferred_foot = 'Left' ho
select * from players_clean where preferred_foot="Left";
-- Players jinka club NULL hai
select * from players_clean where club is null;
-- 🔹 FILTERING & CONDITIONS

-- Players with overall > 85
select * from players_clean where  overall_rating>=85;
-- Players with potential > overall
select * from players_clean where potential> overall_rating;
-- Players jinka work_rate = 'High/High'
select 
* from players_clean where work_rate='high/high';
-- Players jinka skill_moves >= 4
select * from players_clean where skill_moves >=4;
-- Players jinka weak_foot >= 4
select * from players_clean where weak_foot >=4;
-- Players jinka international_reputation >= 3
select * from players_clean where international_reputation >=3;
-- Players jinka position = 'GK'
select * from players_clean where position="gk";
-- Players jinka weight > 80
select * from players_clean where weight>80;
-- Players jinka contract_valid_until = '2025'
select * from players_clean where contract_valid_until ='2025';
-- Loan players identify karo
select * from players_clean where loaned_from !="not mention";
select loaned_from,count(*) from players_clean
group by loaned_from;
-- 🔹 AGGREGATE FUNCTIONS

-- Nationality-wise player count
select nationality,count(*) from players_clean 
group by nationality ;
-- Club-wise average overall rating
select club,avg(overall_rating) from players_clean 
group by club;
-- Position-wise maximum potential
select position,max(potential) as max_potential
from players_clean
group by position;
-- Average finishing by position
select  position, round(avg(finishing),2) from players_clean
group by position;
-- Country-wise average age
alter table players_clean
modify joined date;
alter table players_clean
modify joined_year date;
select nationality,avg(age) from players_clean
group by nationality;

-- Count players per preferred_foot
select preferred_foot,count(*) from players_clean
group by preferred_foot;
-- Highest dribbling score
select max(dribbling) from players_clean;
-- Average ballcontrol
select avg(ballcontrol) from players_clean;
-- Min & max acceleration
select max(acceleration),min(acceleration) from players_clean;
-- Total number of clubs
select count(club) from players_clean;
-- 🔹 GROUP BY + HAVING

-- Nationality jisme 50 se zyada players ho
select nationality, count(*)as total_count from players_clean
group by nationality
having total_count>=50 ;
-- Clubs jinka average overall > 80
select club,avg(overall_rating)as club_overall_rating  from 
players_clean 
group by club
having club_overall_rating>80;
-- Positions jisme average finishing > 75
select position,avg(finishing) as avg_finishing
from players_clean
group by position;
-- Countries jisme average potential > 85
select nationality, avg(potential) as avg_potential
from players_clean
group by  nationality
having avg_potential >80;
-- Work_rate jisme player count > 100
select work_rate,count(*)
from players_clean
group by work_rate
having count(*)>100;
-- 🔹 SORTING & LIMIT

-- Top 10 highest overall players
select * from players_clean 
order by s desc
limit 10;
-- Top 5 youngest players
select * from players_clean 
order by age 
limit 5;
-- Top 10 players by potential
select * from players_clean
order by potential desc
limit 10;
-- Bottom 10 players by overall
select * from players_clean
order by overall_rating desc
limit 10;
-- Top 10 dribblers
select * from players_clean
order by dribbling desc
limit 10;
-- 🔹 STRING & DATE OPERATIONS

-- Players jinka naam 'A' se start hota ho
select * from players_clean
where name like"A%";
-- Players jinka naam 'son' se end hota ho
select *
from players_clean 
where name like "%son";
-- Players jinke club me 'FC' ho
select * from players_clean 
where club like "%fc%";
-- Joined year extract karo
select name,year(joined),contract_valid_until from players_clean;
-- Contract year extract karo
select year(contract_valid_until) from players_clean;
-- 🔹 CASE WHEN (Business Logic)
alter table players_clean modify contract_valid_until date; 
ALTER TABLE players_clean
ADD contract_valid_date DATE;
UPDATE players_clean
SET contract_valid_date =
    STR_TO_DATE(CONCAT(contract_valid_until, '-12-31'), '%Y-%m-%d')
WHERE contract_valid_until IS NOT NULL;
ALTER TABLE players_clean
DROP contract_valid_until;
ALTER TABLE players_clean
RENAME COLUMN contract_valid_date TO contract_valid_until;
SELECT YEAR(contract_valid_until) 
FROM players_clean;

set sql_safe_updates=0;
-- Overall ke base par rating category banao
select 
name, overall_rating,
case
 when overall_rating >=85 then 'Elite'
 when overall_rating between 70 and 84 then 'Average'
 else 'Poor'
end as Rating_category
from players_clean;
 
-- ≥85 → Elite

-- 70–84 → Average

-- <70 → Poor

-- Age group banao (Teen / Prime / Veteran)
select name,age,
case
 when age<20 then 'teen'
 when age between 20 and 30 then 'Prime'
 else 'Veteran'
 end as Age_group
 from players_clean;
-- Skill level classify karo

-- Potential growth flag (High / Medium / Low)
select name,potential,
case when
potential >80 then "High"
when potential between 40 and 80 then "Medium"
else "poor"
end as potential_groop
from players_clean;


-- Loan vs Permanent player flag

-- 🔹 SUBQUERIES

-- Players jinka overall > average overall
select name, overall_rating from players_clean
where overall_rating >(select avg(overall_rating) from players_clean);
-- Players jinka age < average age
select * from players_clean
where age <(select avg(age) from players_clean);
-- Club jiska highest overall player
select * from players_clean
where overall_rating =
(select max(overall_rating) from players_clean);
-- Country jiska max potential player
select * from  players_clean
where potential =(select max(potential) from players_clean);
-- Second highest overall rating
select 
name,overall_rating from (select 
name, club,overall_rating,
dense_rank() over (order by overall_rating desc)
as rnk
from players_clean
)t
where rnk=2;
select distinct overall_rating
from players_clean
order by overall_rating desc
limit 1 offset 1;

-- 🔹 WINDOW FUNCTIONS (Advanced)

-- Country-wise player ranking by overall
select name,nationality,overall_rating,
rank()over(partition by nationality order by overall_rating desc)
from players_clean;
-- Club-wise top 3 players
select 
name,club,
overall_rating
from (select name,club,overall_rating ,
dense_rank() over(partition by club order by overall_rating desc) as rnk
from players_clean
)t
where rnk<=3;

-- Position-wise average overall (window)
select name,
position,
overall_rating,
avg(overall_rating) over (partition by position) as avg_overall_by_position
from players_clean;
-- Rank players by potential
select name,club,potential,
rank() over (order by potential desc)
from players_clean;
-- Dense rank vs rank comparison
select name,
club,
overall_rating,
rank() over(order by overall_rating desc) as rnk_val,
dense_rank() over(order by overall_rating desc)as dense_rnk
from players_clean;
-- 🔹 DATA QUALITY & CLEANING

-- NULL value count in each column
-- NULL value count in each column
SELECT
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS age_nulls,
    SUM(CASE WHEN nationality IS NULL THEN 1 ELSE 0 END) AS nationality_nulls,
    SUM(CASE WHEN overall_rating IS NULL THEN 1 ELSE 0 END) AS overall_nulls,
    SUM(CASE WHEN potential IS NULL THEN 1 ELSE 0 END) AS potential_nulls,
    SUM(CASE WHEN club IS NULL THEN 1 ELSE 0 END) AS club_nulls,
    SUM(CASE WHEN joined IS NULL THEN 1 ELSE 0 END) AS joined_nulls,
    SUM(CASE WHEN contract_valid_until IS NULL THEN 1 ELSE 0 END) AS contract_nulls
FROM players_clean;

-- Duplicate player names find karo
select name,
count(*) as cnt
from players_clean
group by name
having count(*)>1;
-- Missing contract_valid_until wale players
select name,club,nationality,contract_valid_until
from
players_clean
where contract_valid_until is null;
-- Players with overall = 0
select * from players_clean
where overall_rating=0;
-- Invalid age (<15 ya >45)
select * from players_clean
where age <15
or age>45;
SELECT 
    name,
    age,
    CASE
        WHEN age < 15 OR age > 45 THEN 'Invalid'
        ELSE 'Valid'
    END AS age_status
FROM players_clean;

-- 🔹 ANALYTICAL / INTERVIEW QUESTIONS

-- Best country by average overall

select 
nationality,
avg(overall_rating)as avg_overall
from players_clean
group by nationality
order by avg_overall  desc;
-- Best club by average potential
select club,avg(potential) as avg_potential
from players_clean
group by club
order by avg_potential desc;
-- Young players with high potential (>85)
select name,age,potential
from players_clean
where potential>85 and age<18;
-- Best attacking players (finishing + volleys)
select name,club,finishing,volleys,(finishing+volleys) as attacking_players
from players_clean
order by attacking_players desc;
-- Best playmakers (passing + vision)
select name, club,
shortpassing,longpassing,vision,(shortpassing+longpassing+vision)as playmaking_score
from players_clean
order by playmaking_score desc;


