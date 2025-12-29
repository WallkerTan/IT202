CREATE 	DATABASE manager;
USE manager;

CREATE TABLE student (
	st_msv INT AUTO_INCREMENT primary key,
    st_name VARCHAR(50) NOT NULL,    
	st_dob DATE NOT NULL
);

CREATE TABLE subjects (
	sj_id INT auto_increment PRIMARY KEY,
    sj_name VARCHAR(100) UNIQUE NOT NULL,
    sj_credit INT CHECK(sj_credit > 0)
);

CREATE TABLE enrollment (
	er_id INT AUTO_INCREMENT primary key,
    enroll_date DATE,
    sj_id INT,
	st_msv INT,
    foreign key (st_msv) references student(st_msv),
    foreign key (sj_id) references subjects(sj_id),
    unique (st_msv,sj_id)
);

CREATE TABLE score (
	sc_id int auto_increment primary key,
    sc_Score DECIMAL(4,2) check(sc_score between 0 and 10),
    er_id INT not null,
    foreign key (er_id) references enrollment(er_id)
);


-- thêm sinh viên
select * from manager.student;
INSERT INTO student (st_name, st_dob) VALUES
('tan', '2006-01-22'),
('huyen', '2006-01-23');

-- tạo môn học

select * from manager.subjects;
INSERT INTO subjects(sj_name,sj_credit) values
('math',3),
('physics',4);


-- dang ki mon hoc
select * from manager.enrollment;
INSERT INTO enrollment(enroll_date,sj_id,st_msv) values
('2006-01-22',1,1),
('2006-01-22',2,2);

-- them diem
select * from manager.score;
insert into score(sc_Score,er_id) values
(8,1),
(9,2);

UPDATE score
SET sc_Score = 9
WHERE er_id = 1;

DELETE FROM student WHERE st_msv = 1;
