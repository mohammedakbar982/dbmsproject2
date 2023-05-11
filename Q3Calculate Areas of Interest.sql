SELECT place, COUNT(*) as num_earthquakes, AVG(mag) as avg_magnitude, 
       MAX(mag) as max_magnitude, MIN(mag) as min_magnitude
FROM earthquakes_table
WHERE time BETWEEN '2022-01-01' AND '2023-05-11'
GROUP BY place
HAVING COUNT(*) >= 10
ORDER BY num_earthquakes DESC, avg_magnitude DESC;
