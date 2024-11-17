CREATE OR REPLACE FUNCTION GET_ACTIVE_RATES (P_TIME TIMESTAMPTZ) RETURNS TABLE (
	CCY_COUPLE VARCHAR,
	RATE DOUBLE PRECISION,
	CHANGE text
) LANGUAGE PLPGSQL AS $$
DECLARE
	active_duration int;
BEGIN
	-- convert p_time to New York timezone
	p_time := p_time at time zone 'America/New_York';
	active_duration := 1000 * 30; -- 30s 
    -- Return the most recent rate for each currency pair as of the provided timestamp
    RETURN QUERY
    WITH LAST_RATES_30_SEC AS (
		SELECT
			r3.CCY_COUPLE::VARCHAR,
			LAST (r3.RATE, r3.EVENT_TIME) AS LAST_RATE,
			LAST (r3.EVENT_TIME, r3.EVENT_TIME) AS EVENT_TIME
		FROM
			RATES3 r3
		WHERE
			r3.EVENT_TIME > (
				EXTRACT(
					EPOCH
					FROM
						p_time
				) * 1000 - active_duration
			)::BIGINT
		GROUP BY
			r3.CCY_COUPLE
	)
	SELECT
		THISMOMENT.CCY_COUPLE,
		THISMOMENT.LAST_RATE,
		CONCAT(
			ROUND(
				(
					(THISMOMENT.LAST_RATE - YER.LAST_RATE) * 100.0 / YER.LAST_RATE
				)::NUMERIC,
				3
			),
			'%'
		) CHANGE
	FROM
		LAST_RATES_30_SEC THISMOMENT
		JOIN CLOSE_CCY_COUPLE_5_PM YER on THISMOMENT.CCY_COUPLE = YER.CCY_COUPLE;
END;
$$;