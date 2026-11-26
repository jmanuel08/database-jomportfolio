# PostgreSQL Server Comparison

## 1. Purpose

This section documents how to compare SQLite with a PostgreSQL server. I did not have access to the instructor's PostgreSQL server during this exercise, so the server tests below are prepared procedures and have not yet been executed.

## 2. Connection Model

A PostgreSQL client connects to a server using the following information:

| Parameter | Description |
|---|---|
| Host | Server address or hostname |
| Port | PostgreSQL server port (default: 5432) |
| Database | Name of the database |
| Username | Account used to connect |
| Password | Authentication password |

Unlike SQLite, which opens a database file directly, PostgreSQL requires a network connection to a running server.

## 3. Create a Comparable Table

The following SQL can be executed in PostgreSQL to create a table with sample machine records.

```sql
CREATE TABLE machine (
    machine_id INTEGER PRIMARY KEY,
    machine_name TEXT NOT NULL,
    location TEXT NOT NULL
);

INSERT INTO machine (machine_id, machine_name, location)
VALUES
    (1, 'CNC-01', 'Bielefeld'),
    (2, 'CNC-02', 'Osnabrück'),
    (3, 'MOLDER-07', 'Herford');
```

## 4. Run a Query

This query retrieves all machines located in Bielefeld.

```sql
SELECT machine_id, machine_name, location
FROM machine
WHERE location = 'Bielefeld';
```

Expected result after successful execution:

| machine_id | machine_name | location |
|---:|---|---|
| 1 | CNC-01 | Bielefeld |

*This is an expected result, not an observed server result.*

## 5. Test Two Concurrent Writers

To test concurrent access:

1. Open two separate PostgreSQL client sessions.
2. In the first session, begin a transaction and update a machine.
3. In the second session, try to update the same machine.
4. Observe whether the second transaction waits, succeeds, or encounters a conflict.
5. Record the actual behavior.

Example SQL for the first session:

```sql
BEGIN;

UPDATE machine
SET location = 'Münster'
WHERE machine_id = 1;

-- Keep the transaction open while testing the second session.
```

After the second session has been tested, finish the first transaction:

```sql
COMMIT;
```

No concurrent-writer test has been executed yet.

## 6. Server Availability and Network Failures

A PostgreSQL database depends on a running server and a working network connection. If the server is stopped or the network connection is interrupted, clients may not be able to access the database.

SQLite is embedded in the application and accesses a local database file. It does not require a separate database server or network connection for local access.

## 7. Actual Observations

The following observations still need to be collected from the instructor's PostgreSQL server or an instructor demonstration.

| Observation | Result |
|---|---|
| One thing easier than SQLite | Not yet observed |
| One thing harder than SQLite | Not yet observed |
| One possible server failure | Not yet observed |

## 8. Conclusion

PostgreSQL and SQLite have different purposes. SQLite is convenient for local applications because it does not require a separate server. PostgreSQL supports multiple clients connecting to a central database server, but this introduces network and server availability considerations.

The actual server comparison and concurrent-writer behavior still need to be tested before making a conclusion based on observations.