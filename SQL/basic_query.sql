-- filter late 30 seconds and rate not equal to zero then 
-- window function to get the row number then filter the row number = 1 
SELECT
	SUBQUERY.CCY_COUPLE,
	SUBQUERY.RATE,
	SUBQUERY.EVENT_TIME
FROM
	(
		SELECT
			R.CCY_COUPLE::VARCHAR,
			R.RATE,
			R.EVENT_TIME,
			ROW_NUMBER() OVER (
				PARTITION BY
					R.CCY_COUPLE
				ORDER BY
					R.EVENT_TIME DESC
			) AS RNK
		FROM
			RATES3 R
		WHERE
			R.EVENT_TIME >= (
				EXTRACT(
					EPOCH
					FROM
						CURRENT_TIMESTAMP AT TIME ZONE 'America/New_York'
				) * 1000 - 30000
			)::BIGINT
			AND R.RATE <> 0
	) SUBQUERY
WHERE
	SUBQUERY.RNK = 1;