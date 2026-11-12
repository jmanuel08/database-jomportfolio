# Module 5 – Normalization vs. Denormalization

## See It

### 1. Functional Dependencies (FD)

Based on the given dataset and the assumptions in the module:

| Functional Dependency | Explanation |
|---|---|
| job_id → technician | Each job determines its assigned technician. |
| machine_id → site | Each machine determines its site. |
| part_no → part_price | Each part number determines its price. |

### 2. Candidate Key

**Candidate Key:** (job_id, part_no)

The combination of job_id and part_no uniquely identifies each job-part record.

### 3. Observations

The original table contains repeated information, such as machine site, technician, and part price. This creates data redundancy and can lead to update, insert, and delete anomalies.

### 4. Domain Assumptions

The functional dependencies are based on the business rules assumed in this module:

- A job is assigned to one technician.
- A machine belongs to one site.
- A part number has one fixed part price.

These dependencies are business assumptions and cannot be proven only by observing a small sample dataset.

### 5. Normalization Goal

The goal of normalization is to reduce data redundancy and prevent update, insert, and delete anomalies.

The flat table will be decomposed into separate related tables:

- Machine: stores machine information and its site.
- Job: stores job information and its assigned technician.
- Part: stores part information and its price.
- Job_Part: connects jobs with the parts used in each job.

The normalized design will follow Third Normal Form (3NF).


## Break It

### 1. Update Anomaly

Updating the site of machine cnc-01 from Gütersloh to Bielefeld affected 3 rows. This shows that the same machine information is repeated across multiple records.

### 2. Insert Anomaly

Attempting to insert a new part (P-0004) without a job_id failed because job_id is part of the composite primary key and cannot be NULL. This prevents storing part information independently of a job.

### 3. Delete Anomaly

Deleting the only record containing part P-0002 also removed its part information and price (€7.00) from the flat table. This demonstrates how deleting a job-part record can unintentionally remove other information.


## Build It

### Dataset Generation

Generated a flat dataset containing 200,000 records using SQLite.

### Normalized Tables and Row Counts

| Table | Number of Rows |
|---|---:|
| flat_jobpart | 200,000 |
| machine | 20 |
| job | 200,000 |
| part | 100 |
| job_part | 200,000 |

### Integrity Check

Executed `PRAGMA foreign_key_check;`.

No foreign key violations were reported.

### Result

The original flat dataset was successfully decomposed into four normalized tables: machine, job, part, and job_part. The 200,000 job-part records were preserved after normalization.


## Race It

### Denormalized Reporting Table

Created `report_jobpart` by joining the normalized tables:
machine, job, job_part, and part.

The report table contains 200,000 rows.

### Query Benchmark Results

| Design | Execution Time |
|---|---:|
| Normalized | 87 ms |
| Denormalized | 109 ms |

### Query Plan Observations

- The normalized query scanned job_part and searched the related job, machine, and part tables.
- The denormalized query scanned report_jobpart using the ix_report_machine index.
- Both query plans used a temporary B-tree for GROUP BY.
- Both queries returned the same 20 result rows and matching cost values.

### Result

In this benchmark run, the normalized query was faster by 22 ms. The denormalized design did not automatically provide better performance, even with an index. Further storage and update measurements are needed before choosing a design.
