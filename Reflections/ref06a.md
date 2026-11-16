# Reflection – Module 6a

## Take-away and What I Learned

In this module, I learned how to use DuckDB and Parquet for analytical tasks. I learned how to transfer data from SQLite to Parquet, compare the performance of two database engines, and understand why different databases are suitable for different types of work.

One thing I want to remember is that DuckDB is much faster than SQLite when working with large amounts of data. In our test, DuckDB was 176.2 times faster for the dashboard query and 134.3 times faster for the monthly report. However, SQLite performed better for individual inserts and lookups. This taught me that choosing a database depends on the type of operation we need to perform.

## What Went Well

I enjoyed working with my group and learning how the tasks from Module 5 were connected to Module 6a. Our professor discussed the things we needed to check from our previous module and asked us why we used a particular value in our dataset.

One of my groupmates answered that the original data came from our Module 5 report table, which we used as the starting point for creating a larger historical dataset. This helped me understand why it was important to keep the previous module's work and use it as the foundation for the next one.

We also welcomed a new group member, Htet, during Module 6a. He still had some backlog from Modules 2–4, so we guided him through the topics and helped him catch up with the current module. We wanted him to understand what we were doing instead of being left behind, so that we could continue learning and working on the upcoming modules together.

## Challenges and Exploration

Since I am still a beginner, some of the tasks in this module were challenging for me. One difficult part was transferring and expanding the data from SQLite into Parquet. I needed to understand how the Python script worked, how the original dataset was used, and how we could verify that the converted data contained the same information.

Another challenging task was comparing SQLite and DuckDB fairly. I had to understand why we needed warm-up runs, interleaved testing, and median results instead of simply running each query once. Understanding the `EXPLAIN ANALYZE` output was also difficult because I was still learning how to read query execution plans and identify which operations required the most work.

The boundary test was another interesting part for me. I initially expected DuckDB to be faster in every situation, but the results showed that SQLite was much faster for individual inserts and lookups. It helped me understand that a database that performs well for analytical queries is not necessarily the best choice for everyday transactions.

Even though these tasks were complicated at first, exploring the results and understanding the reasons behind them made the experience valuable.

## Interaction, Help, and Extra Work

Our professor's discussion helped us understand the connection between Module 5 and Module 6a, especially the importance of checking our previous work before using it for the next module.

As a group, we also helped Htet catch up with the previous modules. We guided him through the topics we had already covered so he could follow the current lessons and prepare for the upcoming modules with us.

Overall, working together was helpful because we could share our understanding, discuss questions, and make sure that no one was left behind.