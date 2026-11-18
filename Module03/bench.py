import sqlite3
import time
from pathlib import Path
from statistics import median

DB = Path(__file__).with_name("warehouse.db")

query = """
SELECT o.order_id, o.ordered_on, c.name
FROM orders o
JOIN customer c ON c.customer_id = o.customer_id
WHERE o.ordered_on = '2026-02-14';
"""

conn = sqlite3.connect(DB)
repetitions = 1000
times = []

for run in range(3):
    start = time.perf_counter()
    for _ in range(repetitions):
        conn.execute(query).fetchall()
    elapsed = time.perf_counter() - start
    per_query = elapsed / repetitions
    times.append(per_query)
    print(f"Run {run + 1}: {per_query * 1000:.4f} ms per query")

print(f"Median: {median(times) * 1000:.4f} ms per query")
conn.close()
