create database The_KitabGhar_Bookstore;
use The_KitabGhar_Bookstore;
-- 1. Authors
CREATE TABLE Authors (
author_id INT AUTO_INCREMENT PRIMARY KEY,
author_name VARCHAR(100) NOT NULL,
bio TEXT
);
-- 2. Genres
CREATE TABLE Genres (

genre_id INT AUTO_INCREMENT PRIMARY KEY,
genre_name VARCHAR(50) NOT NULL
);
-- 3. Customers
CREATE TABLE Customer(
customer_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100),
email VARCHAR(100) UNIQUE,
city VARCHAR(50),
join_date DATE
);
-- 4. Books
CREATE TABLE Books (
book_id INT AUTO_INCREMENT PRIMARY KEY,
title VARCHAR(150),
price DECIMAL(10, 2),
stock_quantity INT,
author_id INT,
genre_id INT,
FOREIGN KEY (author_id) REFERENCES Authors(author_id),
FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
);
-- 5. Orders
CREATE TABLE Order_s (
order_id INT AUTO_INCREMENT PRIMARY KEY,
order_date DATE,
customer_id INT,
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
-- 6. Order_Details
CREATE TABLE Order_Details (
detail_id INT AUTO_INCREMENT PRIMARY KEY,
order_id INT,
book_id INT,
quantity_ordered INT,
price_at_time_of_order DECIMAL(10,2),
FOREIGN KEY (order_id) REFERENCES Orders(order_id),
FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

INSERT INTO Authors (author_name, bio) VALUES
('Chetan Bhagat', 'Indian author known for 5 Point Someone.'),
('Arundhati Roy', 'Winner of the Man Booker Prize.'),
('R.K. Narayan', 'Creator of Malgudi Days.'),
('Amish Tripathi', 'Known for the Shiva Trilogy.');

INSERT INTO Genres (genre_name) VALUES
('Fiction'), ('Mythology'), ('History'), ('Romance');

INSERT INTO Books (title, price, stock_quantity, author_id, genre_id) VALUES
('Five Point Someone', 250.00, 50, 1, 1),
('2 States', 300.00, 40, 1, 4),
('The God of Small Things', 450.00, 20, 2, 1),
('Malgudi Days', 200.00, 100, 3, 1),
('The Immortals of Meluha', 399.00, 60, 4, 2);

INSERT INTO Customer(name, email, city, join_date) VALUES
('Aarav Sharma', 'aarav@gmail.com', 'Mumbai', '2023-01-10'),
('Diya Patel', 'diya.p@yahoo.com', 'Ahmedabad', '2023-02-15'),
('Vihaan Reddy', 'vihaan.r@outlook.com', 'Hyderabad', '2023-03-20'),
('Ananya Gupta', 'ananya.g@gmail.com', 'Delhi', '2023-04-05');

INSERT INTO Orders (order_date, customer_id) VALUES
('2023-05-01', 1),
('2023-05-03', 2),
('2023-05-05', 1),
('2023-06-01', 3);
INSERT INTO Order_Details (order_id, book_id, quantity_ordered, price_at_time_of_order)
VALUES
(1, 1, 1, 250.00),
(1, 4, 2, 200.00),
(2, 5, 1, 399.00),
(3, 2, 1, 300.00),
(4, 3, 1, 450.00);

SELECT * FROM Books WHERE price < 300;
SELECT email FROM Customer WHERE name = 'Vihaan Reddy';
SELECT * FROM Books WHERE genre_id = 1;
SELECT author_name FROM Authors ORDER BY author_name ASC;
SELECT COUNT(*) AS mumbai_customers FROM Customer WHERE city = 'Mumbai';
SELECT * FROM Books ORDER BY price DESC LIMIT 1;

SELECT b.title,
a.author_name
FROM Books b
JOIN Authors a
ON b.author_id = a.author_id;

SELECT c.name,
SUM(od.quantity_ordered * od.price_at_time_of_order) AS total_spent
FROM Customer c
JOIN Orders o
ON c.customer_id = o.customer_id
JOIN Order_Details od
ON o.order_id = od.order_id
WHERE c.name = 'Aarav Sharma'
GROUP BY c.name;

SELECT g.genre_name,
SUM(b.stock_quantity) AS total_stock
FROM Genres g
JOIN Books b
ON g.genre_id = b.genre_id
GROUP BY g.genre_id, g.genre_name
ORDER BY total_stock DESC
LIMIT 1;

SELECT *
FROM Orders
WHERE order_date BETWEEN '2023-05-01' AND '2023-05-31';

SELECT b.title
FROM Books b
LEFT JOIN Order_Details od
ON b.book_id = od.book_id
WHERE od.book_id IS NULL;

SELECT a.author_name,
SUM(od.quantity_ordered) AS total_books_sold
FROM Authors a
JOIN Books b
ON a.author_id = b.author_id
JOIN Order_Details od
ON b.book_id = od.book_id
GROUP BY a.author_id, a.author_name;

SELECT c.name,
COUNT(o.order_id) AS total_orders
FROM Customer c
JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_orders DESC
LIMIT 1;

SELECT a.author_name,
       AVG(b.price) AS avg_book_price
FROM Authors a
JOIN Books b
ON a.author_id = b.author_id
GROUP BY a.author_id, a.author_name
HAVING AVG(b.price) > 300;

SELECT b.title,
SUM(od.quantity_ordered) AS total_sold
FROM Books b
JOIN Order_Details od
ON b.book_id = od.book_id
GROUP BY b.book_id, b.title
ORDER BY total_sold DESC
LIMIT 1;

SELECT c.name
FROM Customer c
JOIN Orders o
ON c.customer_id = o.customer_id
JOIN Order_Details od
ON o.order_id = od.order_id
JOIN Books b
ON od.book_id = b.book_id
WHERE b.title IN ('Malgudi Days', 'Five Point Someone')
GROUP BY c.customer_id, c.name
HAVING COUNT(DISTINCT b.title) = 2;

SELECT c.name
FROM Customer c
LEFT JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING MAX(o.order_date) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
OR MAX(o.order_date) IS NULL;

SELECT g.genre_name,
SUM(od.quantity_ordered * od.price_at_time_of_order) AS revenue
FROM Genres g
JOIN Books b
ON g.genre_id = b.genre_id
JOIN Order_Details od
ON b.book_id = od.book_id
WHERE g.genre_name = 'Fiction'
GROUP BY g.genre_name;