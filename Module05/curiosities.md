# Module 5 – Normalization vs. Denormalization

## Round 7 – Harvest

### 1. What I Learned

During this module, I learned that normalization helps organize data and reduce repeated information. It also prevents problems when inserting, updating, or deleting records.

I also learned that denormalization can make reporting easier because related information is already stored in one table. However, it can create duplicate data and require more updates when information changes.

### 2. Interesting Findings

- A normalized database does not always have slower queries.
- Adding an index does not always improve query performance.
- Denormalization can make reporting simpler, but it may increase the work needed to keep data updated.
- Database design depends on how the data will be used.

### 3. Sources

1. SQLite Documentation – Query Planning: https://www.sqlite.org/queryplanner.html
2. SQLite Documentation – EXPLAIN QUERY PLAN: https://www.sqlite.org/eqp.html
3. SQLite Documentation – Database File Format: https://www.sqlite.org/fileformat.html

### 4. Final Reflection

This module helped me understand that choosing a database design is not only about query speed. We also need to consider data accuracy, storage, and how difficult it is to update information. Based on my experiments, I would use normalization for the main database and consider denormalization when reporting needs require it.
