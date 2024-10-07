import random
import mysql.connector
from datetime import datetime, timedelta

# Database connection
db = mysql.connector.connect(
    host="localhost",
    user="coursera_user",
    password="coursera_user",
    database="GD_little_lemon_db"
)

cursor = db.cursor()


# Helper function to check if a table is empty before inserting data
def check_and_insert_if_empty(table_name, insert_function):
    cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
    count = cursor.fetchone()[0]
    if count == 0:
        print(f"Table '{table_name}' is empty. Proceeding with data insertion.")
        insert_function()
    else:
        print(f"Table '{table_name}' is not empty. Skipping data insertion.")


# Step 1: Generate Orders from Bookings
def insert_orders():
    cursor.execute("SELECT id_booking FROM bookings")
    bookings = cursor.fetchall()

    for booking in bookings:
        id_booking = booking[0]
        date = datetime.now() - timedelta(days=random.randint(1, 90))  # Random date within last 3 months
        cursor.execute("INSERT INTO orders (date, fk_booking_id) VALUES (%s, %s)", (date, id_booking))
    db.commit()
    print(f"Inserted orders for {len(bookings)} bookings.\n")


check_and_insert_if_empty("orders", insert_orders)


# Step 2: Generate Order Items for Each Order
def insert_order_items():
    cursor.execute("SELECT id_orders FROM orders")
    orders = cursor.fetchall()

    cursor.execute("SELECT id_menu_item FROM menu_items")
    menu_items = cursor.fetchall()

    for order in orders:
        id_order = order[0]
        num_items = random.randint(1, 5)  # Each order can have 1-5 items
        for _ in range(num_items):
            menu_item = random.choice(menu_items)
            quantity = random.randint(1, 3)  # Random quantity between 1-3
            cursor.execute(
                "INSERT INTO order_items (fk_menu_item, quantity, fk_order) VALUES (%s, %s, %s)",
                (menu_item[0], quantity, id_order)
            )
    db.commit()
    print(f"Inserted order items for {len(orders)} orders.\n")


check_and_insert_if_empty("order_items", insert_order_items)


# Step 3: Assign Staff to Bookings (Booking Staff Table)
def insert_booking_staff():
    cursor.execute("SELECT id_booking FROM bookings")
    bookings = cursor.fetchall()

    cursor.execute("SELECT id_staff FROM staff")
    staff = cursor.fetchall()

    for booking in bookings:
        id_booking = booking[0]
        assigned_staff = random.choice(staff)  # Randomly choose a staff member
        cursor.execute("INSERT INTO booking_staff (fk_booking, fk_staff) VALUES (%s, %s)", (id_booking, assigned_staff[0]))
    db.commit()
    print(f"Assigned staff to {len(bookings)} bookings.\n")


check_and_insert_if_empty("booking_staff", insert_booking_staff)


# Step 4: Generate Delivery Data for Each Order Item
def insert_delivery_data():
    cursor.execute("SELECT id_order_items FROM order_items")
    order_items = cursor.fetchall()

    cursor.execute("SELECT id_staff FROM staff")
    staff = cursor.fetchall()

    statuses = ['ordered', 'preparing', 'ready for delivery', 'delivered']

    for item in order_items:
        id_order_item = item[0]
        fk_server = random.choice(staff)[0]

        # Insert each status with different timestamps
        for i, status in enumerate(statuses):
            timestamp = datetime.now() - timedelta(minutes=random.randint(1, 100) + (i * 10))  # Random time in the past 100 minutes, staggered by 10 mins
            cursor.execute(
                "INSERT INTO delivery (last_updated, status, fk_server, fk_order_items) VALUES (%s, %s, %s, %s)",
                (timestamp, status, fk_server, id_order_item)
            )

    db.commit()
    print(f"Inserted delivery records for {len(order_items)} order items with various statuses.\n")


check_and_insert_if_empty("delivery", insert_delivery_data)

# Closing connection
cursor.close()
db.close()
