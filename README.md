We want to display on an LED screen, for a set of 5 currency pairs, both the current FX exchange rate and an indication of the change compared to yesterday’s rate at 5PM New York time.

We receive the rates as high frequency (assume updates for multiple currency pairs every
millisecond) structured data, similar to the data in rates_sample.csv

ccy_couple,rate,change
"EUR/USD",1.08081,"-0.208%"

Description of fields:
• event_id: a unique identifier
• event_time: the epoch time in milliseconds
• ccy_couple: the currency pair, made up of the ISO code of two currencies
• rate: the exchange rate value at the given epoch time

Further notes:
• a rate is considered active iff it’s the last one received for a given currency couple AND
it’s not older than 30 seconds
• everything not specified is to be decided by you, please document all such decisions

##  consideration and assumptions 
1. which timeseries database to use (InfluxDB,TimescaleDB,OpenTSDB,Graphite,Druid,etc)
2.  keep in mind criteria like Data Ingestion Rate,Query Performance,Scalability,..
   **for point 1 and 2 read TimeSeriesDB.md**
3. choicing timescaledb as I have already have experienced at postgresql. but based on requirement we can choose other DB **config_service_locally.sh**
4.  we should focus on power of these Databases like continuous aggregate,compression,partitioning,.. to make our system more efficient **SQL/config_sql.sql**
   1.  set parallelism,cache,buffering etc parameters 
   2.  create index on event_time,ccy_couple and also create index on event_time
   3.  Partial Indexes rates within the last 30 seconds (not tried yet)
   4.  create hypertable on event_time and ccy_couple (that automatically partition data based on time)
   5.  enable_chunk_skipping is a feature that allows TimescaleDB to skip chunks that do not contain data relevant to the query
   6.  data compression is a feature that allows TimescaleDB to compress data in chunks to save disk space and improve query performance
   7.  retention policy to keep data for 30 days based on requirement
   8.  Analyze and vacuum the database regularly
   9.  don't forget to handle time zone