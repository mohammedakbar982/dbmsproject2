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
