/* =====================================================
   FILE: quan_ly_dao_tao_va_thu_ho.sql
   NỘI DUNG: TỔNG HỢP DDL + RÀNG BUỘC
===================================================== */

------------------------------------------------------
-- BÀI 1: SINH VIÊN – LỚP HỌC (QUAN HỆ 1 - N)
------------------------------------------------------

CREATE TABLE Class (
    class_id INT PRIMARY KEY,
    class_name VARCHAR(100) NOT NULL,
    school_year VARCHAR(20) NOT NULL
);

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    class_id INT NOT NULL,
    CONSTRAINT fk_student_class
        FOREIGN KEY (class_id)
        REFERENCES Class(class_id)
);

------------------------------------------------------
-- BÀI 2: SINH VIÊN – MÔN HỌC (UNIQUE, CHECK)
------------------------------------------------------

CREATE TABLE Subject (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    credit INT NOT NULL CHECK (credit > 0)
);

------------------------------------------------------
-- BÀI 3: ĐĂNG KÝ MÔN HỌC (QUAN HỆ N - N)
------------------------------------------------------

CREATE TABLE Enrollment (
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    enroll_date DATE NOT NULL,
    PRIMARY KEY (student_id, subject_id),
    CONSTRAINT fk_enroll_student
        FOREIGN KEY (student_id)
        REFERENCES Student(student_id),
    CONSTRAINT fk_enroll_subject
        FOREIGN KEY (subject_id)
        REFERENCES Subject(subject_id)
);

------------------------------------------------------
-- BÀI 4: GIẢNG VIÊN – MÔN HỌC (ALTER TABLE)
------------------------------------------------------

CREATE TABLE Teacher (
    teacher_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

ALTER TABLE Subject
ADD teacher_id INT;

ALTER TABLE Subject
ADD CONSTRAINT fk_subject_teacher
    FOREIGN KEY (teacher_id)
    REFERENCES Teacher(teacher_id);

------------------------------------------------------
-- BÀI 5: KẾT QUẢ HỌC TẬP (CHECK + PK PHÙ HỢP)
------------------------------------------------------

CREATE TABLE Score (
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    process_score DECIMAL(4,2) CHECK (process_score BETWEEN 0 AND 10),
    final_score DECIMAL(4,2) CHECK (final_score BETWEEN 0 AND 10),
    PRIMARY KEY (student_id, subject_id),
    CONSTRAINT fk_score_student
        FOREIGN KEY (student_id)
        REFERENCES Student(student_id),
    CONSTRAINT fk_score_subject
        FOREIGN KEY (subject_id)
        REFERENCES Subject(subject_id)
);

------------------------------------------------------
-- BÀI 6: TỔNG HỢP CSDL QUẢN LÝ ĐÀO TẠO
-- (ĐÃ BAO GỒM: Student, Class, Subject, Teacher,
-- Enrollment, Score)
------------------------------------------------------
-- Thiết kế đảm bảo:
-- - Không trùng dữ liệu (PK, UNIQUE)
-- - Quan hệ hợp lý (FK)
-- - Dễ mở rộng

------------------------------------------------------
-- BÀI 7: MODULE THU HỘ HỌC PHÍ – VPBANK
------------------------------------------------------

-- KHÁCH HÀNG
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    cccd VARCHAR(20) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE
);

-- ĐỐI TÁC
CREATE TABLE Partner (
    partner_id INT PRIMARY KEY,
    partner_name VARCHAR(100) NOT NULL UNIQUE
);

-- TÀI KHOẢN NGÂN HÀNG
CREATE TABLE Account (
    account_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    balance DECIMAL(15,2) NOT NULL CHECK (balance >= 0),
    CONSTRAINT fk_account_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id)
);

-- HÓA ĐƠN HỌC PHÍ
CREATE TABLE TuitionBill (
    bill_id INT PRIMARY KEY,
    partner_id INT NOT NULL,
    student_name VARCHAR(100) NOT NULL,
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    is_paid BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_bill_partner
        FOREIGN KEY (partner_id)
        REFERENCES Partner(partner_id)
);

-- GIAO DỊCH THANH TOÁN
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT NOT NULL,
    bill_id INT NOT NULL UNIQUE,
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    status VARCHAR(20) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_transaction_account
        FOREIGN KEY (account_id)
        REFERENCES Account(account_id),
    CONSTRAINT fk_transaction_bill
        FOREIGN KEY (bill_id)
        REFERENCES TuitionBill(bill_id)
);
