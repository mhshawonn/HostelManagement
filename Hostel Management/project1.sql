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

CREATE PROCEDURE InsertStudent(
    IN p_studentname VARCHAR(255),
    IN p_gender VARCHAR(10),
    IN p_dob DATE,
    IN p_contactnumber VARCHAR(15),
    IN p_email VARCHAR(255),
    IN p_bloodgroup VARCHAR(5)
)
BEGIN
    -- Inserting a record into the student table
    INSERT INTO student (studentname, gender, dob, contactnumber, email, bloodgroup)
    VALUES (p_studentname, p_gender, p_dob, p_contactnumber, p_email, p_bloodgroup);
END //

DELIMITER ;

CALL InsertStudent('John Doe', 'Male', '1995-03-15', '1234567890', 'john.doe@example.com', 'A+');
CALL InsertStudent('Jane Smith', 'Female', '1998-07-22', '9876543210', 'jane.smith@example.com', 'B-');
CALL InsertStudent('Bob Johnson', 'Male', '1997-01-10', '5555555555', 'bob.johnson@example.com', 'O+');
CALL InsertStudent('Alice Williams', 'Female', '1999-09-05', '1111111111', 'alice.williams@example.com', 'AB+');
CALL InsertStudent('Charlie Brown', 'Male', '1996-12-03', '9999999999', 'charlie.brown@example.com', 'A-');

select *from student;




