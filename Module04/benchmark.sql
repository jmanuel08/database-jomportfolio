-- Benchmark setup
DROP TABLE IF EXISTS bench_alarm;
DROP TABLE IF EXISTS bench_reading;
DROP TABLE IF EXISTS bench_sensor;

CREATE TABLE bench_sensor (
    sensor_id INTEGER PRIMARY KEY,
    metric TEXT NOT NULL
);

INSERT INTO bench_sensor VALUES (1, 'vib_rms');

CREATE TABLE bench_reading (
    reading_id INTEGER PRIMARY KEY,
    sensor_id INTEGER NOT NULL,
    ts TEXT NOT NULL,
    value REAL NOT NULL,
    interval_s INTEGER NOT NULL
);

CREATE TABLE bench_alarm (
    alarm_id INTEGER PRIMARY KEY,
    sensor_id INTEGER NOT NULL,
    ts TEXT NOT NULL,
    value REAL NOT NULL
);

-- Test 1: 10,000 readings WITHOUT trigger
WITH RECURSIVE numbers(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 10000
)
INSERT INTO bench_reading(sensor_id, ts, value, interval_s)
SELECT
    1,
    datetime('2026-11-12 00:00:00', '+' || n || ' seconds'),
    2.5,
    1
FROM numbers;

-- Clear readings before Test 2
DELETE FROM bench_reading;

-- Create alarm trigger
CREATE TRIGGER bench_vib_alarm
AFTER INSERT ON bench_reading
FOR EACH ROW
WHEN NEW.value > 2.0
BEGIN
    INSERT INTO bench_alarm(sensor_id, ts, value)
    VALUES (NEW.sensor_id, NEW.ts, NEW.value);
END;

-- Test 2: 10,000 readings WITH trigger
WITH RECURSIVE numbers(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 10000
)
INSERT INTO bench_reading(sensor_id, ts, value, interval_s)
SELECT
    1,
    datetime('2026-11-12 00:00:00', '+' || n || ' seconds'),
    2.5,
    1
FROM numbers;