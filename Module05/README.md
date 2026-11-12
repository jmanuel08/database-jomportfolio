# Module 5 – Normalization and Denormalization

## Overview

This module focuses on database normalization and denormalization. It explores how database structure affects data consistency, storage requirements, and query performance.

Through practical SQL exercises, I created and compared normalized and denormalized database designs using a dataset of 200,000 records.

## Learning Objectives

After completing this module, I learned how to:

1. Identify functional dependencies and candidate keys in a relational database.
2. Understand data redundancy and the update, insert, and delete anomalies it can cause.
3. Organize data into related tables following Third Normal Form (3NF).
4. Compare normalized and denormalized database structures using query benchmarks.
5. Evaluate query performance, storage usage, and update costs.
6. Use measurements to recommend an appropriate database design for a given workload.

## Module Activities

The following files contain the practical exercises, SQL scripts, and documentation completed during this module.

| File | Description |
|---|---|
| `normalization-notes.md` | Functional dependencies, candidate keys, anomalies, normalization, and query benchmark results |
| `er-diagrams.md` | Visual representation of the flat and normalized database structures |
| `anomalies.sql` | SQL examples demonstrating update, insert, and delete anomalies |
| `setup.sql` | Creates the dataset and normalized database tables |
| `benchmark.sql` | Compares query performance between normalized and denormalized designs |
| `price.sql` | Measures update costs, database storage, and index performance |
| `measurements.md` | Records storage and performance measurements |
| `recommendation.md` | Presents the recommended database design based on the test results |
| `curiosities.md` | Additional observations, findings, and learning resources |

## Key Findings

- The normalized query completed in 87 ms, while the denormalized query took 109 ms in the benchmark run.
- Updating one machine affected 1 row in the normalized design, compared with 10,000 rows in the denormalized table.
- Both database designs used nearly the same amount of storage in the measured comparison.
- Adding an index did not always improve query performance in the test.

These results show that denormalization does not automatically make queries faster. The best design depends on the database workload and the balance between reading, writing, and storage.

## Reflection

See [Reflection 05](../Reflections/ref05.md) for my personal learning experience, challenges, and key takeaways from this module.