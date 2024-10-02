use little_lemon_db;

SET @booking := 1;

-- how to get a customer's order list and prices per order item grouped
SELECT 
    CONCAT(customers.first_name, " ", customers.last_name) AS Customer,
    bookings.table_number AS 'Table No',
    bookings.time as 'Time',
    bookings.date as 'Date',
    menu_items.name AS Item,
    order_items.quantity as Quantity,
    SUM(menu_items.price * order_items.quantity) AS Total_Price
FROM customers
JOIN bookings ON bookings.fk_customer = customers.id_customers
JOIN orders ON bookings.id_booking = orders.fk_booking_id
JOIN order_items ON orders.id_orders = order_items.fk_order
JOIN menu_items ON order_items.fk_menu_item = menu_items.id_menu_item
WHERE bookings.id_booking = @booking
GROUP BY Customer, order_items.quantity, bookings.table_number, bookings.time, bookings.date, menu_items.name;

-- the total bill
SELECT 
    CONCAT(customers.first_name, " ", customers.last_name) AS Customer,
    bookings.table_number AS 'Table No',
    bookings.time as 'Time',
    bookings.date as 'Date',
    SUM(menu_items.price * order_items.quantity) AS Total_Price
FROM customers
JOIN bookings ON bookings.fk_customer = customers.id_customers
JOIN orders ON bookings.id_booking = orders.fk_booking_id
JOIN order_items ON orders.id_orders = order_items.fk_order
JOIN menu_items ON order_items.fk_menu_item = menu_items.id_menu_item
WHERE bookings.id_booking = @booking
GROUP BY Customer, bookings.table_number, bookings.time, bookings.date;
