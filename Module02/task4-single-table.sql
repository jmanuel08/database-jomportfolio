
-- Task 4, Alternative A
-- One table with a discriminator column

CREATE TABLE machine (
    machine_id INTEGER PRIMARY KEY,
    serial_no TEXT UNIQUE NOT NULL,
    machine_type TEXT NOT NULL
        CHECK (machine_type IN ('CNC_MILL', 'INJECTION_MOLDER')),
    site TEXT NOT NULL,
    installed DATE NOT NULL,

    spindle_speed INTEGER,
    tool_capacity INTEGER,

    clamp_force NUMERIC,
    injection_volume NUMERIC,

    CHECK (
        (
            machine_type = 'CNC_MILL'
            AND spindle_speed IS NOT NULL
            AND tool_capacity IS NOT NULL
            AND clamp_force IS NULL
            AND injection_volume IS NULL
        )
        OR
        (
            machine_type = 'INJECTION_MOLDER'
            AND clamp_force IS NOT NULL
            AND injection_volume IS NOT NULL
            AND spindle_speed IS NULL
            AND tool_capacity IS NULL
        )
    )
);

