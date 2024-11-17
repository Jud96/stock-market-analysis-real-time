REATE TABLE latest_values (
    ccy_couple TEXT PRIMARY KEY,  -- Store currency pair, make it a primary key for uniqueness
    last_rate NUMERIC,            -- Store the last rate
    last_event_time BIGINT        -- Store the last event_time in epoch (as in the original table)
);

CREATE OR REPLACE FUNCTION update_latest_values() 
RETURNS TRIGGER AS $$
BEGIN
    -- Insert or update the latest rate and event_time for the ccy_couple
    INSERT INTO latest_values (ccy_couple, last_rate, last_event_time)
    VALUES (NEW.ccy_couple, NEW.rate, NEW.event_time)
    ON CONFLICT (ccy_couple)  -- If the ccy_couple already exists, update the record
    DO UPDATE 
    SET last_rate = EXCLUDED.last_rate,
        last_event_time = EXCLUDED.last_event_time;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


drop trigger update_latest_on_insert;
CREATE TRIGGER update_latest_on_insert
AFTER INSERT ON rates1
FOR EACH ROW
EXECUTE FUNCTION update_latest_values();