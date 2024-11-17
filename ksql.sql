-- create stream from currency from kafka topic
-- docker exec -it ksqldb ksql http://localhost:8088

CREATE STREAM currency_rates_stream (
    event_time BIGINT,
    ccy_couple STRING,
    rate DOUBLE
) WITH (
    KAFKA_TOPIC = 'currency_rates',
    VALUE_FORMAT = 'JSON'
);

-- create table to store the latest currency rates
CREATE TABLE currency_rates_table AS
SELECT
    ccy_couple,
    LATEST_BY_OFFSET(rate) AS rate,
    LATEST_BY_OFFSET(event_time) AS last_event_time
FROM currency_rates_stream
GROUP BY ccy_couple EMIT CHANGES;


