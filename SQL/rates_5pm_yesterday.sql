-- save the last rate of each currency pair at 5pm yesterday daily

CREATE TABLE close_ccy_couple_5_pm (
    ccy_couple TEXT PRIMARY KEY,  -- Store currency pair, make it a primary key for uniqueness
    last_rate NUMERIC,            -- Store the last rate
    last_event_time BIGINT        -- Store the last event_time in epoch (as in the original table)
);

CREATE OR REPLACE PROCEDURE UPDATE_CLOSE_CCY_COUPLE () LANGUAGE PLPGSQL AS $$
BEGIN
  RAISE NOTICE 'Daily task running at 5 PM';
  	INSERT INTO close_ccy_couple_5_pm (ccy_couple, last_rate, last_event_time)
    SELECT ccy_couple, 
			LAST(rate,event_time) AS last_rate,
		   LAST(event_time,event_time) AS event_time   
	FROM 
		rates3
	where event_time > (EXTRACT(EPOCH FROM now()::date + INTERVAL '17 hours'::timestamp 
			at time zone 'America/New_York') * 1000 - 30000)::bigint
	group by ccy_couple
    ON CONFLICT (ccy_couple)  -- If the ccy_couple already exists, update the record
    DO UPDATE 
    SET last_rate = EXCLUDED.last_rate,
        last_event_time = EXCLUDED.last_event_time;
END;
$$

SELECT add_job(
  'update_close_ccy_couple',  -- The name of the function
  '1 day',          -- The job will run once every day
  initial_start => now()::date + INTERVAL '1260 minutes' -- Start time: today at 5 PM
);