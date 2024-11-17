We want to display on an LED screen, for a set of 5 currency pairs, both the current FX exchange
rate and an indication of the change compared to yesterday’s rate at 5PM New York time.

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