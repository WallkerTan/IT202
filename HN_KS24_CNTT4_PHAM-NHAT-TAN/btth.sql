CREATE DATABASE IF NOT EXISTS btth;
USE btth;

CREATE TABLE reader (
    reader_id int auto_increment primary key,
    reader_name VARCHAR(100) NOT NULL,
    phone VARCHAR(10) UNIQUE,
    register_date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE book (
    book_id int auto_increment primary key,
    book_title varchar(100) not null,
    author varchar(100) not null,
    publish_year int check(publish_year > 1000)
);

CREATE TABLE borrow(
    borrow_id int auto_increment primary key,
    reader_id int,
    book_id int,
    borrow_date date default (current_date),
    return_date date
);

ALTER TABLE reader ADD reader_email varchar(50) not null;

-- Fixed: Changed column length from 10 to a more reasonable size for author names
ALTER TABLE book
MODIFY author varchar(100) not null;

ALTER TABLE borrow
ADD CONSTRAINT chk_return_date
CHECK(return_date is null or return_date > borrow_date);

-- Fixed: Changed 'email' to 'reader_email' to match the column name
INSERT INTO reader(reader_name, phone, register_date, reader_email) values
('tan4', '1234567890', '2024-09-01', 'tan4@gmail.com'),
('tan1', '1234567891', '2024-09-01', 'tan1@gmail.com'),
('tan2', '1234567892', '2024-09-01', 'tan2@gmail.com');

INSERT INTO book (book_title, author, publish_year) VALUES
('Lập trình C căn bản', 'Nguyễn Văn A', 2018),
('Cơ sở dữ liệu', 'Trần Thị B', 2020),
('Lập trình Java', 'Lê Minh C', 2019),
('Hệ quản trị MySQL', 'Phạm Văn D', 2021);

INSERT INTO borrow (reader_id, book_id, borrow_date, return_date) values
(1, 1, '2024-09-01', '2024-09-05'),
(2, 2, '2024-09-01', '2024-09-05'),
(3, 3, '2024-09-01', '2024-09-05');

UPDATE borrow
SET return_date = '2024-10-01'
WHERE reader_id = 1;

UPDATE book
SET publish_year = '2023'
WHERE publish_year >= '2021';

DELETE FROM borrow
WHERE borrow_date < '2024-09-18';

-- Display all tables
SELECT * FROM reader;
SELECT * FROM book;
SELECT * FROM borrow;