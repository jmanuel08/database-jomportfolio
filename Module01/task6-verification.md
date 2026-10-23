# Task 6: Telemetry Database and Query Timing

## 1. Objective

The goal of this task was to store telemetry data in SQLite and use SQL queries to analyze the readings from different machines.

## 2. Database Overview

I used the `shell-import.db` database to test my queries. It contains 172,800 readings from three machines.

| Item | Result |
|---|---|
| Database | `shell-import.db` |
| Table | `readings` |
| Total readings | 172,800 |
| Machines | cnc-01, cnc-02, cnc-03 |
| Readings per machine | 57,600 |
| `telemetry.db` size | About 10 MB |
| `shell-import.db` size | About 10 MB |

## 3. SQL Queries and Results

### Query 1: Count readings per machine

```sql
SELECT machine, COUNT(*) AS n
FROM readings
GROUP BY machine;
```

Each machine has 57,600 readings.

**Execution time:** 0.056 seconds

### Query 2: Find the highest vibration for each machine

```sql
SELECT machine, MAX(vib_rms) AS peak_vib
FROM readings
GROUP BY machine;
```

| Machine | Maximum vibration |
|---|---:|
| cnc-01 | 2.398 |
| cnc-02 | 3.168 |
| cnc-03 | 2.550 |

The highest vibration value was recorded for `cnc-02`.

**Execution time:** 0.055 seconds

### Query 3: Count readings with vibration above 2.0

```sql
SELECT COUNT(*)
FROM readings
WHERE vib_rms > 2.0;
```

The query returned 11,714 readings with a vibration value above 2.0.

**Execution time:** 0.016 seconds

## 4. Verification and Reflection

I used `.timer on` in the SQLite shell to measure how long each query took. The first query showed that all three machines had the same number of readings. The second query showed that `cnc-02` had the highest vibration value. The last query counted 11,714 readings above 2.0.

All three queries ran in less than one tenth of a second on my computer. The execution times may be different on other computers.

## 5. Cloud Cost Consideration

Running a database in the cloud can cost money for storage, computing resources, and data transfer. The total cost depends on the cloud provider and how often the database is used.