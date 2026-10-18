
import sqlite3
from pathlib import Path

db_path = Path(__file__).parent / "telemetry.db"

conn = sqlite3.connect(db_path)

row_count = conn.execute(
    "SELECT COUNT(*) FROM readings"
).fetchone()[0]

file_size = db_path.stat().st_size

print(f"Database file size: {file_size:,} bytes")
print(f"Database file size: {file_size / 1_000_000:.2f} MB")
print(f"Total rows: {row_count:,}")

conn.close()
