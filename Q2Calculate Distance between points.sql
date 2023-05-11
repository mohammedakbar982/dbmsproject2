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
