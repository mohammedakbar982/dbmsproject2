CREATE INDEX index_place ON earthquakes_table(mag, magType);

CREATE INDEX index_lat_long ON earthquakes_table (latitude, longitiude);

CREATE INDEX mag_type_index ON earthquakes_table (place);
