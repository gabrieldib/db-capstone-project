# Restaurant Management System Project

- [Project Description](#project-description)
- [Entity-Relationship Diagram](#entity-relationship-diagram)
- [Installation and Setup](#installation-and-setup)
- [Stored Procedures](#stored-procedures)
    - [GetMaxQuantity()](#getmaxquantity)
    - [CheckBooking()](#checkbooking)
    - [UpdateBooking()](#updatebooking)
    - [AddBooking()](#addbooking)
    - [CancelBooking()](#cancelbooking)
    - [AddValidBooking()](#addvalidbooking)
    - [CancelOrder()](#cancelorder)

## The Project
This project was designed to teach the student basic, intermediate and advanced Data Engineering skills
in a real world scenario and is a part of the **Meta Database Engineer Certificate** course on Coursera. 
Tools used: 
- MySQL server
- MySQL Workbench
- SQL
- Python 3.x
- MySQL-Connector-python

## Entity-Relationship Diagram

To view the Entity-Relationship Diagram, click here or see the image below.

![Diagram](./little_lemon_ER_diagram.svg)

## Installation and Setup

To set up the database, do the following:

1. **Install MySQL**: Download and install MySQL on your machine if you haven't done so.

2. **Download SQL File**: Obtain the [build_little_lemon_db.sql]("./build_little_lemon_db.sql") file from this repository.

3. **Import and Execute in MySQL Workbench**:
    - Open MySQL Workbench.
    - File menu > Open SQL script.
    - Choose `build little_lemon_db.sql`.
    - Query menu > Execute All

Your database should now be set up and populated with tables and stored procedures.

## Stored Procedures

### GetMaxQuantity()
This stored procedure retrieves the maximum quantity of a specific item that has been ordered. It's useful for inventory management.

```sql
DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
    SELECT 
        oi.quantity,
        mi.name,
        (oi.quantity * mi.price) AS Price
    FROM order_items AS oi
    JOIN menu_items  AS mi ON oi.fk_menu_item = mi.id_menu_item
    GROUP BY mi.name, oi.quantity, Price
    ORDER BY Price DESC;
END //
DELIMITER ;
```

```sql
CALL GetMaxQuantity() -- Exercise expects 5, but my dataset max is 3
```

### CheckBooking()

The CheckBooking stored procedure validates whether a table is already booked on a specified date. It will output a status message indicating whether the table is available or already booked.

```sql
DELIMITER //
CREATE PROCEDURE CheckBooking(IN check_date DATE, IN check_time TIME, IN tn INT, OUT check_status INT)
BEGIN
    DECLARE row_count INT;
    DECLARE booking_status VARCHAR(20);
    
    SELECT COUNT(*) INTO row_count
    FROM 
        bookings
    WHERE bookings.date = check_date AND bookings.time = check_time AND bookings.table_number = tn;
    
    IF row_count > 0 THEN
        SET booking_status := 'Not available';
        SET check_status := 0;
    ELSE
        SET booking_status := 'Available';
        SET check_status := 1;
    END IF;
    SELECT  
        check_date      AS 'Date',
        check_time      AS 'Time',
        tn              AS 'Table number',
        booking_status  AS 'Status';
END //
DELIMITER ;
```

```sql
-- testing:
SET @booking_status := 0;

-- not available:
CALL CheckBooking('2024-08-25', '07:34:44', 10, @booking_status);

-- available:
CALL CheckBooking('2024-08-25', '07:34:44', 8, @booking_status);

SELECT @booking_status;
```

### UpdateBooking()
This stored procedure updates the booking details in the database. It takes the booking ID and new booking date as parameters, making sure the changes are reflected in the system.

```sql
DELIMITER //
CREATE PROCEDURE UpdateBooking (
    IN booking_id INT,
    IN update_date DATE, 
    IN update_time TIME, 
    IN update_tn INT, 
    IN customer_id INT,
    OUT check_status INT
)
BEGIN
    DECLARE row_count INT;
    DECLARE booking_status VARCHAR(20);

    SELECT COUNT(*) INTO row_count
    FROM bookings AS b
    WHERE 
        booking_id = b.id_booking;

    IF row_count = 0 THEN
        SET booking_status := 'No record was found with this booking ID';
        SET check_status := 0;
    ELSE
        SET booking_status := 'Booking was updated';
        SET check_status := 1;
        UPDATE bookings AS b
        SET 
            b.date = update_date,
            b.time = update_time,
            b.table_number = update_tn,
            b.fk_customer = customer_id
        WHERE 
            booking_id = b.id_booking;
        
    END IF;
    SELECT  
        update_date        AS 'Date',
        update_time        AS 'Time',
        update_tn          AS 'Table number',
        customer_id        AS 'Customer ID',
        booking_status     AS 'Status';
END //
DELIMITER ;
```

```sql
SELECT * FROM bookings; -- check the booking ID 1, we will update this one

SET @booking_status := 0;

START TRANSACTION;
    -- update booking id 1 TO: 2024-08-25, table # 10, customer ID 22, UPDATE TIME TO 08:15:00
    CALL UpdateBooking(1, '2024-08-25', '08:15:00', 10, 22, @r_booking_status);

    SELECT * FROM bookings; -- check the change 

ROLLBACK; -- to keep the database in its initial state for the next procedure calls
```

### AddBooking() 
This procedure adds a new booking to the system. It accepts multiple parameters like booking ID, customer ID, booking date, and table number to complete the process.

```sql
DELIMITER //
CREATE PROCEDURE AddBooking(
    IN add_date DATE, 
    IN add_time TIME, 
    IN add_tn INT, 
    IN customer_id INT,
    OUT check_status INT
)
BEGIN
    DECLARE row_count INT;
    DECLARE booking_status VARCHAR(20);

    SELECT COUNT(*) INTO row_count
    FROM bookings AS b
    WHERE b.date = add_date AND b.time = add_time AND b.table_number = add_tn;

    IF row_count > 0 THEN
        SET booking_status := 'Not available';
        SET check_status := 0;
    ELSE
        SET booking_status := 'New booking added';
        SET check_status := 1;
        INSERT INTO bookings (date, time, table_number, fk_customer)
            VALUES (add_date, add_time, add_tn, customer_id);
    END IF;
    SELECT  
        add_date        AS 'Date',
        add_time        AS 'Time',
        add_tn          AS 'Table number',
        booking_status  AS 'Status';
    
END //
DELIMITER ;
```
```sql
SELECT * FROM bookings; -- check the records on bookings

SET @r_booking_status := 0; -- booking status return value

START TRANSACTION; -- just in case we want to ...
    -- date, time, table number, customer id, out var for operation status
    CALL AddBooking ('2024-10-03', '08:30:00', 1, 11, @r_booking_status );
    SELECT * FROM bookings; -- check the change 
ROLLBACK; -- rollback the insertion if you want
```

### CancelBooking()
This stored procedure deletes a specific booking from the database, allowing for better management and freeing up resources.
```sql
DELIMITER //
CREATE PROCEDURE CancelBooking (
    IN booking_id INT,
    OUT check_status INT
)
BEGIN
    DECLARE row_count INT;
    DECLARE booking_status VARCHAR(255);
    DECLARE b_date DATE;
    DECLARE b_time TIME;
    DECLARE b_tn INT;
    DECLARE b_cid INT;

    SELECT COUNT(*) INTO row_count
    FROM bookings AS b
    WHERE booking_id = b.id_booking;

    IF row_count = 0 THEN
        SET booking_status := 'No record was found with this booking ID';
        SET check_status := 0;
    ELSE
        SET booking_status := 'Booking was cancelled (deleted from the database)';
        SET check_status := 1;
        
        SELECT b.date, b.time, b.table_number, b.fk_customer 
        INTO b_date, b_time, b_tn, b_cid
        FROM bookings AS b
        WHERE b.id_booking = booking_id;
        
        DELETE FROM bookings AS b
        WHERE booking_id = b.id_booking;
        
    END IF;
    SELECT  
        b_date         AS 'Date',
        b_time         AS 'Time',
        b_tn           AS 'Table number',
        b_cid          AS 'Customer ID',
        booking_status AS 'Status';
END //
DELIMITER ;
```
```sql
SELECT * FROM bookings; -- check the records on bookings

SET @r_booking_status := 0; -- booking status return value

START TRANSACTION;
    CALL CancelBooking(1, @r_booking_status);
    SELECT * FROM bookings; -- check the change 
ROLLBACK;
```

### AddValidBooking()
The AddValidBooking stored procedure aims to securely add a new table booking record. It starts a transaction and attempts to insert a new booking record, checking the table's availability.

```sql
DELIMITER //
CREATE PROCEDURE AddValidBooking(
    IN add_date DATE, 
    IN add_time TIME, 
    IN add_table_number INT,
    IN customer_id INT
)
BEGIN
    DECLARE p_booking_status INT;

    CALL CheckBooking(
        add_date, 
        add_time, 
        add_table_number, 
        p_booking_status 
    );

    START TRANSACTION;
    
    INSERT INTO bookings (date, time, table_number, fk_customer)
        VALUES
            (add_date, add_time, add_table_number, customer_id);
    
    IF p_booking_status = 0 THEN
        ROLLBACK;
        SELECT CONCAT(
            "Table ", add_table_number, 
            " is not available on ", add_date, 
            " at ", add_time)
            AS 'booking transaction;', p_booking_status AS 'Status';
    ELSE
        SELECT "Booking was added successfully" AS 'booking transaction;', p_booking_status AS 'Status';
        COMMIT;
    END IF;
    
END //
DELIMITER ;
```

```sql
SELECT * FROM bookings; -- check the records on bookings

-- this will not work, as the table is not available:
CALL AddValidBooking('2024-08-25', '07:34:44', 10, 22);

START TRANSACTION;
	-- this will work:
	CALL AddValidBooking('2024-08-25', '08:30:00', 10, 22);
    
	-- check:
	SELECT * FROM bookings WHERE bookings.table_number = 10;

ROLLBACK;
```


### CancelOrder()
The CancelOrder stored procedure cancels or removes a specific order by its Order ID. It executes a DELETE statement to remove the order record from the Orders table.

```sql
DELIMITER //
CREATE PROCEDURE CancelBooking (
    IN booking_id INT,
    OUT check_status INT
)
BEGIN
    DECLARE row_count INT;
    DECLARE booking_status VARCHAR(255);
    DECLARE b_date DATE;
    DECLARE b_time TIME;
    DECLARE b_tn INT;
    DECLARE b_cid INT;

    SELECT COUNT(*) INTO row_count
    FROM bookings AS b
    WHERE booking_id = b.id_booking;

    IF row_count = 0 THEN
        SET booking_status := 'No record was found with this booking ID';
        SET check_status := 0;
    ELSE
        SET booking_status := 'Booking was cancelled (deleted from the database)';
        SET check_status := 1;
        
        SELECT b.date, b.time, b.table_number, b.fk_customer 
        INTO b_date, b_time, b_tn, b_cid
        FROM bookings AS b
        WHERE b.id_booking = booking_id;
        
        DELETE FROM bookings AS b
        WHERE booking_id = b.id_booking;
        
    END IF;
    SELECT  
        b_date         AS 'Date',
        b_time         AS 'Time',
        b_tn           AS 'Table number',
        b_cid          AS 'Customer ID',
        booking_status AS 'Status';
END //
DELIMITER ;
```

```sql
SELECT * FROM bookings; -- check the records on bookings

START TRANSACTION;
    CALL CancelBooking(22, @r_booking_status);
    SELECT * FROM bookings;
COMMIT;
```





