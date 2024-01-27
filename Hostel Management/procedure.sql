use hostelmanagement;
DELIMITER //
CREATE PROCEDURE update_meal_for_student(
    IN p_student_id INT,
    IN p_character CHAR(1)
)
BEGIN
    -- Declare variables to store the meal values
    DECLARE meal_value INT;

    -- Get the current date
    DECLARE current_date_value DATE;
    SET current_date_value = CURDATE();

    -- Determine the character and set the meal value accordingly
    CASE p_character
        WHEN 'B' THEN
            SELECT breakfast INTO meal_value
            FROM meal_rate
            WHERE meal_date = current_date_value;
        WHEN 'L' THEN
            SELECT lunch INTO meal_value
            FROM meal_rate
            WHERE meal_date = current_date_value;
        WHEN 'A' THEN
            SELECT after_snacks INTO meal_value
            FROM meal_rate
            WHERE meal_date = current_date_value;
        WHEN 'D' THEN
            SELECT dinner INTO meal_value
            FROM meal_rate
            WHERE meal_date = current_date_value;
    END CASE;

    -- Update the student_meal table
    UPDATE student_meal
    SET 
        breakfast = CASE WHEN p_character = 'B' THEN meal_value ELSE breakfast END,
        lunch = CASE WHEN p_character = 'L' THEN meal_value ELSE lunch END,
        after_snacks = CASE WHEN p_character = 'A' THEN meal_value ELSE after_snacks END,
        dinner = CASE WHEN p_character = 'D' THEN meal_value ELSE dinner END
    WHERE student_id = p_student_id AND meal_date = current_date_value;
END;
//
DELIMITER ;

