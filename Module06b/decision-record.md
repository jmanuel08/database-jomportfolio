# Module 6b – Engine Decision Record

## 1. Database Engine Decisions

The following decisions are based on the measurements and observations from Modules 6a and 6b.

| Workload | Engine | Why | Evidence | Cost Accepted | If the Copy Is Stale |
|---|---|---|---|---|---|
| Sensor/job ingest every 30 seconds | SQLite | SQLite is suitable for regular operational transactions and individual writes. | In the Module 6a boundary benchmark, SQLite inserts took 0.5 ms, compared with 243.6 ms for DuckDB. Batch inserts also favored SQLite. | Large analytical queries are slower in SQLite compared with DuckDB. | SQLite remains the main source of truth. Analytical copies must be refreshed regularly. |
| Month-end report over two years | DuckDB + Parquet | DuckDB is designed for analytical queries over large datasets. Parquet also reduces storage size. | DuckDB was approximately 134 times faster for the monthly workload and 176 times faster for the dashboard workload. ZSTD Parquet reduced the dataset from 10.44 MB to 2.69 MB. | Reports depend on exported data and may not contain the newest transactions. | Refresh the Parquet files regularly, for example through a nightly export, and monitor the refresh process. |
| Vendor metadata that gains fields | SQLite with JSON | JSON allows vendor metadata to contain different fields without adding a new database column for every property. | The JSON benchmark demonstrated `json_extract()`, `json_each()`, and an expression index. The query plan showed that the matching expression index was used. | JSON fields are less strictly structured, and queries must match the indexed expression to use the index. | Refresh any exported copy of the metadata when the source records change. |
| Dashboard session state | SQLite | SQLite provides key-based access and can also query across multiple sessions. It was much faster at writing in my benchmark. | SQLite wrote 50,000 records in 0.040 seconds, while Shelve took 1.757 seconds. Shelve was slightly faster for reads. | SQLite reads were slightly slower in this test, and the database requires maintenance. | Keep current session data in the main database rather than relying on an outdated copy. |
| Optional: Concurrent users on the network | PostgreSQL (proposed) | A server database allows multiple clients to connect through a shared database server. | The PostgreSQL server exercise was prepared, but I did not have access to the instructor's server, so I could not collect actual observations. | It requires a running server, network connection, credentials, and administration. | Clients may lose access if the server or network becomes unavailable. |

## 2. If Kortmann Could Run Only One Engine

If Kortmann could run only one engine, I would choose SQLite.

SQLite is a good choice for the main operational database because it supports transactions and performed much better than DuckDB in my insert benchmark. It can also store JSON metadata and dashboard session information.

However, large analytical reports would be slower compared with DuckDB. This would be the first major disadvantage if SQLite were the only engine.

For this reason, using SQLite together with DuckDB and Parquet is a better solution when both operational work and large analytical reports are important.

## 3. Defence Notes

**Question: Which decision has the weakest measurement?**

The PostgreSQL decision has the weakest evidence because I prepared the exercise but could not access the instructor's server to perform the actual test.

**Question: Where is data duplicated, and who updates it?**

Data is duplicated when operational records from SQLite are exported into Parquet files for analytical queries. The export process must update these files regularly. The refresh process should also be monitored to detect failures.

**Question: What happens if two people write at the same time?**

SQLite supports concurrent access, but it allows only one writer at a time. A server database such as PostgreSQL is more suitable for workloads requiring multiple concurrent clients.

**Question: Why use databases instead of spreadsheets?**

Databases provide structured storage, constraints, transactions, indexes, and the ability to query large amounts of data. These features are important for reliable operational records and analytical workloads.

## 4. Reflection After the Defence

Peer defence has not yet been completed. Therefore, I have not recorded any changes based on a peer discussion.

My current decision is to use SQLite for operational data and DuckDB with Parquet for analytical workloads. This combination provides a balance between reliable transactions, query performance, and storage efficiency.

I will update this decision record if the PostgreSQL server exercise or peer defence provides new observations that change my decisions.