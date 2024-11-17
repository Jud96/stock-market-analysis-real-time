from datetime import datetime, timedelta
import time
import random
import pandas as pd
from multiprocessing.dummy import Pool as ThreadPool
import psycopg2



ccy_couples = ["EUR/USD", "NZD/USD", "USD/JPY", "GBP/USD", "AUD/USD", "USD/CAD",
                "USD/CHF", "USD/CNY", "USD/INR", "USD/SGD", "USD/HKD", "USD/KRW",
                "USD/MXN", "USD/NOK", "USD/SEK", "USD/TRY", "USD/ZAR", "USD/BRL",
                "USD/RUB", "USD/AED", "USD/SAR", "USD/QAR", "USD/OMR", "USD/KWD",
                "USD/BHD", "USD/JOD", "USD/EGP", "USD/ILS", "USD/PLN", "USD/CZK",
                "USD/HUF", "USD/THB", "USD/IDR", "USD/MYR", "USD/PHP", "USD/TWD",
                "USD/VND", "USD/ARS", "USD/CLP", "USD/COP", "USD/PEN", "USD/UYU",
                "USD/BOB", "USD/PYG", "USD/DOP", "USD/CRC", "USD/GTQ", "USD/HNL",
                "USD/NIO", "USD/PAB", "USD/BSD", "USD/JMD", "USD/TTD", "USD/XCD",
                "USD/ANG", "USD/BBD", "USD/BMD", "USD/BSD", "USD/BZD", "USD/BSD"]
# Mock streaming function
def connect():
    conn = psycopg2.connect(
        host="localhost",
        database="rates",
        user="postgres",
        password="postgres")
    return conn

def define_pool():
    # create a pool of threads every pool for each currency pair
    pool = ThreadPool(50)
    pool.map(stream_rates, ccy_couples)
    # run the function for each currency pair
    pool.close()

def stream_rates(ccy_couple):
    while True:
        # Simulate incoming raes
        rate = random.uniform(1.0, 1.5)  # Mock real-time rate
        # create epoch for now 
        epoch = int(time.time()*1000)
        # write to the database
        cursor.execute(
            "INSERT INTO rates3 (ccy_couple, rate, event_time) VALUES (%s, %s, %s)",
            (ccy_couple, rate, epoch)
        )
        conn.commit()
        # add this  rate1.csv
        # with open('rate1.csv', 'a') as f:
        #     f.write(f"{ccy_couple},{rate},{epoch}\n")
        # sleep betwwen 1 to 3 milliseconds
        time.sleep(random.uniform(1, 2)/1000)
        

if __name__ == "__main__":
    conn = connect()
    cursor = conn.cursor()

    define_pool()
    print("done")
