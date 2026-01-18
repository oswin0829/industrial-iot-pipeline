-- 1. Create the MACHINES table
-- This stores the static info about our equipment.
CREATE TABLE machines (
    machine_id SERIAL PRIMARY KEY,
    machine_name VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);

-- 2. Create the SENSORS table
-- This links sensors to machines and defines safety limits.
CREATE TABLE sensors (
    sensor_id SERIAL PRIMARY KEY,
    machine_id INT REFERENCES machines(machine_id),
    sensor_type VARCHAR(50) NOT NULL, -- e.g., 'Temperature', 'Vibration'
    unit VARCHAR(20),                 -- e.g., 'Celsius', 'Hz'
    min_safe_value FLOAT,
    max_safe_value FLOAT
);

-- 3. Create the READINGS table
-- This is our time-series data. It will grow very fast.
CREATE TABLE readings (
    reading_id SERIAL PRIMARY KEY,
    sensor_id INT REFERENCES sensors(sensor_id),
    reading_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    value FLOAT
);

-- 4. Let's insert some dummy MACHINES and SENSORS immediately
-- So we have something to work with.

-- Insert 2 Machines
INSERT INTO machines (machine_name, location) 
VALUES 
    ('Conveyor_Belt_01', 'Zone A'),
    ('Robotic_Arm_X1', 'Zone B');

-- Insert Sensors for Conveyor Belt (Machine ID 1)
INSERT INTO sensors (machine_id, sensor_type, unit, min_safe_value, max_safe_value)
VALUES 
    (1, 'Motor Temperature', 'Celsius', 20.0, 85.0),
    (1, 'Belt Speed', 'm/s', 0.5, 2.0);

-- Insert Sensors for Robotic Arm (Machine ID 2)
INSERT INTO sensors (machine_id, sensor_type, unit, min_safe_value, max_safe_value)
VALUES 
    (2, 'Hydraulic Pressure', 'Bar', 100.0, 250.0),
    (2, 'Vibration', 'Hz', 0.0, 50.0);