
"""1,000 single-row writes and lookups: the workload DuckDB is not built for."""

import sqlite3
import time

import duckdb

N = 1_000


def run_sqlite():
    con = sqlite3.connect(":memory:")
    con.execute("CREATE TABLE s(id INTEGER PRIMARY KEY, k TEXT, v REAL)")

    rows = [(i, f"k{i}", i * 1.5) for i in range(N)]

    t0 = time.perf_counter()
    con.executemany("INSERT INTO s VALUES (?, ?, ?)", rows)
    con.commit()
    insert = (time.perf_counter() - t0) * 1000

    t0 = time.perf_counter()
    for i in range(N):
        con.execute("SELECT v FROM s WHERE id = ?", (i,)).fetchone()
    lookup = (time.perf_counter() - t0) * 1000

    return insert, lookup


def run_duckdb():
    con = duckdb.connect()
    con.execute("CREATE TABLE s(id INTEGER PRIMARY KEY, k TEXT, v DOUBLE)")

    rows = [(i, f"k{i}", i * 1.5) for i in range(N)]

    t0 = time.perf_counter()
    con.executemany("INSERT INTO s VALUES (?, ?, ?)", rows)
    insert = (time.perf_counter() - t0) * 1000

    t0 = time.perf_counter()
    for i in range(N):
        con.execute("SELECT v FROM s WHERE id = ?", (i,)).fetchone()
    lookup = (time.perf_counter() - t0) * 1000

    return insert, lookup


si, sl = run_sqlite()
di, dl = run_duckdb()

print(f"batch inserts sqlite {si:8.1f} ms | duckdb {di:8.1f} ms")
print(f"lookups sqlite       {sl:8.1f} ms | duckdb {dl:8.1f} ms")
