-- liquibase formatted sql changeLogId:5480310c-b0d9-477b-99d5-d97f7182f01f

-- changeset ranan:1651234703995-1
CREATE TABLE actor (actor_id SMALLINT UNSIGNED AUTO_INCREMENT NOT NULL, first_name VARCHAR(45) NOT NULL, last_name VARCHAR(45) NOT NULL, last_update timestamp DEFAULT NOW() NOT NULL, CONSTRAINT PK_ACTOR PRIMARY KEY (actor_id));

-- changeset ranan:1651234703995-2
CREATE TABLE address (address_id SMALLINT UNSIGNED AUTO_INCREMENT NOT NULL, address VARCHAR(50) NOT NULL, address2 VARCHAR(50) NULL, district VARCHAR(20) NOT NULL, city_id SMALLINT UNSIGNED NOT NULL, postal_code VARCHAR(10) NULL, phone VARCHAR(20) NOT NULL, location GEOMETRY(65535) NOT NULL, last_update timestamp DEFAULT NOW() NOT NULL, CONSTRAINT PK_ADDRESS PRIMARY KEY (address_id));

-- changeset ranan:1651234703995-3
CREATE TABLE category (category_id TINYINT(3) UNSIGNED AUTO_INCREMENT NOT NULL, name VARCHAR(25) NOT NULL, last_update timestamp DEFAULT NOW() NOT NULL, CONSTRAINT PK_CATEGORY PRIMARY KEY (category_id));

-- changeset ranan:1651234703995-4
CREATE TABLE city (city_id SMALLINT UNSIGNED AUTO_INCREMENT NOT NULL, city VARCHAR(50) NOT NULL, country_id SMALLINT UNSIGNED NOT NULL, last_update timestamp DEFAULT NOW() NOT NULL, CONSTRAINT PK_CITY PRIMARY KEY (city_id));

-- changeset ranan:1651234703995-5
CREATE TABLE country (country_id SMALLINT UNSIGNED AUTO_INCREMENT NOT NULL, country VARCHAR(50) NOT NULL, last_update timestamp DEFAULT NOW() NOT NULL, CONSTRAINT PK_COUNTRY PRIMARY KEY (country_id));

-- changeset ranan:1651234703995-6
CREATE TABLE customer (customer_id SMALLINT UNSIGNED AUTO_INCREMENT NOT NULL, store_id TINYINT(3) UNSIGNED NOT NULL, first_name VARCHAR(45) NOT NULL, last_name VARCHAR(45) NOT NULL, email VARCHAR(50) NULL, address_id SMALLINT UNSIGNED NOT NULL, active BIT(1) DEFAULT 1 NOT NULL, create_date datetime NOT NULL, last_update timestamp DEFAULT NOW() NULL, CONSTRAINT PK_CUSTOMER PRIMARY KEY (customer_id));

-- changeset ranan:1651234703995-7
CREATE TABLE film (film_id SMALLINT UNSIGNED AUTO_INCREMENT NOT NULL, title VARCHAR(255) NOT NULL, `description` TEXT NULL, release_year YEAR(4) NULL, language_id TINYINT(3) UNSIGNED NOT NULL, original_language_id TINYINT(3) UNSIGNED NULL, rental_duration TINYINT(3) UNSIGNED DEFAULT 3 NOT NULL, rental_rate DECIMAL(4, 2) DEFAULT 4.99 NOT NULL, length SMALLINT UNSIGNED NULL, replacement_cost DECIMAL(5, 2) DEFAULT 19.99 NOT NULL, rating ENUM('NC-17', 'R', 'PG-13', 'PG', 'G') DEFAULT 'G' NULL, special_features SET('Behind the Scenes', 'Deleted Scenes', 'Commentaries', 'Trailers') NULL, last_update timestamp DEFAULT NOW() NOT NULL, CONSTRAINT PK_FILM PRIMARY KEY (film_id));

-- changeset ranan:1651234703995-8
CREATE TABLE film_actor (actor_id SMALLINT UNSIGNED NOT NULL, film_id SMALLINT UNSIGNED NOT NULL, last_update timestamp DEFAULT NOW() NOT NULL, CONSTRAINT PK_FILM_ACTOR PRIMARY KEY (actor_id, film_id));

-- changeset ranan:1651234703995-9
CREATE TABLE film_category (film_id SMALLINT UNSIGNED NOT NULL, category_id TINYINT(3) UNSIGNED NOT NULL, last_update timestamp DEFAULT NOW() NOT NULL, CONSTRAINT PK_FILM_CATEGORY PRIMARY KEY (film_id, category_id));

-- changeset ranan:1651234703995-10
CREATE TABLE film_text (film_id SMALLINT NOT NULL, title VARCHAR(255) NOT NULL, `description` TEXT NULL, CONSTRAINT PK_FILM_TEXT PRIMARY KEY (film_id));

-- changeset ranan:1651234703995-11
CREATE TABLE inventory (inventory_id MEDIUMINT UNSIGNED AUTO_INCREMENT NOT NULL, film_id SMALLINT UNSIGNED NOT NULL, store_id TINYINT(3) UNSIGNED NOT NULL, last_update timestamp DEFAULT NOW() NOT NULL, CONSTRAINT PK_INVENTORY PRIMARY KEY (inventory_id));

-- changeset ranan:1651234703995-12
CREATE TABLE language (language_id TINYINT(3) UNSIGNED AUTO_INCREMENT NOT NULL, name CHAR(20) NOT NULL, last_update timestamp DEFAULT NOW() NOT NULL, CONSTRAINT PK_LANGUAGE PRIMARY KEY (language_id));

-- changeset ranan:1651234703995-13
CREATE TABLE payment (payment_id SMALLINT UNSIGNED AUTO_INCREMENT NOT NULL, customer_id SMALLINT UNSIGNED NOT NULL, staff_id TINYINT(3) UNSIGNED NOT NULL, rental_id INT NULL, amount DECIMAL(5, 2) NOT NULL, payment_date datetime NOT NULL, last_update timestamp DEFAULT NOW() NULL, CONSTRAINT PK_PAYMENT PRIMARY KEY (payment_id));

-- changeset ranan:1651234703995-14
CREATE TABLE rental (rental_id INT AUTO_INCREMENT NOT NULL, rental_date datetime NOT NULL, inventory_id MEDIUMINT UNSIGNED NOT NULL, customer_id SMALLINT UNSIGNED NOT NULL, return_date datetime NULL, staff_id TINYINT(3) UNSIGNED NOT NULL, last_update timestamp DEFAULT NOW() NOT NULL, CONSTRAINT PK_RENTAL PRIMARY KEY (rental_id));

-- changeset ranan:1651234703995-15
CREATE TABLE staff (staff_id TINYINT(3) UNSIGNED AUTO_INCREMENT NOT NULL, first_name VARCHAR(45) NOT NULL, last_name VARCHAR(45) NOT NULL, address_id SMALLINT UNSIGNED NOT NULL, picture BLOB NULL, email VARCHAR(50) NULL, store_id TINYINT(3) UNSIGNED NOT NULL, active BIT(1) DEFAULT 1 NOT NULL, username VARCHAR(16) NOT NULL, password VARCHAR(40) NULL, last_update timestamp DEFAULT NOW() NOT NULL, CONSTRAINT PK_STAFF PRIMARY KEY (staff_id));

-- changeset ranan:1651234703995-16
CREATE TABLE store (store_id TINYINT(3) UNSIGNED AUTO_INCREMENT NOT NULL, manager_staff_id TINYINT(3) UNSIGNED NOT NULL, address_id SMALLINT UNSIGNED NOT NULL, last_update timestamp DEFAULT NOW() NOT NULL, CONSTRAINT PK_STORE PRIMARY KEY (store_id), UNIQUE (manager_staff_id));

-- changeset ranan:1651234703995-17
ALTER TABLE rental ADD CONSTRAINT rental_date UNIQUE (rental_date, inventory_id, customer_id);

-- changeset ranan:1651234703995-18
CREATE VIEW actor_info AS select `a`.`actor_id` AS `actor_id`,`a`.`first_name` AS `first_name`,`a`.`last_name` AS `last_name`,group_concat(distinct concat(`c`.`name`,': ',(select group_concat(`f`.`title` order by `f`.`title` ASC separator ', ') from ((`sakila`.`film` `f` join `sakila`.`film_category` `fc` on((`f`.`film_id` = `fc`.`film_id`))) join `sakila`.`film_actor` `fa` on((`f`.`film_id` = `fa`.`film_id`))) where ((`fc`.`category_id` = `c`.`category_id`) and (`fa`.`actor_id` = `a`.`actor_id`)))) order by `c`.`name` ASC separator '; ') AS `film_info` from (((`sakila`.`actor` `a` left join `sakila`.`film_actor` `fa` on((`a`.`actor_id` = `fa`.`actor_id`))) left join `sakila`.`film_category` `fc` on((`fa`.`film_id` = `fc`.`film_id`))) left join `sakila`.`category` `c` on((`fc`.`category_id` = `c`.`category_id`))) group by `a`.`actor_id`,`a`.`first_name`,`a`.`last_name`;

-- changeset ranan:1651234703995-19
CREATE VIEW customer_list AS select `cu`.`customer_id` AS `ID`,concat(`cu`.`first_name`,' ',`cu`.`last_name`) AS `name`,`a`.`address` AS `address`,`a`.`postal_code` AS `zip code`,`a`.`phone` AS `phone`,`sakila`.`city`.`city` AS `city`,`sakila`.`country`.`country` AS `country`,if(`cu`.`active`,'active','') AS `notes`,`cu`.`store_id` AS `SID` from (((`sakila`.`customer` `cu` join `sakila`.`address` `a` on((`cu`.`address_id` = `a`.`address_id`))) join `sakila`.`city` on((`a`.`city_id` = `sakila`.`city`.`city_id`))) join `sakila`.`country` on((`sakila`.`city`.`country_id` = `sakila`.`country`.`country_id`)));

-- changeset ranan:1651234703995-20
CREATE VIEW film_list AS select `sakila`.`film`.`film_id` AS `FID`,`sakila`.`film`.`title` AS `title`,`sakila`.`film`.`description` AS `description`,`sakila`.`category`.`name` AS `category`,`sakila`.`film`.`rental_rate` AS `price`,`sakila`.`film`.`length` AS `length`,`sakila`.`film`.`rating` AS `rating`,group_concat(concat(`sakila`.`actor`.`first_name`,' ',`sakila`.`actor`.`last_name`) separator ', ') AS `actors` from ((((`sakila`.`category` left join `sakila`.`film_category` on((`sakila`.`category`.`category_id` = `sakila`.`film_category`.`category_id`))) left join `sakila`.`film` on((`sakila`.`film_category`.`film_id` = `sakila`.`film`.`film_id`))) join `sakila`.`film_actor` on((`sakila`.`film`.`film_id` = `sakila`.`film_actor`.`film_id`))) join `sakila`.`actor` on((`sakila`.`film_actor`.`actor_id` = `sakila`.`actor`.`actor_id`))) group by `sakila`.`film`.`film_id`,`sakila`.`category`.`name`;

-- changeset ranan:1651234703995-21
CREATE VIEW nicer_but_slower_film_list AS select `sakila`.`film`.`film_id` AS `FID`,`sakila`.`film`.`title` AS `title`,`sakila`.`film`.`description` AS `description`,`sakila`.`category`.`name` AS `category`,`sakila`.`film`.`rental_rate` AS `price`,`sakila`.`film`.`length` AS `length`,`sakila`.`film`.`rating` AS `rating`,group_concat(concat(concat(upper(substr(`sakila`.`actor`.`first_name`,1,1)),lower(substr(`sakila`.`actor`.`first_name`,2,length(`sakila`.`actor`.`first_name`))),' ',concat(upper(substr(`sakila`.`actor`.`last_name`,1,1)),lower(substr(`sakila`.`actor`.`last_name`,2,length(`sakila`.`actor`.`last_name`)))))) separator ', ') AS `actors` from ((((`sakila`.`category` left join `sakila`.`film_category` on((`sakila`.`category`.`category_id` = `sakila`.`film_category`.`category_id`))) left join `sakila`.`film` on((`sakila`.`film_category`.`film_id` = `sakila`.`film`.`film_id`))) join `sakila`.`film_actor` on((`sakila`.`film`.`film_id` = `sakila`.`film_actor`.`film_id`))) join `sakila`.`actor` on((`sakila`.`film_actor`.`actor_id` = `sakila`.`actor`.`actor_id`))) group by `sakila`.`film`.`film_id`,`sakila`.`category`.`name`;

-- changeset ranan:1651234703995-22
CREATE VIEW sales_by_film_category AS select `c`.`name` AS `category`,sum(`p`.`amount`) AS `total_sales` from (((((`sakila`.`payment` `p` join `sakila`.`rental` `r` on((`p`.`rental_id` = `r`.`rental_id`))) join `sakila`.`inventory` `i` on((`r`.`inventory_id` = `i`.`inventory_id`))) join `sakila`.`film` `f` on((`i`.`film_id` = `f`.`film_id`))) join `sakila`.`film_category` `fc` on((`f`.`film_id` = `fc`.`film_id`))) join `sakila`.`category` `c` on((`fc`.`category_id` = `c`.`category_id`))) group by `c`.`name` order by `total_sales` desc;

-- changeset ranan:1651234703995-23
CREATE VIEW sales_by_store AS select concat(`c`.`city`,',',`cy`.`country`) AS `store`,concat(`m`.`first_name`,' ',`m`.`last_name`) AS `manager`,sum(`p`.`amount`) AS `total_sales` from (((((((`sakila`.`payment` `p` join `sakila`.`rental` `r` on((`p`.`rental_id` = `r`.`rental_id`))) join `sakila`.`inventory` `i` on((`r`.`inventory_id` = `i`.`inventory_id`))) join `sakila`.`store` `s` on((`i`.`store_id` = `s`.`store_id`))) join `sakila`.`address` `a` on((`s`.`address_id` = `a`.`address_id`))) join `sakila`.`city` `c` on((`a`.`city_id` = `c`.`city_id`))) join `sakila`.`country` `cy` on((`c`.`country_id` = `cy`.`country_id`))) join `sakila`.`staff` `m` on((`s`.`manager_staff_id` = `m`.`staff_id`))) group by `s`.`store_id` order by `cy`.`country`,`c`.`city`;

-- changeset ranan:1651234703995-24
CREATE VIEW staff_list AS select `s`.`staff_id` AS `ID`,concat(`s`.`first_name`,' ',`s`.`last_name`) AS `name`,`a`.`address` AS `address`,`a`.`postal_code` AS `zip code`,`a`.`phone` AS `phone`,`sakila`.`city`.`city` AS `city`,`sakila`.`country`.`country` AS `country`,`s`.`store_id` AS `SID` from (((`sakila`.`staff` `s` join `sakila`.`address` `a` on((`s`.`address_id` = `a`.`address_id`))) join `sakila`.`city` on((`a`.`city_id` = `sakila`.`city`.`city_id`))) join `sakila`.`country` on((`sakila`.`city`.`country_id` = `sakila`.`country`.`country_id`)));

-- changeset ranan:1651234703995-25 splitStatements:false
CREATE FUNCTION `get_customer_balance`(p_customer_id INT, p_effective_date DATETIME) RETURNS decimal(5,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN

       #OK, WE NEED TO CALCULATE THE CURRENT BALANCE GIVEN A CUSTOMER_ID AND A DATE
       #THAT WE WANT THE BALANCE TO BE EFFECTIVE FOR. THE BALANCE IS:
       #   1) RENTAL FEES FOR ALL PREVIOUS RENTALS
       #   2) ONE DOLLAR FOR EVERY DAY THE PREVIOUS RENTALS ARE OVERDUE
       #   3) IF A FILM IS MORE THAN RENTAL_DURATION * 2 OVERDUE, CHARGE THE REPLACEMENT_COST
       #   4) SUBTRACT ALL PAYMENTS MADE BEFORE THE DATE SPECIFIED

  DECLARE v_rentfees DECIMAL(5,2); #FEES PAID TO RENT THE VIDEOS INITIALLY
  DECLARE v_overfees INTEGER;      #LATE FEES FOR PRIOR RENTALS
  DECLARE v_payments DECIMAL(5,2); #SUM OF PAYMENTS MADE PREVIOUSLY

  SELECT IFNULL(SUM(film.rental_rate),0) INTO v_rentfees
    FROM film, inventory, rental
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

  SELECT IFNULL(SUM(IF((TO_DAYS(rental.return_date) - TO_DAYS(rental.rental_date)) > film.rental_duration,
        ((TO_DAYS(rental.return_date) - TO_DAYS(rental.rental_date)) - film.rental_duration),0)),0) INTO v_overfees
    FROM rental, inventory, film
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;


  SELECT IFNULL(SUM(payment.amount),0) INTO v_payments
    FROM payment

    WHERE payment.payment_date <= p_effective_date
    AND payment.customer_id = p_customer_id;

  RETURN v_rentfees + v_overfees - v_payments;
END;

-- changeset ranan:1651234703995-26 splitStatements:false
CREATE FUNCTION `inventory_held_by_customer`(p_inventory_id INT) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE v_customer_id INT;
  DECLARE EXIT HANDLER FOR NOT FOUND RETURN NULL;

  SELECT customer_id INTO v_customer_id
  FROM rental
  WHERE return_date IS NULL
  AND inventory_id = p_inventory_id;

  RETURN v_customer_id;
END;

-- changeset ranan:1651234703995-27 splitStatements:false
CREATE FUNCTION `inventory_in_stock`(p_inventory_id INT) RETURNS tinyint(1)
    READS SQL DATA
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out     INT;

    #AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE
    #FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED

    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END;

-- changeset ranan:1651234703995-28 splitStatements:false
CREATE TRIGGER customer_create_date BEFORE INSERT ON customer FOR EACH ROW SET NEW.create_date = NOW();

-- changeset ranan:1651234703995-29 splitStatements:false
CREATE TRIGGER del_film AFTER DELETE ON film FOR EACH ROW BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
  END;

-- changeset ranan:1651234703995-30 splitStatements:false
CREATE TRIGGER ins_film AFTER INSERT ON film FOR EACH ROW BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
  END;

-- changeset ranan:1651234703995-31 splitStatements:false
CREATE TRIGGER payment_date BEFORE INSERT ON payment FOR EACH ROW SET NEW.payment_date = NOW();

-- changeset ranan:1651234703995-32 splitStatements:false
CREATE TRIGGER rental_date BEFORE INSERT ON rental FOR EACH ROW SET NEW.rental_date = NOW();

-- changeset ranan:1651234703995-33 splitStatements:false
CREATE TRIGGER upd_film AFTER UPDATE ON film FOR EACH ROW BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END;

-- changeset ranan:1651234703995-34 splitStatements:false
CREATE PROCEDURE `film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
    READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);

     SELECT FOUND_ROWS() INTO p_film_count;
END;

-- changeset ranan:1651234703995-35 splitStatements:false
CREATE PROCEDURE `film_not_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
    READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND NOT inventory_in_stock(inventory_id);

     SELECT FOUND_ROWS() INTO p_film_count;
END;

-- changeset ranan:1651234703995-36 splitStatements:false
CREATE PROCEDURE `rewards_report`(
    IN min_monthly_purchases TINYINT UNSIGNED
    , IN min_dollar_amount_purchased DECIMAL(10,2) UNSIGNED
    , OUT count_rewardees INT
)
    READS SQL DATA
    COMMENT 'Provides a customizable report on best customers'
proc: BEGIN

    DECLARE last_month_start DATE;
    DECLARE last_month_end DATE;

    /* Some sanity checks... */
    IF min_monthly_purchases = 0 THEN
        SELECT 'Minimum monthly purchases parameter must be > 0';
        LEAVE proc;
    END IF;
    IF min_dollar_amount_purchased = 0.00 THEN
        SELECT 'Minimum monthly dollar amount purchased parameter must be > $0.00';
        LEAVE proc;
    END IF;

    /* Determine start and end time periods */
    SET last_month_start = DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH);
    SET last_month_start = STR_TO_DATE(CONCAT(YEAR(last_month_start),'-',MONTH(last_month_start),'-01'),'%Y-%m-%d');
    SET last_month_end = LAST_DAY(last_month_start);

    /*
        Create a temporary storage area for
        Customer IDs.
    */
    CREATE TEMPORARY TABLE tmpCustomer (customer_id SMALLINT UNSIGNED NOT NULL PRIMARY KEY);

    /*
        Find all customers meeting the
        monthly purchase requirements
    */
    INSERT INTO tmpCustomer (customer_id)
    SELECT p.customer_id
    FROM payment AS p
    WHERE DATE(p.payment_date) BETWEEN last_month_start AND last_month_end
    GROUP BY customer_id
    HAVING SUM(p.amount) > min_dollar_amount_purchased
    AND COUNT(customer_id) > min_monthly_purchases;

    /* Populate OUT parameter with count of found customers */
    SELECT COUNT(*) FROM tmpCustomer INTO count_rewardees;

    /*
        Output ALL customer information of matching rewardees.
        Customize output as needed.
    */
    SELECT c.*
    FROM tmpCustomer AS t
    INNER JOIN customer AS c ON t.customer_id = c.customer_id;

    /* Clean up */
    DROP TABLE tmpCustomer;
END;

-- changeset ranan:1651234703995-37
CREATE INDEX fk_film_category_category ON film_category(category_id);

-- changeset ranan:1651234703995-38
CREATE INDEX fk_payment_rental ON payment(rental_id);

-- changeset ranan:1651234703995-39
CREATE INDEX idx_actor_last_name ON actor(last_name);

-- changeset ranan:1651234703995-40
CREATE INDEX idx_fk_address_id ON customer(address_id);

-- changeset ranan:1651234703995-41
CREATE INDEX idx_fk_address_id ON staff(address_id);

-- changeset ranan:1651234703995-42
CREATE INDEX idx_fk_address_id ON store(address_id);

-- changeset ranan:1651234703995-43
CREATE INDEX idx_fk_city_id ON address(city_id);

-- changeset ranan:1651234703995-44
CREATE INDEX idx_fk_country_id ON city(country_id);

-- changeset ranan:1651234703995-45
CREATE INDEX idx_fk_customer_id ON payment(customer_id);

-- changeset ranan:1651234703995-46
CREATE INDEX idx_fk_customer_id ON rental(customer_id);

-- changeset ranan:1651234703995-47
CREATE INDEX idx_fk_film_id ON film_actor(film_id);

-- changeset ranan:1651234703995-48
CREATE INDEX idx_fk_film_id ON inventory(film_id);

-- changeset ranan:1651234703995-49
CREATE INDEX idx_fk_inventory_id ON rental(inventory_id);

-- changeset ranan:1651234703995-50
CREATE INDEX idx_fk_language_id ON film(language_id);

-- changeset ranan:1651234703995-51
CREATE INDEX idx_fk_original_language_id ON film(original_language_id);

-- changeset ranan:1651234703995-52
CREATE INDEX idx_fk_staff_id ON payment(staff_id);

-- changeset ranan:1651234703995-53
CREATE INDEX idx_fk_staff_id ON rental(staff_id);

-- changeset ranan:1651234703995-54
CREATE INDEX idx_fk_store_id ON customer(store_id);

-- changeset ranan:1651234703995-55
CREATE INDEX idx_fk_store_id ON staff(store_id);

-- changeset ranan:1651234703995-56
CREATE INDEX idx_last_name ON customer(last_name);

-- changeset ranan:1651234703995-57
CREATE INDEX idx_location ON address(location);

-- changeset ranan:1651234703995-58
CREATE INDEX idx_store_id_film_id ON inventory(store_id, film_id);

-- changeset ranan:1651234703995-59
CREATE INDEX idx_title ON film(title);

-- changeset ranan:1651234703995-60
CREATE INDEX idx_title_description ON film_text(title, `description`);

-- changeset ranan:1651234703995-61
ALTER TABLE address ADD CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES city (city_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-62
ALTER TABLE city ADD CONSTRAINT fk_city_country FOREIGN KEY (country_id) REFERENCES country (country_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-63
ALTER TABLE customer ADD CONSTRAINT fk_customer_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-64
ALTER TABLE customer ADD CONSTRAINT fk_customer_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-65
ALTER TABLE film_actor ADD CONSTRAINT fk_film_actor_actor FOREIGN KEY (actor_id) REFERENCES actor (actor_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-66
ALTER TABLE film_actor ADD CONSTRAINT fk_film_actor_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-67
ALTER TABLE film_category ADD CONSTRAINT fk_film_category_category FOREIGN KEY (category_id) REFERENCES category (category_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-68
ALTER TABLE film_category ADD CONSTRAINT fk_film_category_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-69
ALTER TABLE film ADD CONSTRAINT fk_film_language FOREIGN KEY (language_id) REFERENCES language (language_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-70
ALTER TABLE film ADD CONSTRAINT fk_film_language_original FOREIGN KEY (original_language_id) REFERENCES language (language_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-71
ALTER TABLE inventory ADD CONSTRAINT fk_inventory_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-72
ALTER TABLE inventory ADD CONSTRAINT fk_inventory_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-73
ALTER TABLE payment ADD CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-74
ALTER TABLE payment ADD CONSTRAINT fk_payment_rental FOREIGN KEY (rental_id) REFERENCES rental (rental_id) ON UPDATE CASCADE ON DELETE SET NULL;

-- changeset ranan:1651234703995-75
ALTER TABLE payment ADD CONSTRAINT fk_payment_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-76
ALTER TABLE rental ADD CONSTRAINT fk_rental_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-77
ALTER TABLE rental ADD CONSTRAINT fk_rental_inventory FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-78
ALTER TABLE rental ADD CONSTRAINT fk_rental_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-79
ALTER TABLE staff ADD CONSTRAINT fk_staff_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-80
ALTER TABLE staff ADD CONSTRAINT fk_staff_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-81
ALTER TABLE store ADD CONSTRAINT fk_store_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- changeset ranan:1651234703995-82
ALTER TABLE store ADD CONSTRAINT fk_store_staff FOREIGN KEY (manager_staff_id) REFERENCES staff (staff_id) ON UPDATE CASCADE ON DELETE RESTRICT;

