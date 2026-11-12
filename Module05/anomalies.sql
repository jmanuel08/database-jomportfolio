
-- =====================================================
-- Module 5: Normalization vs. Denormalization
-- Round 2: Break It
-- Demonstrating Update, Insert, and Delete Anomalies
-- =====================================================


-- 1. CREATE THE ORIGINAL FLAT TABLE

DROP TABLE IF EXISTS flat5;

CREATE TABLE flat5 (
    job_id INTEGER NOT NULL,
    machine_id TEXT,
    site TEXT,
    technician TEXT,
    part_no TEXT NOT NULL,
    part_price REAL,
    PRIMARY KEY (job_id, part_no)
);


-- 2. INSERT SAMPLE DATA

INSERT INTO flat5 VALUES
(1, 'cnc-01', 'Gütersloh', 'tech-0', 'P-0001', 6.00),
(1, 'cnc-01', 'Gütersloh', 'tech-0', 'P-0002', 7.00),
(2, 'cnc-02', 'Gütersloh', 'tech-1', 'P-0001', 6.00),
(2, 'cnc-02', 'Gütersloh', 'tech-1', 'P-0003', 8.50),
(3, 'cnc-01', 'Gütersloh', 'tech-0', 'P-0003', 8.50);


-- 3. DISPLAY ORIGINAL DATA

SELECT * FROM flat5;


-- 4. UPDATE ANOMALY

-- Change the site of machine cnc-01.
-- The same machine information is repeated in multiple rows.

UPDATE flat5
SET site = 'Bielefeld'
WHERE machine_id = 'cnc-01';

-- Count the rows affected by the update.

SELECT changes() AS rows_changed_by_update;

-- Display the updated data.

SELECT * FROM flat5;


-- 5. INSERT ANOMALY

-- Try to insert a new part without assigning it to a job.
-- This fails because job_id is part of the primary key
-- and cannot be NULL.

INSERT INTO flat5 (
    job_id,
    machine_id,
    site,
    technician,
    part_no,
    part_price
)
VALUES (
    NULL,
    NULL,
    NULL,
    NULL,
    'P-0004',
    12.00
);


-- 6. DELETE ANOMALY

-- Delete the only record containing part P-0002.
-- Its part information and price will also disappear
-- from the flat table.

DELETE FROM flat5
WHERE job_id = 1
AND part_no = 'P-0002';

-- Display the remaining records.

SELECT * FROM flat5;

-- Check whether part P-0002 still exists.

SELECT * FROM flat5
WHERE part_no = 'P-0002';
