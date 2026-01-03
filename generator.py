import mysql.connector
import random
import time
from datetime import datetime, timedelta

DB_CONFIG = {
    "host": "mysql",
    "port": 3306,
    "user": "root",
    "password": "root",
}
DB_NAME = "fitness_datanaly"

current_hr = 65
current_activity = None
activity_seconds_left = 0
virtual_time = datetime.now()


def activity(hour):
    if 0 <= hour < 6:
        return "sleep"
    elif 6 <= hour < 9:
        return "walk"
    elif 9 <= hour < 17:
        return random.choice(["rest", "walk"])
    elif 17 <= hour < 20:
        return random.choice(["run", "cycling"])
    else:
        return "rest"


def smooth_hr(target):
    global current_hr
    current_hr += int((target - current_hr) * 0.2)
    return current_hr


def generate_step(timestamp, user_id=1):
    global current_activity, activity_seconds_left, current_hr

    if activity_seconds_left <= 0:
        current_activity = activity(timestamp.hour)
        activity_seconds_left = {
            "sleep": random.randint(300, 900),
            "rest": random.randint(60, 300),
            "walk": random.randint(120, 600),
            "run": random.randint(60, 180),
            "cycling": random.randint(180, 600)
        }[current_activity]

    activity_seconds_left -= 1

    if current_activity == "sleep":
        steps = 0;
        hr_target = random.randint(50, 60);
        cal = 0.2
    elif current_activity == "rest":
        steps = random.randint(0, 3);
        hr_target = random.randint(60, 75);
        cal = 0.5
    elif current_activity == "walk":
        steps = random.randint(1, 2);
        hr_target = random.randint(85, 105);
        cal = steps * 0.04
    elif current_activity == "run":
        steps = random.randint(3, 5);
        hr_target = random.randint(130, 160);
        cal = steps * 0.09
    else:
        steps = random.randint(0, 5);
        hr_target = random.randint(110, 140);
        cal = random.uniform(0.1, 0.2)

    #smooth_hr обновляет глобальную переменную current_hr
    real_hr = smooth_hr(hr_target)

    return (user_id, timestamp, steps, real_hr, round(cal, 2), current_activity)

def init_db():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()

    cursor.execute(f"CREATE DATABASE IF NOT EXISTS {DB_NAME}")
    cursor.execute(f"USE {DB_NAME}")

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS fitness_data (
          id int NOT NULL AUTO_INCREMENT,
          user_id int DEFAULT NULL,
          ts datetime DEFAULT NULL,
          steps int DEFAULT NULL,
          heart_rate int DEFAULT NULL,
          calories float DEFAULT NULL,
          activity_type varchar(50) DEFAULT NULL,
          PRIMARY KEY (id)
        )
    """)
    conn.commit()
    return conn


def backfill_history(cursor):

    end_time = datetime.now()
    start_time = end_time - timedelta(days=2)
    sim_time = start_time

    batch_data = []
    total_seconds = int((end_time - start_time).total_seconds())

    for _ in range(total_seconds):
        sim_time += timedelta(seconds=1)
        record = generate_step(sim_time)
        batch_data.append(record)

        if len(batch_data) >= 5000:
            cursor.executemany("""
                INSERT INTO fitness_data
                (user_id, ts, steps, heart_rate, calories, activity_type)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, batch_data)
            batch_data = []

    if batch_data:
        cursor.executemany("""
            INSERT INTO fitness_data (user_id, ts, steps, heart_rate, calories, activity_type)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, batch_data)

if __name__ == "__main__":

    db = init_db()
    cursor = db.cursor()

    backfill_history(cursor)
    db.commit()

    next_tick = time.time()

    virtual_time = datetime.now()

    while True:
        next_tick += 1

        virtual_time += timedelta(seconds=1)

        data = generate_step(virtual_time)

        cursor.execute("""
            INSERT INTO fitness_data
            (user_id, ts, steps, heart_rate, calories, activity_type)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, data)
        db.commit()
        sleep_time = next_tick - time.time()
        if sleep_time > 0:
            time.sleep(sleep_time)