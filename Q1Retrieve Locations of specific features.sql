SELECT time, latitude, longitiude, place
FROM earthquakes_table
WHERE mag <= 4.0 AND type = 'earthquake' AND magType = 'md';
