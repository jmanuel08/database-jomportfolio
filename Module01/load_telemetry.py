
import csv
import sqlite3
from pathlib import Path

folder = Path(__file__).parent
csv_path = folder / "telemetry.csv"
db_path = folder / "telemetry.db"

conn = sqlite3.connect(db_path)

conn.executescript("""
    DROP TABLE IF EXISTS readings;

    CREATE TABLE readings (
        ts TEXT NOT NULL,
        machine TEXT NOT NULL,
        temp_c REAL NOT NULL,
        vib_rms REAL NOT NULL,
        spindle_load REAL NOT NULL
    );
""")

with csv_path.open(newline="") as file:
    reader = csv.reader(file)
    next(reader)

    conn.executemany(
        "INSERT INTO readings VALUES (?, ?, ?, ?, ?)",
        reader
    )

conn.commit()

count = conn.execute(
    "SELECT COUNT(*) FROM readings"
).fetchone()[0]

print(f"Loaded {count:,} rows into {db_path.name}")

conn.close()
