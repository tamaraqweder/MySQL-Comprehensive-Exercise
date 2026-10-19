# University Database Project

## Step 1: Database Design

**Q1. Create the database and tables.**

```sql
CREATE DATABASE IF NOT EXISTS university_db;
USE university_db;

CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    date_of_birth DATE,
    gender VARCHAR(10),
    major VARCHAR(100),
    enrollment_year INT
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100),
    course_code VARCHAR(20),
    credits INT,
    department VARCHAR(100)
);

CREATE TABLE Instructors (
    instructor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    hire_date DATE,
    department VARCHAR(100)
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Course_Assignments (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    instructor_id INT,
    course_id INT,
    semester VARCHAR(20),
    year INT,
    FOREIGN KEY (instructor_id) REFERENCES Instructors(instructor_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
```

## Step 2: Insert Data

**Q2. Insert 10 students, 5 instructors, 5 courses, assign instructors, and enroll students in at least 2 courses each.**

```sql
INSERT INTO Students
(first_name, last_name, email, date_of_birth, gender, major, enrollment_year)
VALUES
('Ahmad','Ali','ahmad.ali@example.com','2003-05-12','Male','Computer Science',2022),
('Sara','Khaled','sara.khaled@example.com','2004-02-18','Female','Information Technology',2023),
('Omar','Hassan','omar.hassan@example.com','2002-11-25','Male','Software Engineering',2021),
('Lina','Mohammad','lina.mohammad@example.com','2003-07-09','Female','Computer Science',2022),
('Yousef','Ibrahim','yousef.ibrahim@example.com','2004-01-30','Male','Cybersecurity',2023),
('Noor','Sami','noor.sami@example.com','2003-09-14','Female','Information Technology',2022),
('Khaled','Nasser','khaled.nasser@example.com','2002-04-21','Male','Software Engineering',2021),
('Maya','Adel','maya.adel@example.com','2004-06-05','Female','Cybersecurity',2023),
('Zaid','Tareq','zaid.tareq@example.com','2003-12-17','Male','Computer Science',2022),
('Hala','Fadi','hala.fadi@example.com','2004-08-23','Female','Information Technology',2023);

INSERT INTO Instructors
(first_name, last_name, email, hire_date, department)
VALUES
('Khaled','Ahmad','khaled.ahmad@university.com','2020-02-10','Computer Science'),
('Mona','Ali','mona.ali@university.com','2021-06-15','Information Technology'),
('Omar','Hassan','omar.hassan@university.com','2019-09-01','Software Engineering'),
('Sara','Mohammad','sara.mohammad@university.com','2022-01-20','Cybersecurity'),
('Ahmad','Nasser','ahmad.nasser@university.com','2020-11-05','Computer Science');

INSERT INTO Courses
(course_name, course_code, credits, department)
VALUES
('Database Systems','CS101',3,'Computer Science'),
('Web Development','IT201',3,'Information Technology'),
('Software Engineering','SE301',4,'Software Engineering'),
('Cybersecurity Basics','CY101',3,'Cybersecurity'),
('Programming Fundamentals','CS102',3,'Computer Science');

INSERT INTO Course_Assignments
(instructor_id, course_id, semester, year)
VALUES
(1,1,'Fall',2026),
(2,2,'Fall',2026),
(3,3,'Fall',2026),
(4,4,'Fall',2026),
(5,5,'Fall',2026);

INSERT INTO Enrollments (student_id, course_id, grade)
VALUES
(1,1,'A'),(2,2,'B'),(3,3,'A'),(4,4,'B'),(5,5,'A'),
(6,1,'B'),(7,2,'A'),(8,3,'B'),(9,4,'A'),(10,5,'B'),
(1,2,'B'),(2,3,'A'),(3,4,'B'),(4,5,'A'),(5,1,'B'),
(6,3,'A'),(7,4,'B'),(8,5,'A'),(9,1,'B'),(10,2,'A');
```

## Step 3: Basic Queries

**Q1. List all students.**

```sql
SELECT * FROM Students;
```

**Q2. Count all courses.**

```sql
SELECT COUNT(*) AS total_courses
FROM Courses;
```

**Q3. Find students enrolled in Database Systems.**

```sql
SELECT Students.first_name, Students.last_name
FROM Students
INNER JOIN Enrollments
ON Students.student_id = Enrollments.student_id
INNER JOIN Courses
ON Enrollments.course_id = Courses.course_id
WHERE Courses.course_name = 'Database Systems';
```

**Q4. Find instructor emails in Cybersecurity.**

```sql
SELECT email
FROM Instructors
WHERE department = 'Cybersecurity';
```

## Step 4: Intermediate Queries

**Q5. Count students enrolled in each course.**

```sql
SELECT Courses.course_name,
       COUNT(Enrollments.student_id) AS total_students
FROM Courses
LEFT JOIN Enrollments
ON Courses.course_id = Enrollments.course_id
GROUP BY Courses.course_id, Courses.course_name;
```

**Q6. Find students who received grade A.**

```sql
SELECT DISTINCT Students.first_name, Students.last_name
FROM Students
INNER JOIN Enrollments
ON Students.student_id = Enrollments.student_id
WHERE Enrollments.grade = 'A';
```

**Q7. Display courses and instructors for Fall 2026.**

```sql
SELECT Courses.course_name,
       Instructors.first_name,
       Instructors.last_name
FROM Course_Assignments
INNER JOIN Courses
ON Course_Assignments.course_id = Courses.course_id
INNER JOIN Instructors
ON Course_Assignments.instructor_id = Instructors.instructor_id
WHERE Course_Assignments.semester = 'Fall'
AND Course_Assignments.year = 2026;
```

**Q8. Calculate the average grade for Database Systems.**

```sql
SELECT Courses.course_name,
       AVG(
           CASE Enrollments.grade
               WHEN 'A' THEN 4
               WHEN 'B' THEN 3
               WHEN 'C' THEN 2
               WHEN 'D' THEN 1
               WHEN 'F' THEN 0
           END
       ) AS average_grade
FROM Courses
INNER JOIN Enrollments
ON Courses.course_id = Enrollments.course_id
WHERE Courses.course_name = 'Database Systems'
GROUP BY Courses.course_id, Courses.course_name;
```

## Advanced Queries

**Q9. Find students taking more than 3 courses in Fall 2026.**

```sql
SELECT Students.student_id,
       Students.first_name,
       Students.last_name,
       COUNT(DISTINCT Enrollments.course_id) AS total_courses
FROM Students
INNER JOIN Enrollments
ON Students.student_id = Enrollments.student_id
INNER JOIN Course_Assignments
ON Enrollments.course_id = Course_Assignments.course_id
WHERE Course_Assignments.semester = 'Fall'
AND Course_Assignments.year = 2026
GROUP BY Students.student_id, Students.first_name, Students.last_name
HAVING COUNT(DISTINCT Enrollments.course_id) > 3;
```

**Q10. Find students with incomplete grades.**

```sql
SELECT Students.first_name, Students.last_name,
       Courses.course_name, Enrollments.grade
FROM Students
INNER JOIN Enrollments
ON Students.student_id = Enrollments.student_id
INNER JOIN Courses
ON Enrollments.course_id = Courses.course_id
WHERE Enrollments.grade IS NULL;
```

**Q11. Find the student with the highest average grade.**

```sql
SELECT Students.student_id,
       Students.first_name,
       Students.last_name,
       AVG(
           CASE Enrollments.grade
               WHEN 'A' THEN 4
               WHEN 'B' THEN 3
               WHEN 'C' THEN 2
               WHEN 'D' THEN 1
               WHEN 'F' THEN 0
           END
       ) AS average_grade
FROM Students
INNER JOIN Enrollments
ON Students.student_id = Enrollments.student_id
GROUP BY Students.student_id, Students.first_name, Students.last_name
ORDER BY average_grade DESC
LIMIT 1;
```

**Q12. Find the department teaching the most courses in 2026.**

```sql
SELECT Courses.department,
       COUNT(DISTINCT Courses.course_id) AS total_courses
FROM Courses
INNER JOIN Course_Assignments
ON Courses.course_id = Course_Assignments.course_id
WHERE Course_Assignments.year = 2026
GROUP BY Courses.department
ORDER BY total_courses DESC
LIMIT 1;
```

**Q13. Find courses without student enrollments.**

```sql
SELECT Courses.course_id, Courses.course_name
FROM Courses
LEFT JOIN Enrollments
ON Courses.course_id = Enrollments.course_id
WHERE Enrollments.enrollment_id IS NULL;
```

## Step 4: Functions and Aggregates

**Q1. Create a function to calculate student age.**

```sql
DELIMITER //

CREATE FUNCTION CalculateAge(student_birth_date DATE)
RETURNS INT
NOT DETERMINISTIC
NO SQL
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, student_birth_date, CURDATE());
END //

DELIMITER ;

SELECT first_name, last_name,
       CalculateAge(date_of_birth) AS age
FROM Students;
```

**Q2. Create a procedure to enroll a student.**

```sql
DELIMITER //

CREATE PROCEDURE EnrollStudent(
    IN input_student_id INT,
    IN input_course_id INT
)
BEGIN
    INSERT INTO Enrollments (student_id, course_id, grade)
    VALUES (input_student_id, input_course_id, NULL);
END //

DELIMITER ;

CALL EnrollStudent(1, 3);
```

**Q3. Calculate average grades by department.**

```sql
SELECT Courses.department,
       AVG(
           CASE Enrollments.grade
               WHEN 'A' THEN 4
               WHEN 'B' THEN 3
               WHEN 'C' THEN 2
               WHEN 'D' THEN 1
               WHEN 'F' THEN 0
           END
       ) AS average_grade
FROM Courses
INNER JOIN Enrollments
ON Courses.course_id = Enrollments.course_id
GROUP BY Courses.department;
```

## Step 5: Constraints and Transactions

**Q1. Ensure student emails are unique.**

```sql
ALTER TABLE Students
ADD CONSTRAINT unique_student_email UNIQUE (email);
```

**Q2. Enroll a student if course capacity is not exceeded.**

```sql
ALTER TABLE Courses
ADD COLUMN capacity INT NOT NULL DEFAULT 30;

DELIMITER //

CREATE PROCEDURE EnrollStudentWithCapacity(
    IN input_student_id INT,
    IN input_course_id INT
)
BEGIN
    DECLARE course_capacity INT;
    DECLARE enrolled_count INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT capacity INTO course_capacity
    FROM Courses
    WHERE course_id = input_course_id
    FOR UPDATE;

    SELECT COUNT(*) INTO enrolled_count
    FROM Enrollments
    WHERE course_id = input_course_id;

    IF enrolled_count < course_capacity THEN
        INSERT INTO Enrollments (student_id, course_id, grade)
        VALUES (input_student_id, input_course_id, NULL);

        COMMIT;
    ELSE
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Course capacity exceeded';
    END IF;
END //

DELIMITER ;

CALL EnrollStudentWithCapacity(1, 3);
```

## Step 6: Optimization and Indexes

**Q1. Create an index on course_code.**

```sql
CREATE INDEX index_course_code
ON Courses(course_code);
```

**Q2. Use EXPLAIN to analyze a student enrollment query.**

```sql
EXPLAIN
SELECT Students.first_name, Students.last_name
FROM Students
INNER JOIN Enrollments
ON Students.student_id = Enrollments.student_id
WHERE Enrollments.course_id = 1;
```

## Step 7: Joins

**Q1. INNER JOIN: Students and courses.**


SELECT Students.first_name, Students.last_name,
       Courses.course_name
FROM Students
INNER JOIN Enrollments
ON Students.student_id = Enrollments.student_id
INNER JOIN Courses
ON Enrollments.course_id = Courses.course_id;


**Q2. LEFT JOIN: Instructors and their courses.**


SELECT Instructors.first_name, Instructors.last_name,
       Courses.course_name
FROM Instructors
LEFT JOIN Course_Assignments
ON Instructors.instructor_id = Course_Assignments.instructor_id
LEFT JOIN Courses
ON Course_Assignments.course_id = Courses.course_id;


**Q3. UNION: List all students and instructors.**


SELECT first_name, last_name, email,
       'Student' AS person_type
FROM Students

UNION

SELECT first_name, last_name, email,
       'Instructor' AS person_type
FROM Instructors;


## Step 8: Final Challenge

**Q1. Generate a report with student details, courses, instructors, grades, and total credits.**

```sql
SELECT Students.first_name,
       Students.last_name,
       Students.email,
       Students.major,
       Courses.course_name,
       Instructors.first_name AS instructor_first_name,
       Instructors.last_name AS instructor_last_name,
       Enrollments.grade,
       Courses.credits,
       SUM(COALESCE(Courses.credits, 0)) OVER (
           PARTITION BY Students.student_id
       ) AS total_credits
FROM Students
LEFT JOIN Enrollments
ON Students.student_id = Enrollments.student_id
LEFT JOIN Courses
ON Enrollments.course_id = Courses.course_id
LEFT JOIN Course_Assignments
ON Courses.course_id = Course_Assignments.course_id
AND Course_Assignments.semester = 'Fall'
AND Course_Assignments.year = 2026
LEFT JOIN Instructors
ON Course_Assignments.instructor_id = Instructors.instructor_id
ORDER BY Students.student_id, Courses.course_name;

