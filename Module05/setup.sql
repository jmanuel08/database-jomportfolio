
-- =====================================================
-- Module 5: Normalization vs. Denormalization
-- Round 3: Build It
-- Create a 200,000-row flat dataset and normalize it
-- =====================================================

-- 1. Enable foreign key constraints
PRAGMA foreign_keys = ON;

-- 2. Remove old tables if they exist
DROP TABLE IF EXISTS job_part;
DROP TABLE IF EXISTS job;
DROP TABLE IF EXISTS part;
DROP TABLE IF EXISTS machine;
DROP TABLE IF EXISTS flat_jobpart;

-- 3. Create the original flat table
CREATE TABLE flat_jobpart (
    job_id INTEGER NOT NULL,
    machine_id TEXT NOT NULL,
    site TEXT NOT NULL,
    technician TEXT NOT NULL,
    part_no TEXT NOT NULL,
    part_price REAL NOT NULL,
    done_on TEXT NOT NULL,
    PRIMARY KEY (job_id, part_no)
);

-- 4. Generate approximately 200,000 records
WITH RECURSIVE numbers(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1
    FROM numbers
    WHERE n < 200000
)
INSERT INTO flat_jobpart
SELECT
    n AS job_id,
    'cnc-' || printf('%02d', ((n - 1) % 20) + 1),
    CASE
        WHEN ((n - 1) % 20) < 10 THEN 'Gütersloh'
        ELSE 'Bielefeld'
    END,
    'tech-' || ((n - 1) % 10),
    'P-' || printf('%04d', ((n - 1) % 100) + 1),
    ROUND(5.00 + (((n - 1) % 100) * 0.50), 2),
    date('2026-01-01', '+' || ((n - 1) % 365) || ' days')
FROM numbers;

-- 5. Create normalized tables

CREATE TABLE machine (
    machine_id TEXT PRIMARY KEY,
    site TEXT NOT NULL
);

CREATE TABLE part (
    part_no TEXT PRIMARY KEY,
    part_price REAL NOT NULL
);

CREATE TABLE job (
    job_id INTEGER PRIMARY KEY,
    machine_id TEXT NOT NULL REFERENCES machine(machine_id),
    technician TEXT NOT NULL,
    done_on TEXT NOT NULL
);

CREATE TABLE job_part (
    job_id INTEGER NOT NULL REFERENCES job(job_id),
    part_no TEXT NOT NULL REFERENCES part(part_no),
    PRIMARY KEY (job_id, part_no)
);

-- 6. Populate normalized tables

INSERT INTO machine (machine_id, site)
SELECT DISTINCT machine_id, site
FROM flat_jobpart;

INSERT INTO part (part_no, part_price)
SELECT DISTINCT part_no, part_price
FROM flat_jobpart;

INSERT INTO job (job_id, machine_id, technician, done_on)
SELECT DISTINCT job_id, machine_id, technician, done_on
FROM flat_jobpart;

INSERT INTO job_part (job_id, part_no)
SELECT job_id, part_no
FROM flat_jobpart;

-- 7. Verify row counts

SELECT 'flat_jobpart' AS table_name, COUNT(*) AS total_rows
FROM flat_jobpart
UNION ALL
SELECT 'machine', COUNT(*) FROM machine
UNION ALL
SELECT 'job', COUNT(*) FROM job
UNION ALL
SELECT 'part', COUNT(*) FROM part
UNION ALL
SELECT 'job_part', COUNT(*) FROM job_part;

-- 8. Verify foreign key integrity

PRAGMA foreign_key_check;
