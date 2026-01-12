CREATE DATABASE session06; 
USE session06;
CREATE TABLE customer (
    c_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL
); 
CREATE TABLE orders( 
o_id int auto_increment primary key, 
c_id int not null, 
o_date date default(current_date), 
o_status enum('pending','completed','canceller') default 'pending', 
foreign key (c_id) references customer(c_id) 
);
insert into customer(full_name,city) values ('number1','ha noi'), ('number2','ha noi'), ('number3','ha noi'), ('number4','ha noi'), ('number5','ha noi'), ('number6','ha noi'), ('number7','ha noi'), ('number8','ha noi'), ('number9','ha noi'); insert into orders(c_id) values (1), (1), (1), (2), (3), (4), (5), (6), (7), (8);SELECT 
    *
FROM
    session06.orders;SELECT 
    *
FROM
    session06.customer;SELECT 
    o.o_id, c.full_name, o.o_date, o.o_status
FROM
    orders o
        JOIN
    customer c ON o.c_id = c.c_id;
    
SELECT 
    c.c_id, c.full_name, c.city, COUNT(o.o_id) AS total_orders
FROM
    customer c
        LEFT JOIN
    orders o ON c.c_id = o.c_id
GROUP BY c.c_id , c.full_name;

SELECT 
    c.c_id, c.full_name, c.city, COUNT(o.o_id) AS total_orders
FROM
    customer c
        LEFT JOIN
    orders o ON c.c_id = o.c_id
GROUP BY c.c_id , c.full_name
HAVING COUNT(o.o_id) >= 2;
alter table orders add total_amount decimal(10,2) not null default(100000) check(total_amount >= 0);SELECT 
    *
FROM
    session06.orders;SELECT 
    c.c_id,
    c.full_name,
    COUNT(o.o_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM
    customer c
        LEFT JOIN
    orders o ON c.c_id = o.c_id
GROUP BY c.c_id , c.full_name;

SELECT 
    c.c_id, c.full_name, MAX(o.total_amount) AS max_order
FROM
    customer c
        LEFT JOIN
    orders o ON c.c_id = o.c_id
GROUP BY c.c_id , c.full_name;SELECT 
    c.c_id,
    c.full_name,
    COUNT(o.o_id) AS so_don,
    SUM(o.total_amount) AS tong_tien
FROM
    customer c
        LEFT JOIN
    orders o ON c.c_id = o.c_id
        AND o.o_status <> 'completed'
GROUP BY c.c_id , c.full_name
ORDER BY tong_tien DESC;
SELECT 
    o_date, COUNT(o_id) AS so_don
FROM
    orders
WHERE
    o_status <> 'canceller'
GROUP BY o_date
ORDER BY o_date;SELECT 
    o_date, SUM(total_amount) AS tong_tien
FROM
    orders
GROUP BY o_date
ORDER BY tong_tien DESC;SELECT 
    o_date, SUM(total_amount) AS tong_tien
FROM
    orders
GROUP BY o_date
HAVING SUM(total_amount) > 500000
ORDER BY tong_tien DESC;CREATE TABLE product (
    p_id INT AUTO_INCREMENT PRIMARY KEY,
    p_name VARCHAR(100) NOT NULL,
    p_price DECIMAL(10 , 2 ) NOT NULL DEFAULT 100000
);


CREATE TABLE order_items (
    o_id INT,
    p_id INT,
    quantity INT NOT NULL CHECK (quantity >= 0),
    FOREIGN KEY (o_id)
        REFERENCES orders (o_id),
    FOREIGN KEY (p_id)
        REFERENCES product (p_id)
); 
insert into product (p_name) values ('sp1'), ('sp2'), ('sp3'), ('sp4'), ('sp5'), ('sp6'), ('sp7'), ('sp8'), ('sp9'), ('sp10');
SELECT 
    *
FROM
    session06.product;
    INSERT INTO order_items (o_id, p_id, quantity) VALUES 
    (1, 1, 2), (1, 2, 1), (2, 3, 2), (3, 2, 1), (3, 4, 1), (4, 1, 1), (5, 4, 3), (5, 2, 1), (6, 5, 2), (7, 3, 1);
SELECT 
    p.p_id,
    p.p_name,
    SUM(oi.quantity) AS da_ban
FROM product p
LEFT JOIN order_items oi ON p.p_id = oi.p_id
GROUP BY p.p_id, p.p_name
ORDER BY da_ban DESC;


-- lấy các sản phẩm có trên 300000 doanh thu
select * from session06.order_items;
SELECT
	p.p_id,
    p.p_name,
    sum(o.quantity) as da_ban,
    sum(o.quantity * p.p_price) as doanh_thu
    from product p
    left join order_items o on p.p_id = o.p_id
    group by p.p_id, p.p_name
    having sum(o.quantity * p.p_price) > 300000
    order by p.p_id;


-- tổng số đơn hàng của mỗi khách // order or order_items
SELECT 
	c.c_id,
    c.full_name,
    count(o.o_id) as so_don_da_mua,
    sum(o.total_amount) as tong_tien
from customer c
	left join orders o on c.c_id = o.c_id
    group by c.c_id,c.full_name
    order by c.c_id;
    

-- lấy tổng số tiền đã chi cảu mỗi người bằng order_items
select
	c.c_id,
    c.full_name,
    p.p_name,
    sum(oi.quantity) as so_luong,
    sum(oi.quantity * p.p_price) as thanh_tien
    from customer c
    left join orders o on c.c_id  = o.c_id
    left join order_items oi on oi.o_id = o.o_id
    left join product p on p.p_id = oi.p_id
    group by c.c_id,c.full_name,p.p_name
    
    