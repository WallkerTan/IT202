CREATE DATABASE session05;
USE session05;

create table Products (
	p_id int auto_increment primary key,
    p_name varchar(50) not null unique,
    p_price decimal(10,2) not null,
    p_stock int not null check(p_stock>=0),
    p_status enum("active" , "inactive")
);
INSERT INTO Products (p_name, p_price, p_stock, p_status) VALUES
('Laptop Dell XPS', 25000.00, 20, 'active'),
('iPhone 14', 22000.00, 15, 'active'),
('Samsung Galaxy S23', 21000.00, 18, 'active'),
('Chuột Logitech', 500.00, 50, 'active'),
('Bàn phím cơ Keychron', 1800.00, 30, 'active'),
('Tai nghe Sony WH-1000XM5', 7500.00, 12, 'active'),
('Màn hình LG 27inch', 6500.00, 10, 'active'),
('Ổ cứng SSD Samsung 1TB', 3200.00, 25, 'inactive'),
('USB Kingston 64GB', 250.00, 100, 'inactive'),
('Webcam Logitech C920', 2100.00, 8, 'inactive');

-- 	SELECT * FROM session05.Products;
-- 	SELECT * FROM session05.Products where p_status='active';
--  SELECT * FROM session05.Products where p_price>1000;
    SELECT * FROM session05.Products order by p_price asc;
    
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    city VARCHAR(255),
    status ENUM('active', 'inactive') DEFAULT 'active'
);

INSERT INTO customers (full_name, email, city, status) VALUES
('Nguyễn Văn A', 'a@gmail.com', 'Hà Nội', 'active'),
('Trần Thị B', 'b@gmail.com', 'Đà Nẵng', 'inactive'),
('Lê Văn C', 'c@gmail.com', 'TP.HCM', 'active'),
('Phạm Văn D', 'd@gmail.com', 'Hải Phòng', 'active'),
('Hoàng Thị E', 'e@gmail.com', 'Cần Thơ', 'active');

SELECT * FROM session05.customers;
SELECT * FROM session05.customers where city = 'TP.HCM';
SELECT * FROM session05.customers where (status='active' and lower(city) like 'ha%');
SELECT * FROM session05.customers order by full_name asc;


CREATE TABLE orders (
	order_id int auto_increment primary key,
    customer_id int not null,
    total_amount decimal(10,2) not null,
    order_date  date default(current_date),
    o_status ENUM('pending', 'completed', 'cancelled') DEFAULT 'pending',
    foreign key(customer_id) references customers(customer_id)
);
INSERT INTO orders (customer_id, total_amount, order_date, o_status) VALUES
(1, 150000.00, '2024-05-01', 'pending'),
(2, 250000.00, '2024-05-02', 'completed'),
(1, 99000.00, '2024-05-03', 'cancelled');

SELECT * FROM session05.orders where o_status = 'completed';
SELECT * FROM session05.orders where total_amount > 100000;
SELECT * FROM session05.orders order by order_id desc limit 5 ;
SELECT * FROM session05.orders where o_status = 'completed' order by total_amount asc;

alter table Products
add sold_quantity int not null default 0 check(sold_quantity>=0);

SELECT * FROM session05.Products;
SELECT * FROM session05.Products limit 5 offset 5;
SELECT * FROM session05.Products where p_price>1000 order by sold_quantity desc;

INSERT INTO orders (customer_id, total_amount, order_date, o_status) VALUES
(3, 180000.00, '2024-05-04', 'pending'),
(4, 320000.00, '2024-05-05', 'completed'),
(2, 210000.00, '2024-05-06', 'pending'),
(5, 450000.00, '2024-05-07', 'completed'),
(1, 125000.00, '2024-05-08', 'pending'),

(3, 98000.00,  '2024-05-09', 'completed'),
(4, 67000.00,  '2024-05-10', 'pending'),
(2, 560000.00, '2024-05-11', 'completed'),
(5, 134000.00, '2024-05-12', 'pending'),
(1, 275000.00, '2024-05-13', 'completed'),

(3, 89000.00,  '2024-05-14', 'pending'),
(4, 410000.00, '2024-05-15', 'completed'),
(2, 222000.00, '2024-05-16', 'pending'),
(5, 199000.00, '2024-05-17', 'completed'),
(1, 305000.00, '2024-05-18', 'pending'),

(3, 175000.00, '2024-05-19', 'completed'),
(4, 268000.00, '2024-05-20', 'pending');

SELECT * FROM session05.orders where o_status <> 'cancelled' order by order_id asc limit 5 offset 0 ;
SELECT * FROM session05.orders where o_status <> 'cancelled' order by order_id asc limit 5 offset 5 ;
SELECT * FROM session05.orders where o_status <> 'cancelled' order by order_id asc limit 5 offset 10 ;

INSERT INTO Products (p_name, p_price, p_stock, p_status) VALUES
('Asus Zenbook 14', 23000.00, 15, 'active'),
('MacBook Air M1', 28000.00, 10, 'active'),
('HP Pavilion 15', 19000.00, 20, 'active'),
('Lenovo ThinkPad X1', 30000.00, 8, 'active'),
('Acer Aspire 7', 17000.00, 25, 'active'),

('Chuột Gaming Razer', 1200.00, 40, 'active'),
('Bàn phím Logitech K380', 900.00, 35, 'active'),
('Tai nghe JBL Tune 510', 1500.00, 22, 'active'),
('Loa Bluetooth Sony', 2200.00, 18, 'active'),
('Webcam Logitech Brio', 4200.00, 12, 'active'),

('Màn hình Samsung 24inch', 4800.00, 14, 'active'),
('Màn hình Dell UltraSharp', 8200.00, 6, 'active'),
('Ổ cứng HDD WD 2TB', 2600.00, 30, 'inactive'),
('Ổ cứng SSD Kingston 512GB', 2100.00, 28, 'active'),
('USB Sandisk 128GB', 450.00, 60, 'active'),

('Sạc nhanh Anker 65W', 1300.00, 45, 'active'),
('Pin dự phòng Xiaomi 20000mAh', 1100.00, 38, 'active'),
('Cáp Type-C Anker', 300.00, 80, 'active'),
('Router Wifi TP-Link AX3000', 3500.00, 9, 'inactive'),
('Balo Laptop Targus', 950.00, 27, 'active');


SELECT * FROM  session05.products
where (p_price>1000 and p_price<100000)
order by p_price asc
limit 10 offset 0;

SELECT * FROM  session05.products
where (p_price>1000 and p_price<100000)
order by p_price asc
limit 10 offset 10;