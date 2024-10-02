-- Task 1
 -- In this first task, Little Lemon need you to create a procedure 
 -- that displays the maximum ordered quantity in the Orders table. 
-- Creating this procedure will allow Little Lemon to reuse the logic 
-- implemented in the procedure easily without retyping the same code over again and again to check the maximum quantity. 

-- since there isn't an absolute maximum ordered item,
-- most were 3 orders, I made this report that shows
-- the most ordered in quantity, their name and the aggregated price

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



-- Task 2
-- In the second task, Little Lemon needs you to help them to create 
-- a prepared statement called GetOrderDetail. 
-- This prepared statement will help to reduce the parsing time of queries. 
-- It will also help to secure the database from SQL injections.
-- The prepared statement should accept one input argument, the CustomerID value, from a variable. 
-- The statement should return the order id, the quantity and the order cost from the Orders table. 
-- Once you create the prepared statement, you can create a variable called id and assign it value of 1. 


SET @customer_id := 31;

PREPARE get_order_detail FROM
	'SELECT 
		c.id_customers                         AS customer_id,
        CONCAT(c.first_name, " ", c.last_name) AS customer,
		o.id_orders                            AS order_id,
		mi.name                                AS item,
		oi.quantity                            AS quantity,
		b.date                                 AS booking_date
	FROM
		customers AS c
	JOIN bookings AS b 
		ON c.id_customers = b.fk_customer
	JOIN orders   AS o
		ON b.id_booking = o.fk_booking_id
	JOIN order_items AS oi
		ON o.id_orders = oi.fk_order
	JOIN menu_items AS mi
		ON oi.fk_menu_item = mi.id_menu_item
	WHERE c.id_customers = ?
	ORDER BY customer ASC;';

EXECUTE get_order_detail USING @customer_id;
	
-- in case this is neeeded for some reason:
-- deallocate prepare get_order_detail;



-- Task 3
-- Your third and final task is to create a stored procedure called CancelOrder. 
-- Little Lemon wants to use this stored procedure to delete an order record based on the user input of the order id.
-- Creating this procedure will allow Little Lemon to cancel any order by 
-- specifying the order id value in the procedure parameter without typing the entire SQL delete statement.   
-- If you invoke the CancelOrder procedure, the output result should be similar to the output of the following screenshot:

-- first a look at the orders and their statuses
SELECT 
	bookings.id_booking,
    bookings.table_number,
    orders.id_orders,
    order_items.id_order_items AS order_item_id,
	menu_items.name,
    delivery.status
FROM bookings
JOIN orders ON orders.fk_booking_id = bookings.id_booking
JOIN order_items ON orders.id_orders = order_items.fk_order
JOIN menu_items ON menu_items.id_menu_item = order_items.fk_menu_item
JOIN delivery ON delivery.fk_order_items = order_items.id_order_items
GROUP BY 
	bookings.id_booking,
    bookings.table_number,
    orders.id_orders,
    order_item_id,
	menu_items.name,
    delivery.status
ORDER BY bookings.id_booking ASC, bookings.table_number ASC, delivery.status ASC;

-- my database has order_items table to separate the multiple items a booking can order
-- the total order is tracked in the orders table, and the details of the order in the order_items
-- so we need to delete records in the order_items in this case for the similar effect of this task

DELIMITER //
CREATE PROCEDURE cancel_order(IN order_item_id INT)
BEGIN
	DELETE FROM order_items WHERE id_order_items = order_item_id; 
END //
DELIMITER ;

CALL cancel_order(1);

-- works.
-- order 1 was deleted.







