
CREATE DATABASE online_store;
USE online_store;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    city VARCHAR(60),
    signup_date DATE NOT NULL
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    CHECK (price >= 0),
    CHECK (stock_quantity >= 0)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status ENUM('Completed', 'Pending', 'Cancelled')
        NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    CHECK (quantity > 0),
    CHECK (unit_price >= 0),
    UNIQUE (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


INSERT INTO 
customers(customer_name, email,city, signup_date) 
VALUES
('Ritesh','ritsh@example.com','Delhi','2026-01-10'),
('Shreya','shreya@example.com','Pune','2026-01-10'),
('Preeti','preeti@example.com','Goa','2026-01-10'),
('Ram','ram@example.com','Mumbai','2026-01-10'),
('Kris','kris@example.com','Kolkata','2026-01-10');

INSERT INTO products
    (product_name, category, price, stock_quantity)
VALUES
    ('Laptop', 'Electronics', 800.00, 10),
    ('Headphones', 'Electronics', 50.00, 30),
    ('Office Chair', 'Furniture', 150.00, 12),
    ('Notebook', 'Stationery', 5.00, 100),
    ('Desk Lamp', 'Furniture', 35.00, 20),
    ('Keyboard', 'Electronics', 40.00, 25);

INSERT INTO orders (customer_id, order_date, status)
VALUES
    (1, '2026-03-10', 'Completed'),
    (2, '2026-03-12', 'Completed'),
    (1, '2026-03-15', 'Completed'),
    (3, '2026-04-02', 'Pending'),
    (4, '2026-04-05', 'Completed'),
    (5, '2026-04-10', 'Cancelled'),
    (2, '2026-04-12', 'Completed'),
    (3, '2026-04-15', 'Completed');

INSERT INTO order_items
    (order_id, product_id, quantity, unit_price)
VALUES
    (1, 1, 1, 800.00),
    (1, 2, 2, 50.00),
    (2, 3, 1, 150.00),
    (2, 4, 5, 5.00),
    (3, 6, 2, 40.00),
    (3, 2, 1, 50.00),
    (4, 1, 1, 800.00),
    (5, 5, 2, 35.00),
    (5, 4, 10, 5.00),
    (6, 3, 1, 150.00),
    (7, 1, 1, 800.00),
    (7, 6, 1, 40.00),
    (8, 2, 3, 50.00),
    (8, 4, 4, 5.00);

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;

SELECT *
FROM customers;

SELECT product_name, category, price
FROM products
WHERE price > 50
ORDER BY price DESC;

SELECT city, COUNT(*) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC, city;

SELECT
    o.order_id,
    o.status,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id, o.status
ORDER BY o.order_id;

SELECT
    ROUND(SUM(oi.quantity * oi.unit_price), 2)
        AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'Completed';

SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC, p.product_name
LIMIT 5;

SELECT
    p.product_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)
        AS product_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.product_id, p.product_name
ORDER BY product_revenue DESC;

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_orders DESC, c.customer_name;

SELECT
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_orders DESC, c.customer_name;

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)
        AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;

SELECT product_name, stock_quantity
FROM products
WHERE stock_quantity < 15
ORDER BY stock_quantity ASC;

SELECT
    c.customer_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)
        AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.customer_name
HAVING SUM(oi.quantity * oi.unit_price) > 500
ORDER BY total_spent DESC;