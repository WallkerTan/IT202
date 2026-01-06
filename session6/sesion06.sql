
CREATE DATABASE IF NOT EXISTS session06;
USE session06;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;

-- Tạo bảng customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    city VARCHAR(100)
);

-- Tạo bảng orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20),
    total_amount DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Tạo bảng products
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10,2)
);

-- Tạo bảng order_items
CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- customers
INSERT INTO customers (customer_id, full_name, city) VALUES 
(1, 'Nguyễn Văn An', 'Hà Nội'),
(2, 'Trần Thị Bình', 'TP. Hồ Chí Minh'),
(3, 'Lê Văn Cường', 'Đà Nẵng'),
(4, 'Phạm Thị Dung', 'Hải Phòng'),
(5, 'Hoàng Văn Em', 'Cần Thơ'),
(6, 'Vũ Thị Phương', 'Hà Nội');

-- orders
INSERT INTO orders (order_id, customer_id, order_date, status, total_amount) VALUES 
(101, 1, '2025-12-01', 'completed', 1500000.00),
(102, 2, '2025-12-05', 'completed', 3200000.00),
(103, 1, '2025-12-10', 'pending',    800000.00),
(104, 3, '2025-12-15', 'completed', 4500000.00),
(105, 4, '2025-12-20', 'cancelled', 1200000.00),
(106, 1, '2025-12-25', 'completed', 2800000.00),
(107, 5, '2026-01-02', 'completed', 1900000.00);

-- products
INSERT INTO products (product_id, product_name, price) VALUES 
(1, 'Laptop Dell XPS', 25000000.00),
(2, 'Điện thoại iPhone 15', 30000000.00),
(3, 'Tai nghe Sony', 5000000.00),
(4, 'Chuột Logitech', 1500000.00),
(5, 'Bàn phím cơ', 3000000.00);

-- order_items
INSERT INTO order_items (order_id, product_id, quantity) VALUES 
(101, 1, 1),
(101, 3, 2),
(102, 2, 1),
(104, 1, 1),
(104, 4, 3),
(106, 2, 1),
(106, 5, 2),
(107, 3, 1);


-- 1. Hiển thị danh sách đơn hàng kèm tên khách hàng và thành phố
SELECT 
    o.order_id, 
    o.order_date, 
    o.status, 
    c.full_name, 
    c.city 
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id;

SELECT 
    c.customer_id, 
    c.full_name, 
    COUNT(o.order_id) AS so_don_hang 
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id 
GROUP BY c.customer_id, c.full_name 
HAVING COUNT(o.order_id) >= 1 
ORDER BY so_don_hang DESC;

-- 3. Tổng tiền mà mỗi khách hàng đã chi tiêu (chỉ tính đơn completed)
SELECT 
    c.customer_id, 
    c.full_name, 
    SUM(o.total_amount) AS tong_chi_tieu 
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id 
WHERE o.status = 'completed' 
GROUP BY c.customer_id, c.full_name;

-- 4. Giá trị đơn hàng cao nhất của từng khách hàng (chỉ tính đơn completed)
SELECT 
    c.customer_id, 
    c.full_name, 
    MAX(o.total_amount) AS don_hang_cao_nhat 
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id 
WHERE o.status = 'completed' 
GROUP BY c.customer_id, c.full_name;

-- 5. Sắp xếp khách hàng theo tổng chi tiêu giảm dần (chỉ tính đơn completed)
SELECT 
    c.customer_id, 
    c.full_name, 
    SUM(o.total_amount) AS tong_chi_tieu 
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id 
WHERE o.status = 'completed' 
GROUP BY c.customer_id, c.full_name 
ORDER BY tong_chi_tieu DESC;

-- 6. Tổng doanh thu theo từng ngày (chỉ tính đơn completed)
SELECT 
    order_date, 
    SUM(total_amount) AS tong_doanh_thu 
FROM orders 
WHERE status = 'completed' 
GROUP BY order_date 
ORDER BY order_date;

-- 7. Số lượng đơn hàng theo từng ngày (chỉ tính đơn completed)
SELECT 
    order_date,
    COUNT(order_id) AS so_luong_don 
FROM orders 
WHERE status = 'completed' 
GROUP BY order_date 
ORDER BY order_date;

-- 8. Chỉ hiển thị các ngày có doanh thu > 10.000.000
SELECT 
    order_date, 
    SUM(total_amount) AS tong_doanh_thu 
FROM orders 
WHERE status = 'completed' 
GROUP BY order_date 
HAVING SUM(total_amount) > 10000000 
ORDER BY order_date;

-- 9. Mỗi sản phẩm đã bán được bao nhiêu cái (chỉ tính đơn completed)
SELECT 
    p.product_id, 
    p.product_name, 
    SUM(oi.quantity) AS tong_so_luong_ban 
FROM products p 
JOIN order_items oi ON p.product_id = oi.product_id 
JOIN orders o ON oi.order_id = o.order_id 
WHERE o.status = 'completed' 
GROUP BY p.product_id, p.product_name;

-- 10. Doanh thu của từng sản phẩm (chỉ hiển thị sản phẩm có doanh thu > 5.000.000)
SELECT 
    p.product_name, 
    SUM(oi.quantity) AS so_luong_ban, 
    SUM(oi.quantity * p.price) AS doanh_thu 
FROM products p 
JOIN order_items oi ON p.product_id = oi.product_id 
JOIN orders o ON oi.order_id = o.order_id 
WHERE o.status = 'completed' 
GROUP BY p.product_id, p.product_name 
HAVING SUM(oi.quantity * p.price) > 5000000 
ORDER BY doanh_thu DESC;

-- 11. Khách hàng VIP: có ít nhất 3 đơn completed và tổng chi > 10.000.000
SELECT 
    c.customer_id, 
    c.full_name, 
    COUNT(o.order_id) AS tong_so_don_hang, 
    SUM(o.total_amount) AS tong_tien_chi, 
    AVG(o.total_amount) AS gia_tri_don_trung_binh 
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id 
WHERE o.status = 'completed' 
GROUP BY c.customer_id, c.full_name 
HAVING COUNT(o.order_id) >= 3 
   AND SUM(o.total_amount) > 10000000 
ORDER BY tong_tien_chi DESC;

-- 12. Top 5 sản phẩm bán chạy (tổng số lượng >= 10)
SELECT 
    p.product_name, 
    SUM(oi.quantity) AS tong_so_luong_ban, 
    SUM(oi.quantity * p.price) AS tong_doanh_thu, 
    AVG(p.price) AS gia_ban_trung_binh 
FROM products p 
JOIN order_items oi ON p.product_id = oi.product_id 
JOIN orders o ON oi.order_id = o.order_id 
WHERE o.status = 'completed' 
GROUP BY p.product_id, p.product_name 
HAVING SUM(oi.quantity) >= 10 
ORDER BY tong_doanh_thu DESC 
LIMIT 5;