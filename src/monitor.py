import time
import psycopg2
from dotenv import load_dotenv
import os
from datetime import datetime

# Load same passwords as before
load_dotenv()

def get_db_connection():
    return psycopg2.connect(
        host=os.getenv('DB_HOST'),
        database=os.getenv('DB_NAME'),
        user=os.getenv('DB_USER'),
        password=os.getenv('DB_PASS')
    )

def check_for_danger():
    conn = get_db_connection()
    cur = conn.cursor()
    
    print("👀 Watchdog active. Monitoring for failures...")
    
    last_checked_time = datetime.now()

    try:
        while True:
            # 1. The Logic: This is the exact same SQL logic you wrote earlier
            # We check for readings created in the last 10 seconds that exceed safety limits
            query = """
                SELECT m.machine_name, s.sensor_type, r.value, s.max_safe_value, r.reading_time
                FROM readings r
                JOIN sensors s ON r.sensor_id = s.sensor_id
                JOIN machines m ON s.machine_id = m.machine_id
                WHERE r.value > s.max_safe_value
                AND r.reading_time > NOW() - INTERVAL '10 seconds'
                ORDER BY r.reading_time DESC;
            """
            
            cur.execute(query)
            alerts = cur.fetchall()
            
            # 2. The Alert: If the list is not empty, SCREAM!
            if alerts:
                print("\n" + "!"*50)
                print(f"🚨 ALERT TRIGGERED AT {datetime.now().strftime('%H:%M:%S')} 🚨")
                for alert in alerts:
                    machine, sensor, val, limit, time_log = alert
                    print(f"   CRITICAL: {machine} - {sensor}")
                    print(f"   Value: {val:.2f} (Limit: {limit})")
                print("!"*50 + "\n")
            else:
                print(f". System Normal ({datetime.now().strftime('%H:%M:%S')})")

            # 3. Wait 5 seconds and check again
            time.sleep(5)

    except KeyboardInterrupt:
        print("Watchdog stopped.")
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    check_for_danger()