
# Module 5 – Normalization vs. Denormalization

## Round 5 – Price It

### 1. Rows Touched Experiment

Updated the site of machine `cnc-02` in both database designs.

| Design | Rows Changed |
|---|---:|
| Normalized (`machine`) | 1 |
| Denormalized (`report_jobpart`) | 10,000 |

**Observation:**

The normalized design required updating only one machine record. The denormalized reporting table required updating 10,000 records because machine information is repeated across multiple rows.

### 2. Storage Measurements

Storage measurements were collected using SQLite's `dbstat` virtual table.

| Design / Object | Storage |
|---|---:|
| Normalized tables and primary-key indexes | 14,557,184 bytes |
| Denormalized report table | 11,882,496 bytes |
| Denormalized report index | 3,002,368 bytes |
| Denormalized total | 14,884,864 bytes |

**Observation:**

The denormalized design used slightly more storage when its reporting index was included. The two designs had relatively similar storage requirements in this experiment.

### 3. Index Experiment

Compared the reporting query with and without the `ix_report_machine` index.

| Experiment | Execution Time |
|---|---:|
| With index | 44 ms |
| Without index | 35 ms |

**Observation:**

The query without the index was 9 ms faster in this particular run. This shows that an index does not automatically improve query performance. Results may vary depending on the query, database size, and caching.

### 4. Round 5 Conclusion

The normalized design significantly reduced the number of rows affected by a machine-site update. The denormalized design required more repeated updates and slightly more storage when its index was included. The index experiment also showed that an index does not always make a query faster. These measurements demonstrate the trade-offs between normalization and denormalization.
