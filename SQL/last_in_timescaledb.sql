SELECT
	CCY_COUPLE,
	LAST (EVENT_TIME, EVENT_TIME) AS EVENT_TIME,
	LAST (RATE, EVENT_TIME) AS LAST_RATE
FROM
	RATES2
WHERE
	EVENT_TIME > EXTRACT(
		EPOCH
		FROM
			'2024-10-19 07:40:37'::TIMESTAMP AT TIME ZONE 'America/New_York'
	)
GROUP BY
	CCY_COUPLE