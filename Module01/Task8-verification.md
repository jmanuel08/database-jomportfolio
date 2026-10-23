# Task 8: Publish Data with Datasette

## 1. Objective

Publish the telemetry database using Datasette so that the data can be browsed, filtered, and exported through a web browser.

## 2. Database Overview

- **Database:** `telemetry.db`
- **Table:** `readings`
- **Total readings:** 172,800

## 3. Filtered View

I filtered the readings table to show records from machine `cnc-02`.

**Filter:** `machine = cnc-02`

[Open the filtered table](http://127.0.0.1:8001/telemetry/readings?machine=cnc-02)

## 4. Single Row

I also recorded the URL for an individual row in the readings table.

[Open row 2](http://127.0.0.1:8001/telemetry/readings/2)

## 5. Exported CSV

- **File:** `filtered_readings.csv`
- **Location:** `Module01/filtered_readings.csv`
- **Contents:** 100 data rows and one header row.

## 6. Screenshot Evidence

- **File:** `datasette-table.png`
- **Location:** `Module01/pictures/datasette-table.png`

The screenshot shows the filtered table for `cnc-02`.

## 7. Reflection

I learned how to use Datasette to explore and share telemetry data through a web browser. I filtered the readings for `cnc-02`, exported the results as a CSV file, and recorded the URL of an individual row. The CSV file contains 100 data rows, while the database has 57,600 readings for `cnc-02`. This helped me understand how Datasette makes database information easier to access and explore.