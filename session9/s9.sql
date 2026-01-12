CREATE DATABASE HKT;
USE HKT;


-- TẠO BẢNG

-- sản phẩm
CREATE TABLE Category (
    c_id VARCHAR(10) PRIMARY KEY,
    c_name VARCHAR(100) NOT NULL UNIQUE,
    c_description TEXT
);


-- SẢN PHẨM
CREATE TABLE Product (
    p_id VARCHAR(10) PRIMARY KEY,
    p_name VARCHAR(150) NOT NULL,
    price DECIMAL(10 , 2 ) NOT NULL CHECK (price > 0),
    p_status ENUM('Available', 'Out of Stock') DEFAULT 'Available',
    c_id VARCHAR(10),
    FOREIGN KEY (c_id)
        REFERENCES Category (c_id)
);
-- thêm bảng khách hàng
CREATE TABLE Customer (
	ct_id int auto_increment primary key,
    ct_name varchar(50) not null
);

-- ĐƠN HÀNG
CREATE TABLE orders (
    o_id INT AUTO_INCREMENT PRIMARY KEY,
    o_date DATETIME NOT NULL,
    total_amount DECIMAL(15 , 2 ) NOT NULL,
    ct_id int,
    FOREIGN KEY (ct_id)
        REFERENCES Customer (ct_id)
);


-- CHI TIẾT ĐƠN HÀNG
CREATE TABLE Order_detail (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    o_id INT,
    p_id VARCHAR(10),
    quantity INT CHECK (quantity >= 0),
    subtotal DECIMAL(12,2),
    FOREIGN KEY (o_id)
        REFERENCES orders (o_id),
    FOREIGN KEY (p_id)
        REFERENCES Product (p_id)
);



-- THÊM DỮ LIỆU
INSERT INTO Customer (ct_name) values
('Mr. An'),
('Ms. Hoa'),
('CompletedMr. Binh'),
('Anonymous'),
('Ms. Lan');


INSERT INTO Category (c_id,c_name,c_description) values
('C01','Coffee','All types of coffee beans and brews'),
('C02','Tea & Fruit','Fresh fruit juices and tea'),
('C03','Bakery','Cakes and pastries');

INSERT INTO Product (p_id,p_name,price,p_status,c_id) values
('P001','Espresso',35000.00,'Available','C01'),
('P002','Matcha Latte',45000.00,'Available','C02'),
('P003','Tiramisu',55000.00,'Available','C03'),
('P004','Cold Brew',50000.00,'Out of Stock','C01'),
('P005','Croissant',30000.00,'Available','C03');

INSERT INTO orders (o_date,total_amount,ct_id) values
('2025-01-01 08:30:00',80000.00,1),
('2025-01-01 09:15:00',45000.00,2),
('2025-01-02 14:00:00',140000.00,3),
('2025-01-03 10:00:00',35000.00,1),
('2025-01-03 11:20:00',90000.00,2);

INSERT INTO Order_detail (o_id,p_id,quantity,subtotal) values
(1,'P001',5,35000.00),
(1,'P001',10,45000.00),
(3,'P002',0,110000.00),
(3,'P001',0,30000.00),
(5,'P002',0,90000.00);



-- KIỂM TRA TẠM
SELECT * FROM HKT.Category;
SELECT * FROM HKT.Product;
SELECT * FROM HKT.orders;
SELECT * FROM HKT.Order_detail;

-- 3. Chuyển trạng thái (status) của sản phẩm 'Cold Brew' sang 'Available'.(5 điểm)
UPDATE Product 
SET p_status = 'Available'
where p_name = 'Cold Brew';
SELECT * FROM HKT.Product;
-- +5

-- 4. Tăng giá bán (price) thêm 10% cho tất cả các sản phẩm thuộc danh mục 'Bakery' (mã 'C03').(5 điểm)
UPDATE Product p
SET price = (p.price*1.1);
SELECT * FROM HKT.Product;
-- +5

-- 5. Xóa các chi tiết đơn hàng (order_details) có số lượng  bằng 0 hoặc nhỏ hơn .(5 điểm)
DELETE FROM Order_detail 
where quantity = 0;
SELECT * FROM HKT.Order_detail;
-- +5

-- PHẦN 2

-- 6. Liệt kê product_id, product_name, price của các sản phẩm có giá từ 40,000 trở lên và đang còn hàng (Available).(5 điểm)
SELECT 
	p_id,
    p_name,
    price
FROM Product where price > 40000.00 and p_status = 'Available';
-- +5


-- 7. Lấy thông tin order_id, order_date, customer_name của các khách hàng có tên bắt đầu bằng chữ 'M'.(5 điểm)
SELECT
	o.o_id,
    o.o_date,
    ct.ct_name
from Customer ct
join orders o on o.ct_id = ct.ct_id
group by o.o_id,o.o_date,ct.ct_name
having ct_name like 'M%';


-- 8. Hiển thị danh sách sản phẩm gồm: product_name, price. Sắp xếp theo giá giảm dần.(5 điểm)
select 
	p_name,
    price
from Product
order by price desc;
-- +5

-- 9. Lấy 3 đơn hàng mới nhất (dựa vào order_date).(5 điểm)
select * from orders order by o_id limit 3;
-- +5

-- 10. Hiển thị danh sách sản phẩm, bỏ qua 2 sản phẩm đầu tiên và lấy 3 sản phẩm tiếp theo.(5 điểm)
select * from Product limit 3 offset 2;


-- 11. Hiển thị product_name, price và tên danh mục (category_name) của từng sản phẩm.(5 điểm)
select 
	p_name,
    price,
    c_name
from Product p
left join Category c on p.c_id = c.c_id
group by p.p_name,p.price,c.c_name;
-- +5

-- 12. Liệt kê tất cả danh mục và các sản phẩm thuộc danh mục đó. Hiển thị cả những danh mục chưa có sản phẩm nào.(5 điểm)
select 
    c_name,
	p_name
from Product p
left join Category c on p.c_id = c.c_id
group by p.p_name,c.c_name
order by c_name;
-- +5


-- 13. Tính tổng doanh thu của quán theo từng ngày. (5 điểm)
SELECT 
    o.o_date,
    SUM(o.total_amount) AS tong_doanh_thu 
FROM orders o 
GROUP BY o.o_date;


-- 14. Thống kê những đơn hàng (order_id) có từ 2 loại sản phẩm khác nhau trở lên trong order_detail.(5 điểm)


-- 15. Lấy danh sách sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm trong quán.(5 điểm)
select
	p.p_name,
    p.price
from Product p
	where p.price > avg(p.price);
    
-- 16. Hiển thị tên các khách hàng đã từng mua sản phẩm 'Matcha Latte'.(5 điểm)
-- 17. Hiển thị bảng thông tin về đơn hàng gồm: order_id, order_date, product_name, quantity, subtotal. (5 điểm)
    
