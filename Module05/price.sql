
-- =====================================================
-- Module 5: Normalization vs. Denormalization
-- Round 5: Price It
-- =====================================================

PRAGMA foreign_keys = ON;

-- 1. ROWS TOUCHED EXPERIMENT

BEGIN TRANSACTION;

-- Update the normalized design
UPDATE machine
SET site = 'TestSite'
WHERE machine_id = 'cnc-02';

SELECT changes() AS normalized_rows_changed;

-- Update the denormalized reporting table
UPDATE report_jobpart
SET site = 'TestSite'
WHERE machine_id = 'cnc-02';

SELECT changes() AS denormalized_rows_changed;

ROLLBACK;

-- 2. STORAGE MEASUREMENTS

-- Check storage used by each database object
SELECT
    name,
    SUM(pgsize) AS storage_bytes,
    ROUND(SUM(pgsize) / 1024.0, 2) AS storage_kb
FROM dbstat
GROUP BY name
ORDER BY storage_bytes DESC;

-- 3. INDEX EXPERIMENT

.timer on

-- Query with the index
SELECT
    machine_id,
    technician,
    COUNT(*) AS total_jobs,
    ROUND(SUM(part_price), 2) AS total_part_cost
FROM report_jobpart
WHERE done_on >= date('2026-03-01')
GROUP BY machine_id, technician;

-- Remove the index temporarily
DROP INDEX IF EXISTS ix_report_machine;

-- Query without the index
SELECT
    machine_id,
    technician,
    COUNT(*) AS total_jobs,
    ROUND(SUM(part_price), 2) AS total_part_cost
FROM report_jobpart
WHERE done_on >= date('2026-03-01')
GROUP BY machine_id, technician;

-- Restore the index
CREATE INDEX ix_report_machine
ON report_jobpart(machine_id);

.timer off
