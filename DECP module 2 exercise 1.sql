-- Task 1
-- In the first task, Little Lemon need you to create a virtual table called OrdersView 
-- that focuses on OrderID, Quantity and Cost columns within the Orders table for all orders with a quantity greater than 2. 
-- Here’s some guidance around completing this task: 
-- Use a CREATE VIEW statement.
-- Extract the order id, quantity and cost data from the Orders table.
-- Filter data from the orders table based on orders with a quantity greater than 2. 

CREATE VIEW Orders_View AS
SELECT 
	orders.id_orders,
    order_items.quantity,
    menu_items.name,
    bookings.table_number,
	SUM(menu_items.price * order_items.quantity) as price
FROM orders
JOIN bookings ON bookings.id_booking = orders.fk_booking_id
JOIN order_items ON order_items.fk_order = orders.id_orders
JOIN menu_items ON order_items.fk_menu_item = menu_items.id_menu_item
WHERE order_items.quantity >= 2
GROUP BY orders.id_orders, order_items.quantity, menu_items.name;

-- run the query to see the summary 
SELECT * from Orders_View;



-- Task 2
-- For your second task, Little Lemon needs information from four tables 
-- on all customers with orders that cost more than $150. 
-- Extract the required information from each of the following tables by using the relevant JOIN clause: 
-- Customers table: The customer id and full name.
-- Orders table: The order id and cost.
-- Menus table: The menus name.
-- MenusItems table: course name and starter name.
-- The result set should be sorted by the lowest cost amount.

-- Adjusted to orders that cost more than $40, since aggregated prices didn't go as high as $150

SELECT 
	c.id_customers                                         AS 'customer_id',
    CONCAT(c.first_name, " ", c.last_name)                 AS Customer,
    o.id_orders                                            AS 'order_id',
    SUM(oi.quantity * mi.price)                            AS Price,
    cu.name                                                AS 'Menu Name',
    mi.name                                                AS 'Menu Item'
FROM customers   AS c
JOIN bookings    AS b  ON b.fk_customer   = c.id_customers
JOIN orders      AS o  ON b.id_booking    = o.fk_booking_id
JOIN order_items AS oi ON o.id_orders     = oi.fk_order
JOIN menu_items  AS mi ON oi.fk_menu_item = mi.id_menu_item
JOIN cuisine     AS cu ON cu.id_cuisine   = mi.fk_cuisine
GROUP BY c.id_customers, Customer, o.id_orders, cu.name, mi.name
HAVING Price >= 40
ORDER BY Price ASC;

-- an alternative aggregating the customers as well and getting their total spent per customer
SELECT 
    c.id_customers                                         AS 'customer_id',
    CONCAT(c.first_name, " ", c.last_name)                 AS Customer,
    COUNT(DISTINCT o.id_orders)                            AS 'Total_Orders',
    SUM(oi.quantity * mi.price)                            AS 'Total_Spent',
    GROUP_CONCAT(DISTINCT cu.name SEPARATOR ', ')          AS 'Cuisines_Ordered',
    GROUP_CONCAT(DISTINCT mi.name SEPARATOR ', ')          AS 'Menu_Items_Ordered'
FROM customers   AS c
JOIN bookings    AS b  ON b.fk_customer   = c.id_customers
JOIN orders      AS o  ON b.id_booking    = o.fk_booking_id
JOIN order_items AS oi ON o.id_orders     = oi.fk_order
JOIN menu_items  AS mi ON oi.fk_menu_item = mi.id_menu_item
JOIN cuisine     AS cu ON cu.id_cuisine   = mi.fk_cuisine
GROUP BY c.id_customers, Customer
HAVING Total_Spent >= 40
ORDER BY Total_Spent ASC;

-- another alternative aggregating the spend per table
SELECT 
    b.table_number                                    AS 'Table_Number',
    COUNT(DISTINCT o.id_orders)                       AS 'Total_Orders',
    SUM(oi.quantity * mi.price)                       AS 'Total_Spent',
    GROUP_CONCAT(DISTINCT cu.name SEPARATOR ', ')     AS 'Cuisines_Ordered',
    GROUP_CONCAT(DISTINCT mi.name SEPARATOR ', ')     AS 'Menu_Items_Ordered'
FROM bookings    AS b
JOIN orders      AS o  ON b.id_booking    = o.fk_booking_id
JOIN order_items AS oi ON o.id_orders     = oi.fk_order
JOIN menu_items  AS mi ON oi.fk_menu_item = mi.id_menu_item
JOIN cuisine     AS cu ON cu.id_cuisine   = mi.fk_cuisine
GROUP BY b.table_number
ORDER BY Total_Spent ASC;

-- but none of these scenarios make sense as if a customer booked multiple times,
-- like the first alternative query, this means we are getting his total spend ever in the
-- restaurant. In the second alternative query we get the total revenue per table ever,
-- which also is a strange metric. 
-- ideally we want to know how much a customer related to an unique booking spend on a certain date.


SELECT 
    c.id_customers                                         AS 'customer_id',
    b.date                                                 AS 'date',
    b.table_number                                         AS 'Table Number',
    CONCAT(c.first_name, " ", c.last_name)                 AS Customer,
    COUNT(DISTINCT o.id_orders)                            AS 'Total_Orders',
    SUM(oi.quantity * mi.price)                            AS 'Total_Spent',
    GROUP_CONCAT(DISTINCT cu.name SEPARATOR ', ')          AS 'Cuisines_Ordered',
    GROUP_CONCAT(DISTINCT mi.name SEPARATOR ', ')          AS 'Menu_Items_Ordered'
FROM customers   AS c
JOIN bookings    AS b  ON b.fk_customer   = c.id_customers
JOIN orders      AS o  ON b.id_booking    = o.fk_booking_id
JOIN order_items AS oi ON o.id_orders     = oi.fk_order
JOIN menu_items  AS mi ON oi.fk_menu_item = mi.id_menu_item
JOIN cuisine     AS cu ON cu.id_cuisine   = mi.fk_cuisine
GROUP BY c.id_customers, Customer, b.date, b.table_number
HAVING Total_Spent >= 40
ORDER BY Customer ASC; -- could also be date 
-- ORDER BY Total_Spent ASC;


-- Task 3
-- For the third and final task, Little Lemon needs you to find all menu items 
-- for which more than 2 orders have been placed. 
-- You can carry out this task by creating a subquery that lists the menu names 
-- from the menus table for any order quantity with more than 2.
-- Here’s some guidance around completing this task: 
-- Use the ANY operator in a subquery
-- The outer query should be used to select the menu name from the menus table.
-- The inner query should check if any item quantity in the order table is more than 2. 

-- as requested
SELECT 
	mi.name AS 'Menu Item'
FROM menu_items AS mi
WHERE mi.id_menu_item = ANY(
	SELECT oi.fk_menu_item
    FROM order_items AS oi
    GROUP BY oi.fk_menu_item -- );
    HAVING COUNT(oi.id_order_items) > 2);
	
-- a more efficient way, with additional info
SELECT 
    mi.name AS 'Menu Item',
    SUM(oi.quantity) AS 'Total Quantity Ordered'
FROM menu_items AS mi
JOIN order_items AS oi ON mi.id_menu_item = oi.fk_menu_item
GROUP BY mi.name
HAVING COUNT(oi.id_order_items) > 2;








