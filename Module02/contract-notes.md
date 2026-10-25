# Task 3: Data Contract Notes

## 1. What I learned

I learned that a data contract helps check if the data is correct. I used Pydantic and SQLAlchemy in this task.

## 2. Pydantic

Pydantic checks the data before using it in the application.

- The machine ID must be at least 1.
- The serial number must start with `SN-`.
- The installed date must be a real date.
- The list of parts can be empty if no parts are used.

I learned that Pydantic can help find wrong data early.

## 3. SQLAlchemy

SQLAlchemy defines the tables and rules for the database.

- A primary key identifies a record.
- A unique rule prevents duplicate serial numbers.
- A foreign key connects tables.
- The price uses `NUMERIC` instead of `TEXT`.
- The `job_part` table connects jobs and parts.

## 4. Why use both?

Pydantic checks data in the application. The database also checks some rules when saving data. I learned that using both can help keep the data correct.

## 5. DDL output

I ran `uv run python Module02/contract.py` and saved the output in `Module02/contract-ddl.sql`. The output shows the SQL statements for creating the tables.

## 6. Constraint choice: Model vs Database

I chose to check the serial number prefix in the Pydantic model. The serial number must start with `SN-`. This is checked before the data is used by the application.

I chose to enforce unique serial numbers in the database with `uq_machine_serial`. The database should prevent two machines from having the same serial number, even if data is added by another application.

The database also uses primary keys and foreign keys to identify records and connect the tables. These rules help keep the data consistent.
