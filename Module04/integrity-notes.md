# Module 4 — Data Integrity and Triggers

# Task A — Testing Data Integrity

## 1. Objective

The goal of this task was to understand how SQLite protects data using constraints.

## 2. Table Without Constraints

First, we created a table without constraints.

```sql
CREATE TABLE t(
    sensor_id INTEGER,
    metric TEXT,
    value REAL
);
```

We inserted three records:

```sql
INSERT INTO t VALUES
(1, 'temp_c', 9000),
(1, 'temp_c', 'hot'),
(2, 'bogus', -500);
```

**Result:** All three records were accepted.

| Sensor ID | Metric | Value |
|---|---|---|
| 1 | temp_c | 9000 |
| 1 | temp_c | hot |
| 2 | bogus | -500 |

The table accepted all records because it had no constraints.

## 3. Table With Constraints and STRICT

Next, we created a table with constraints.

```sql
CREATE TABLE t(
    sensor_id INTEGER PRIMARY KEY,
    metric TEXT NOT NULL
        CHECK(metric IN ('temp_c', 'vib_rms', 'spindle_load')),
    value REAL NOT NULL
        CHECK(value BETWEEN -273.15 AND 5000)
) STRICT;
```

We tested different values.

| Test | Result |
|---|---|
| Temperature 9000 | Rejected |
| Text 'hot' in REAL column | Rejected |
| Invalid metric | Rejected |
| Duplicate sensor ID | Rejected |
| NULL metric | Rejected |
| NULL value | Rejected |

**Actual errors from SQLite:**

- `CHECK constraint failed`
- `cannot store TEXT value in REAL column`
- `UNIQUE constraint failed`
- `NOT NULL constraint failed`

**What I learned:**

- PRIMARY KEY prevents duplicate IDs.
- NOT NULL does not allow empty values.
- CHECK checks if a value follows a condition.
- STRICT checks the data type.

## 4. CHECK and NULL

We created a table with CHECK but without NOT NULL.

```sql
CREATE TABLE check_null_test (
    value REAL CHECK(value > 0)
) STRICT;
```

Then we inserted NULL:

```sql
INSERT INTO check_null_test VALUES (NULL);
```

**Result:** SQLite accepted NULL.

This shows that CHECK alone does not prevent NULL values.

## 5. Using NOT NULL and CHECK Together

We created another table:

```sql
CREATE TABLE check_null_test_2 (
    value REAL NOT NULL CHECK(value > 0)
) STRICT;
```

We tested different values.

| Input | Result |
|---|---|
| NULL | Rejected |
| 0 | Rejected |
| -5 | Rejected |
| 25.5 | Accepted |

**What I learned:**

NOT NULL makes sure that a value is provided. CHECK makes sure that the value follows the required condition.

---

# Task B — Pod Discussion

## 6. Most Surprising Finding

Our most surprising finding was that a normal SQLite table accepted the text `'hot'` in a column declared as REAL.

We learned that normal SQLite tables can accept different data types in a column.

## 7. Hardest Concept

The hardest concept for our pod was understanding CHECK and NULL.

We learned that CHECK alone does not reject NULL. We need NOT NULL if the value is required.

## 8. Other Findings

**UNIQUE and NULL**

A UNIQUE constraint can allow multiple NULL values.

**STRICT and Type Conversion**

STRICT tables can convert some values when the conversion does not lose information.

## 9. Agreed Points

Our pod agreed that:

1. Each constraint has a different purpose.
2. CHECK alone does not prevent NULL.
3. UNIQUE can allow multiple NULL values.
4. A value can be accepted by the database but still be unrealistic.

## 10. Conclusion

I learned that constraints are important for keeping data correct. They help prevent duplicate IDs, missing values, invalid values, and incorrect data types.

---

# Studio Task 1 — Prove the Constraints Work

## 1. Objective

The goal was to test if our database could reject invalid data.

## 2. Sensor and Reading Tables

We created two tables: `sensor` and `reading`.

The sensor table uses PRIMARY KEY, NOT NULL, CHECK, and UNIQUE constraints.

The reading table uses FOREIGN KEY, NOT NULL, CHECK, and a generated column.

The generated column calculates energy using:

```sql
energy_j = value * interval_s
```

## 3. Foreign Key Test

We tried to insert a reading with sensor ID 99, which does not exist.

```sql
INSERT INTO reading(sensor_id, ts, value, interval_s)
VALUES (99, '2026-11-05 12:40:00', 30.0, 10);
```

**Actual result:**

```text
Runtime error: FOREIGN KEY constraint failed (19)
```

The database rejected the record because the sensor ID does not exist.

## 4. Generated Column

The `energy_j` column calculates its value automatically.

For example:

```text
41.5 * 10 = 415.0
```

**What I learned:**

The database can calculate values automatically and prevent invalid records using constraints.

---

# Studio Task 2 — Idempotent Edge Ingestion with UPSERT

## 1. Objective

The goal was to insert sensor readings without creating duplicates when the same data is imported again.

## 2. Unique Index

We created a unique index using `sensor_id` and `ts`.

```sql
CREATE UNIQUE INDEX ux_reading_sensor_ts
ON reading(sensor_id, ts);
```

This prevents the same sensor and timestamp from being stored more than once.

## 3. UPSERT

We used this SQL statement:

```sql
INSERT INTO reading (sensor_id, ts, value, interval_s)
VALUES (?, ?, ?, ?)
ON CONFLICT(sensor_id, ts)
DO UPDATE SET value = excluded.value;
```

If the same sensor and timestamp already exist, SQLite updates the value instead of creating another row.

## 4. Python Ingestion

We created two files:

- `Module04/readings.csv` — contains the sensor readings.
- `Module04/ingest.py` — reads the CSV file and inserts the data into SQLite.

The Python script uses `executemany()` to process multiple records.

## 5. Testing

We ran the Python script twice.

| Execution | Result |
|---|---|
| First run | Successfully processed 2 readings |
| Second run | Successfully processed 2 readings |

We checked the database after both runs.

**Actual result:**

| Sensor ID | Timestamp | Value | Interval | Copies |
|---|---|---:|---:|---:|
| 1 | 2026-11-16 10:00:00 | 42.0 | 10 | 1 |
| 3 | 2026-11-16 10:01:00 | 70.0 | 5 | 1 |

Each reading appeared only once.

## 6. Conclusion

I learned that UPSERT helps prevent duplicate records. Even after running the Python script twice, the database still had only one record for each sensor and timestamp.

---

# Studio Task 3 — Triggers for Alarms and Audit

## 1. Objective

The goal was to create triggers that automatically save alarms and record changes in the database.

## 2. Alarm Trigger

We created an alarm table and a trigger for vibration readings.

The trigger creates an alarm when vibration is higher than 2.0 mm/s.

```sql
CREATE TRIGGER trg_vib_alarm
AFTER INSERT ON reading
FOR EACH ROW
WHEN NEW.value > 2.0
AND (
    SELECT metric
    FROM sensor
    WHERE sensor_id = NEW.sensor_id
) = 'vib_rms'
BEGIN
    INSERT INTO alarm(sensor_id, ts, value, reason)
    VALUES (
        NEW.sensor_id,
        NEW.ts,
        NEW.value,
        'vibration over 2.0 mm/s'
    );
END;
```

We tested it using a vibration value of 2.7.

**Actual result:**

```text
1|2|2026-11-12 12:00:00|2.7|vibration over 2.0 mm/s
```

The alarm was created automatically.

## 3. Audit Trigger

We also created an audit table and a trigger to record changes in reading values.

```sql
CREATE TRIGGER trg_reading_audit
AFTER UPDATE OF value ON reading
FOR EACH ROW
BEGIN
    INSERT INTO audit(reading_id, old_value, new_value)
    VALUES (NEW.reading_id, OLD.value, NEW.value);
END;
```

We changed the value of reading ID 4 from 45.0 to 50.0.

**Actual result:**

```text
1|4|45.0|50.0|2026-11-12 10:45:34
```

The audit table saved the old value and the new value.

## 4. Trigger Benchmark

We tested the time needed to insert 10,000 readings with and without a trigger.

| Test | Records | Time |
|---|---:|---:|
| Without trigger | 10,000 | 0.009 seconds |
| With trigger | 10,000 | 0.012 seconds |

We also checked the results:

- Readings inserted: 10,000
- Alarm records generated: 10,000

**What I learned:**

Triggers can automatically create alarms and save changes. However, they can make database operations slightly slower.

---

# Studio Task 4 — Access Control Without a Server

## 1. Objective

The goal was to test how SQLite handles read-only access.

## 2. Creating a View

We created a view called `machine_health`.

```sql
CREATE VIEW machine_health AS
SELECT
    s.machine_id,
    s.metric,
    MAX(r.value) AS peak,
    COUNT(*) AS n
FROM sensor s
JOIN reading r USING(sensor_id)
GROUP BY s.machine_id, s.metric;
```

The view shows a summary of machine readings.

## 3. Read-Only Test

First, we changed the database file permission:

```bash
chmod 444 Module04/edge.db
```

Then we tested if we could read the database:

```bash
sqlite3 "file:Module04/edge.db?mode=ro" "SELECT COUNT(*) FROM reading;"
```

**Actual result:**

```text
5
```

The SELECT command worked.

Next, we tried to delete records:

```bash
sqlite3 "file:Module04/edge.db?mode=ro" "DELETE FROM reading;"
```

**Actual error:**

```text
Error: stepping, attempt to write a readonly database (8)
```

SQLite did not allow the DELETE command.

## 4. Restoring Permission

After the test, we restored write permission:

```bash
chmod 644 Module04/edge.db
```

## 5. SQLite and PostgreSQL

SQLite does not have GRANT and REVOKE commands like PostgreSQL. PostgreSQL uses users and roles to control who can access the database. SQLite can use file permissions and read-only connections instead. This is useful for a local database, but it is not enough for a web application with many users who need different permissions.

## 6. Conclusion

I learned that SQLite can restrict writing by using read-only connections and file permissions. These features are useful for local database applications.

---

# Overall Module 4 Conclusion

In this module, I learned how to protect data using SQLite constraints.

I also learned how to use UPSERT to prevent duplicate readings and triggers to create alarms and record changes automatically.

Finally, I tested how to make the database read-only using file permissions and read-only connections.

This module helped me understand how SQLite can protect data and perform important tasks without needing a separate database server.