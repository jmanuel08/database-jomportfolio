# Task 4: Model Inheritance

## 1. Single Table

The first design uses one table for all machines. The `machine_type` column tells us if the machine is a CNC mill or an injection molder.

## 2. Separate Tables

The second design uses one main table and two separate tables for the machine types. Each type has its own extra attributes.

## 3. My Decision

I would choose separate tables because they are easier to understand and keep the attributes of each machine type separate.

This design shows how machines can have different types. However, extra rules may be needed to make sure one machine cannot belong to both types.

## 4. Test Result

I tested both designs using SQLite.

The first design accepts correct data and rejects wrong data.

The second design allows one machine to be in both tables. More rules are needed to prevent this.
