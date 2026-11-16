# Reflection 04 – Data Integrity, Constraints and Triggers

## 1. What is my take-away?

I learned how database constraints help keep data correct and prevent invalid records. I also learned how `STRICT` tables, `CHECK`, `UNIQUE`, and foreign keys work. Another important lesson was that UPSERT can prevent duplicate records when data is imported more than once.

## 2. What was good?

I enjoyed testing the database and seeing how it reacts to invalid data. It was also interesting to create triggers that automatically generate alarms and record changes in the audit table.

## 3. What was difficult?

Understanding the different constraints was challenging for me, especially how `CHECK` handles NULL values. I also needed time to understand the UPSERT statement and how the Python script works with SQLite.

## 4. What was interesting?

I found it interesting that I could run the same CSV ingestion script twice without creating duplicate records. I also learned that triggers have a small performance cost. In my benchmark, the execution time increased from 0.009 seconds to 0.012 seconds when the alarm trigger was enabled.

## 5. Interaction with peers and instructors

Our group discussed meeting at one place so we could work together on Module 4. I also asked one of my groupmates, Sebastian, about his outputs for the different tasks in the module. We compared our work and checked whether we were doing the tasks correctly. This helped me understand the activities better and gave me more confidence in my own results.

## 6. Help and extra work

I completed the SQL scripts, Python ingestion script, and documentation for the required Studio Lab tasks. I also tested the constraints, UPSERT, triggers, and read-only access using my own SQLite database. I used the test results to document what I learned and verify that the database was working correctly.