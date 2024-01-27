use hostelmanagement;
-- pay bill on selective month
DELIMITER //

CREATE PROCEDURE get_students_paid_for_month(IN p_month VARCHAR(7))
BEGIN
    SELECT s.studentid, s.studentname
    FROM student s
    INNER JOIN student_billing sb ON s.studentid = sb.student_id
    WHERE sb.bill_month = p_month AND sb.pay_status = 'Paid';
END;

//

DELIMITER ;

CALL get_students_paid_for_month('2024-01');

-- student billing details
DELIMITER //
CREATE PROCEDURE get_student_billing_details(IN p_student_id INT, IN p_month VARCHAR(7))
BEGIN
    SELECT sb.bill_month, sb.meal_bill, sb.house_rent, sb.other, sb.pay_status
    FROM student_billing sb
    WHERE sb.student_id = p_student_id AND sb.bill_month = p_month;
END;
//
DELIMITER ;

CALL get_student_billing_details(20240001, '2024-02');


-- student all details
DELIMITER //
CREATE PROCEDURE get_student_information(IN p_student_id INT)
BEGIN
    SELECT
        s.studentname,
        s.gender,
        s.dob,
        s.contactnumber,
        s.email,
        s.bloodgroup,
        g.guardian_name,
        g.contact_number AS guardian_contact,
        g.relationship,
        si.institution_name,
        si.institutional_guardian,
        si.guardian_contact AS institutional_guardian_contact,
        si.guardian_post
    FROM
        student s
    LEFT JOIN guardian g ON s.studentid = g.student_id
    LEFT JOIN student_institution si ON s.studentid = si.student_id
    WHERE
        s.studentid = p_student_id;
END;
//
DELIMITER ;

CALL get_student_information(20240001);



-- available room
DELIMITER //
CREATE PROCEDURE find_available_rooms(
    IN p_gender VARCHAR(10),
    IN p_capacity INT
)
BEGIN
    SELECT
        r.room_number,
        r.floor_number,
        r.capacity - r.occupancy_status AS available_capacity
    FROM
        room_number r
    WHERE
        r.occupancy_status < r.capacity
        AND r.room_number NOT IN (
            SELECT a.room_number
            FROM allocation a
            WHERE a.check_out_date IS NULL
        );
END;
//
DELIMITER ;

CALL find_available_rooms('Male', 2);

-- employee salary

DELIMITER //
CREATE PROCEDURE find_employees_without_salary()
BEGIN
    SELECT
        e.employee_id,
        e.name
    FROM
        employee e
    LEFT JOIN
        employee_salary es ON e.employee_id = es.employee_id
    WHERE
        es.employee_id IS NULL;
END;
//
DELIMITER ;
CALL find_employees_without_salary();


-- employee all details


DELIMITER //
CREATE PROCEDURE get_employee_details(
    IN p_employee_id INT
)
BEGIN
    SELECT *
    FROM employee
    WHERE employee_id = p_employee_id;
END;
//
DELIMITER ;

CALL get_employee_details(6); 

DELIMITER //
CREATE PROCEDURE get_all_employee_details_with_salary()
BEGIN
    SELECT e.*, mb.bill_id, mb.bill_date, es.salary_amount, es.pay_date
    FROM employee e
    LEFT JOIN make_bill mb ON e.employee_id = mb.employee_id
    LEFT JOIN employee_salary es ON e.employee_id = es.employee_id;
END;
//
DELIMITER ;



CALL get_employee_details_with_salary(6);




-- student meal details on specific month
DELIMITER //
CREATE PROCEDURE get_student_monthly_meals(
    IN p_student_id INT,
    IN p_month VARCHAR(7)
)
BEGIN
    DECLARE total_meals INT;
    DECLARE breakfast_count INT;
    DECLARE lunch_count INT;
    DECLARE after_snacks_count INT;
    DECLARE dinner_count INT;

    -- Get the counts for each type of meal
    SELECT COALESCE(SUM(breakfast), 0) INTO breakfast_count
    FROM student_meal
    WHERE student_id = p_student_id AND DATE_FORMAT(meal_date, '%Y-%m') = p_month;

    SELECT COALESCE(SUM(lunch), 0) INTO lunch_count
    FROM student_meal
    WHERE student_id = p_student_id AND DATE_FORMAT(meal_date, '%Y-%m') = p_month;

    SELECT COALESCE(SUM(after_snacks), 0) INTO after_snacks_count
    FROM student_meal
    WHERE student_id = p_student_id AND DATE_FORMAT(meal_date, '%Y-%m') = p_month;

    SELECT COALESCE(SUM(dinner), 0) INTO dinner_count
    FROM student_meal
    WHERE student_id = p_student_id AND DATE_FORMAT(meal_date, '%Y-%m') = p_month;

    -- Calculate the total number of meals
    SET total_meals = breakfast_count + lunch_count + after_snacks_count + dinner_count;

    -- Display the results
    SELECT
        'Total Meals' AS meal_type,
        total_meals AS meal_count
    UNION
    SELECT
        'Breakfast' AS meal_type,
        breakfast_count AS meal_count
    UNION
    SELECT
        'Lunch' AS meal_type,
        lunch_count AS meal_count
    UNION
    SELECT
        'After Snacks' AS meal_type,
        after_snacks_count AS meal_count
    UNION
    SELECT
        'Dinner' AS meal_type,
        dinner_count AS meal_count;
END;
//
DELIMITER ;


CALL get_student_monthly_meals(20240001, '2024-01');


-- set meal rate
DELIMITER //
CREATE PROCEDURE set_meal_rate(
    IN p_meal_date DATE,
    IN p_breakfast_rate INT,
    IN p_lunch_rate INT,
    IN p_after_snacks_rate INT,
    IN p_dinner_rate INT
)
BEGIN
    -- Attempt to insert new record
    DECLARE duplicate_key INT DEFAULT 0;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        SET duplicate_key = 1;

    -- Try inserting a new record
    INSERT INTO meal_rate (meal_date, breakfast, lunch, after_snacks, dinner)
    VALUES (p_meal_date, p_breakfast_rate, p_lunch_rate, p_after_snacks_rate, p_dinner_rate);

    -- If duplicate key error occurs, update the existing record
    IF duplicate_key THEN
        UPDATE meal_rate
        SET
            breakfast = p_breakfast_rate,
            lunch = p_lunch_rate,
            after_snacks = p_after_snacks_rate,
            dinner = p_dinner_rate
        WHERE meal_date = p_meal_date;
    END IF;
END;
//
DELIMITER ;



CALL set_meal_rate('2024-02-12', 30, 60, 40, 70);


-- those student not paid on month
DELIMITER //

CREATE PROCEDURE get_students_not_paid_for_month(IN p_month VARCHAR(7))
BEGIN
    SELECT s.studentid, s.studentname
    FROM student s
    WHERE NOT EXISTS (
        SELECT 1
        FROM student_billing sb
        WHERE s.studentid = sb.student_id AND sb.bill_month = p_month AND sb.pay_status = 'Paid'
    );
END;

//

DELIMITER ;

CALL get_students_not_paid_for_month('2024-01');



