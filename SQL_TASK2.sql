create database Jeevan_Raksha_Pharmacy ;
use Jeevan_Raksha_Pharmacy ;

CREATE TABLE customers (
customer_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100),
phone VARCHAR(15),
city VARCHAR(50)
);
CREATE TABLE suppliers (
supplier_id INT AUTO_INCREMENT PRIMARY KEY,
supplier_name VARCHAR(100),
contact_person VARCHAR(100),
phone VARCHAR(15)
);
CREATE TABLE medicines (
medicine_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100),
category VARCHAR(50),
price DECIMAL(10,2),
stock_quantity INT,
expiry_date DATE,
supplier_id INT,
FOREIGN KEY (supplier_id) REFERENCES
suppliers(supplier_id)
);
CREATE TABLE orders (
order_id INT AUTO_INCREMENT PRIMARY KEY,
customer_id INT,
order_date DATE,
total_amount DECIMAL(10,2),
payment_mode ENUM('UPI', 'Cash', 'Card'),
FOREIGN KEY (customer_id) REFERENCES
customers(customer_id)
);
CREATE TABLE order_items (
item_id INT AUTO_INCREMENT PRIMARY KEY,
order_id INT,
medicine_id INT,
quantity INT,
subtotal DECIMAL(10,2),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (medicine_id) REFERENCES
medicines(medicine_id)
);

INSERT INTO customers (name, phone, city) VALUES
('Rahul Sharma', '9876543210', 'Mumbai'),
('Priya Verma', '9123456789', 'Delhi'),
('Amit Patel', '9988776655', 'Ahmedabad'),
('Sneha Reddy', '8877665544', 'Hyderabad'),
('Vikram Singh', '7766554433', 'Mumbai');

INSERT INTO suppliers (supplier_name, contact_person, phone)
VALUES
('Apollo Distributors', 'Rajesh Gupta', '022-123456'),
('MedPlus Supply Chain', 'Suresh Nair', '040-987654'),
('Himalaya Wellness', 'Anjali Mehta', '011-456789');

INSERT INTO medicines (name, category, price, stock_quantity,
expiry_date, supplier_id) VALUES
('Dolo 650', 'Tablet', 30.00, 500, '2025-12-31', 1),
('Azithral 500', 'Tablet', 120.00, 50, '2024-05-20', 1),
('Benadryl', 'Syrup', 110.00, 20, '2024-11-15', 2),
('Combiflam', 'Tablet', 45.00, 200, '2026-01-01', 3),
('Insulin Pen', 'Injection', 800.00, 5, '2024-03-10', 2);

INSERT INTO orders (customer_id, order_date, total_amount,
payment_mode) VALUES
(1, '2023-10-01', 150.00, 'UPI'),
(2, '2023-10-02', 240.00, 'Card'),
(3, '2023-10-05', 45.00, 'Cash'),
(1, '2023-10-10', 800.00, 'UPI'),
(4, '2023-10-12', 1200.00, 'Card');

INSERT INTO order_items (order_id, medicine_id, quantity,
subtotal) VALUES
(1, 1, 5, 150.00), -- Rahul bought 5 Dolo
(2, 2, 2, 240.00), -- Priya bought 2 Azithral
(3, 4, 1, 45.00), -- Amit bought 1 Combiflam
(4, 5, 1, 800.00), -- Rahul bought 1 Insulin
(5, 5, 1, 800.00), -- Sneha bought 1 Insulin
(5, 2, 2, 240.00), -- Sneha bought 2 Azithral
(5, 1, 5, 150.00); -- Sneha bought 5 Dolo


SELECT name, city FROM customers;
SELECT name FROM medicines WHERE category IN ('Syrup', 'Injection');
SELECT * FROM orders WHERE total_amount > 500;
SELECT phone FROM customers WHERE city = 'Mumbai';
SELECT COUNT(*) AS upi_orders FROM orders WHERE payment_mode = 'UPI';
SELECT COUNT(*) AS medicine_count
FROM medicines m
JOIN suppliers s
ON m.supplier_id = s.supplier_id
WHERE s.supplier_name = 'Apollo Distributors';
SELECT c.name AS customer_name,
       o.order_date,
       o.total_amount
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id;
SELECT payment_mode,
SUM(total_amount) AS total_revenue
FROM orders
GROUP BY payment_mode;

SELECT m.name AS medicine_name,
       SUM(oi.quantity) AS total_quantity_sold
FROM medicines m
JOIN order_items oi
ON m.medicine_id = oi.medicine_id
GROUP BY m.medicine_id, m.name
ORDER BY total_quantity_sold DESC
LIMIT 1;

SELECT c.name,
SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING SUM(o.total_amount) > 1000;

SELECT m.name AS medicine_name,
m.stock_quantity,
s.supplier_name
FROM medicines m
JOIN suppliers s
ON m.supplier_id = s.supplier_id
WHERE m.stock_quantity < 50;



