Task 8: Publish Data with Datasette

Objective

Publish the telemetry database using Datasette so that the data can be browsed, filtered, and exported through a web browser.

Database

Database: telemetry.db

Table: readings

Total readings: 172,800

Filtered View

Filter: machine = cnc-02

Filtered table URL: http://127.0.0.1:8001/telemetry/readings?machine=cnc-02

Single Row URL

http://127.0.0.1:8001/telemetry/readings/2

Exported CSV

File: filtered_readings.csv

Location: Module01/filtered_readings.csv

Screenshot Evidence

File: datasette-table.png

Location: Module01/pictures/datasette-table.png

Reflection

I learned how to use Datasette to explore and share telemetry data through a web browser. I filtered the readings for cnc-02, exported the results as a CSV file, and recorded the URL of an individual row. This task helped me understand how Datasette makes database information easier to access, organize, and analyze without writing additional SQL queries.