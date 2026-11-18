
# Module 3 — SQL Notes

## Task 1: LLM Query and Query Profiling

### Prompt given to the LLM
SQLite schema: customer(customer_id, name, city), product(product_id, sku, price), orders(order_id, customer_id, ordered_on, status), order_line(order_id, product_id, qty).

Write a query that returns, for each city, the number of distinct customers and the total revenue (sum of qty*price) of orders placed in 2025, ordered by revenue descending.

### Generated SQL
```sql
SELECT
    c.city,
    COUNT(DISTINCT c.customer_id) AS customers,
    SUM(ol.qty * p.price) AS revenue
FROM customer c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_line ol ON ol.order_id = o.order_id
JOIN product p ON p.product_id = ol.product_id
WHERE o.ordered_on >= '2025-01-01'
  AND o.ordered_on < '2026-01-01'
GROUP BY c.city
ORDER BY revenue DESC;
```

### Actual EXPLAIN QUERY PLAN
```text
QUERY PLAN
|--SCAN ol
|--SEARCH o USING INTEGER PRIMARY KEY (rowid=?)
|--SEARCH c USING INTEGER PRIMARY KEY (rowid=?)
|--SEARCH p USING INTEGER PRIMARY KEY (rowid=?)
|--USE TEMP B-TREE FOR GROUP BY
|--USE TEMP B-TREE FOR count(DISTINCT)
`--USE TEMP B-TREE FOR ORDER BY
```

### Observations
- `SCAN ol`: SQLite reads all rows in order_line.
- `SEARCH o`, `SEARCH c`, and `SEARCH p`: SQLite uses primary keys to find matching records.
- `USE TEMP B-TREE FOR GROUP BY`: temporary structure for grouping by city.
- `USE TEMP B-TREE FOR count(DISTINCT)`: temporary structure for counting distinct customers.
- `USE TEMP B-TREE FOR ORDER BY`: temporary structure for sorting revenue.

### Correctness
The query uses JOINs to connect the four tables, COUNT(DISTINCT) to avoid counting the same customer multiple times, and a date range to filter orders placed in 2025.

### Baseline conclusion
The query scans the entire order_line table. No additional indexes have been created yet.

## Task 2 — Baseline Benchmark

| Run | Time |
|---|---:|
| 1 | 0.074 s |
| 2 | 0.081 s |
| 3 | 0.081 s |
| Median | 0.081 s |

All three runs returned the same results.

Baseline median execution time: 0.081 seconds.

### Index 1 — ix_orders_ordered_on

| Run | Time |
|---|---:|
| 1 | 0.086 s |
| 2 | 0.077 s |
| 3 | 0.082 s |
| Median | 0.082 s |

Plan:
- SCAN ol
- SEARCH o USING INTEGER PRIMARY KEY
- SEARCH c USING INTEGER PRIMARY KEY
- SEARCH p USING INTEGER PRIMARY KEY
- USE TEMP B-TREE FOR GROUP BY
- USE TEMP B-TREE FOR count(DISTINCT)
- USE TEMP B-TREE FOR ORDER BY

Observation:
The index did not change the query plan. SQLite still scans
order_line and looks up orders using the primary key.
The median execution time changed only slightly, from
0.081 s to 0.082 s. The index did not improve this dashboard query.

### Index 2 — ix_orderline_order

| Run | Time |
|---|---:|
| 1 | 0.144 s |
| 2 | 0.145 s |
| 3 | 0.109 s |
| Median | 0.144 s |

Plan:
- SEARCH o USING INDEX ix_orders_ordered_on
- SEARCH c USING INTEGER PRIMARY KEY
- SEARCH ol USING INDEX ix_orderline_order
- SEARCH p USING INTEGER PRIMARY KEY
- USE TEMP B-TREE FOR GROUP BY
- USE TEMP B-TREE FOR count(DISTINCT)
- USE TEMP B-TREE FOR ORDER BY

Observation:
The query plan now uses both indexes.
However, the median execution time increased from
0.082 s to 0.144 s compared with the date-index-only test.
The changed query plan did not result in faster execution.

### Index 3 — ix_orderline_product

| Run | Time |
|---|---:|
| 1 | 0.168 s |
| 2 | 0.150 s |
| 3 | 0.144 s |
| Median | 0.150 s |

Plan:
- SEARCH o USING INDEX ix_orders_ordered_on
- SEARCH c USING INTEGER PRIMARY KEY
- SEARCH ol USING INDEX ix_orderline_order
- SEARCH p USING INTEGER PRIMARY KEY
- USE TEMP B-TREE FOR GROUP BY
- USE TEMP B-TREE FOR count(DISTINCT)
- USE TEMP B-TREE FOR ORDER BY

Observation:
The query plan did not change after adding ix_orderline_product.
SQLite still uses ix_orderline_order to find order_line rows
and the product primary key to look up products.

The median execution time was 0.150 s.
The index did not improve the dashboard query.
It may still help queries that directly filter order_line
by product_id.

### Single-day lookup — Before date index

Query plan:
- SCAN o
- SEARCH c USING INTEGER PRIMARY KEY (rowid=?)

Observation:
SQLite scans the entire orders table to find orders
from 2026-02-14. It uses the customer primary key
to retrieve the matching customer.

### Single-day lookup — After date index

Query plan:
- SEARCH o USING INDEX ix_orders_ordered_on (ordered_on=?)
- SEARCH c USING INTEGER PRIMARY KEY (rowid=?)

Benchmark — 1,000 repetitions per run:

| Run | Time per query |
|---|---:|
| 1 | 0.0626 ms |
| 2 | 0.0924 ms |
| 3 | 0.0530 ms |
| Median | 0.0626 ms |

Observation:
After restoring ix_orders_ordered_on, SQLite uses the
date index instead of scanning the entire orders table.

The median execution time decreased from 1.1894 ms
to 0.0626 ms per query, approximately 94.7% faster.

The date index is useful for this single-day lookup.

### Testing ix_orderline_product directly

Query:
SELECT * FROM order_line WHERE product_id = 10;

Query plan:
- SEARCH order_line USING INDEX ix_orderline_product (product_id=?)

Observation:
SQLite uses ix_orderline_product when filtering
order_line directly by product_id.

The index was not used by the dashboard query,
but it is useful for queries that directly filter
by product_id.

An index may be useful for one query but not another.

### Date index with a function

Query:
WHERE date(o.ordered_on) = '2026-02-14';

Query plan:
- SCAN o
- SEARCH c USING INTEGER PRIMARY KEY (rowid=?)

Observation:
Although ix_orders_ordered_on exists, SQLite does not
use it when the date() function wraps the ordered_on column.

Instead, SQLite scans the entire orders table.

Using the raw column in the WHERE condition allows
SQLite to use the index.

## Task 3 — SQL Injection Demonstration

Command:
python3 Module03/injection_demo.py

Output:
- normal: [(1, 'Customer 1')]
- injected: [(1, 'Customer 1'), (2, 'Customer 2'), (3, 'Customer 3')] ...
- safe: []

### Observation

The vulnerable query uses string formatting to insert
user input directly into the SQL statement.

The injected input `' OR '1'='1` changes the condition
and returns multiple customer records.

The safe query uses a bound parameter (`?`).
SQLite treats the input as data, not as SQL code.
Therefore, the injected input returns no matching rows.

### Why is manual escaping not a real fix?

Manually escaping or filtering apostrophes is error-prone.
It may fail in different SQL contexts or overlook other
special characters.

Bound parameters are the correct solution because they
keep user input separate from the SQL statement.

## Task 4 — Relational Algebra

Query:
Calculate the number of distinct customers and total
revenue for each city for orders placed in 2025,
ordered by revenue descending.

Relational Algebra:

1. σ (Selection): Filter orders placed in 2025.
2. ⋈ (Join): Connect customer, orders, order_line,
   and product using their matching IDs.
3. γ (Grouping): Group results by city, count distinct
   customers, and calculate total revenue.
4. τ (Sorting): Sort the results by revenue descending.

Verification:

The relational algebra expression represents the same
operations as the SQL query. The selection corresponds
to WHERE, joins correspond to JOIN ON, grouping
corresponds to GROUP BY and aggregate functions,
and sorting corresponds to ORDER BY.

The SQL query was previously executed and verified
against the SQLite database.

## Pod Study Task A — Plan Safari

### Before adding the index

Tested query plans:

1. `SELECT * FROM maint_job WHERE technician = 'Beier';`
   - SCAN maint_job

2. `SELECT * FROM machine WHERE machine_name = 'cnc-02';`
   - SCAN machine

3. `SELECT * FROM maint_job WHERE technician LIKE '%ei%';`
   - SCAN maint_job

### Adding the index

```sql
CREATE INDEX ix_job_tech ON maint_job(technician);
```

### After adding the index

| Query | Query plan | Result |
|---|---|---|
| `technician = 'Beier'` | SEARCH maint_job USING INDEX ix_job_tech (technician=?) | Index used |
| `machine_name = 'cnc-02'` | SCAN machine | No change |
| `technician LIKE '%ei%'` | SCAN maint_job | No change |

### Breaking the index on purpose

Query:

```sql
SELECT * FROM maint_job WHERE lower(technician) = 'beier';
```

Query plan:
- SCAN maint_job

Observation:

Even though ix_job_tech exists, SQLite scans the table when the indexed column is wrapped in the lower() function. The ordinary index does not directly match this expression.

### Conclusion

The technician index improves the equality search on technician.

It does not affect the machine_name query because the index belongs to maint_job, not machine.

The leading-wildcard LIKE search and the function-wrapped column still result in table scans.

An index is useful only when the query can use the indexed column in a compatible way.

## Pod Study Task B — Relational Algebra Check

### SQL Query

```sql
SELECT *
FROM maint_job
WHERE technician = 'Beier';
```

### My Relational Algebra Expression

σ(technician = 'Beier')(maint_job)

### LLM Translation

σ(technician = 'Beier')(maint_job)

### Comparison and Verification

Both expressions match.

- Selection (σ) filters the rows where technician is 'Beier'.
- Projection (π) is not needed because SELECT * retrieves all columns.
- Join (⋈) is not needed because the query uses only one table.

The relational algebra expression correctly represents the SQL query.

## Pod Study Task C — Explain & Share (Individual Study)

### SQLite Version

```text
3.51.0
```

### Most Surprising Result

The most surprising result was that adding an index did not improve every query.

The equality search on technician changed from SCAN to SEARCH USING INDEX ix_job_tech.

However, the leading-wildcard LIKE query and the query using lower(technician) still performed a table scan.

### What I Learned About Indexes

I learned that indexes are not automatically used for every query. SQLite uses an index when the query conditions allow it.

An index can improve a specific search, but the query structure also matters.

### Individual Study Note

I completed this activity individually, so I could not compare query plans or exchange curiosities with a neighbouring pod.