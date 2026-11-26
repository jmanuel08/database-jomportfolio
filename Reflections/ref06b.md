
# Module 6b – Polyglot Persistence & the Decision

## 1. JSON Metadata in SQLite

In this task, I learned how SQLite can store and work with semi-structured JSON data. Instead of creating a separate column for every device property, I stored the metadata in a JSON column.

I used `json_extract()` to retrieve specific values, `->>` to extract scalar values, and `json_each()` to turn JSON objects into individual rows.

I also created an expression index for the vendor field and compared two query plans using `EXPLAIN QUERY PLAN`.

The first query used the expression index:

`SEARCH device USING INDEX ix_device_vendor`

The second query performed a full table scan:

`SCAN device`

This showed me that SQLite needs the query expression to match the indexed expression to use the index. Even if two expressions retrieve the same value, they may produce different query plans.

### Evidence 1 – JSON Benchmark

The screenshot below shows the actual output of my JSON benchmark, including JSON extraction, JSON rows, and both query plans.

![JSON Benchmark Evidence](evidence/06b-json-benchmark.png)


## 2. Key-Value Storage: Shelve vs. SQLite

In this benchmark, I compared Python's `shelve` with SQLite using 50,000 session records.

| Operation | Shelve | SQLite |
|---|---:|---:|
| Set (write) | 1.757 s | 0.040 s |
| Get (read) | 0.128 s | 0.185 s |

SQLite was much faster when writing the records. Shelve was slightly faster when reading them. This shows that performance depends on the type of operation.

For the dashboard session workload, I would choose SQLite. Although Shelve was faster for reading in this test, SQLite had much faster writes and offers more querying capabilities.

One thing SQLite can do that Shelve cannot easily do is query across all sessions. For example, SQLite can count how many users selected a particular city filter. Shelve is mainly designed for retrieving values using individual keys.

### Evidence 2 – Key-Value Benchmark

The screenshot below shows the actual benchmark results for Shelve and SQLite.

![Key-Value Benchmark Evidence](evidence/06b-kv-benchmark.png)

## 3. Choosing the Right Database Engine

After completing the benchmarks, I learned that different database engines are designed for different workloads.

For regular operational writes and transactions, I would choose SQLite. In my Module 6a boundary benchmark, SQLite performed much faster than DuckDB for individual inserts and lookups.

For large analytical reports, I would choose DuckDB with Parquet. In my monthly report benchmark, DuckDB was approximately 134 times faster than SQLite. The compressed Parquet file also reduced the dataset size from 10.44 MB to 2.69 MB.

For flexible vendor metadata, SQLite with JSON is a practical choice. It allows additional fields without changing the table structure every time. However, I learned that an expression index only works when the query uses the matching expression.

For dashboard session storage, I would choose SQLite based on my benchmark. It was much faster at writing 50,000 records than Shelve, although Shelve was slightly faster at reading them.

## 4. Server Contrast – Pending

I prepared the PostgreSQL comparison, but I have not performed the actual server exercise because I have not received access to the instructor's PostgreSQL server.

Therefore, I cannot report real observations about connecting, concurrent writers, or server failure yet.

I understand that a server database introduces additional requirements, such as network connectivity, credentials, and server availability. Unlike an embedded database, clients may lose access when the server or network becomes unavailable. These are currently conceptual observations, not results from my own server test.

I will update this section when the instructor provides access or demonstrates the exercise.

## 5. ACID, BASE, and CAP

ACID describes transaction properties such as atomicity, consistency, isolation, and durability. SQLite uses transactions to help protect operational data.

BASE describes an approach that prioritizes availability and eventual consistency in distributed systems.

The CAP theorem explains the trade-offs between consistency, availability, and partition tolerance in distributed systems. A network partition can prevent a distributed database from providing both full consistency and availability at the same time.

I have studied these concepts, but the PostgreSQL server exercise is still pending, so I have not yet observed these trade-offs directly.

## 6. Final Reflection

My main lesson from Module 6b is that there is no single database engine that is best for every workload.

SQLite is suitable for operational data, DuckDB with Parquet is suitable for analytical workloads, and SQLite JSON provides flexibility for changing metadata.

If Kortmann could run only one engine, I would choose SQLite because it supports the operational workload. However, large analytical reports would become slower.

Combining engines allows each workload to use the technology that fits it best. The trade-off is additional maintenance and the need to keep copied data up to date.