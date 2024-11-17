"""
make pull query to  data from forex_rates_table with cron job at 5:00 PM
and push the data into forex_rates_5pm_table
"""
import requests
import json
import time
# from confluent_kafka import Producer

# KSQL Server URL
KSQL_SERVER_URL = 'http://localhost:8088'

# Kafka Broker URL
KAFKA_BROKER = 'localhost:9092'


ksql_query = {
    "ksql": "SELECT * FROM currency_rates_table WHERE ccy_couple in \
        ('EURUSD','NZDUSD','USDJPY', 'GBPUSD', 'AUDUSD');",
    "streamsProperties": {}
}

# Kafka Producer Configuration
kafka_config = {
    'bootstrap.servers': KAFKA_BROKER
}


def fetch_from_ksql():
    headers = {
        'Accept': 'application/vnd.ksql.v1+json',
        'Content-Type': 'application/vnd.ksql.v1+json'
    }

    response = requests.post(
        f'{KSQL_SERVER_URL}/query', json=ksql_query, headers=headers)
    print(response.status_code)
    if response.status_code != 200:
        print(
            f"Failed to fetch data from KSQL. Status Code: {response.status_code}")
        return None
    return response.json()


def insert_into_ksql(latest_rates):
    # ignore the header
    for i in range(1, len(latest_rates)):
        row = latest_rates[i]['row']
        columns = row['columns']
        ccy_couple = columns[0]
        rate = columns[1]
        last_event_time = columns[2]
        # KSQL INSERT INTO query to insert data into the forex_rates_5pm_table
        insert_query = {
            "ksql": f"INSERT INTO currency_rates_5pm_table (ccy_couple, rate, last_event_time) VALUES ('{ccy_couple}', {rate}, {last_event_time});",
            "streamsProperties": {}
        }

        headers = {
            'Accept': 'application/vnd.ksql.v1+json',
            'Content-Type': 'application/vnd.ksql.v1+json'
        }

        response = requests.post(
            f'{KSQL_SERVER_URL}/ksql', json=insert_query, headers=headers)

        if response.status_code != 200:
            print(
                f"Failed to insert data into KSQL. Status Code: {response.status_code}")
        else:
            print(f"Inserted {ccy_couple} data into forex_rates_5pm_table.")


if __name__ == "__main__":

    latest_rates = fetch_from_ksql()
    insert_into_ksql(latest_rates)
    print("Data inserted into forex_rates_5pm_table successfully.")
