use hostelmanagement;

CREATE TABLE student (
    studentid INT PRIMARY KEY,
    studentname VARCHAR(255) NOT NULL,
    gender VARCHAR(10),
    dob DATE,
    contactnumber VARCHAR(15),
    email VARCHAR(255),
    bloodgroup VARCHAR(5)
);


CREATE TABLE student_meal (
    student_id INT,
    meal_date DATE,
    breakfast INT,
    lunch INT,
    after_snacks INT,
    dinner INT,
    PRIMARY KEY (student_id, meal_date),
    FOREIGN KEY (student_id) REFERENCES student(studentid)
);


CREATE TABLE meal_rate (
    meal_date DATE PRIMARY KEY,
    breakfast INT DEFAULT 0,
    lunch INT DEFAULT 0,
    after_snacks INT DEFAULT 0,
    dinner INT DEFAULT 0
);


CREATE TABLE room_number (
    room_number INT PRIMARY KEY,
    floor_number INT,
    capacity INT,
    occupancy_status INT default 0
);

CREATE TABLE allocation (
    student_id INT,
    room_number INT,
    check_in_date DATE,
    check_out_date DATE,
    PRIMARY KEY (student_id, room_number),
    FOREIGN KEY (student_id) REFERENCES student(studentid),
    FOREIGN KEY (room_number) REFERENCES room_number(room_number)
);

CREATE TABLE guardian (
    student_id INT PRIMARY KEY,
    guardian_name VARCHAR(255),
    contact_number VARCHAR(15),
    relationship VARCHAR(255),
    FOREIGN KEY (student_id) REFERENCES student(studentid)
);

CREATE TABLE student_institution (
    student_id INT PRIMARY KEY,
    institution_name VARCHAR(255),
    institutional_guardian VARCHAR(255),
    guardian_contact VARCHAR(15),
    guardian_post VARCHAR(50),
    FOREIGN KEY (student_id) REFERENCES student(studentid)
);




CREATE TABLE student_billing (
    student_id INT,
    bill_month VARCHAR(7),
    meal_bill INT,
    house_rent INT DEFAULT 3000,
    other INT DEFAULT 4000,
    pay_status VARCHAR(50),
    PRIMARY KEY (student_id, bill_month),
    FOREIGN KEY (student_id) REFERENCES student(studentid)
);
CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    name VARCHAR(255),
    contact VARCHAR(15),
    position VARCHAR(255)
);
CREATE TABLE make_bill (
    bill_id VARCHAR(7) PRIMARY KEY,
    employee_id INT,
    bill_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TABLE employee_salary (
    employee_id INT,
    month DATE,
    salary_amount DECIMAL(10, 2),
    pay_date DATE,
    PRIMARY KEY (employee_id, month),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);