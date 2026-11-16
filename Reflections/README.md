# Module 6a – The Analytical Engine (DuckDB)

## Learning Goals

By the end of this module, I learned how to:

1. Transfer data from SQLite to Parquet using a Python script.
2. Compare SQLite and DuckDB performance using the same queries, multiple runs, and median results.
3. Read `EXPLAIN ANALYZE` and identify the main operations and number of rows processed.
4. Identify situations where DuckDB is not the best choice based on actual performance measurements.
5. Decide which workloads are suitable for analytical databases and how to keep the data updated.

## Module Contents

| File | Description |
|---|---|
| `prepare.py` | Creates a larger historical dataset using the Module 5 database. |
| `to_parquet.py` | Converts the historical data into Parquet files, including a ZSTD-compressed version. |
| `race.py` | Compares SQLite and DuckDB query performance. |
| `plan.py` | Examines query execution plans using `EXPLAIN ANALYZE`. |
| `boundary.py` | Compares insert and lookup performance between SQLite and DuckDB. |
| `duckdb-notes.md` | Contains measurements, results, and explanations from the module. |
| `decision-memo.md` | Presents the recommendation for analytical reporting. |

## Key Findings

- DuckDB was 176.2 times faster than SQLite for the dashboard query.
- DuckDB was 134.3 times faster for the monthly report.
- The ZSTD-compressed Parquet file was 2.69 MB, compared with 10.44 MB for the original Parquet file.
- SQLite performed better for individual inserts and lookups.

## Reflection

[Read my Module 6a Reflection](../Reflections/ref06a.md)