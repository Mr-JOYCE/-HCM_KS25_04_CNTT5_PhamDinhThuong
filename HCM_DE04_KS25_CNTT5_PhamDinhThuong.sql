CREATE DATABASE IF NOT EXISTS SmartPhoneStore;
USE SmartPhoneStore;

CREATE TABLE Product (
    product_id CHAR(6) PRIMARY KEY,
	product_name VARCHAR(100) NOT NULL,
    product_type VARCHAR(50) NOT NULL,
    product_price DECIMAL(14,2) NOT NULL,
    product_quantity INT NOT NULL
);

CREATE TABLE Customer (
    customer_id CHAR(6) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(150) NOT NULL,
    customer_phone VARCHAR(10) NOT NULL,
    customer_level ENUM('Gold','Silver','Bronze') NOT NULL DEFAULT 'Bronze'
);

CREATE TABLE Orders (
    orders_id CHAR(6) PRIMARY KEY,
    orders_date DATE NOT NULL,
    sum_price DECIMAL(14,2) NOT NULL DEFAULT 0,
    customer_id CHAR(6) NOT NULL,
    CONSTRAINT FK_Orders_Customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Order_Detail (
    orders_id CHAR(6) NOT NULL,
    product_id CHAR(6) NOT NULL,
    quantity_buy INT NOT NULL,
    reallity_buy DECIMAL(14,2) NOT NULL,
    PRIMARY KEY (orders_id, product_id),
    CONSTRAINT FK_OD_Orders FOREIGN KEY (orders_id) REFERENCES Orders(orders_id) ON DELETE CASCADE,
    CONSTRAINT FK_OD_Product FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

ALTER TABLE Product ADD COLUMN time_guarantee SMALLINT UNSIGNED NOT NULL DEFAULT 12;

ALTER TABLE Customer CHANGE customer_level customer_rank ENUM('Gold','Silver','Bronze') NOT NULL DEFAULT 'Bronze';

DROP TABLE IF EXISTS Order_Detail;
DROP TABLE IF EXISTS Orders;

INSERT INTO Product (product_id, product_name, product_type, product_price, product_quantity, time_guarantee) VALUES
('101', 'Samsung Galaxy A56', 'Smartphone', 18990000.00, 50, 24),
('000102', 'Xiaomi 14 Lite', 'Smartphone', 12490000.00, 30, 18),
('00A901', 'Op lung Samsung silicon', 'Accessories', 350000.00, 150, 3),
('00A902', 'Sac nhanh 25W', 'Accessories', 490000.00, 200, 12),
('00A903', 'Tai nghe Bluetooth', 'Accessories', 799000.00, 95, 6);

INSERT INTO Customer (customer_id, customer_name, customer_email, customer_phone, customer_rank) VALUES
('KH0001', 'Nguyen Van A', 'nga@mail.example', '0909123456', 'Gold'),
('KH0002', 'Tran Thi B', 'ttb@mail.example', '0909234567', 'Silver'),
('KH0003', 'Le Van C', 'lvc@mail.example', '0909345678', 'Bronze'),
('KH0004', 'Pham Thi D', 'ptd@mail.example', '0909456789', 'Gold'),
('KH0005', 'Hoang Van E', 'hve@mail.example', '0909567890', 'Bronze');

INSERT INTO Orders (orders_id, orders_date, sum_price, customer_id) VALUES
('DH0001', '2026-05-06', 32180000.00, 'KH0001'),
('DH0002', '2026-05-29', 12490000.00, 'KH0002'),
('DH0003', '2026-04-12', 4666000.00, 'KH0003'),
('DH0004', '2026-05-18', 19970000.00, 'KH0004'),
('DH0005', '2026-03-01', 0.00, 'KH0005');

INSERT INTO Order_Detail (orders_id, product_id, quantity_buy, reallity_buy) VALUES
('DH0001', '101', 1, 18990000.00),
('DH0001', '000102', 1, 12490000.00),
('DH0001', '00A901', 2, 350000.00),
('DH0002', '000102', 1, 12490000.00),
('DH0003', '00A902', 3, 490000.00),
('DH0003', '00A903', 4, 799000.00),
('DH0004', '101', 1, 18990000.00),
('DH0004', '00A902', 2, 490000.00),
('DH0005', '00A903', 1, 799000.00);

UPDATE Product SET product_price = ROUND(product_price * 0.9, 2) WHERE product_type = 'Accessories';

DELETE FROM Orders WHERE sum_price = 0;

SELECT product_id, product_name, product_type, product_price, product_quantity
FROM Product
WHERE product_price > 15000000;

SELECT customer_id, customer_name, customer_email, customer_phone, customer_rank
FROM Customer
WHERE customer_rank IN ('Gold', 'Silver');

SELECT orders_id, orders_date, sum_price, customer_id
FROM Orders
WHERE YEAR(orders_date) = 2026 AND MONTH(orders_date) = 5;

SELECT product_id, product_name, product_price, product_quantity
FROM Product
WHERE product_name LIKE 'Samsung%' AND product_quantity > 20;

SELECT orders_id,
       SUM(quantity_buy * reallity_buy) AS sum_price_product_101
FROM Order_Detail
WHERE product_id = '101'
GROUP BY orders_id;