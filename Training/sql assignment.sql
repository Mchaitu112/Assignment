-- My SQL Case Study on Flights
-- GRADED ASSIGNMENT - II
-- a) Create external table “flights” using Database “airline_delayDB”CREATE DATABASE airline_delayDB;
USE airline_delayDB;
CREATE TABLE flights(ID INT, 
YEAR INT,
MONTH INT, 
DAY INT,
DAY_OF_WEEK INT,
AIRLINE VARCHAR(20),
FLIGHT_NUMBER INT, 
TAIL_NUMBER VARCHAR(30),
ORIGIN_AIRPORT VARCHAR(30), 
DESTINATION_AIRPORT VARCHAR(30),
SCHEDULED_DEPARTURE INT, 
DEPARTURE_TIME INT, 
DEPARTURE_DELAY INT,
TAXI_OUT INT, 
WHEELS_OFF INT,
SCHEDULED_TIME INT, 
ELAPSED_TIME INT, 
AIR_TIME INT, 
DISTANCE INT, 
WHEELS_ON INT, 
TAXI_IN INT,
SCHEDULED_ARRIVAL INT,
ARRIVAL_TIME INT,
ARRIVAL_DELAY INT, 
DIVERTED INT, 
CANCELLED INT);

-- b) Describe the table schema & show top 10 rows of Dataset
DESC flights;
SELECT * FROM flights LIMIT 10;

-- c) Find duplicates rows present in dataset.
SELECT
    ID, YEAR, MONTH, DAY, DAY_OF_WEEK, AIRLINE, FLIGHT_NUMBER, TAIL_NUMBER, ORIGIN_AIRPORT, DESTINATION_AIRPORT,
    SCHEDULED_DEPARTURE, DEPARTURE_TIME, DEPARTURE_DELAY, TAXI_OUT, WHEELS_OFF, SCHEDULED_TIME,
    ELAPSED_TIME, AIR_TIME, DISTANCE, WHEELS_ON, TAXI_IN, SCHEDULED_ARRIVAL, ARRIVAL_TIME, ARRIVAL_DELAY,
    DIVERTED, CANCELLED, COUNT(*) AS Frequency_Of_Row
FROM
    flights
GROUP BY
    ID, YEAR, MONTH, DAY, DAY_OF_WEEK, AIRLINE, FLIGHT_NUMBER, TAIL_NUMBER, ORIGIN_AIRPORT, DESTINATION_AIRPORT,
    SCHEDULED_DEPARTURE, DEPARTURE_TIME, DEPARTURE_DELAY, TAXI_OUT, WHEELS_OFF, SCHEDULED_TIME, ELAPSED_TIME,
    AIR_TIME, DISTANCE, WHEELS_ON, TAXI_IN,SCHEDULED_ARRIVAL, ARRIVAL_TIME, ARRIVAL_DELAY, DIVERTED, CANCELLED
HAVING
   COUNT(*) > 1;

-- d) Average arrival delay caused by airlines
SELECT AVG(ARRIVAL_DELAY) FROM flights WHERE ARRIVAL_DELAY > 0 AND ARRIVAL_DELAY != 999999;

-- e) Days of months with respected to average of arrival delays
SELECT DAY, AVG(ARRIVAL_DELAY)
FROM flights
WHERE ARRIVAL_DELAY > 0 AND ARRIVAL_DELAY != 999999
GROUP BY DAY
ORDER BY DAY;

-- f) Arrange weekdays with respect to the average arrival delays caused
SELECT DAY_OF_WEEK, AVG(ARRIVAL_DELAY) AS Average_Arrival_delays
FROM flights
WHERE ARRIVAL_DELAY > 0 AND ARRIVAL_DELAY != 999999
GROUP BY DAY_OF_WEEK
ORDER BY DAY_OF_WEEK;

-- g) Arrange Days of month as per cancellations done in Descending
SELECT DAY, SUM(CANCELLED) AS Cancellations
FROM flights
WHERE CANCELLED != 999999
GROUP BY DAY
ORDER BY Cancellations DESC;

-- h) Finding busiest airports with respect to day of week
SELECT ORIGIN_AIRPORT((SELECT COUNT(DESTINATION_AIRPORT) AS FLIGHTS_LANDING
FROM flights GROUP BY DESTINATION_AIRPORT ORDER BY DESTINATION_AIRPORT)
+
(SELECT COUNT(ORIGIN_AIRPORT) AS FLIGHTS_LANDING
FROM flights GROUP BY ORIGIN_AIRPORT ORDER BY ORIGIN_AIRPORT)) AS NUMBER_OF_FLIGHTS FROM flights;
select
    ORIGIN_AIRPORT, sum(LANDED_FLIHGTS) AS LANDED, sum(FLIGHTS_FLEW) AS FLEW, 
    sum(FLIGHTS_FLEW)+sum(LANDED_FLIHGTS) AS TOTAL
 from (select F1.ORIGIN_AIRPORT, count(*) AS LANDED_FLIHGTS
       from flights F1
        group by ORIGIN_AIRPORT) t
  JOIN
  (select F2.DESTINATION_AIRPORT, count(*) AS FLIGHTS_FLEW
  from flights F2
  group by DESTINATION_AIRPORT
  ) T2
  group by ORIGIN_AIRPORT ORDER BY TOTAL DESC; 
 (select F1.ORIGIN_AIRPORT, count(*) AS LANDED_FLIHGTS
  from flights F1
  group by ORIGIN_AIRPORT);

-- i) Finding airlines that make the maximum number of cancellations
SELECT AIRLINE, COUNT(*) AS CANCELLATIONS FROM flights WHERE CANCELLED = 1
 GROUP BY AIRLINE ORDER BY CANCELLATIONS DESC;
 
 -- j) Find and order airlines in descending that make the most number of diversions
SELECT AIRLINE, COUNT(*) AS DIVERSIONS FROM flights WHERE DIVERTED = 1
 GROUP BY AIRLINE ORDER BY DIVERSIONS DESC;
 
 -- k) Finding days of month that see the most number of diversion
SELECT DAY, COUNT(*) AS DIVERSIONS FROM flights WHERE DIVERTED = 1
 GROUP BY DAY ORDER BY DIVERSIONS DESC;
 
 -- l) Calculating mean and standard deviation of departure delay for all flights in minutes
SELECT AVG(DEPARTURE_DELAY) AS MEAN, STD(DEPARTURE_DELAY) AS STANDARD_DEVIATION
FROM flights WHERE DEPARTURE_DELAY>0 AND DEPARTURE_DELAY != 999999;

-- m) Calculating mean and standard deviation of arrival delay for all flights in minutes
SELECT AVG(ARRIVAL_DELAY) AS MEAN, STD(ARRIVAL_DELAY) AS STANDARD_DEVIATION
FROM flights WHERE ARRIVAL_DELAY>0 AND ARRIVAL_DELAY != 999999;

-- n) Write a query to show Top 3 employee from each department earning Highest salary

-- o) Create a partitioning table “flights_partition” using suitable partitioned by schema

 -- p) Finding all diverted Route from a source to destination Airport & which route is the most diverted
SELECT ORIGIN_AIRPORT, DESTINATION_AIRPORT, SUM(DIVERTED) AS DIVERSIONS FROM flights WHERE DIVERTED = 1 
GROUP BY ORIGIN_AIRPORT, DESTINATION_AIRPORT
ORDER BY DIVERSIONS DESC;
-- q) Write a query to show Top 3 airlines from each airport making most Delays.(Use Dense Rank/ Rank)
-- By longest delays
SELECT * FROM
(SELECT ORIGIN_AIRPORT, AIRLINE, AVG_DELAY, DENSE_RANK() OVER(PARTITION BY ORIGIN_AIRPORT ORDER BY AVG_DELAY DESC) AS DELAY_RANK
FROM(
SELECT ORIGIN_AIRPORT, AIRLINE, ROUND(SUM(DEPARTURE_DELAY + ARRIVAL_DELAY)/2) AS AVG_DELAY FROM flights
    where DEPARTURE_DELAY < 999999 AND ARRIVAL_DELAY < 999999
    GROUP BY ORIGIN_AIRPORT, AIRLINE
    ) AS T WHERE AVG_DELAY>0
    ) T1 WHERE DELAY_RANK < 4;-- By number of Delays
SELECT * FROM
(SELECT ORIGIN_AIRPORT, AIRLINE, DELAYS, DENSE_RANK() OVER(PARTITION BY ORIGIN_AIRPORT ORDER BY DELAYS DESC) AS DELAY_RANK
FROM(
SELECT ORIGIN_AIRPORT, AIRLINE, COUNT((DEPARTURE_DELAY + ARRIVAL_DELAY)/2) AS DELAYS FROM flights
    WHERE DEPARTURE_DELAY < 999999 AND ARRIVAL_DELAY < 999999 AND DEPARTURE_DELAY > 0 AND ARRIVAL_DELAY > 0
    GROUP BY ORIGIN_AIRPORT, AIRLINE
    ) AS T
    ) T1 WHERE DELAY_RANK < 4;
-- r) Write a query to show Top 10 airlines from each week making most Delays. Find its Ranking.
-- By longest delays
SELECT * FROM
(SELECT DAY_OF_WEEK, AIRLINE, AVG_DELAY, DENSE_RANK() OVER(PARTITION BY DAY_OF_WEEK ORDER BY AVG_DELAY DESC)
 AS DELAY_RANK
FROM(
SELECT DAY_OF_WEEK, AIRLINE, SUM((DEPARTURE_DELAY + ARRIVAL_DELAY)/2) AS AVG_DELAY FROM flights
    WHERE DEPARTURE_DELAY < 999999 AND ARRIVAL_DELAY < 999999
    GROUP BY DAY_OF_WEEK, AIRLINE
    ) AS T WHERE AVG_DELAY>0
    ) T1 WHERE DELAY_RANK < 11;    -- By number of Delays
SELECT * FROM
(SELECT DAY_OF_WEEK, AIRLINE, DELAYS, DENSE_RANK() OVER(PARTITION BY DAY_OF_WEEK ORDER BY DELAYS DESC) AS DELAY_RANK
FROM(
SELECT DAY_OF_WEEK, AIRLINE, COUNT((DEPARTURE_DELAY + ARRIVAL_DELAY)/2) AS DELAYS FROM flights
    WHERE DEPARTURE_DELAY < 999999 AND ARRIVAL_DELAY < 999999 AND DEPARTURE_DELAY > 0 AND ARRIVAL_DELAY > 0
    GROUP BY DAY_OF_WEEK, AIRLINE
    ) AS T
    ) T1 WHERE DELAY_RANK < 4;

-- s) Create a materialized view for client to show Top 10 airlines with highest Delay.
CREATE VIEW FLIGHTS_WITH_DELAY AS
SELECT AIRLINE, ROUND(SUM((ARRIVAL_DELAY+DEPARTURE_DELAY)/2)) AS DELAY
FROM flights WHERE ARRIVAL_DELAY>0 AND DEPARTURE_DELAY>0 AND ARRIVAL_DELAY<999999 AND DEPARTURE_DELAY<999999
GROUP BY AIRLINE;SELECT * FROM FLIGHTS_WITH_DELAY;

-- t) Create a new column named ‘Delay_Comaprison’ showing if flights making higher or lower than average flight delay.
ALTER TABLE flights ADD COLUMN DELAY_COMPARISON VARCHAR(10);SET SQL_SAFE_UPDATES = FALSE;
UPDATE flights SET DELAY_COMPARISON = (IF(((ARRIVAL_DELAY+DEPARTURE_DELAY)/2) > 0, "Higher", "Lower"));
SELECT AIRLINE, ARRIVAL_DELAY, DEPARTURE_DELAY, DELAY_COMPARISON FROM flights;

-- u) Finding AIRLINES with its total flight count, total number of flights arrival delayed by more than 30 Minutes,
-- % of such flights delayed by more than 30 minutes when it is not Weekends with minimum count of flights from
-- Airlines by more than 10. Also Exclude some of Airlines 'AK', 'HI', 'PR', 'VI' and arrange output in descending order by
-- % of such count of flights.SELECT T1.AIRLINE, TOTAL_FLIGHTS, DELAYED_FLIGHTS, DELAYED_FLIGHTS_WD, CONCAT(ROUND((DELAYED_FLIGHTS_WD/DELAYED_FLIGHTS)*100, 2), '%') AS DELAY_PERCENT FROM (
  (SELECT AIRLINE, COUNT(*) AS TOTAL_FLIGHTS FROM FLIGHTS GROUP BY AIRLINE) T1
    JOIN
   (SELECT AIRLINE, COUNT(*) AS DELAYED_FLIGHTS FROM FLIGHTS WHERE ARRIVAL_DELAY>30 AND ARRIVAL_DELAY<999999 
    GROUP BY AIRLINE) T2
    ON T1.AIRLINE = T2.AIRLINE
    JOIN
    (SELECT AIRLINE, COUNT(*) AS DELAYED_FLIGHTS_WD FROM FLIGHTS 
    WHERE ARRIVAL_DELAY>30 AND ARRIVAL_DELAY<999999 AND DAY_OF_WEEK NOT IN (6,7) GROUP BY AIRLINE) T3
ON T2.AIRLINE = T3.AIRLINE
)  WHERE T1.AIRLINE NOT IN ('AK', 'HI', 'PR', 'VI') AND TOTAL_FLIGHTS > 10
ORDER BY DELAY_PERCENT DESC;

-- v) Finding AIRLINES with its total flight count with total number of flights departure delayed by less than 30 Minutes,
-- % of such flights delayed by
-- less than 30 minutes when it is Weekends with minimum count of flights from Airlines by more than 10.
-- Also Exclude some of Airlines 'AK', 'HI', 'PR', 'VI' and arrange output in descending order by % of such count of flights.
  SELECT T1.AIRLINE, TOTAL_FLIGHTS, DELAYED_FLIGHTS, DELAYED_FLIGHTS_WD,
  CONCAT(ROUND((DELAYED_FLIGHTS_WD/DELAYED_FLIGHTS)*100, 2), '%') AS DELAY_PERCENT FROM (
(SELECT AIRLINE, COUNT(*) AS TOTAL_FLIGHTS FROM FLIGHTS GROUP BY AIRLINE) T1
inner JOIN
    (SELECT AIRLINE, COUNT(*) AS DELAYED_FLIGHTS FROM FLIGHTS 
WHERE DEPARTURE_DELAY>0 AND DEPARTURE_DELAY<30 GROUP BY AIRLINE)  T2
    ON T1.AIRLINE = T2.AIRLINE
    JOIN
    (SELECT AIRLINE, COUNT(*) AS DELAYED_FLIGHTS_WD FROM FLIGHTS WHERE DEPARTURE_DELAY>0 AND DEPARTURE_DELAY<30 AND DAY_OF_WEEK NOT IN (6,7) GROUP BY AIRLINE) T3
ON T2.AIRLINE = T3.AIRLINE
)  WHERE T1.AIRLINE NOT IN ('AK', 'HI', 'PR', 'VI') AND TOTAL_FLIGHTS > 10
ORDER BY DELAY_PERCENT DESC;

-- w) When is the best time of day/day of week/time of a year to fly with minimum delays?
SELECT * FROM
(SELECT MONTH, DAY_OF_WEEK, AVG_DELAY, DENSE_RANK() OVER(PARTITION BY MONTH ORDER BY AVG_DELAY) AS DELAY_RANK
FROM(
SELECT MONTH, DAY_OF_WEEK, SUM((DEPARTURE_DELAY + ARRIVAL_DELAY)/2) AS AVG_DELAY FROM flights
    WHERE DEPARTURE_DELAY < 999999 AND ARRIVAL_DELAY < 999999
    GROUP BY MONTH, DAY_OF_WEEK
    ) AS T WHERE AVG_DELAY>0
    ) T1 WHERE DELAY_RANK < 2;

-- x) Suggest reasons of airlines delays and suggest, build solutions for it.-- y) Create a stored procedure to find weeks with maximum flights delays count.
DROP PROCEDURE IF EXISTS MAX_DELAYS_PER_WEEK;
delimiter ##
create procedure MAX_DELAYS_PER_WEEK()
begin
select day_of_week,delay from
(select day_of_week,count((departure_delay+arrival_delay)>0) as delay from flights
 group by day_of_week order by delay desc) as a;
 end ##
delimiter;
delimiter ##CALL MAX_DELAYS_PER_WEEK();has context menu