import psycopg2
import requests
import time
from datetime import datetime, timezone
import random


# Database connection settings
DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'database': 'eurusd_task',
    'user': 'postgres',
    'password': 'mypassword'
}

def setup_database():
    """Creates the ticks table in PostgreSQL"""
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    
    print("Setting up database...")
    
    cur.execute("CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;")
    cur.execute("DROP TABLE IF EXISTS ticks CASCADE;")
    
    cur.execute("""
        CREATE TABLE ticks (
            time TIMESTAMPTZ NOT NULL,
            price DECIMAL(10, 5) NOT NULL,
            symbol TEXT NOT NULL
        );
    """)
    
    cur.execute("SELECT create_hypertable('ticks', 'time');")
    cur.execute("CREATE INDEX ON ticks (symbol, time DESC);")
    
    conn.commit()
    cur.close()
    conn.close()
    
    print("Database ready!")


def stream_simulated():
    """Generate realistic EURUSD data without api"""
    print("Starting SIMULATED data streaming...")
    print("Generating realistic EURUSD prices every 1 second")
    # print("Press Ctrl+C to stop\n")
    
    conn = psycopg2.connect(**DB_CONFIG)
    current_price = 1.0500  # Starting EUR/USD price
    tick_count = 0
    
    try:
        while True:
            # Generate realistic price movement
            change = random.uniform(-0.0005, 0.0005)
            current_price += change
            current_price = max(1.04, min(1.06, current_price))  # Keep in range
            price = round(current_price, 5)
            
            timestamp = datetime.now(timezone.utc)
            
            # Save to database
            cur = conn.cursor()
            cur.execute("""
                INSERT INTO ticks (time, price, symbol)
                VALUES (%s, %s, %s)
            """, (timestamp, price, 'EURUSD'))
            conn.commit()
            cur.close()
            
            tick_count += 1
            print(f"[{tick_count}] : {timestamp.strftime('%H:%M:%S')} | EURUSD | {price}")
            
            # Wait 1 second
            time.sleep(1)
            
    except KeyboardInterrupt:
        print("\nStopping...")
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    
    print("EURUSD STREAMING TO POSTGRESQL")
    
    
    if len(sys.argv) < 2:
        print("\nUsage:")
        print("  python eurusd_test.py setup")
        print("  python eurusd_test.py simulate")
        sys.exit(0)
    
    command = sys.argv[1]
    
    if command == 'setup':
        setup_database()
    elif command == 'simulate':
        stream_simulated()
    else:
        print(f"Unknown command: {command}")
        sys.exit(1)