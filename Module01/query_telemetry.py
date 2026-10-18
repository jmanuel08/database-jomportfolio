
import sqlite3
from pathlib import Path

db_path = Path(__file__).parent / "telemetry.db"

conn = sqlite3.connect(db_path)

# Query 1: Count readings per machine
print("\n1. Readings per machine")
query1 = """
SELECT machine, COUNT(*) AS total_readings
FROM readings
GROUP BY machine
ORDER BY machine;
"""
for row in conn.execute(query1):
    print(row)

# Query 2: Peak vibration per machine
print("\n2. Peak vibration per machine")
query2 = """
SELECT machine, MAX(vib_rms) AS peak_vibration
FROM readings
GROUP BY machine
ORDER BY machine;
"""
for row in conn.execute(query2):
    print(row)

# Query 3: Count readings where vibration is above 2.0
print("\n3. Readings with vibration above 2.0")
query3 = """
SELECT COUNT(*)
FROM readings
WHERE vib_rms > 2.0;
"""
print(conn.execute(query3).fetchone()[0])

conn.close()
