# Project 2 DBMS

The project would involve writing SQL queries to retrieve information such as the locations of specific features, distances between points, and areas of interest. Using indexing, aggregate and join executors, sort+ limit executors, sorting, and top-N optimization.

Creating a Geographic Information System (GIS) Analysis: A project that involves analyzing geographic data such as maps and spatial data. You will use PostgreSQL (PostGIS).

1. Retrieve Locations of specific features (10 marks)
2. Calculate Distance between points (10 marks)
3. Calculate Areas of Interest (specific to each group) (10 marks)
4. Analyze the queries (10 marks)
5. Sorting and Limit Executions (10 marks)
6. Optimize the queries to speed up execution time (10 marks)
7. N-Optimization of queries (5 marks)
8. Presentation and Posting to Individual GitHub (5 marks)
9. Code functionality, documentation and proper output provided (5marks)

---

### INTRODUCTION

This entire project is done in postgresql (PGAdmin4) with extracted data from https://www.usgs.gov/programs/earthquake-hazards....... the CSV file used for this project is earthquake_data.csv

---

Created the table using query .. inside the public schema after creating the database for this project....

### 1. Retrieve Locations of 


```sql
SELECT time, latitude, longitiude, place
FROM earthquakes_table
WHERE mag <= 4.0 AND type = 'earthquake' AND magType = 'md';
```


### 2. Calculate Distance between locations

```sql
SELECT 
    place, 
    mag, 
    time, 
    latitude, 
    longitiude, 
    SQRT(POWER(69.1 * (latitude - 45.3251), 2) + POWER(69.1 * (-69.8856 - longitiude) * COS(latitude / 55.7), 2)) AS distance,
    CASE 
        WHEN mag < 2 THEN 'Minor' 
        WHEN mag BETWEEN 2 AND 3.9 THEN 'Light' 
        WHEN mag BETWEEN 4 AND 5.9 THEN 'Moderate' 
        WHEN mag BETWEEN 6 AND 6.9 THEN 'Strong' 
        WHEN mag BETWEEN 7 AND 7.9 THEN 'Major' 
        ELSE 'Great' 
    END 
    
FROM earthquakes_table
ORDER BY distance DESC;
```

![Untitled](results/Untitled%201.png)

### 3. Calculate Areas oF Intrests


```sql
SELECT place, COUNT(*) as num_earthquakes, AVG(mag) as avg_magnitude, 
       MAX(mag) as max_magnitude, MIN(mag) as min_magnitude
FROM earthquakes_table
WHERE time BETWEEN '2022-01-01' AND '2023-05-11'
GROUP BY place
HAVING COUNT(*) >= 10
ORDER BY num_earthquakes DESC, avg_magnitude DESC;
```


### 4. Analyze the queries


```sql
SELECT COUNT(*) as num_earthquakes, AVG(mag) as avg_magnitude, nst as nst
FROM earthquakes_table
WHERE place LIKE '%California%'
GROUP BY nst
ORDER BY nst ASC;
```


### 5. Sorting and Limit Executions

```sql
SELECT place, COUNT(*) as num_earthquakes, AVG(mag) as avg_magnitude
FROM earthquakes_table
WHERE time BETWEEN '2022-01-01' AND '2023-05-11'
GROUP BY place
HAVING COUNT(*) >= 10
ORDER BY num_earthquakes DESC;
```


### 6. Optimize the queries to speed up execution time

To speed up the search process, we create an index on the fclass field. And run ANALYZE after creating indexes

```sql
CREATE INDEX index_place ON earthquakes_table(mag, magType);
SELECT time, latitude, longitiude, place
FROM earthquakes_table
WHERE mag <= 4.0 AND type = 'earthquake' AND magType = 'md';
```

The first statement creates an index on the "mag" and "magType" columns of the "earthquakes_table" table. The purpose of creating an index is to improve query performance by allowing the database management system to quickly locate and retrieve the data needed to satisfy a query.

```sql
CREATE INDEX index_lat_long ON earthquakes_table (latitude, longitude);
SELECT 
    place, 
    mag, 
    time, 
    latitude, 
    longitiude, 
    SQRT(POWER(69.1 * (latitude - 45.3251), 2) + POWER(69.1 * (-69.8856 - longitiude) * COS(latitude / 55.7), 2)) AS distance,
    CASE 
        WHEN mag < 2 THEN 'Minor' 
        WHEN mag BETWEEN 2 AND 3.9 THEN 'Light' 
        WHEN mag BETWEEN 4 AND 5.9 THEN 'Moderate' 
        WHEN mag BETWEEN 6 AND 6.9 THEN 'Strong' 
        WHEN mag BETWEEN 7 AND 7.9 THEN 'Major' 
        ELSE 'Great' 
    END 
    
FROM earthquakes_table
ORDER BY distance DESC;
```
The purpose of this query is to retrieve earthquake data sorted by the distance from a reference point, which is calculated based on the latitude and longitude of each earthquake. The index created on the "latitude" and "longitude" columns can be used to speed up the sorting process, as the database management system can use the index to quickly locate and sort the relevant data.

```sql
CREATE INDEX mag_type_index ON earthquakes_table (place);
SELECT place, COUNT(*) as num_earthquakes, AVG(mag) as avg_magnitude
FROM earthquakes_table
WHERE time BETWEEN '2022-01-01' AND '2023-05-11'
GROUP BY place
HAVING COUNT(*) >= 10
ORDER BY num_earthquakes DESC;
```
The purpose of this query is to retrieve earthquake data grouped by location, with aggregate statistics on the number and magnitude of earthquakes. The index created on the "place" column can be used to speed up the grouping process, as the database management system can use the index to quickly locate and group the relevant data.


### 7. N-Optimization of queries

N Optimization is a query optimization technique that aims to improve the performance of queries that use the LIMIT clause to retrieve only a fixed number of rows from a table. By keeping track of only the top N results as it scans through the table, the database can reduce the amount of memory it needs to use and lower the computational load, resulting in faster query execution times. This optimization technique is especially useful in situations where a large amount of data needs to be processed, but the user is only interested in a small subset of the results.

We can add a LIMIT clause to limit the number of results returned, and a ORDER BY clause to sort the results by distance. 

```sql
SELECT *
FROM (
  SELECT place, COUNT(*) as num_earthquakes, AVG(mag) as avg_magnitude
  FROM earthquakes_table
  WHERE time BETWEEN '2022-01-01' AND '2023-05-11'
  GROUP BY place
  HAVING COUNT(*) >= 10
) AS results
WHERE place LIKE '%California%'
ORDER BY num_earthquakes DESC;
```

The purpose of this query is to retrieve earthquake data for locations in California that had at least 10 earthquakes between January 1, 2022, and May 11, 2023. The query groups the data by location and calculates aggregate statistics on the number and average magnitude of earthquakes.

The query is optimized by first grouping the data by location and aggregating the earthquake count and average magnitude for each location, and then filtering the results to only include locations in California. By doing this, the query reduces the amount of data that needs to be processed in the filtering stage, which can improve performance.

The syntax for this query uses a subquery to first group and aggregate the data, and then filters and sorts the results in the outer query. The "AS" keyword is used to give the subquery a name, which can then be referred to in the outer query. The "%California%" wildcard is used in the WHERE clause to match any place that contains the string "California" in it.

The query can be further optimized by creating an index on the "place" column of the "earthquakes_table" table, which can speed up the grouping and filtering processes.


