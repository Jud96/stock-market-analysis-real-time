-- Creating a continuous aggregate with integer-based time
CREATE FUNCTION current_epoch() RETURNS BIGINT
LANGUAGE SQL STABLE AS $$
SELECT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP)::bigint;$$;


SELECT set_integer_now_func('rates', 'current_epoch');

-- timescaledb.materialized_only = false to allow continuous aggregates to be created
ALTER MATERIALIZED VIEW table_name set (timescaledb.materialized_only = false);

CREATE MATERIALIZED VIEW devices_summary
WITH (timescaledb.continuous) AS
SELECT 
time_bucket('60000', event_time) AS bucket, -- 1000 is second in ms 
ccy_couple,
LAST(rate,event_time) AS last_rate,
LAST(event_time,event_time) AS last_event_time
FROM rates
GROUP BY bucket,ccy_couple;

-- Add a continuous aggregate policy to refresh the continuous aggregate every second
SELECT add_continuous_aggregate_policy('devices_summary',
  start_offset => 1000 *60,      -- Start refreshing data from 60,000 milliseconds (1 minute) ago
  end_offset   => 1000,       -- Up to 1000 milliseconds (1 second) behind real-time
  schedule_interval => INTERVAL '1 second'  -- Refresh every second
);

SELECT * FROM timescaledb_information.continuous_aggregates;
-- SELECT remove_continuous_aggregate_policy('devices_summary');

-- watch -n 1 -x  psql -h localhost -U postgres -d rates -c "SELECT * FROM devices_summary 
-- ORDER BY bucket DESC LIMIT 5;"


-- Insert random data into the 'rates' table

CREATE EXTENSION tablefunc;

INSERT INTO rates (event_time, ccy_couple, rate)
SELECT 
    extract(epoch FROM now())::BIGINT + s, -- Simulate current epoch time + s for series
    ccy_couple,                            -- Randomly select ccy_couple
    1.0 + (random() * 0.05)                -- Random rate between 1.0 and 1.05
FROM 
    generate_series(1, 10000) AS s,         -- Generate 10,000 rows
    unnest(ARRAY['EUR/USD', 'NZD/USD', 'USD/JPY', 'GBP/USD', 'AUD/USD', 'USD/CAD']) AS ccy_couple;