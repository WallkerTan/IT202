CREATE DATABASE session03;
USE session03;

-- cau 1
CREATE TABLE student (
	student_id int primary key auto_increment,
    full_name varchar(50) not null,
    date_of_birth date,
    email varchar(50) not null,
    unique(email)
);

-- them sinh vien 
INSERT INTO student (full_name, date_of_birth, email) VALUES
('Nguyen Van An', '2004-05-12', 'an.nguyen@gmail.com'),
('Tran Thi Binh', '2003-11-20', 'binh.tran@gmail.com'),
('Pham Nhat Tan', '2004-01-15', 'tan.pham@gmail.com');

-- lấy toàn bộ danh sách sinh viên
SELECT * FROM session03.student;


-- lấy name , id
SELECT student_id,full_name  FROM student; 


-- cau 2
UPDATE student
SET email = "tandz@gmail.com"
where student_id = 3;

UPDATE student
SET date_of_birth = '2006-01-22'
where student_id = 2;

DElETE FROM student
where student_id = 1;


SELECT * FROM session03.student;

-- cau 3

CREATE TABLE subjects (
	subject_id int auto_increment primary key,
    subject_name varchar(100) not null unique,
	credit int check(credit > 0)
);

INSERT INTO subjects (subject_name, credit) VALUES
('Cơ sở dữ liệu', 3),
('Lập trình C', 4),
('Cấu trúc dữ liệu và giải thuật', 3);

UPDATE subjects
set credit = 5
where subject_id = 1;

UPDATE subjects
set subject_name = 'hoc tai thi phan'
where subject_id = 2;


SELECT * FROM session03.subjects;
 
-- cau 4

CREATE TABLE enrollment (
	enrollment_id int auto_increment primary key,
    student_id int,
    subject_id int,
    enroll_date DATE,
    foreign key (student_id) references student(student_id),
    foreign key (subject_id) references subject(subject_id),
    unique(student_id,subject_id,enroll_date)
);



INSERT INTO enrrollment(student_id,subject_id) values
(1,1,'2006-01-22'),
(2,2,'2006-01-22');


select * from session03.enrrollment;
select enrollment_id from enrollment where student_id = 1;

-- cau5
CREATE TABLE score (
    student_id INT,
    subject_id INT,
    mid_score FLOAT CHECK (mid_score BETWEEN 0 AND 10),
    final_score FLOAT CHECK (final_score BETWEEN 0 AND 10),

    -- mỗi sinh viên chỉ có 1 bảng điểm cho mỗi môn
    PRIMARY KEY (student_id, subject_id),

    -- khóa ngoại
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);
INSERT INTO score (student_id, subject_id, mid_score, final_score) VALUES
(1, 1, 7.5, 8.0),
(2, 1, 6.0, 7.5);
UPDATE score
SET final_score = 9.0
WHERE student_id = 1 AND subject_id = 1;
SELECT *
FROM score;
SELECT *
FROM score
WHERE final_score >= 8;

    