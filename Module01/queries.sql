SELECT COUNT(*) AS total_readings
FROM readings;

SELECT machine, AVG(temp_c) AS average_temperature
FROM readings
GROUP BY machine
ORDER BY average_temperature DESC;