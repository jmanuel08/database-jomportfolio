### Module 4 — Data Integrity, Constraints & Edge Triggers

## 🎯 Learning Goals

In this module, I learned how to keep data correct and prevent invalid information from being saved in a database.

By the end of this module, I learned how to:

- Use constraints like `NOT NULL`, `UNIQUE`, `CHECK`, `PRIMARY KEY`, and `FOREIGN KEY`.
- Use `STRICT` tables to make sure that data has the correct type.
- Use generated columns to calculate values automatically.
- Create triggers that automatically generate alarms and record changes.
- Use UPSERT to avoid duplicate records when importing data.
- Control database access using read-only connections and file permissions.

## Tasks:

### Divide & Conquer Pod Study

- **Study notes:** [Integrity Notes](integrity-notes.md)

### Task 1: Test Database Constraints

- Created tables with different constraints.
- Tested valid and invalid data.
- Checked how the database rejects incorrect information.
- Tested the generated `energy_j` column.

### Task 2: Import Data Using UPSERT

- Created an SQL UPSERT statement.
- Created a Python script to import readings from a CSV file.
- Ran the script twice to check if it prevents duplicate records.

### Task 3: Create Triggers for Alarms and Audit

- Created a trigger that automatically generates an alarm when vibration is too high.
- Created another trigger to record changes in the database.
- Compared the execution time with and without a trigger.

### Task 4: Database Access Control

- Created a `machine_health` view to display selected information.
- Tested read-only database access.
- Used file permissions to control who can modify the database.

### Reflection 4

[Reflection 4](../Reflections/ref04.md)