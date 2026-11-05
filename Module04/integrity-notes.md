# Module 4 — Data Integrity, Constraints & Edge Cases
## Task A and Task B — Pod Study and Discussion Report

---

# Task A — Pod Study: Testing Data Integrity

## 1. Objective

The objective of this activity was to understand how database constraints protect data integrity. We compared an unconstrained SQLite table with a constrained table and tested how SQLite handles invalid data, duplicate identifiers, incorrect data types, and NULL values.

## 2. Experiment 1: Unconstrained Table

First, we created a table without constraints:

```sql
CREATE TABLE t(
    sensor_id INTEGER,
    metric TEXT,
    value REAL
);
```

We inserted three records containing questionable data:

```sql
INSERT INTO t VALUES
(1, 'temp_c', 9000),
(1, 'temp_c', 'hot'),
(2, 'bogus', -500);
```

**Actual result:** All three records were accepted without errors.

| Sensor ID | Metric | Value | Observation |
|---:|---|---:|---|
| 1 | temp_c | 9000 | Temperature exceeds the intended limit |
| 1 | temp_c | hot | Text was accepted in a REAL column |
| 2 | bogus | -500 | Invalid metric and questionable value |

The query:

```sql
SELECT COUNT(*) FROM t;
```

Returned:

```text
3
```

**Explanation:**

The unconstrained table allowed:
- Duplicate sensor IDs.
- Invalid metric names.
- Values outside the intended range.
- Text values in a column declared as REAL.

This demonstrates SQLite's flexible typing behavior in ordinary tables. The declared data type does not strictly prevent values of other storage classes from being stored.

## 3. Experiment 2: Constrained and STRICT Table

We replaced the original table with a constrained version:

```sql
CREATE TABLE t(
    sensor_id INTEGER PRIMARY KEY,
    metric TEXT NOT NULL
        CHECK(metric IN ('temp_c', 'vib_rms', 'spindle_load')),
    value REAL NOT NULL
        CHECK(value BETWEEN -273.15 AND 5000)
) STRICT;
```

We first inserted a valid record:

```sql
INSERT INTO t VALUES (1, 'temp_c', 41.5);
```

**Actual result:** Accepted successfully.

We then tested invalid records.

### Testing Results

| Test | Input | Expected | Actual | Constraint |
|---|---|---|---|---|
| Invalid temperature | 9000 | Rejected | Rejected | CHECK |
| Text in REAL column | hot | Rejected | Rejected | STRICT |
| Invalid metric | humidity | Rejected | Rejected | CHECK |
| Duplicate sensor ID | 1 | Rejected | Rejected | PRIMARY KEY |
| NULL metric | NULL | Rejected | Rejected | NOT NULL |
| NULL value | NULL | Rejected | Rejected | NOT NULL |

### Actual SQLite Error Messages

The following errors were observed during the experiments:

| Test | Actual SQLite error |
|---|---|
| Invalid temperature | `CHECK constraint failed: value BETWEEN -273.15 AND 5000 (19)` |
| Text in REAL column | `cannot store TEXT value in REAL column t.value (19)` |
| Invalid metric | `CHECK constraint failed: metric IN ('temp_c', 'vib_rms', 'spindle_load') (19)` |
| Duplicate sensor ID | `UNIQUE constraint failed: t.sensor_id (19)` |
| NULL metric | `NOT NULL constraint failed: t.metric (19)` |
| NULL value | `NOT NULL constraint failed: t.value (19)` |

Error code `(19)` indicates a SQLite constraint violation.

## 4. Experiment 3: CHECK Constraint and NULL Values

We created a table with a CHECK constraint but without NOT NULL:

```sql
CREATE TABLE check_null_test (
    value REAL CHECK(value > 0)
) STRICT;
```

We inserted NULL:

```sql
INSERT INTO check_null_test VALUES (NULL);
```

**Actual result:** SQLite accepted the NULL value without an error.

The query:

```sql
SELECT * FROM check_null_test;
```

Displayed an empty-looking value in the result.

**Explanation:**

A CHECK constraint rejects a row when its expression evaluates to FALSE (zero). However, when a comparison involves NULL, the result is NULL (unknown), not FALSE. Therefore, SQLite accepts the row.

## 5. Experiment 4: Combining NOT NULL and CHECK

We created another table with both constraints:

```sql
CREATE TABLE check_null_test_2 (
    value REAL NOT NULL CHECK(value > 0)
) STRICT;
```

We tested four different inputs:

| Input | Expected | Actual | Reason |
|---:|---|---|---|
| NULL | Rejected | Rejected | NOT NULL violation |
| 0 | Rejected | Rejected | CHECK violation |
| -5 | Rejected | Rejected | CHECK violation |
| 25.5 | Accepted | Accepted | Valid positive value |

### Actual results

For NULL:

```text
Runtime error: NOT NULL constraint failed: check_null_test_2.value (19)
```

For zero and negative values:

```text
Runtime error: CHECK constraint failed: value > 0 (19)
```

For 25.5, SQLite accepted the value.

The final query:

```sql
SELECT * FROM check_null_test_2;
```

Returned:

```text
value
-----
25.5
```

**Explanation:**

NOT NULL ensures that a value is provided, while CHECK validates whether the provided value satisfies the defined condition.

Combining both constraints prevents missing and invalid values.

---

# Task B — Sharing with Another Pod

## 6. Most Surprising Finding

One of the most surprising findings from our pod was that an unconstrained SQLite table accepted the text value `'hot'` in a column declared as REAL without producing an error.

Using `typeof()`, we observed that the value was stored as TEXT.

SQLite attempts to convert values to the declared column type when possible. For example:
- Text `'7'` can be converted into an integer.
- Non-numeric text such as `'abc'` remains stored as TEXT.

**Key takeaway:** In ordinary SQLite tables, a declared data type is a type preference rather than a strict rule.

## 7. Hardest Constraint to Understand: CHECK with NULL

The most challenging concept for our pod was understanding how CHECK constraints behave when handling NULL values.

For example:

```sql
CHECK(value BETWEEN -273.15 AND 5000)
```

This constraint still accepts NULL values.

The reason is that SQLite rejects a row when the CHECK expression evaluates to FALSE. A comparison involving NULL evaluates to NULL (unknown), so the row is accepted.

**Solution:** Combine CHECK with NOT NULL:

```sql
value REAL NOT NULL
CHECK(value BETWEEN -273.15 AND 5000)
```

This ensures that a value is provided and that it follows the defined range.

## 8. Additional Findings from the Pod Discussion

### A. UNIQUE and NULL values

A UNIQUE constraint on `(sensor_id, metric)` can accept multiple rows where `sensor_id` is NULL, even if the metric is identical.

SQLite treats NULL values as distinct for UNIQUE constraint purposes.

### B. STRICT and type conversion

STRICT tables allow values that can be converted to the declared type without losing information.

For example:
- Text `'1.0'` can be converted to INTEGER `1`.
- Decimal value `1.5` cannot be stored as INTEGER because conversion would lose its fractional part.

These findings demonstrate that STRICT tables enforce data types more strictly than ordinary tables, but they still allow valid lossless conversions.

## 9. Agreed Points

Based on our pod discussion, we identified the following points:

1. STRICT, NOT NULL, CHECK, and UNIQUE each enforce different aspects of data integrity. None completely replaces the others.
2. A CHECK constraint on a nullable column does not prevent NULL values. NOT NULL must be added when a value is required.
3. UNIQUE constraints do not treat NULL values as duplicates.
4. A range check can prevent values outside a defined range, but it does not guarantee that every accepted value is physically realistic.

For example, a temperature of 4999 °C would pass a CHECK constraint with a maximum value of 5000, even though it may be unrealistic for the intended industrial application.

## 10. Unresolved Questions

The following questions were raised for further discussion:

1. Should plausible measurement ranges be defined separately for each metric using conditional CHECK expressions (such as CASE) or database triggers?
2. Is it acceptable for STRICT tables to convert numeric text such as `'1.0'` into an INTEGER value?

These questions were identified for further discussion with the class.

---

# 11. Overall Conclusion

The experiments in Task A and the discussion in Task B demonstrated that maintaining data integrity requires more than simply declaring column data types.

Task A showed through practical SQLite experiments that an unconstrained table can accept questionable records, while a properly constrained table rejects invalid values, duplicate identifiers, and missing required data.

Task B expanded our understanding through additional observations about UNIQUE constraints, NULL values, STRICT type conversion, and the limitations of range checks.

The main lesson is that database constraints work together to protect data quality. However, technically valid data is not always realistic data. For industrial applications, database designers must consider both technical integrity and the physical meaning of the stored measurements.