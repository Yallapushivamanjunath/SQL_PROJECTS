create database school;
use school;
CREATE TABLE Students (
student_id INT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
enrollment_year INT
);

CREATE TABLE Subjects (
subject_id INT PRIMARY KEY,
subject_name VARCHAR(50)
);

CREATE TABLE Exams (
exam_id INT PRIMARY KEY,
exam_name VARCHAR(50),
exam_date DATE
);

CREATE TABLE Marks (
mark_id INT PRIMARY KEY,
student_id INT,
subject_id INT,
exam_id INT,
score INT,
FOREIGN KEY (student_id) REFERENCES Students(student_id),
FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id),
FOREIGN KEY (exam_id) REFERENCES Exams(exam_id)
);

INSERT INTO Students VALUES
(1, 'Aarav', 'Sharma', 2023),
(2, 'Diya', 'Patel', 2023),
(3, 'Vihaan', 'Rao', 2024),
(4, 'Ananya', 'Singh', 2024);

INSERT INTO Subjects VALUES
(101, 'Mathematics'),
(102, 'Science'),
(103, 'Hindi Literature');

INSERT INTO Exams VALUES
(1, 'Half-Yearly 2024', '2024-09-15'),
(2, 'Final Annual 2024', '2024-03-20');

INSERT INTO Marks VALUES
(1, 1, 101, 1, 85), -- Aarav, Math, Half-Yearly
(2, 1, 102, 1, 90), -- Aarav, Science, Half-Yearly
(3, 2, 101, 1, 75), -- Diya, Math, Half-Yearly
(4, 2, 102, 1, 60), -- Diya, Science, Half-Yearly
(5, 3, 101, 1, 95), -- Vihaan, Math, Half-Yearly
(6, 1, 101, 2, 88), -- Aarav, Math, Final
(7, 2, 101, 2, 79), -- Diya, Math, Final
(8, 3, 101, 2, 92); -- Vihaan, Math, Final

SELECT first_name, last_name FROM Students;
SELECT * FROM Marks WHERE score > 80;
SELECT * FROM Exams ORDER BY exam_date DESC;

SELECT s.first_name,
       sub.subject_name,
       m.score
FROM Marks m
JOIN Students s
    ON m.student_id = s.student_id
JOIN Subjects sub
    ON m.subject_id = sub.subject_id;
    
SELECT sub.subject_name,
       AVG(m.score) AS average_score
FROM Marks m
JOIN Subjects sub
    ON m.subject_id = sub.subject_id
GROUP BY sub.subject_name;

SELECT COUNT(*) AS total_marks_recorded
FROM Marks m
JOIN Students s
    ON m.student_id = s.student_id
WHERE s.first_name = 'Aarav'
  AND s.last_name = 'Sharma';
  
SELECT s.first_name,
       s.last_name,
       m.score
FROM Marks m
JOIN Students s
    ON m.student_id = s.student_id
WHERE m.score = (
    SELECT MAX(score)
    FROM Marks
);

SELECT e.exam_name,
	SUM(m.score) AS total_score
FROM Marks m
JOIN Exams e
    ON m.exam_id = e.exam_id
GROUP BY e.exam_name
HAVING SUM(m.score) > 250;

SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name,
	sub.subject_name,
	m.score,
	CASE
	WHEN m.score >= 70 THEN 'Pass'
	ELSE 'Fail'
	END AS status
FROM Marks m
JOIN Students s
    ON m.student_id = s.student_id
JOIN Subjects sub
    ON m.subject_id = sub.subject_id;
