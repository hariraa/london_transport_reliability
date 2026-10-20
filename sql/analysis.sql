-- London Transport Reliability Analysis
-- SQLite queries using the service_status table.

-- 01_total_records_by_line
SELECT
    Line, 
    COUNT (*) AS total_records
FROM service_status
GROUP BY Line
ORDER BY total_records DESC;

-- 02_severe_delays_by_line
SELECT
    Line, 
    COUNT(*) AS severe_delay_records
FROM service_status
WHERE "Service Status" = 'Severe Delays'
GROUP BY Line
ORDER BY severe_delay_records DESC;

-- 03_severe_delay_percentage_by_line
SELECT
    Line,
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN "Service Status" = 'Severe Delays' THEN 1
            ELSE 0
        END
    ) AS severe_delay_records,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN "Service Status" = 'Severe Delays' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS severe_delay_percentage
FROM service_status
GROUP BY Line
ORDER BY severe_delay_percentage DESC;

-- 04_service_status_distribution
SELECT
    "Service Status",
    COUNT(*) AS total_records,
    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(*) FROM service_status),
        2
    ) AS percentage_of_records
FROM service_status
GROUP BY "Service Status"
ORDER BY total_records DESC;

-- 05_severe_delays_by_weekday
SELECT
    CASE strftime('%w', "Start Date/Time")
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS weekday,
    COUNT(*) AS severe_delay_records
FROM service_status
WHERE "Service Status" = 'Severe Delays'
GROUP BY strftime('%w', "Start Date/Time")
ORDER BY strftime('%w', "Start Date/Time");

-- 06_severe_delays_by_hour
SELECT
    CAST(strftime('%H', "Start Date/Time") AS INTEGER) AS hour,
    COUNT(*) AS severe_delay_records
FROM service_status
WHERE "Service Status" = 'Severe Delays'
GROUP BY strftime('%H', "Start Date/Time")
ORDER BY hour;

