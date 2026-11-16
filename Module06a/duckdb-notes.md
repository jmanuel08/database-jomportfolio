# Module 6a – DuckDB Analytical Engine

## Round 1 – Build

- Created a SQLite history database using the Module 5 normalized database.
- Original `report_jobpart` table: 200,000 rows.
- Expanded history dataset: 2,000,000 rows.
- Exported the dataset as CSV.

## Round 2 – Convert

- Converted the CSV dataset into Parquet using DuckDB.
- Verified the Parquet dataset contains 2,000,000 rows.
- SQLite total `part_price`: 59,500,000.0
- DuckDB Parquet total `part_price`: 59,500,000.0
- Parquet file size: 10.44 MB.

## Round 3 – Race

Dataset: 2,000,000 rows.

| Query | SQLite median [min–max] | DuckDB median [min–max] | Speedup |
|---|---:|---:|---:|
| Dashboard | 864.7 ms [825.4–877.8] | 4.9 ms [4.7–7.1] | 176.2x |
| Monthly | 748.9 ms [741.7–821.1] | 5.6 ms [5.4–6.0] | 134.3x |

**Observation:**

DuckDB was significantly faster than SQLite for both analytical queries. It achieved approximately 176.2x speedup for the dashboard query and 134.3x for the monthly query.

## Round 4 – Plan

### DuckDB

#### EXPLAIN ANALYZE – Actual Output

```text
Total Time: 0.0187s

HASH_GROUP_BY
  Aggregates: sum(#3)
  20 rows

PROJECTION
  machine_id, site, technician, part_price
  2,000,000 rows

TABLE_SCAN
  Function: READ_PARQUET
  Projections: machine_id, site, technician, part_price
  2,000,000 rows
```

**Dominating work:** `HASH_GROUP_BY` is the most time-consuming operator in the displayed plan, with a reported time of 0.05s. It aggregates the 2,000,000 input rows into 20 groups. `TABLE_SCAN` reads the 2,000,000 rows from the Parquet file, while `PROJECTION` passes only the four required columns to the aggregation step.

**Observation:** DuckDB reads only the four required columns instead of all seven columns. This reduces the amount of data read during the analytical query.

- Used EXPLAIN ANALYZE to inspect query execution.
- TABLE_SCAN read the Parquet file.
- DuckDB read only the four required columns.
- HASH_GROUP_BY grouped the 2,000,000 rows into 20 groups.
- Total execution time: 0.0187 seconds.

### SQLite

- SCAN report_history shows that SQLite scans the table.
- USE TEMP B-TREE FOR GROUP BY shows that SQLite uses a temporary B-tree to group the results.

**Observation:**

DuckDB uses a columnar scan and hash aggregation for analytical queries, while SQLite scans its table and uses a temporary B-tree for grouping.

## Round 5 – Boundary

Test: 1,000 individual INSERT statements and 1,000 individual SELECT lookups.

| Operation | SQLite | DuckDB |
|---|---:|---:|
| 1,000 inserts | 0.5 ms | 243.6 ms |
| 1,000 lookups | 0.5 ms | 105.1 ms |

**Observation:**

SQLite was approximately 487x faster for individual inserts and 210x faster for individual lookups in this test.

This demonstrates that DuckDB is not the best choice for every workload. SQLite is better suited for frequent individual writes and point lookups, while DuckDB is designed for large analytical queries.

### Batch Insert Experiment

I also tested batch inserts using Python's `executemany()`.

| Operation | SQLite | DuckDB |
|---|---:|---:|
| 1,000 batch inserts | 0.3 ms | 203.7 ms |
| 1,000 individual lookups | 0.5 ms | 101.7 ms |

Batch insertion improved DuckDB's insert time from 243.6 ms to 203.7 ms (approximately 16.4% faster).

However, SQLite remained significantly faster for this small transactional workload. The lookup performance also remained almost unchanged.

**Observation:** Batch inserts help DuckDB, but they do not make it a better choice than SQLite for small, individual transactional operations.

## Round 6 – ZSTD Compression

- Created a second Parquet file using ZSTD compression.
- Original Parquet file size: 10.44 MB.
- ZSTD-compressed Parquet file size: 2.69 MB.
- Storage reduction: approximately 74.2%.
- Both files contain the same 2,000,000 rows and data.

**Observation:**

ZSTD compression significantly reduced the Parquet file size from 10.44 MB to 2.69 MB. This saves approximately 74.2% of storage space while preserving the dataset. Compressed Parquet files are useful for storing large historical datasets more efficiently.

## Storage Size Comparison

| Storage format | File size |
|---|---:|
| SQLite (`history.db`) | 114 MB |
| Original Parquet | 10 MB |
| ZSTD Parquet | 2.6 MB |

**Observation:**

The Parquet file uses less storage space than the SQLite database. Applying ZSTD compression reduced the Parquet file size even further, making it more efficient for storing historical analytical data.

### ZSTD Data Verification

| Check | Original Parquet | ZSTD Parquet |
|---|---:|---:|
| Row count | 2,000,000 | 2,000,000 |
| Total `part_price` | 59,500,000.0 | 59,500,000.0 |

**Result:**

Both files contain the same number of rows and the same total `part_price`. ZSTD compression reduced the file size without changing the verified data.