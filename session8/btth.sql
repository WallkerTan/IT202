CREATE DATABASE mini_project_ss08;
USE mini_project_ss08;

-- Xóa bảng nếu đã tồn tại (để chạy lại nhiều lần)
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS guests;

-- Bảng khách hàng
CREATE TABLE guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_name VARCHAR(100),
    phone VARCHAR(20)
);

-- Bảng phòng
CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_type VARCHAR(50),
    price_per_day DECIMAL(10,0)
);

-- Bảng đặt phòng
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

INSERT INTO guests (guest_name, phone) VALUES
('Nguyễn Văn An', '0901111111'),
('Trần Thị Bình', '0902222222'),
('Lê Văn Cường', '0903333333'),
('Phạm Thị Dung', '0904444444'),
('Hoàng Văn Em', '0905555555');

INSERT INTO rooms (room_type, price_per_day) VALUES
('Standard', 500000),
('Standard', 500000),
('Deluxe', 800000),
('Deluxe', 800000),
('VIP', 1500000),
('VIP', 2000000);

INSERT INTO bookings (guest_id, room_id, check_in, check_out) VALUES
(1, 1, '2024-01-10', '2024-01-12'), -- 2 ngày
(1, 3, '2024-03-05', '2024-03-10'), -- 5 ngày
(2, 2, '2024-02-01', '2024-02-03'), -- 2 ngày
(2, 5, '2024-04-15', '2024-04-18'), -- 3 ngày
(3, 4, '2023-12-20', '2023-12-25'), -- 5 ngày
(3, 6, '2024-05-01', '2024-05-06'), -- 5 ngày
(4, 1, '2024-06-10', '2024-06-11'); -- 1 ngày


-- lấy số khách hàng
select * from mini_project_ss08.guests;
select * from mini_project_ss08.rooms;
select * from mini_project_ss08.bookings;


-- lấy danh sách các loại phòng khác nhau , khác giá được tính là 2 phòng khác đẳng cấp
select 
    r.room_type,
    count(r.room_type) as so_luong_phong
    from rooms r
	group by r.room_type,r.price_per_day;
    

-- lấy danh sách các loại phòng khác nhau và giá thuê theo ngày
select 
    r.room_type,
    r.price_per_day,
    count(r.room_type) as so_luong_phong
    from rooms r
	group by r.room_type,r.price_per_day
    order by r.price_per_day desc;
    

-- lấy danh sách các loại phòng khác nhau và giá thuê theo ngày giá trị hơn 1.000.000 vnd
select 
    r.room_type,
    r.price_per_day,
    count(r.room_type) as so_luong_phong
    from rooms r
	group by r.room_type,r.price_per_day
    having r.price_per_day > 1000000
    order by r.price_per_day desc;
    
-- liệt kê các lần đặt phòng diễn ra trong 2024
select
	b.booking_id,
    g.guest_name,
    b.check_in,
    b.check_out
from bookings b
left join guests g on g.guest_id = b.guest_id
    having b.check_in >= '2024-01-01'
    order by b.check_in;


-- số lượng phòng từng phòng

select 
    r.room_type,
    count(r.room_type) as so_luong_phong
    from rooms r
	group by r.room_type,r.price_per_day;
    
    
-- phần II 

-- liệt kê các lần đặt phòng , chi tiết hơn

select
	b.booking_id,
    g.guest_name,
    r.room_type,
    b.check_in
from bookings b
left join guests g on g.guest_id = b.guest_id
left join rooms r on r.room_id = b.room_id;


-- mỗi khách đã đặt hàng bao nhiêu lần
select
    g.guest_name,
    r.room_type,
    count(b.guest_id) as so_lan_dat_phong
from bookings b
left join guests g on g.guest_id = b.guest_id
left join rooms r on r.room_id = b.room_id
group by g.guest_name, r.room_type;


-- doanh thu của mỗi phòng
select
    g.guest_name,
    r.room_type,
    count(b.guest_id) as so_lan_dat_phong,
    sum((b.check_out - b.check_in)*r.price_per_day) as doanh_thu
from bookings b
left join guests g on g.guest_id = b.guest_id
left join rooms r on r.room_id = b.room_id
group by g.guest_name, r.room_type;

-- tổng doanh thu từng loại phòng
select
    r.room_type,
    count(b.guest_id) as so_lan_dat_phong,
    sum((b.check_out - b.check_in)*r.price_per_day) as doanh_thu
from bookings b
left join guests g on g.guest_id = b.guest_id
left join rooms r on r.room_id = b.room_id
group by r.room_type;


