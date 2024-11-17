import random
import time
import json
from kafka import KafkaProducer

# Kafka configuration
KAFKA_BROKER = 'localhost:9092'  # Change this if your broker runs on a different address
TOPIC = 'currency_rates'  # Define your Kafka topic

# Define the currency pairs
ccy_couples = ["EURUSD", "NZDUSD", "USDJPY", "GBPUSD", "AUDUSD"]

# Function to generate random forex data
def generate_event():
    event_time = int(time.time() * 1000)  # Current time in epoch (milliseconds)
    ccy_couple = random.choice(ccy_couples)  # Pick a random currency pair
    rate = round(random.uniform(1.00, 1.05), 5)  # Random rate between 1.00 and 1.05
    return {
        "event_time": event_time,
        "ccy_couple": ccy_couple,
        "rate": rate
    }

# Initialize Kafka Producer
producer = KafkaProducer(
    bootstrap_servers=KAFKA_BROKER,
    value_serializer=lambda v: json.dumps(v).encode('utf-8')  # JSON serialization
)

if __name__ == "__main__":
    try:
        while True:
            event = generate_event()
            producer.send(TOPIC, value=event)  # Send event to Kafka topic
            print(f"Produced event: {event}")
            # sleep for 2 to 3 milliseconds
            #time.sleep(random.uniform(2, 3)/1000)
            time.sleep(1)
    except KeyboardInterrupt:
        print("Producer stopped.")
    finally:
        producer.close()