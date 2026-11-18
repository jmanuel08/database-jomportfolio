# Reflection 03 — SQL and Query Profiling

## Take-away

I learned that writing an SQL query is not enough. I also need to test if it works correctly. I should not assume that indexes always make queries faster.

## What was good?

I enjoyed testing different indexes and comparing their execution times. I learned that the date index made the single-day search much faster.

## What was difficult?

I found it difficult to understand why some queries use indexes while others do not. I learned that it depends on how the query is written.

## Exploration and show stoppers

I was surprised that adding more indexes made the dashboard query slower. I also learned that using `LIKE '%ei%'` and `lower()` can prevent SQLite from using an ordinary index.

## Interaction with peers and instructors

I worked on this module individually. I used ChatGPT to help me understand the SQL queries and instructions.

## How did you verify AI suggestions?

I asked ChatGPT to write an SQL query for the database. I tested the query in SQLite and checked its execution plan using `EXPLAIN QUERY PLAN`. I also checked the results and compared the execution times after adding indexes.

## Help and extra work

ChatGPT helped me understand the lessons step by step. I also completed exercises about SQL injection, relational algebra, and indexes.