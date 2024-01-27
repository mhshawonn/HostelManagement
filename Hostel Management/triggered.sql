use hostelmanagement;
DELIMITER //
CREATE TRIGGER before_insert_student
BEFORE INSERT ON student
FOR EACH ROW
BEGIN
    SET NEW.studentid = CONCAT(YEAR(CURDATE()), LPAD((SELECT IFNULL(MAX(CAST(SUBSTRING(studentid, 5) AS UNSIGNED)), 0) + 1 FROM student WHERE studentid LIKE CONCAT(YEAR(CURDATE()), '%')), 4, '0'));
END;
//
DELIMITER ;


DELIMITER //
CREATE TRIGGER insert_student_meal_for_today
AFTER INSERT ON meal_rate
FOR EACH ROW
BEGIN
    -- Insert meal records for all studentids with the current date
    INSERT INTO student_meal (student_id, meal_date)
    SELECT studentid, NEW.meal_date
    FROM student;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER set_current_date_meal_rate
BEFORE INSERT ON meal_rate
FOR EACH ROW
BEGIN
    -- Set meal_date to the current date
    SET NEW.meal_date = CURDATE();
END;
//
DELIMITER ;


DELIMITER //
CREATE TRIGGER before_insert_student_meal
BEFORE INSERT ON student_meal
FOR EACH ROW
BEGIN
    -- Set default values for meal columns if not provided
    IF NEW.breakfast IS NULL THEN
        SET NEW.breakfast = 0;
    END IF;

    IF NEW.lunch IS NULL THEN
        SET NEW.lunch = 0;
    END IF;

    IF NEW.after_snacks IS NULL THEN
        SET NEW.after_snacks = 0;
    END IF;

    IF NEW.dinner IS NULL THEN
        SET NEW.dinner = 0;
    END IF;
END;
//
DELIMITER ;

DELIMITER $$
CREATE TRIGGER before_insert_allocation
BEFORE INSERT ON allocation
FOR EACH ROW
BEGIN
    DECLARE current_occupancy INT;
    DECLARE room_capacity INT;

    SELECT occupancy_status, capacity
    INTO current_occupancy, room_capacity
    FROM room_number
    WHERE room_number.room_number = NEW.room_number;

    IF current_occupancy + 1 > room_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Room is at full capacity. Cannot make a new allocation.';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER after_insert_allocation
AFTER INSERT ON allocation
FOR EACH ROW
BEGIN
    UPDATE room_number
    SET occupancy_status = occupancy_status + 1
    WHERE room_number.room_number = NEW.room_number;
END $$
DELIMITER ;



DELIMITER //
CREATE TRIGGER set_bill_id_and_date
BEFORE INSERT ON make_bill
FOR EACH ROW
BEGIN
    -- Set bill_id as current year and month (YYYY-MM)
    SET NEW.bill_id = CONCAT(YEAR(CURDATE()), '-', LPAD(MONTH(CURDATE()), 2, '0'));

    -- Set bill_date as current date
    SET NEW.bill_date = CURDATE();
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER insert_student_billing_after_make_bill
AFTER INSERT ON make_bill
FOR EACH ROW
BEGIN
    -- Insert records into student_billing for all studentids
    INSERT INTO student_billing (student_id, bill_month)
    SELECT studentid, LEFT(NEW.bill_id, 7)
    FROM student;
END;
//
DELIMITER ;

