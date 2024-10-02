-- Task 1
-- Little Lemon wants to populate the Bookings table of their database with some records of data. 
-- Your first task is to replicate the list of records in the following table by adding them to the Little Lemon booking table. 

-- looking at the tables first:
SELECT 
	*
FROM 
	bookings
JOIN 
	customers 
	ON 
		bookings.fk_customer = customers.id_customers
ORDER BY customers.id_customers;
        

-- since my DB was populate with 20 bookings at start,
-- I'll add these 4 new bookings as 21 through 24
-- also I will use the first 3 customers 
-- also booking ID is atuo generated, no need to add manually
-- also I added the time because we have it and it makes sense

START TRANSACTION;
INSERT INTO bookings (date, time, table_number, fk_customer)
VALUES
	('2024-10-02', '20:00', 1, 2),
	('2024-10-02', '21:00', 2, 4),
	('2024-10-02', '19:00', 3, 11),
	('2024-10-03', '18:00', 1, 2);
ROLLBACK;

-- Task 2
-- For your second task, Little Lemon needs you to create a stored procedure 
-- called CheckBooking to check whether a table in the restaurant is already booked. 
-- Creating this procedure helps to minimize the effort involved in repeatedly coding the same SQL statements.
-- The procedure should have two input parameters in the form of booking date and table number. 
-- You can also create a variable in the procedure to check the status of each table.

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

SET @booking_status := 0;

-- not available:
call check_booking('2024-09-25', '06:12:44', 8, @booking_status);

-- available:
call check_booking('2024-09-25', '06:12:44', 9, @booking_status);
SELECT @booking_status;

-- DROP PROCEDURE IF EXISTS check_booking;

-- Task 3
-- For your third and final task, Little Lemon need to verify a booking, 
-- and decline any reservations for tables that are already booked under another name. 
-- Since integrity is not optional, Little Lemon need to ensure that every booking attempt 
-- includes these verification and decline steps. However, implementing these steps requires a stored procedure and a transaction. 
-- To implement these steps, you need to create a new procedure called AddValidBooking. 
-- This procedure must use a transaction statement to perform a rollback if a customer reserves a table that’s already booked under another name.  
--
-- Use the following guidelines to complete this task:
-- The procedure should include two input parameters in the form of booking date and table number.
-- It also requires at least one variable and should begin with a START TRANSACTION statement.
-- Your INSERT statement must add a new booking record using the input parameter's values.
-- Use an IF ELSE statement to check if a table is already booked on the given date. 
-- If the table is already booked, then rollback the transaction. If the table is available, then commit the transaction. 

    
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
    
    
    
    
    
    
    