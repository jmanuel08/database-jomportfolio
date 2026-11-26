# Module 6b – Polyglot Persistence & the Decision

## Overview

This module explores how different database engines can support different workloads. I worked with SQLite, JSON metadata, and key-value storage, then prepared a decision record explaining which database engine is suitable for each workload.

## Learning Goals

- Store and query semi-structured JSON data in SQLite.
- Compare Python Shelve with SQLite for key-value storage.
- Understand the differences between embedded and server databases.
- Explain ACID, BASE, and CAP in practical terms.
- Choose a database engine based on measurements and workload requirements.

## Files

| File | Description |
|---|---|
| `json_bench.py` | Tests JSON operations and expression indexes in SQLite. |
| `kv_compare.py` | Compares Shelve and SQLite performance. |
| `server_comparison.md` | Documents the PostgreSQL server comparison procedure. |
| `engine-notes.md` | Records observations from the module exercises. |
| `decision-record.md` | Documents database engine choices and trade-offs. |

## Key Findings

### 1. JSON Metadata

SQLite successfully handled JSON data using `json_extract()`, `->>`, and `json_each()`.

The expression index was used when the query matched the indexed expression. The alternative shorthand query performed a full table scan.

### 2. Key-Value Storage

The benchmark used 50,000 session records.

| Operation | Shelve | SQLite |
|---|---:|---:|
| Write | 1.757 s | 0.040 s |
| Read | 0.128 s | 0.185 s |

SQLite was faster for writing, while Shelve was slightly faster for reading in this test. I selected SQLite for the dashboard session workload because of its write performance and querying capabilities.

### 3. PostgreSQL Server

The PostgreSQL server exercise is not yet completed because I did not have access to the instructor's server. The connection procedure and test instructions are documented in `server_comparison.md`.

### 4. Engine Decisions

My current decisions are:

- SQLite for operational sensor and job data.
- DuckDB with Parquet for analytical reporting.
- SQLite with JSON for vendor metadata.
- SQLite for dashboard session state.
- PostgreSQL as a proposed option for concurrent network users.

## Reflection

This module helped me understand that one database engine does not need to handle every type of workload. The choice should depend on the data, access pattern, performance measurements, and system requirements.

**Status:** Decision record drafted. PostgreSQL server exercise and peer defence are still pending.