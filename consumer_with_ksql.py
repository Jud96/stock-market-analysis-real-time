import requests
import time

KSQL_SERVER_URL = 'http://localhost:8088'  # KSQL Server URL

# Query to get the latest rates from the table
ksql_query = {
    "ksql": "SELECT ccy_couple, rate, last_event_time FROM currency_rates_table EMIT CHANGES;",
    "streamsProperties": {}
}

def fetch_latest_rates():
    headers = {
        'Accept': 'application/vnd.ksql.v1+json',
        'Content-Type': 'application/vnd.ksql.v1+json'
    }

    response = requests.post(f'{KSQL_SERVER_URL}/query', json=ksql_query, headers=headers, stream=True)
    
    if response.status_code != 200:
        print(f"Failed to fetch data from KSQL. Status Code: {response.status_code}")
        return

    for line in response.iter_lines():
        if line:
            print(f"Received update: {line.decode('utf-8')}")

if __name__ == "__main__":
    try:
        print("Consuming data from KSQL...")
        fetch_latest_rates()
    except KeyboardInterrupt:
        print("Consumer stopped.")
