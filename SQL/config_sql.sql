-- max_parallel_workers_per_gather : Sets the maximum number of parallel 
-- processes per executor node.
-- work_mem : Sets the maximum memory to be used for query workspaces.

show timezone; -- Europe/Berlin
set timezone to 'America/New_York';
-- parallel workers --
select * from pg_settings where name in ('max_parallel_workers_per_gather','work_mem');
set max_parallel_workers_per_gather = 4;
--Increase parallel workers based on the table size
SET parallel_tuple_cost = 0.1;
SET parallel_setup_cost = 1000;
-- Tune PostgreSQL Configuration for Performance

--  settings to suit your workload. Here are some important parameters
--shared_buffers: This should be set to about 25% of your total system memory.
SET shared_buffers = '2GB'; -- I haven't tested this value
--  Used for VACUUM and ANALYZE operations.
SET maintenance_work_mem = '1GB'; -- I haven't tested this value
-- work_mem: The amount of memory allocated for complex
-- operations (e.g., sorting). Increase for large queries.
-- reset the server
set work_mem = '128 MB';
-- effective_cache_size: Should be set to around 50-75% of your available system memory
-- to help the planner make better use of cached data.
SET effective_cache_size = '6GB'; -- I haven't tested this value
-- sudo systemctl restart postgresql
--set max_locks_per_transaction = 256;


CREATE TABLE rates(
    event_id  serial  NOT NULL,
    event_time  BIGINT NOT NULL, 
    ccy_couple TEXT NOT NULL,
    rate DOUBLE PRECISION NOT NULL,
	PRIMARY KEY (event_time, ccy_couple)
);


-- create index on ccy_couple, event_time
CREATE  INDEX  idx_rates3_ccy_couple_event_time ON rates3 (ccy_couple, event_time);
Create INDEX  idx_rates3_event_time ON rates3 (event_time);
-- Partial Indexes: If you only care about recent rates 
-- (e.g., rates within the last 30 seconds
CREATE INDEX idx_rates_recent_event_time ON rates(event_time)
WHERE event_time > (EXTRACT(EPOCH FROM NOW()) * 1000 - 30000)::bigint;
-- create a hypertable om epoch time column
SELECT create_hypertable(
    'rates', 
    'event_time', 
    partitioning_column => 'ccy_couple', 
    number_partitions => 5,  -- partition based on ccy_couple
    chunk_time_interval => 60*1000, -- 60 1000 1 minutes
);

SELECT * FROM timescaledb_information.hypertables;

-- Chunk skipping can only be enabled for compressed hypertables.
-- chunk exclusion when the WHERE clause of an SQL query specifies ranges on the column. 
-- Enable chunk skipping
SELECT enable_chunk_skipping('rates', 'event_time');


-- compression 
ALTER TABLE rates 
SET (
	timescaledb.compress, 
	timescaledb.compress_segmentby = 'ccy_couple',
	timescaledb.compress_orderby='event_time'
);
-- Add a compression policy to compress chunks that are older than seven days:
SELECT add_compression_policy('rates', INTERVAL '1 hour'); -- set interval based on use case

-- retention policy
SELECT add_retention_policy('rates', INTERVAL '30 days'); -- set interval based on use case

SELECT show_chunks('rates3');