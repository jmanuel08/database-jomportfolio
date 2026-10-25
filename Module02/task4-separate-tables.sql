-- Task 4, Alternative B
-- Separate tables for machine subtypes

CREATE TABLE machine (
    machine_id INTEGER PRIMARY KEY,
    serial_no TEXT UNIQUE NOT NULL,
    site TEXT NOT NULL,
    installed DATE NOT NULL
);

CREATE TABLE cnc_mill (
    machine_id INTEGER PRIMARY KEY,
    spindle_speed INTEGER NOT NULL,
    tool_capacity INTEGER NOT NULL,
    FOREIGN KEY (machine_id)
        REFERENCES machine(machine_id)
);

CREATE TABLE injection_molder (
    machine_id INTEGER PRIMARY KEY,
    clamp_force NUMERIC NOT NULL,
    injection_volume NUMERIC NOT NULL,
    FOREIGN KEY (machine_id)
        REFERENCES machine(machine_id)
);
