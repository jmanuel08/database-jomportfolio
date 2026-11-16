import csv
import sqlite3

DB_PATH = "Module04/edge.db"
CSV_PATH = "Module04/readings.csv"

UPSERT_SQL = """
INSERT INTO reading (sensor_id, ts, value, interval_s)
VALUES (?, ?, ?, ?)
ON CONFLICT(sensor_id, ts)
DO UPDATE SET value = excluded.value;
"""

with sqlite3.connect(DB_PATH) as conn:
    with open(CSV_PATH, newline="") as csvfile:
        reader = csv.DictReader(csvfile)

        rows = [
            (
                int(row["sensor_id"]),
                row["ts"],
                float(row["value"]),
                int(row["interval_s"])
            )
            for row in reader
        ]

    conn.executemany(UPSERT_SQL, rows)

print(f"Successfully processed {len(rows)} readings.")