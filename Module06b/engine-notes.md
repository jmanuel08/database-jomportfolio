# Module 6b – Engine Notes

## Bench 1 – JSON Metadata in SQLite

I used SQLite to store semi-structured device metadata in a JSON column.

I tested three JSON operations:

- `json_extract()` to retrieve a specific JSON value.
- `->>` to extract a scalar value.
- `json_each()` to turn JSON objects into individual rows.

I also created an expression index for the vendor field and checked the query plans using `EXPLAIN QUERY PLAN`.

**Actual observations:**

- The query using `json_extract(meta, '$.vendor')` used the expression index.
- The query using `meta ->> 'vendor'` performed a full table scan.
- The query expression needs to match the indexed expression for SQLite to use that index.

**Evidence:** `Reflections/evidence/06b-json-benchmark.png`

## Bench 2 – Key-Value Storage

I compared Python's `shelve` with SQLite using 50,000 session records.

### Actual benchmark results

| Operation | Shelve | SQLite |
|---|---:|---:|
| Set (write) | 1.757 s | 0.040 s |
| Get (read) | 0.128 s | 0.185 s |

**Observations:**

- SQLite was much faster when writing records in this benchmark.
- Shelve was slightly faster when reading records.
- SQLite can also query across multiple sessions, while Shelve is mainly designed for retrieving values by individual keys.

**Decision:** I would choose SQLite for the dashboard session workload because of its faster writes in this test and its additional querying capabilities.

**Evidence:** `Reflections/evidence/06b-kv-benchmark.png`

## Bench 3 – PostgreSQL Server

**Status: Not yet executed.**

I did not have access to the instructor's PostgreSQL server during this exercise.

The connection procedure, sample SQL, and concurrent-writer test are documented in `server_comparison.md`.

Actual observations about server connections, concurrent writers, and server availability still need to be collected.

## Bench 4 – Engine Decision Record

**Status: Draft completed; peer defence pending.**

I prepared the engine decision record using measurements and observations from Modules 6a and 6b.

My current decisions are:

- **Operational sensor/job data:** SQLite, based on the Module 6a boundary benchmark.
- **Month-end analytical reports:** DuckDB with Parquet, based on the monthly report performance and storage-size measurements.
- **Vendor metadata:** SQLite with JSON, based on the JSON benchmark.
- **Dashboard session state:** SQLite, based on the Shelve versus SQLite benchmark.
- **Concurrent users on a network:** PostgreSQL is proposed, but the server exercise has not yet been performed.

The decision record and defence notes are saved in `decision-record.md`.

The peer defence and any changes resulting from the discussion are still pending.