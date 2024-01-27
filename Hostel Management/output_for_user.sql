use hostelmanagement;
-- student pay bill on selective month
CALL get_students_paid_for_month('2024-01');

-- those student not pay bill on selective month
CALL get_students_not_paid_for_month('2024-01');

-- student billing details using StudentId
CALL get_student_billing_details(20240001, '2024-02');

-- student all details using StudentID
CALL get_student_information(20240001);

-- available room
CALL find_available_rooms('Male', 2);

-- find employee who didnot get salary
CALL find_employees_without_salary();

-- employe details
CALL get_employee_details(6); 
-- employe details with salary 
CALL get_employee_details_with_salary(6);

-- student meal details on specific month
CALL get_student_monthly_meals(20240001, '2024-01');


