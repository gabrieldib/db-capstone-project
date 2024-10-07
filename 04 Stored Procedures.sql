DELIMITER //
CREATE PROCEDURE get_max_quantity()
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
CALL get_max_quantity();

-- ----------------------------------------------------------------------------------------------- 

DELIMITER //
CREATE PROCEDURE check_booking(IN check_date DATE, IN check_time TIME, IN tn INT, OUT check_status INT)
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

-- testing:
SET @booking_status := 0;

-- not available:
CALL check_booking('2024-09-25', '06:12:44', 8, @booking_status);

-- available:
CALL check_booking('2024-09-25', '06:12:44', 9, @booking_status);
SELECT @booking_status;

-- ----------------------------------------------------------------------------------------------- 

DELIMITER //
CREATE PROCEDURE add_valid_booking(
    IN add_date DATE, 
    IN add_time TIME, 
    IN add_table_number INT,
    IN customer_id INT
)
BEGIN
    DECLARE p_booking_status INT;

    CALL check_booking(
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
    
-- this will not work, as the table is not available:
CALL add_valid_booking('2024-09-25', '06:12:44', 9, 1);

-- this will work:
CALL add_valid_booking('2024-09-25', '06:12:44', 10, 1);
    
-- check:
SELECT * FROM bookings WHERE bookings.table_number = 8;
SELECT * FROM bookings WHERE bookings.table_number = 9;

-- ----------------------------------------------------------------------------------------------- 

DELIMITER //
CREATE PROCEDURE add_booking(
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


DROP PROCEDURE add_booking;

SET @r_booking_status := 0; -- booking status return value

-- works
START TRANSACTION; -- just in case we want to ...
    CALL add_booking ('2024-10-03', '08:30:00', 1, 11, @r_booking_status );
ROLLBACK; -- rollback the insertion

-- ---------------------------------------------------------------------------------

-- GD: do the whole thing already: date, time, table # and customer id, also return a operation status
DELIMITER //
CREATE PROCEDURE update_booking (
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

START TRANSACTION;
    -- update booking id 1 TO: 2024-08-26, table # 11, customer ID 22, time 08:15:00
    CALL update_booking(1, '2024-08-26', '08:15:00', 11, 22, @r_booking_status);
    table bookings; -- check the change 

ROLLBACK; -- to keep the database in its initial state for the next exercises

-- -----------------------------------------------------------------------------------------

DELIMITER //
CREATE PROCEDURE cancel_booking (
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

-- tested, works
START TRANSACTION;
    CALL cancel_booking(1, @r_booking_status);
    table bookings;
ROLLBACK;