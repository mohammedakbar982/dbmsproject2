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
This is a SQL query that retrieves the time, latitude, longitude, and place of earthquakes with a magnitude of 4.0 or less, a type of "earthquake," and a magnitude type of "md" from a table named "earthquakes_table."

![1DBMS](https://github.com/mohammedakbar982/dbmsproject2/assets/133189360/442d2415-8cb1-4986-924c-973ab52a21c2)


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

This is a SQL query that retrieves the place, magnitude, time, latitude, longitude, distance, and earthquake magnitude classification for all earthquakes in a table named "earthquakes_table." The results are ordered by the distance from the epicenter of each earthquake in descending order.

![2DBMS1](https://github.com/mohammedakbar982/dbmsproject2/assets/133189360/7c1c3001-1c10-4fa3-bf30-4251a9854d9c)



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
This is a SQL query that retrieves the place, the number of earthquakes, the average magnitude, the maximum magnitude, and the minimum magnitude of earthquakes that occurred between January 1, 2022, and May 11, 2023, from a table named "earthquakes_table". The results are grouped by place, but only include places where there have been at least 10 earthquakes during the specified time period. The results are then sorted by the number of earthquakes in descending order, and then by the average magnitude in descending order.

![3DBMS](https://github.com/mohammedakbar982/dbmsproject2/assets/133189360/6d6bfe66-f406-4a74-bc3e-4cf269340a18)


### 4. Analyze the queries
1)
```
SELECT time, latitude, longitude, place
FROM earthquakes_table
WHERE mag <= 4.0 AND type = 'earthquake' AND magType = 'md';
```

Here's a breakdown of what each part of the query does:

- `SELECT time, latitude, longitude, place` specifies the columns to be returned in the result set. In this case, we want the time, latitude, longitude, and place columns.
- `FROM earthquakes_table` specifies the table from which to retrieve the data. In this case, the table is named "earthquakes_table."
- `WHERE mag <= 4.0 AND type = 'earthquake' AND magType = 'md'` specifies the conditions that the rows must meet in order to be included in the result set. In this case, we want only earthquakes with a magnitude of 4.0 or less, a type of "earthquake," and a magnitude type of "md."

----

2)
```
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

- `SELECT place, mag, time, latitude, longitiude,` specifies the columns to be returned in the result set. In this case, we want the place, magnitude, time, latitude, and longitude columns.
- `SQRT(POWER(69.1 * (latitude - 45.3251), 2) + POWER(69.1 * (-69.8856 - longitiude) * COS(latitude / 55.7), 2)) AS distance` calculates the distance between the earthquake's epicenter and a reference location (latitude 45.3251, longitude -69.8856) using the Haversine formula, which takes into account the curvature of the Earth. The distance is returned as a new column called "distance."
- `CASE WHEN mag < 2 THEN 'Minor' WHEN mag BETWEEN 2 AND 3.9 THEN 'Light' WHEN mag BETWEEN 4 AND 5.9 THEN 'Moderate' WHEN mag BETWEEN 6 AND 6.9 THEN 'Strong' WHEN mag BETWEEN 7 AND 7.9 THEN 'Major' ELSE 'Great' END` assigns a earthquake magnitude classification to each earthquake based on its magnitude, and returns it as a new column called "Mag_Classification."
- `FROM earthquakes_table` specifies the table from which to retrieve the data. In this case, the table is named "earthquakes_table."
- `ORDER BY distance DESC` sorts the results by the "distance" column in descending order.

----
3)
```
SELECT place, COUNT(*) as num_earthquakes, AVG(mag) as avg_magnitude, 
       MAX(mag) as max_magnitude, MIN(mag) as min_magnitude
```

- `SELECT place` specifies the column to be returned in the result set. In this case, we want the place column.
- `COUNT(*) as num_earthquakes` counts the number of earthquakes for each place and returns it as a new column called "num_earthquakes."
- `AVG(mag) as avg_magnitude` calculates the average magnitude of earthquakes for each place and returns it as a new column called "avg_magnitude."
- `MAX(mag) as max_magnitude` finds the maximum magnitude of earthquakes for each place and returns it as a new column called "max_magnitude."
- `MIN(mag) as min_magnitude` finds the minimum magnitude of earthquakes for each place and returns it as a new column called "min_magnitude."

```
FROM earthquakes_table
WHERE time BETWEEN '2022-01-01' AND '2023-05-11'
```

- `FROM earthquakes_table` specifies the table from which to retrieve the data. In this case, the table is named "earthquakes_table."
- `WHERE time BETWEEN '2022-01-01' AND '2023-05-11'` specifies the condition that the earthquakes must have occurred between January 1, 2022, and May 11, 2023, to be included in the result set.

```
GROUP BY place
HAVING COUNT(*) >= 10
```

- `GROUP BY place` groups the earthquakes by place.
- `HAVING COUNT(*) >= 10` specifies that only places where there have been at least 10 earthquakes during the specified time period should be included in the result set.

```
ORDER BY num_earthquakes DESC, avg_magnitude DESC;
```

- `ORDER BY num_earthquakes DESC, avg_magnitude DESC` sorts the results by the "num_earthquakes" column in descending order, and then by the "avg_magnitude" column in descending order.

----
4)
```sql
SELECT COUNT(*) as num_earthquakes, AVG(mag) as avg_magnitude, nst as nst
FROM earthquakes_table
WHERE place LIKE '%California%'
GROUP BY nst
ORDER BY nst ASC;
```

Here's a breakdown of what each part of the query does:

```
SELECT COUNT(*) as num_earthquakes, AVG(mag) as avg_magnitude, nst as nst
```

- `SELECT COUNT(*) as num_earthquakes` counts the number of earthquakes and returns it as a new column called "num_earthquakes."
- `AVG(mag) as avg_magnitude` calculates the average magnitude of earthquakes and returns it as a new column called "avg_magnitude."
- `nst as nst` specifies the "nst" column to be returned in the result set.

```
FROM earthquakes_table
WHERE place LIKE '%California%'
```

- `FROM earthquakes_table` specifies the table from which to retrieve the data. In this case, the table is named "earthquakes_table."
- `WHERE place LIKE '%California%'` specifies the condition that the "place" column must contain the string "California" to be included in the result set.

```
GROUP BY nst
ORDER BY nst ASC;
```

- `GROUP BY nst` groups the earthquakes by the "nst" value.
- `ORDER BY nst ASC` sorts the results by the "nst" value in ascending order.


### 5. Sorting and Limit Executions

```sql
SELECT place, COUNT(*) as num_earthquakes, AVG(mag) as avg_magnitude
FROM earthquakes_table
WHERE time BETWEEN '2022-01-01' AND '2023-05-11'
GROUP BY place
HAVING COUNT(*) >= 10
ORDER BY num_earthquakes DESC;
```

This is a SQL query that retrieves the count of earthquakes, the average magnitude of earthquakes, and the place for earthquakes that occurred between January 1, 2022, and May 11, 2023, and have occurred at least 10 times in a specific location. The results are grouped by the "place" column and sorted by the "num_earthquakes" column in descending order. 

Here's a breakdown of what each part of the query does:

```
SELECT place, COUNT(*) as num_earthquakes, AVG(mag) as avg_magnitude
```

- `SELECT place` specifies the "place" column to be returned in the result set.
- `COUNT(*) as num_earthquakes` counts the number of earthquakes and returns it as a new column called "num_earthquakes."
- `AVG(mag) as avg_magnitude` calculates the average magnitude of earthquakes and returns it as a new column called "avg_magnitude."

```
FROM earthquakes_table
WHERE time BETWEEN '2022-01-01' AND '2023-05-11'
```

- `FROM earthquakes_table` specifies the table from which to retrieve the data. In this case, the table is named "earthquakes_table."
- `WHERE time BETWEEN '2022-01-01' AND '2023-05-11'` specifies the condition that the "time" column must be between January 1, 2022, and May 11, 2023, to be included in the result set.

```
GROUP BY place
HAVING COUNT(*) >= 10
ORDER BY num_earthquakes DESC;
```

- `GROUP BY place` groups the earthquakes by the "place" column.
- `HAVING COUNT(*) >= 10` specifies the condition that the count of earthquakes must be at least 10 for a specific location to be included in the result set.
- `ORDER BY num_earthquakes DESC` sorts the results by the "num_earthquakes" column in descending order.

![4DBMS](https://github.com/mohammedakbar982/dbmsproject2/assets/133189360/07655a03-5327-4307-96c3-26c02a5eee46)

### 6. Optimize the queries to speed up execution time

To speed up the search process, we create an index on the fclass field. And run ANALYZE after creating indexes

```sql
CREATE INDEX index_place ON earthquakes_table(mag, magType);
SELECT time, latitude, longitiude, place
FROM earthquakes_table
WHERE mag <= 4.0 AND type = 'earthquake' AND magType = 'md';
```

The first statement creates an index on the "mag" and "magType" columns of the "earthquakes_table" table. The purpose of creating an index is to improve query performance by allowing the database management system to quickly locate and retrieve the data needed to satisfy a query.

![5DBMS](https://github.com/mohammedakbar982/dbmsproject2/assets/133189360/95ace74e-07b2-4f00-b1ad-4dbdbe33f683)

----

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

![6DBMS](https://github.com/mohammedakbar982/dbmsproject2/assets/133189360/fa629dac-8559-4a60-8457-c0f476fdc05e)

----

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

![7DBMS](https://github.com/mohammedakbar982/dbmsproject2/assets/133189360/854872be-37eb-418d-9398-0d346f3d28af)


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

![8DBMS](https://github.com/mohammedakbar982/dbmsproject2/assets/133189360/f0c05e5f-06ae-4958-a9c8-d02445ba42f7)


