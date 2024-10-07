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
  `fk_server` INT NOT NULL,
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
