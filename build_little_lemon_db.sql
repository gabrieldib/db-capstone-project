-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema GD_little_lemon_db
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `GD_little_lemon_db` ;

-- -----------------------------------------------------
-- Schema GD_little_lemon_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `GD_little_lemon_db` DEFAULT CHARACTER SET utf8 ;
SHOW WARNINGS;
USE `GD_little_lemon_db` ;

-- -----------------------------------------------------
-- Table `GD_little_lemon_db`.`customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GD_little_lemon_db`.`customers` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `GD_little_lemon_db`.`customers` (
  `id_customers` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(255) NOT NULL,
  `last_name` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_customers`))
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `id_customers_UNIQUE` ON `GD_little_lemon_db`.`customers` (`id_customers` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `GD_little_lemon_db`.`bookings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GD_little_lemon_db`.`bookings` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `GD_little_lemon_db`.`bookings` (
  `id_booking` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `table_number` INT NOT NULL,
  `fk_customer` INT UNSIGNED NOT NULL,
  `time` TIME NOT NULL,
  PRIMARY KEY (`id_booking`),
  CONSTRAINT `fk_customer_id`
    FOREIGN KEY (`fk_customer`)
    REFERENCES `GD_little_lemon_db`.`customers` (`id_customers`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `id_booking_UNIQUE` ON `GD_little_lemon_db`.`bookings` (`id_booking` ASC) VISIBLE;

SHOW WARNINGS;
CREATE INDEX `fk_customer_id_idx` ON `GD_little_lemon_db`.`bookings` (`fk_customer` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `GD_little_lemon_db`.`orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GD_little_lemon_db`.`orders` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `GD_little_lemon_db`.`orders` (
  `id_orders` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `date` DATETIME NOT NULL,
  `fk_booking_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_orders`),
  CONSTRAINT `fk_booking_id`
    FOREIGN KEY (`fk_booking_id`)
    REFERENCES `GD_little_lemon_db`.`bookings` (`id_booking`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `id_orders_UNIQUE` ON `GD_little_lemon_db`.`orders` (`id_orders` ASC) VISIBLE;

SHOW WARNINGS;
CREATE UNIQUE INDEX `fk_booking_id_UNIQUE` ON `GD_little_lemon_db`.`orders` (`fk_booking_id` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `GD_little_lemon_db`.`menu_item_sections`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GD_little_lemon_db`.`menu_item_sections` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `GD_little_lemon_db`.`menu_item_sections` (
  `id_menu_item_section` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id_menu_item_section`))
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `id_menu_item_type_UNIQUE` ON `GD_little_lemon_db`.`menu_item_sections` (`id_menu_item_section` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `GD_little_lemon_db`.`cuisine`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GD_little_lemon_db`.`cuisine` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `GD_little_lemon_db`.`cuisine` (
  `id_cuisine` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id_cuisine`))
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `id_cuisine_UNIQUE` ON `GD_little_lemon_db`.`cuisine` (`id_cuisine` ASC) VISIBLE;

SHOW WARNINGS;
CREATE UNIQUE INDEX `cuisine_name_UNIQUE` ON `GD_little_lemon_db`.`cuisine` (`name` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `GD_little_lemon_db`.`menu_items`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GD_little_lemon_db`.`menu_items` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `GD_little_lemon_db`.`menu_items` (
  `id_menu_item` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `fk_cuisine` INT UNSIGNED NOT NULL,
  `fk_menu_item_section` INT UNSIGNED NOT NULL,
  `price` DECIMAL(10,2) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id_menu_item`),
  CONSTRAINT `fk_menu_item_section`
    FOREIGN KEY (`fk_menu_item_section`)
    REFERENCES `GD_little_lemon_db`.`menu_item_sections` (`id_menu_item_section`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_cuisine`
    FOREIGN KEY (`fk_cuisine`)
    REFERENCES `GD_little_lemon_db`.`cuisine` (`id_cuisine`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `id_menu_UNIQUE` ON `GD_little_lemon_db`.`menu_items` (`id_menu_item` ASC) VISIBLE;

SHOW WARNINGS;
CREATE INDEX `fk_menu_item_section_idx` ON `GD_little_lemon_db`.`menu_items` (`fk_menu_item_section` ASC) VISIBLE;

SHOW WARNINGS;
CREATE INDEX `fk_cuisine_idx` ON `GD_little_lemon_db`.`menu_items` (`fk_cuisine` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `GD_little_lemon_db`.`order_items`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GD_little_lemon_db`.`order_items` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `GD_little_lemon_db`.`order_items` (
  `id_order_items` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `quantity` INT UNSIGNED NOT NULL,
  `fk_order` INT UNSIGNED NOT NULL,
  `fk_menu_item` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_order_items`),
  CONSTRAINT `fk_order_id`
    FOREIGN KEY (`fk_order`)
    REFERENCES `GD_little_lemon_db`.`orders` (`id_orders`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_menu_item`
    FOREIGN KEY (`fk_menu_item`)
    REFERENCES `GD_little_lemon_db`.`menu_items` (`id_menu_item`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `id_order_items_UNIQUE` ON `GD_little_lemon_db`.`order_items` (`id_order_items` ASC) VISIBLE;

SHOW WARNINGS;
CREATE INDEX `fk_order_id_idx` ON `GD_little_lemon_db`.`order_items` (`fk_order` ASC) VISIBLE;

SHOW WARNINGS;
CREATE INDEX `fk_menu_item_idx` ON `GD_little_lemon_db`.`order_items` (`fk_menu_item` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `GD_little_lemon_db`.`delivery`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GD_little_lemon_db`.`delivery` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `GD_little_lemon_db`.`delivery` (
  `id_delivery` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `last_updated` TIMESTAMP NOT NULL,
  `status` ENUM('ordered', 'preparing', 'ready for delivery', 'delivered') NOT NULL,
  `fk_order_items` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_delivery`),
  CONSTRAINT `fk_order_items`
    FOREIGN KEY (`fk_order_items`)
    REFERENCES `GD_little_lemon_db`.`order_items` (`id_order_items`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `id_delivery_UNIQUE` ON `GD_little_lemon_db`.`delivery` (`id_delivery` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `GD_little_lemon_db`.`staff`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GD_little_lemon_db`.`staff` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `GD_little_lemon_db`.`staff` (
  `id_staff` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(255) NOT NULL,
  `last_name` VARCHAR(255) NOT NULL,
  `role` VARCHAR(255) NOT NULL,
  `salary` INT NOT NULL,
  PRIMARY KEY (`id_staff`))
ENGINE = InnoDB
COMMENT = '																';

SHOW WARNINGS;
CREATE UNIQUE INDEX `id_staff_UNIQUE` ON `GD_little_lemon_db`.`staff` (`id_staff` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `GD_little_lemon_db`.`booking_staff`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GD_little_lemon_db`.`booking_staff` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `GD_little_lemon_db`.`booking_staff` (
  `id_booking_staff` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `fk_booking` INT UNSIGNED NOT NULL,
  `fk_staff` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_booking_staff`),
  CONSTRAINT `fk_booking`
    FOREIGN KEY (`fk_booking`)
    REFERENCES `GD_little_lemon_db`.`bookings` (`id_booking`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_staff`
    FOREIGN KEY (`fk_staff`)
    REFERENCES `GD_little_lemon_db`.`staff` (`id_staff`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `id_booking_staff_UNIQUE` ON `GD_little_lemon_db`.`booking_staff` (`id_booking_staff` ASC) VISIBLE;

SHOW WARNINGS;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- add data to the non dependent tables:
USE GD_little_lemon_db;

INSERT INTO customers (first_name, last_name, phone, email) 
VALUES 
	('Logan', 'Allen', '9647184668', 'logan.allen@mail.com'),
	('Grace', 'Walker', '3619034772', 'grace.walker@example.com'),
	('Aiden', 'Smith', '9953747584', 'aiden.smith@test.org'),
	('Hank', 'Wilson', '3997226001', 'hank.wilson@test.org'),
	('Mona', 'Carter', '2637925772', 'mona.carter@example.com'),
	('Quincy', 'Carter', '9444938154', 'quincy.carter@mail.com'),
	('Mia', 'Gonzalez', '3623357729', 'mia.gonzalez@example.com'),
	('Alexander', 'Harris', '7630246696', 'alexander.harris@example.com'),
	('Grace', 'Roberts', '3323388143', 'grace.roberts@mail.com'),
	('Mia', 'Jackson', '8136595290', 'mia.jackson@sample.net'),
	('Mason', 'Robinson', '8221000436', 'mason.robinson@example.com'),
	('Grace', 'Nelson', '1439889364', 'grace.nelson@example.com'),
	('Ava', 'Jackson', '2535623503', 'ava.jackson@mail.com'),
	('Daniel', 'King', '3442538420', 'daniel.king@example.com'),
	('Leon', 'Jones', '7941081707', 'leon.jones@sample.net'),
	('Jacob', 'Martin', '0820951534', 'jacob.martin@mail.com'),
	('Michael', 'Wright', '7871279805', 'michael.wright@sample.net'),
	('Nancy', 'Davis', '3500352136', 'nancy.davis@test.org'),
	('Mia', 'Smith', '0233924624', 'mia.smith@sample.net'),
	('David', 'Smith', '2475049819', 'david.smith@mail.com'),
	('Ivy', 'Scott', '0033966476', 'ivy.scott@test.org'),
	('Jane', 'Rodriguez', '6024984248', 'jane.rodriguez@sample.net'),
	('Nancy', 'Wilson', '2302418051', 'nancy.wilson@mail.com'),
	('Alexander', 'Hall', '2862355276', 'alexander.hall@mail.com'),
	('Rita', 'White', '5395376265', 'rita.white@test.org'),
	('Amelia', 'Roberts', '6733735193', 'amelia.roberts@mail.com'),
	('Uma', 'Williams', '5962318283', 'uma.williams@mail.com'),
	('Rita', 'Jackson', '9895966036', 'rita.jackson@mail.com'),
	('Jacob', 'Jones', '9712239127', 'jacob.jones@mail.com'),
	('John', 'Taylor', '3945827938', 'john.taylor@test.org'),
	('Alice', 'Lewis', '1154165942', 'alice.lewis@test.org'),
	('Tina', 'Martinez', '7574967875', 'tina.martinez@test.org'),
	('Paul', 'Nelson', '5129651612', 'paul.nelson@sample.net'),
	('Quincy', 'Lewis', '0039492421', 'quincy.lewis@example.com'),
	('Victor', 'Harris', '3584038866', 'victor.harris@example.com'),
	('Rita', 'Jackson', '2097885651', 'rita.jackson@sample.net'),
	('Olivia', 'Rodriguez', '3044584180', 'olivia.rodriguez@mail.com'),
	('John', 'Rodriguez', '0801818560', 'john.rodriguez@test.org'),
	('Isabella', 'Martin', '7645012576', 'isabella.martin@mail.com'),
	('James', 'Taylor', '2106072428', 'james.taylor@example.com'),
	('Daniel', 'Perez', '3106579570', 'daniel.perez@sample.net'),
	('Aria', 'White', '1810191267', 'aria.white@sample.net'),
	('Xander', 'Thomas', '9011513378', 'xander.thomas@example.com'),
	('Amelia', 'Nelson', '6710332102', 'amelia.nelson@test.org'),
	('Charlie', 'Lee', '5887684932', 'charlie.lee@example.com'),
	('Sophia', 'Williams', '8961792184', 'sophia.williams@sample.net'),
	('Alice', 'Walker', '4175933642', 'alice.walker@example.com'),
	('Emma', 'White', '1494000530', 'emma.white@test.org'),
	('Hank', 'Young', '1974845721', 'hank.young@test.org'),
	('Quincy', 'Jones', '0118742050', 'quincy.jones@test.org');


INSERT INTO menu_item_sections (name) 
VALUES 
	('Appetizers'),
	('Entrees'),
	('Salads'),
	('Desserts'),
	('Drinks'),
	('Pasta Specials'),
	('Sushi'),
	('Grilled Dishes');

INSERT INTO cuisine (name) 
VALUES 
	('Italian'),
	('Japanese'),
	('Brazilian');


INSERT INTO bookings (id_booking, date, time, table_number, fk_customer) 
VALUES 
	(1, '2024-08-25', '07:34:44', 10, 22),
	(2, '2024-04-12', '13:00:44', 8, 4),
	(3, '2024-05-06', '06:11:44', 9, 12),
	(4, '2024-09-18', '08:41:44', 4, 2),
	(5, '2024-08-27', '11:29:44', 1, 15),
	(6, '2024-08-22', '12:14:44', 1, 12),
	(7, '2024-07-05', '02:34:44', 6, 26),
	(8, '2024-04-13', '07:21:44', 2, 12),
	(9, '2024-07-17', '02:26:44', 7, 11),
	(10, '2024-07-30', '11:09:44', 1, 36),
	(11, '2024-09-12', '05:59:44', 2, 31),
	(12, '2024-09-23', '03:21:44', 3, 23),
	(13, '2024-09-25', '06:12:44', 8, 14),
	(14, '2024-07-31', '09:29:44', 3, 32),
	(15, '2024-04-12', '05:23:44', 3, 13),
	(16, '2024-04-04', '10:57:44', 5, 45),
	(17, '2024-08-23', '11:01:44', 7, 20),
	(18, '2024-06-06', '08:52:44', 5, 12),
	(19, '2024-08-17', '02:33:44', 3, 20),
	(20, '2024-08-19', '10:29:44', 2, 15);


INSERT INTO menu_items (name, fk_cuisine, fk_menu_item_section, price) 
VALUES 
	('Bruschetta', 1, 1, 8.5),
	('Caesar Salad', 1, 3, 10.0),
	('Margherita Pizza', 1, 2, 15.0),
	('Penne Arrabbiata', 1, 6, 13.5),
	('Tiramisu', 1, 4, 7.0),
	('Miso Soup', 2, 1, 6.0),
	('Edamame', 2, 1, 5.0),
	('Sashimi Platter', 2, 7, 22.0),
	('Teriyaki Chicken', 2, 8, 18.5),
	('Green Tea Ice Cream', 2, 4, 6.0),
	('Pão de Queijo', 3, 1, 5.0),
	('Feijoada', 3, 2, 20.0),
	('Churrasco', 3, 8, 25.0),
	('Moqueca', 3, 2, 18.0),
	('Brigadeiro', 3, 4, 4.0),
	('Spaghetti Carbonara', 1, 6, 14.0),
	('Gyoza', 2, 1, 8.0),
	('Tempura Udon', 2, 2, 15.0),
	('Yakitori', 2, 8, 9.0),
	('Caipirinha', 3, 5, 8.5),
	('Sushi Roll Set', 2, 7, 19.0),
	('Fettuccine Alfredo', 1, 6, 13.0),
	('Picanha', 3, 8, 28.0),
	('Garlic Bread', 1, 1, 5.5),
	('Japanese Green Tea', 2, 5, 3.5),
	('Lemonade', 3, 5, 4.0),
	('Caprese Salad', 1, 3, 9.5),
	('Mochi', 2, 4, 5.0),
	('Grilled Pineapple', 3, 4, 6.0),
	('Chicken Alfredo', 1, 2, 16.5),
	('Sake', 2, 5, 9.0),
	('Pasta Primavera', 1, 6, 13.5),
	('Yakimeshi', 2, 2, 12.0),
	('Acai Bowl', 3, 4, 7.5),
	('Coconut Water', 3, 5, 4.5),
	('Pasta Puttanesca', 1, 6, 14.5),
	('Eggplant Parmesan', 1, 2, 15.5),
	('Caesar with Grilled Chicken', 1, 3, 12.0),
	('Takoyaki', 2, 1, 7.0);


INSERT INTO staff (first_name, last_name, role, salary) 
VALUES 
	('Emily', 'Nelson', 'Waiter', 57360),
	('David', 'Davis', 'Busboy', 61691),
	('Charlie', 'Miller', 'Manager', 66531),
	('David', 'Wright', 'Busboy', 64459),
	('Yara', 'Rodriguez', 'Bartender', 41086),
	('Mona', 'Thompson', 'Waiter', 28926),
	('Leon', 'Martin', 'Waiter', 37741),
	('Hank', 'Rodriguez', 'Chef', 37558),
	('Bob', 'Nelson', 'Host', 57010),
	('David', 'Miller', 'Manager', 46562),
	('Yara', 'Gonzalez', 'Bartender', 40723),
	('Kathy', 'Smith', 'Sous Chef', 29744),
	('Alice', 'Garcia', 'Sous Chef', 52326),
	('Kathy', 'Brown', 'Sous Chef', 61665),
	('Daniel', 'Miller', 'Busboy', 56811);

-- Booking Staff Data (dependent)
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (1,15);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (2,6);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (3,14);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (4,9);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (5,3);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (6,3);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (7,6);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (8,10);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (9,5);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (10,1);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (11,2);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (12,5);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (13,3);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (14,9);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (15,15);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (16,2);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (17,4);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (18,14);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (19,1);
INSERT INTO booking_staff (`fk_booking`,`fk_staff`) VALUES (20,15);

-- Orders data (dependent)
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-09-30 09:39:32',1);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-08-01 09:39:32',2);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-08-13 09:39:32',3);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-07-21 09:39:32',4);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-08-11 09:39:32',5);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-09-25 09:39:32',6);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-07-16 09:39:32',7);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-08-27 09:39:32',8);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-09-28 09:39:32',9);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-10-05 09:39:32',10);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-08-02 09:39:32',11);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-08-10 09:39:32',12);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-09-20 09:39:32',13);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-10-01 09:39:32',14);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-07-26 09:39:32',15);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-09-19 09:39:32',16);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-09-23 09:39:32',17);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-08-08 09:39:32',18);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-08-06 09:39:32',19);
INSERT INTO orders (`date`,`fk_booking_id`) VALUES ('2024-09-27 09:39:32',20);

-- order_items data (dependent)
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (1,1,7);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,1,27);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,1,3);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (1,2,18);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,2,33);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (1,2,11);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (1,2,39);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,2,5);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,3,25);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,3,13);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,3,4);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,3,1);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,4,15);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,4,19);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,4,2);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (1,5,31);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,5,22);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,6,1);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,6,27);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,6,14);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,6,31);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,7,2);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,8,35);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (1,8,16);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (1,8,29);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,8,9);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,8,36);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,9,13);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (1,9,24);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,10,35);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (1,10,7);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (1,10,30);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (1,10,27);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,11,15);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,12,16);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,12,36);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (1,12,20);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (1,13,21);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,14,19);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,14,29);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,15,37);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (1,15,16);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (1,15,23);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,15,34);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,16,30);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,16,19);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,16,13);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,17,20);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,17,26);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,17,27);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,18,26);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (1,18,18);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,18,31);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (2,18,39);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,19,19);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,20,27);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (3,20,37);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (1,20,22);
INSERT INTO order_items (`quantity`,`fk_order`,`fk_menu_item`) VALUES (1,20,13);

-- Delivery table data (dependent)
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:17:08','ordered',             2);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:57:08','preparing',           2);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:58:08','ready for delivery',  2);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:46:08','delivered',           2);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:20:08','ordered',             3);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:21:08','preparing',           3);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:34:08','ready for delivery',  3);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:46:08','delivered',           3);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:56:08','ordered',             4);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:05:08','preparing',           4);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:44:08','ready for delivery',  4);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:59:08','delivered',           4);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:30:08','ordered',             5);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:00:08','preparing',           5);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:58:08','ready for delivery',  5);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:46:08','delivered',           5);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:14:08','ordered',             6);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:57:08','preparing',           6);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:15:08','ready for delivery',  6);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:03:08','delivered',           6);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:34:08','ordered',             7);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:52:08','preparing',           7);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:24:08','ready for delivery',  7);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:17:08','delivered',           7);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:11:08','ordered',             8);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:21:08','preparing',           8);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:35:08','ready for delivery',  8);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:43:08','delivered',           8);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:08:08','ordered',             9);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:54:08','preparing',           9);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:46:08','ready for delivery',  9);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:46:08','delivered',           9);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:34:08','ordered',             10);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:04:08','preparing',           10);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:24:08','ready for delivery',  10);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:23:08','delivered',           10);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:11:08','ordered',             11);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:31:08','preparing',           11);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:50:08','ready for delivery',  11);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:51:08','delivered',           11);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:30:08','ordered',             12);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:07:08','preparing',           12);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:11:08','ready for delivery',  12);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:31:08','delivered',           12);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:20:08','ordered',             13);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:31:08','preparing',           13);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:05:08','ready for delivery',  13);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:11:08','delivered',           13);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:12:08','ordered',             14);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:21:08','preparing',           14);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:53:08','ready for delivery',  14);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:20:08','delivered',           14);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:18:08','ordered',             15);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:24:08','preparing',           15);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:07:08','ready for delivery',  15);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:53:08','delivered',           15);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:44:08','ordered',             16);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:41:08','preparing',           16);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:25:08','ready for delivery',  16);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:46:08','delivered',           16);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:11:08','ordered',             17);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:11:08','preparing',           17);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:46:08','ready for delivery',  17);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:25:08','delivered',           17);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:37:08','ordered',             18);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:19:08','preparing',           18);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:10:08','ready for delivery',  18);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:05:08','delivered',           18);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:58:08','ordered',             19);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:14:08','preparing',           19);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:51:08','ready for delivery',  19);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:18:08','delivered',           19);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:16:08','ordered',             20);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:40:08','preparing',           20);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:53:08','ready for delivery',  20);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:58:08','delivered',           20);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:51:08','ordered',             21);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:00:08','preparing',           21);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:12:08','ready for delivery',  21);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:46:08','delivered',           21);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:56:08','ordered',             22);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:02:08','preparing',           22);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:05:08','ready for delivery',  22);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:51:08','delivered',           22);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:53:08','ordered',             23);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:29:08','preparing',           23);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:54:08','ready for delivery',  23);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:54:08','delivered',           23);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:02:08','ordered',             24);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:26:08','preparing',           24);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:26:08','ready for delivery',  24);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:19:08','delivered',           24);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:46:08','ordered',             25);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:37:08','preparing',           25);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:30:08','ready for delivery',  25);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:17:08','delivered',           25);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:44:08','ordered',             26);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:42:08','preparing',           26);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:59:08','ready for delivery',  26);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:17:08','delivered',           26);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:57:08','ordered',             27);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:30:08','preparing',           27);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:52:08','ready for delivery',  27);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:06:08','delivered',           27);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:33:08','ordered',             28);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:34:08','preparing',           28);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:03:08','ready for delivery',  28);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:02:08','delivered',           28);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:44:08','ordered',             29);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:09:08','preparing',           29);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:22:08','ready for delivery',  29);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:26:08','delivered',           29);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:08:08','ordered',             30);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:19:08','preparing',           30);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:04:08','ready for delivery',  30);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:20:08','delivered',           30);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:03:08','ordered',             31);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:26:08','preparing',           31);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:55:08','ready for delivery',  31);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:20:08','delivered',           31);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:51:08','ordered',             32);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:41:08','preparing',           32);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:51:08','ready for delivery',  32);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:48:08','delivered',           32);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:41:08','ordered',             33);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:33:08','preparing',           33);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:24:08','ready for delivery',  33);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:40:08','delivered',           33);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:22:08','ordered',             34);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:15:08','preparing',           34);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:01:08','ready for delivery',  34);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:57:08','delivered',           34);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:47:08','ordered',             35);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:13:08','preparing',           35);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:56:08','ready for delivery',  35);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:52:08','delivered',           35);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:34:08','ordered',             36);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:11:08','preparing',           36);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:06:08','ready for delivery',  36);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:41:08','delivered',           36);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:09:08','ordered',             37);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:12:08','preparing',           37);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:50:08','ready for delivery',  37);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:07:08','delivered',           37);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:34:08','ordered',             38);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:51:08','preparing',           38);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:07:08','ready for delivery',  38);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:48:08','delivered',           38);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:52:08','ordered',             39);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:29:08','preparing',           39);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:48:08','ready for delivery',  39);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:02:08','delivered',           39);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:44:08','ordered',             40);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:43:08','preparing',           40);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:25:08','ready for delivery',  40);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:31:08','delivered',           40);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:56:08','ordered',             41);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:50:08','preparing',           41);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:43:08','ready for delivery',  41);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:33:08','delivered',           41);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:15:08','ordered',             42);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:24:08','preparing',           42);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:57:08','ready for delivery',  42);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:41:08','delivered',           42);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:04:08','ordered',             43);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:12:08','preparing',           43);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:08:08','ready for delivery',  43);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:05:08','delivered',           43);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:54:08','ordered',             44);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:16:08','preparing',           44);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:34:08','ready for delivery',  44);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:46:08','delivered',           44);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:38:08','ordered',             45);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:13:08','preparing',           45);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:04:08','ready for delivery',  45);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:59:08','delivered',           45);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:09:08','ordered',             46);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:27:08','preparing',           46);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:57:08','ready for delivery',  46);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:46:08','delivered',           46);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:43:08','ordered',             47);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:26:08','preparing',           47);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:31:08','ready for delivery',  47);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:41:08','delivered',           47);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:35:08','ordered',             48);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:18:08','preparing',           48);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:42:08','ready for delivery',  48);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:02:08','delivered',           48);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:09:08','ordered',             49);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:06:08','preparing',           49);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:09:08','ready for delivery',  49);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:50:08','delivered',           49);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:30:08','ordered',             50);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:39:08','preparing',           50);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:51:08','ready for delivery',  50);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:41:08','delivered',           50);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:05:08','ordered',             51);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:03:08','preparing',           51);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:36:08','ready for delivery',  51);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:54:08','delivered',           51);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:26:08','ordered',             52);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:09:08','preparing',           52);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:07:08','ready for delivery',  52);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:16:08','delivered',           52);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:32:08','ordered',             53);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:07:08','preparing',           53);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:47:08','ready for delivery',  53);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:28:08','delivered',           53);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:45:08','ordered',             54);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:56:08','preparing',           54);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:30:08','ready for delivery',  54);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:05:08','delivered',           54);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:17:08','ordered',             55);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:10:08','preparing',           55);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:55:08','ready for delivery',  55);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:13:08','delivered',           55);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:35:08','ordered',             56);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:16:08','preparing',           56);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 13:52:08','ready for delivery',  56);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:11:08','delivered',           56);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:28:08','ordered',             57);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:39:08','preparing',           57);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:12:08','ready for delivery',  57);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:56:08','delivered',           57);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:21:08','ordered',             58);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:14:08','preparing',           58);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:41:08','ready for delivery',  58);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:19:08','delivered',           58);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:39:08','ordered',             59);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:08:08','preparing',           59);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 15:16:08','ready for delivery',  59);
INSERT INTO delivery (`last_updated`,`status`,`fk_order_items`) VALUES ('2024-10-02 14:26:08','delivered',           59);

-- STORED PROCEDURES DECLARATIONS _______________________________________________________________________

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

SET @r_booking_status := 0; -- booking status return value initialization, before calling the procedure 

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