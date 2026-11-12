# Module 5 – Normalization vs. Denormalization

## Round 6 – Recommendation Memo

**To:** Operations Lead  
**Subject:** Choosing the Best Database Design

After testing both designs, I recommend using the normalized database as our main database. In our test, the normalized query was faster, taking 87 ms compared to 109 ms for the denormalized query. Updating one machine required changing only 1 row in the normalized database, while the denormalized table required changing 10,000 rows. Both designs used almost the same amount of storage. Our index test also showed that adding an index does not always make a query faster. A denormalized table can still be useful for reports and dashboards when needed. To keep the report table updated, we can refresh it regularly whenever the main database changes.

