import os
import time
import random
import psycopg2
from dotenv import load_dotenv
from datetime import datetime

# 1. Load credentials from .env file
load_dotenv()

def get_db_connection():
    return psycopg2.connect(
        host=os.getenv('DB_HOST'),
        database=os.getenv('DB_NAME'),
        user=os.getenv('DB_USER'),
        password=os.getenv('DB_PASS')
    )

def simulate_sensor_data():
    conn = get_db_connection()
    cur = conn.cursor()

    print("🚀 Connected to AWS RDS! Starting simulation...")

    try:
        # 2. Fetch all active sensors so we know what to simulate
        cur.execute("SELECT sensor_id, sensor_type, min_safe_value, max_safe_value FROM sensors")
        sensors = cur.fetchall() # Returns list of tuples
        
        while True:
            for sensor in sensors:
                s_id, s_type, s_min, s_max = sensor
                
                # 3. Generate realistic data
                # We add some random "noise" to make it look real
                # 95% of the time, it's normal. 5% of the time, it spikes (anomaly).
                if random.random() > 0.95:
                    # Create a spike (Failure simulation)
                    value = s_max * random.uniform(1.1, 1.3)
                else:
                    # Normal operation
                    value = random.uniform(s_min, s_max)

                # 4. Insert into Cloud Database
                insert_query = "INSERT INTO readings (sensor_id, value) VALUES (%s, %s)"
                cur.execute(insert_query, (s_id, value))
                
                print(f"[{datetime.now().strftime('%H:%M:%S')}] {s_type} (ID: {s_id}): {value:.2f}")

            # 5. Commit the transaction (Save data)
            conn.commit()
            
            # Wait 2 seconds before next batch
            time.sleep(2)

    except KeyboardInterrupt:
        print("\n🛑 Simulation stopped by user.")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    simulate_sensor_data()