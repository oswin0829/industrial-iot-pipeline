/* * PROJECT: Cloud-Native Industrial IoT Telemetry Pipeline
 * FILE: queries.sql
 * AUTHOR: [Your Name]
 * DESCRIPTION: 
 * This file contains the analytical layer of the project. 
 * It demonstrates Data Engineering skills including JOINs, 
 * Anomaly Detection logic, and Window Functions for time-series smoothing.
 */

-- =================================================================
-- QUERY 1: THE DASHBOARD VIEW (Data Denormalization)
-- Use Case: Providing a human-readable feed for operators/frontend UIs.
-- Concept: Inner Joins to link fast "Fact Tables" (readings) with "Dimension Tables" (machines/sensors).
-- =================================================================

SELECT 
    m.machine_name,         -- Human-readable machine name (e.g., "Robot Arm A")
    s.sensor_type,          -- The type of metric (e.g., "Vibration")
    r.reading_time,         -- Exact timestamp of the event
    r.value,                -- The raw sensor data
    s.unit                  -- Unit of measurement (e.g., "Hz", "Celsius")
FROM readings r
-- Join readings to sensors to get type and limits
JOIN sensors s ON r.sensor_id = s.sensor_id
-- Join sensors to machines to get location and asset names
JOIN machines m ON s.machine_id = m.machine_id
ORDER BY r.reading_time DESC -- Show the most recent data first (Real-time view)
LIMIT 10;


-- =================================================================
-- QUERY 2: THE ANOMALY DETECTOR (Filtering & Transformation)
-- Use Case: Root Cause Analysis. Finding specific instances of equipment failure.
-- Concept: Filtering rows based on dynamic thresholds defined in a separate table.
-- =================================================================

SELECT 
    m.machine_name,
    s.sensor_type,
    r.value AS current_value,
    s.max_safe_value,
    -- Calculate how far above the limit we went (Severity of failure)
    (r.value - s.max_safe_value) AS excess_amount, 
    r.reading_time
FROM readings r
JOIN sensors s ON r.sensor_id = s.sensor_id
JOIN machines m ON s.machine_id = m.machine_id
-- THE LOGIC: Compare real-time value against the static safety limit
WHERE r.value > s.max_safe_value 
ORDER BY r.reading_time DESC;


-- =================================================================
-- QUERY 3: MOVING AVERAGE (Advanced Window Functions)
-- Use Case: Noise Reduction. Smoothing out volatile sensor data to see trends.
-- Concept: Computing aggregates across a sliding window of rows without collapsing the result set.
-- =================================================================

SELECT 
    sensor_id,
    reading_time,
    value AS raw_value,
    
    -- WINDOW FUNCTION EXPLANATION:
    -- 1. PARTITION BY: Treat each sensor's data as a separate isolated group.
    -- 2. ORDER BY: Ensure we process data strictly in time order.
    -- 3. ROWS BETWEEN: The "Sliding Window." Look at the current row + previous 2.
    AVG(value) OVER (
        PARTITION BY sensor_id 
        ORDER BY reading_time 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as moving_avg_3_points
    
FROM readings
ORDER BY reading_time DESC
LIMIT 20;