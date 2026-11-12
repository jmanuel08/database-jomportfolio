
-- =====================================================
-- Module 5: Normalization vs. Denormalization
-- Round 4: Race It
-- Benchmark normalized vs. denormalized queries
-- =====================================================

-- 1. Remove the old report table if it exists

DROP TABLE IF EXISTS report_jobpart;


-- 2. Create the denormalized reporting table

CREATE TABLE report_jobpart AS
SELECT
    j.job_id,
    m.machine_id,
    m.site,
    j.technician,
    jp.part_no,
    p.part_price,
    j.done_on
FROM job j
JOIN machine m
    ON m.machine_id = j.machine_id
JOIN job_part jp
    ON jp.job_id = j.job_id
JOIN part p
    ON p.part_no = jp.part_no;


-- 3. Create an index for the reporting table

CREATE INDEX ix_report_machine
ON report_jobpart(machine_id);


-- 4. Verify the report table row count

SELECT COUNT(*) AS report_jobpart_rows
FROM report_jobpart;


-- 5. Explain the normalized query plan

EXPLAIN QUERY PLAN
SELECT
    m.machine_id,
    m.site,
    j.technician,
    SUM(p.part_price) AS cost
FROM job j
JOIN machine m
    ON m.machine_id = j.machine_id
JOIN job_part jp
    ON jp.job_id = j.job_id
JOIN part p
    ON p.part_no = jp.part_no
WHERE j.done_on >= date('2026-03-01')
GROUP BY m.machine_id, j.technician;


-- 6. Explain the denormalized query plan

EXPLAIN QUERY PLAN
SELECT
    machine_id,
    site,
    technician,
    SUM(part_price) AS cost
FROM report_jobpart
WHERE done_on >= date('2026-03-01')
GROUP BY machine_id, technician;


-- 7. Warm up the normalized query

SELECT
    m.machine_id,
    m.site,
    j.technician,
    SUM(p.part_price) AS cost
FROM job j
JOIN machine m
    ON m.machine_id = j.machine_id
JOIN job_part jp
    ON jp.job_id = j.job_id
JOIN part p
    ON p.part_no = jp.part_no
WHERE j.done_on >= date('2026-03-01')
GROUP BY m.machine_id, j.technician;


-- 8. Warm up the denormalized query

SELECT
    machine_id,
    site,
    technician,
    SUM(part_price) AS cost
FROM report_jobpart
WHERE done_on >= date('2026-03-01')
GROUP BY machine_id, technician;


-- 9. Enable query timing

.timer on


-- 10. Benchmark normalized query

SELECT
    m.machine_id,
    m.site,
    j.technician,
    SUM(p.part_price) AS cost
FROM job j
JOIN machine m
    ON m.machine_id = j.machine_id
JOIN job_part jp
    ON jp.job_id = j.job_id
JOIN part p
    ON p.part_no = jp.part_no
WHERE j.done_on >= date('2026-03-01')
GROUP BY m.machine_id, j.technician;


-- 11. Benchmark denormalized query

SELECT
    machine_id,
    site,
    technician,
    SUM(part_price) AS cost
FROM report_jobpart
WHERE done_on >= date('2026-03-01')
GROUP BY machine_id, technician;
