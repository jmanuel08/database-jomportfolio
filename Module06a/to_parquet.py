
"""Convert the 200k CSV into a 2M-row Parquet file using DuckDB."""

import duckdb
from pathlib import Path

here = Path(__file__).parent
csv_path = here / "report_jobpart.csv"
parquet = here / "report_history.parquet"
zstd_file = here / "report_zstd.parquet"

con = duckdb.connect()

# Create the original Parquet file
con.execute(f"""
    COPY (
        SELECT
            r.job_id + k * 1000000 AS job_id,
            r.machine_id,
            r.site,
            r.technician,
            r.part_no,
            r.part_price,
            CAST(r.done_on AS DATE) + CAST(k * 91 AS INTEGER) AS done_on
        FROM read_csv_auto('{csv_path}', header = true, encoding = 'utf-8') AS r,
             range(0, 10) AS t(k)
    )
    TO '{parquet}' (FORMAT parquet)
""")

print(
    "parquet rows:",
    con.execute(
        f"SELECT COUNT(*) FROM read_parquet('{parquet}')"
    ).fetchone()[0]
)

print(
    "parquet MB  :",
    round(parquet.stat().st_size / 1e6, 2)
)

print(
    "parquet total:",
    con.execute(
        f"SELECT ROUND(SUM(part_price), 2) FROM read_parquet('{parquet}')"
    ).fetchone()[0]
)

# Create a second Parquet file using ZSTD compression
con.execute(f"""
    COPY (
        SELECT * FROM read_parquet('{parquet}')
    )
    TO '{zstd_file}' (FORMAT parquet, COMPRESSION ZSTD)
""")

print(
    "zstd MB     :",
    round(zstd_file.stat().st_size / 1e6, 2)
)

con.close()
