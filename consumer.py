import json
import random
import time
from kafka import KafkaConsumer
import threading

# Kafka configuration
bootstrap_servers = ['localhost:9092']
group_id = 'currency_rate_consumer_group'
topic = 'currency_rates'

# Currency pairs and rate limits
ccy_pairs = ["EURUSD", "NZDUSD", "USDJPY", "GBPUSD", "AUDUSD"]
rate_min = 1.00
rate_max = 1.05

# Initialize the latest_rates dictionary with default values
latest_rates = {
    ccy_couple: {
        'event_time': 0,  # Initial epoch time is 0
        'rate': 0,        # Initial rate is 0
        'rate_yesterday_5pm': round(random.uniform(rate_min, rate_max), 5)  # Random rate between 1 and 1.05
    }
    for ccy_couple in ccy_pairs
}

print(f"Initial rates: {latest_rates}")

# Create a Kafka consumer
consumer = KafkaConsumer(
    topic,
    bootstrap_servers=bootstrap_servers,
    auto_offset_reset='latest',
    group_id=group_id,
    value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)

print(f"Subscribed to topic {topic}. Waiting for messages...")

# Function to check and print currency pairs where the last event_time is > 30 seconds ago
def check_rate_changes():
    while True:
        current_time = int(time.time()*1000)  # Get the current epoch time
        for ccy_couple, data in latest_rates.items():
            event_time = data['event_time']
            rate = data['rate']
            rate_yesterday_5pm = data['rate_yesterday_5pm']
            # Check if the last event time is more than 30 seconds ago
            if current_time - event_time < 30000 and rate > 0:
                # Calculate the rate difference
                rate_change = round((rate - rate_yesterday_5pm)*100/rate_yesterday_5pm, 3)
                print(f"{ccy_couple}: with rate {rate}. Rate change: {rate_change}")

        time.sleep(1)  # Sleep for 1 second before checking again
# Start the rate check in a separate thread
rate_check_thread = threading.Thread(target=check_rate_changes)
rate_check_thread.daemon = True  # Ensure the thread closes when the main program exits
rate_check_thread.start()
if __name__ == "__main__":
    try:
        for message in consumer:
            # The message value is already deserialized as a dictionary
            event = message.value
            ccy_couple = event['ccy_couple']
            rate = event['rate']
            event_time = event['event_time']

            # Update the latest rate and event_time for the currency pair
            if ccy_couple in latest_rates:
                latest_rates[ccy_couple]['rate'] = rate
                latest_rates[ccy_couple]['event_time'] = event_time

            # print(f"Received event: {event}")

    except KeyboardInterrupt:
        pass
    finally:
        # Close the consumer cleanly
        consumer.close()