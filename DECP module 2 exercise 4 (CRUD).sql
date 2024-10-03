-- Task 1
-- In this first task you need to create a new procedure called AddBooking to add a new table booking record.
-- The procedure should include four input parameters in the form of the following bookings parameters:
-- booking id, customer id, booking date, and table number.

table bookings;

-- I added a 'check_status' variable in case we want to get a value from the procedure
-- to use later on as status value

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

-- Task 2
-- For your second task, Little Lemon need you to create a new procedure called 
-- UpdateBooking that they can use to update existing bookings in the booking table.
-- The procedure should have two input parameters in the form of booking id and booking date. 
-- You must also include an UPDATE statement inside the procedure.

-- GD: do teh whole thing already: date, time, table # and customer id, also return a operation status
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

	-- we need to find that booking ID first, if it exists
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

-- Task 3
-- For the third and final task, Little Lemon need you to create 
-- a new procedure called CancelBooking that they can use to cancel or remove a booking.
-- The procedure should have one input parameter in the form of booking id. 
-- You must also write a DELETE statement inside the procedure. 

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

	-- we need to find that booking ID first, if it exists
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







