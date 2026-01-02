import mysql.connector
import random
import time
from datetime import datetime, timedelta

db = mysql.connector.connect(
    host="mysql",
    port=3306,
    user="root",
    password="root",
    database="fitness_datanaly"
)
cursor = db.cursor()

#Состояние в покое
current_hr = 65
current_activity = None
activity_seconds_left = 0

#Данные за прошлые два дня + текущ
virtual_time = datetime.now() #- timedelta(days=2)

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

#Пульс
def smooth_hr(target):
    global current_hr
    current_hr += int((target - current_hr) * 0.2)
    return current_hr
def generate(user_id):
    global virtual_time, current_activity, activity_seconds_left

    virtual_time += timedelta(seconds=1)

    if activity_seconds_left <= 0:
        current_activity = activity(virtual_time.hour)

        activity_seconds_left = {
            "sleep": random.randint(300, 900),
            "rest": random.randint(60, 300),
            "walk": random.randint(120, 600),
            "run": random.randint(60, 180),
            "cycling": random.randint(180, 600)
        }[current_activity]

    activity_seconds_left -= 1

    if current_activity == "sleep":
        steps = 0
        hr = smooth_hr(random.randint(50, 60))
        calories = 0.2

    elif current_activity == "rest":
        steps = random.randint(0, 3)
        hr = smooth_hr(random.randint(60, 75))
        calories = 0.5

    elif current_activity == "walk":
        steps = random.randint(1, 2)
        hr = smooth_hr(random.randint(85, 105))
        calories = steps * 0.04

    elif current_activity == "run":
        steps = random.randint(3, 5)
        hr = smooth_hr(random.randint(130, 160))
        calories = steps * 0.09

    else:
        steps = random.randint(0, 5)
        hr = smooth_hr(random.randint(110, 140))
        calories = random.uniform(0.1, 0.2)

    return (
        user_id,
        virtual_time,
        steps,
        hr,
        round(calories, 2),
        current_activity
    )

#for _ in range(2 * 24 * 60 * 60):
#    data = generate(1)
#    cursor.execute("""
#        INSERT INTO fitness_data
#        (user_id, ts, steps, heart_rate, calories, activity_type)
#        VALUES (%s, %s, %s, %s, %s, %s)
#    """, data)

#db.commit()

next_tick = time.time()

while True:
    next_tick += 1
    data = generate(1)

    cursor.execute("""
        INSERT INTO fitness_data
        (user_id, ts, steps, heart_rate, calories, activity_type)
        VALUES (%s, %s, %s, %s, %s, %s)
    """, data)
    db.commit()

    sleep_time = next_tick - time.time()
    if sleep_time > 0:
        time.sleep(sleep_time)
