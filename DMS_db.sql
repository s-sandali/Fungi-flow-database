CREATE DATABASE IF NOT EXISTS fungi_db;
USE fungi_db;

#inventory management
CREATE TABLE supplier (                         
    supplier_id INT PRIMARY KEY,
    engagement_date DATE NOT NULL,
    supplier_name VARCHAR(100) NOT NULL,
    supply_material VARCHAR(100) NOT NULL,
    address VARCHAR(100),
    contact_number VARCHAR(15)
);

#lab management
CREATE TABLE mushroom_type (
    mushroom_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE NOT NULL,
    growth_duration INT NOT NULL,
    description TEXT
);


#inventory management
CREATE TABLE inventory_item (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    category ENUM('seed', 'material') NOT NULL,
    mushroom_id INT,
    stock INT NOT NULL,
    threshold INT NOT NULL,
    units VARCHAR(20),
    FOREIGN KEY (mushroom_id) REFERENCES mushroom_type(mushroom_id)
);


#inventory management
CREATE TABLE purchased_raw_material (
    purchase_id INT PRIMARY KEY,
    supplier_id INT,
    item_id INT,
    purchased_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2),
    CONSTRAINT quantity_check CHECK (quantity > 0),
    CONSTRAINT fk1 FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk2 FOREIGN KEY (item_id) REFERENCES inventory_item(item_id) ON DELETE RESTRICT ON UPDATE CASCADE
);


#inventory management
CREATE TABLE material_transfer (
    transfer_id INT PRIMARY KEY,
    item_id INT,
    quantity INT NOT NULL,
    destination ENUM('lab', 'sales', 'production') NOT NULL,
    transfer_date DATE NOT NULL,
    CONSTRAINT fk3 FOREIGN KEY (item_id) REFERENCES inventory_item(item_id)
);


#lab management
CREATE TABLE batch (
    batch_id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT NOT NULL,
    mushroom_id INT NOT NULL,
    start_date DATE NOT NULL,
    expected_enddate DATE NOT NULL,
    initial_quantity INT NOT NULL,
    successful_count INT DEFAULT 0,
    contaminated_count INT DEFAULT 0,
    status ENUM('Active', 'Completed', 'Abandoned') NOT NULL,
    Constraint FOREIGN KEY (item_id) REFERENCES inventory_item (item_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    Constraint FOREIGN KEY (mushroom_id) REFERENCES mushroom_type (mushroom_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

#lab management
CREATE TABLE daily_update (
    update_id INT PRIMARY KEY AUTO_INCREMENT,
    batch_id INT NOT NULL,
    date DATE NOT NULL,
    successful_today INT NOT NULL,
    contaminated_today INT NOT NULL,
    contamination_reason VARCHAR(100),
    Constraint FOREIGN KEY (batch_id) REFERENCES batch(batch_id) ON DELETE CASCADE ON UPDATE CASCADE
);

#Admin and management
CREATE TABLE employee (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    nic VARCHAR(15) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL,
    address VARCHAR(50) NOT NULL,
    sex ENUM('M', 'F', 'other') NOT NULL,
    role ENUM('lab', 'sales', 'inventory') NOT NULL
);

#Sales and distribution
CREATE TABLE Branch(
    Branch_id INT PRIMARY KEY,
    Location VARCHAR(50) NOT NULL,
    Manager_id INT,
    FOREIGN KEY (Manager_id) REFERENCES Employee(Employee_id)
);

#lab management
CREATE TABLE batch_allocation (
    allocation_id INT PRIMARY KEY AUTO_INCREMENT,
    batch_id INT NOT NULL,
    branch_id INT NOT NULL,
    quantity INT NOT NULL,
    type ENUM('Pre-order', 'Walk-in', 'Production') NOT NULL,
    date DATE NOT NULL,
    Constraint FOREIGN KEY (batch_id) REFERENCES batch(batch_id) ON DELETE CASCADE ON UPDATE CASCADE,
	Constraint FOREIGN KEY (branch_id) REFERENCES branch(branch_id) ON DELETE RESTRICT ON UPDATE CASCADE
);


#lab management
CREATE TABLE growth_outcome_by_types (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    mushroom_id INT NOT NULL,
    time_range INT NOT NULL,
    initial_quantity INT NOT NULL,
    successful_count INT NOT NULL,
    contaminated_count INT NOT NULL,
    success_rate INT GENERATED ALWAYS AS ((successful_count * 100) / initial_quantity) STORED,
   CONSTRAINT FOREIGN KEY (mushroom_id) REFERENCES mushroom_type(mushroom_id) ON DELETE RESTRICT ON UPDATE CASCADE
);


#sales and distribution
CREATE TABLE Product(
    Product_id INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Batch_id INT,
    Quantity INT NOT NULL,
    Unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Batch_id) REFERENCES Batch(Batch_id)
);

#sales and distribution
CREATE TABLE WalkinSales (
    Sales_id INT PRIMARY KEY,
    Product_id INT,
    Customer_name VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    Unit_price DECIMAL(10,2) NOT NULL,
    Total_price DECIMAL(10,2) GENERATED ALWAYS AS (Quantity * Unit_price) STORED,
    Date DATE NOT NULL,
    FOREIGN KEY (Product_id) REFERENCES Product(Product_id)
);

#sales and distribution
CREATE TABLE Preorder(
    Preorder_id INT PRIMARY KEY,
    Product_id INT,
    Branch_id INT,
    Customer_name VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    Unit_price DECIMAL(10,2) NOT NULL,
    Total_price DECIMAL(10,2) NOT NULL,
    Order_date DATE NOT NULL,
    Delivery_date DATE,
    Status ENUM('pending', 'fullfilled', 'cancelled') NOT NULL,
    FOREIGN KEY (Product_id) REFERENCES Product(Product_id),
    FOREIGN KEY (Branch_id) REFERENCES Branch(Branch_id)
);

#Admin and management
CREATE TABLE user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'staff') NOT NULL,
	FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

#Admin and management
CREATE TABLE stock_alert (
    alert_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    message VARCHAR(100),
    alert_date DATE NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

#Admin and management
CREATE TABLE report (
    rid INT PRIMARY KEY AUTO_INCREMENT,
    report_type VARCHAR(50) NOT NULL,
    generated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    report_format VARCHAR(10) CHECK (report_format IN ('pdf'))
);


#Populating tables

INSERT INTO supplier VALUES
(1, '2024-06-15', 'GreenGrow Supplies', 'seeds', 'Garden Lane, Kurunegala', '0771234567'),
(2, '2023-07-10', 'AgroTech Ltd.', 'fertilizer', '311 Park st, Colombo ', '0712345678'),
(3, '2025-05-01', 'Farm Co.', 'polythene', '102,high level rd,Gampaha', '0712333678');

INSERT INTO mushroom_type (name, growth_duration, description) VALUES
('American Oyster', 14, 'Fast-growing and commonly cultivated'),
('Abalone', 16, 'Meaty texture and high nutritional value'),
('Milky Mushroom', 12, 'White stalks, preferred in tropical climates');

INSERT INTO inventory_item VALUES
(101, 'American oyster seed', 'seed', 1, 500, 100, 'kg'),
(102, 'Abalone seed', 'seed', 2, 300, 50, 'kg'),
(103, 'Polythene bags', 'material', NULL, 2000, 500, 'bags');

INSERT INTO purchased_raw_material  VALUES
(1001, 1, 101, '2024-12-01 10:30:00', 200, 1500.00),
(1002, 1, 102, '2025-01-10 09:45:00', 100, 1200.00),
(1003, 2, 103, '2025-02-05 14:15:00', 1000, 2.50);

INSERT INTO material_transfer VALUES
(201, 101, 50, 'lab', '2025-03-01'),
(202, 103, 300, 'sales', '2025-03-10'),
(203, 102, 25, 'production', '2025-03-15');


INSERT INTO batch (item_id, mushroom_id, start_date, expected_enddate, initial_quantity, status) VALUES
(101, 1, '2025-05-01', '2025-05-15', 200, 'Active'),
(102, 2, '2025-05-03', '2025-05-19', 150, 'Active'),
(103, 3, '2025-05-05', '2025-05-17', 180, 'Completed');


INSERT INTO daily_update (batch_id, date, successful_today, contaminated_today, contamination_reason) VALUES
(1, '2025-05-02', 30, 2, 'Humidity issue'),
(1, '2025-05-03', 40, 1, NULL),
(2, '2025-05-04', 20, 5, 'Poor ventilation'),
(3, '2025-05-06', 50, 0, NULL);

INSERT INTO employee (name, nic, phone, address, sex, role) 
VALUES 
('Akith De Silva', '200012345678', '0771234567', 'Colombo', 'M', 'lab'),
('Sakith Nethma', '200098765432', '0777654321', 'Kandy', 'M', 'sales'),
('Sathindu Danushka', '200034567890', '0772345678', 'Galle', 'M', 'inventory'),
('Dinushka Sandeepa', '200076543210', '0778765432', 'Jaffna', 'M', 'lab');

INSERT INTO Branch(Branch_id, Location, Manager_id) VALUES
(101, 'Ratmalana', 2),
(102, 'Matara', 2),
(103, 'Kurunegala', 4),
(104, 'Kandy', 4);

INSERT INTO batch_allocation (batch_id, branch_id, quantity, type, date) VALUES
(1, 101, 50, 'Pre-order', '2025-05-15'),
(2, 102, 30, 'Walk-in', '2025-05-16'),
(3, 103, 40, 'Production', '2025-05-17');

INSERT INTO growth_outcome_by_types (mushroom_id, time_range, initial_quantity, successful_count, contaminated_count) VALUES
(1, 30, 200, 180, 20),
(2, 30, 150, 135, 15),
(3, 30, 180, 160, 20);

INSERT INTO Product(Product_id, Name, Batch_id, Quantity, Unit_price) VALUES
(301, 'White Oyster Mushrooms', 1, 1500, 250.00),
(302, 'Shiitake Mushrooms', 2, 800, 450.00),
(303, 'King Oyster Mushrooms', 3, 1800, 200.00),
(304, 'Button Mushroom spores',2,700,350.00);

INSERT INTO WalkinSales (Sales_id, Product_id, Customer_name, Quantity, Unit_price, Date) VALUES
(501, 301, 'Chathura Gunasekara', 10, 250.00, '2025-04-15'),
(502, 302, 'Harshani Wickramasinghe', 6, 450.00, '2025-04-20'),
(503, 303, 'Roshan Perera', 2, 200.00, '2025-04-22');

INSERT INTO Preorder(Preorder_id, Product_id, Branch_id, Customer_name, Quantity, Unit_price, Total_price, Order_date, Delivery_date,Status) VALUES
(401, 301, 101, 'Sanduni Rajapaksha', 5, 250.00, 1250.00, '2025-04-25', '2025-04-30', 'pending'),
(402, 302, 102, 'Tharindu De Silva', 3, 450.00, 1350.00, '2025-04-26', NULL, 'cancelled'),
(403, 303, 103, 'Nimasha Karunaratne', 4, 200.00, 800.00, '2025-04-28', '2025-05-02', 'fullfilled');

INSERT INTO user (username, password, role, employee_id) 
VALUES 
('akith.desilva@example.com', 'password123', 'admin', 1),
('sakith.nethma@example.com', 'password456', 'staff', 2),
('sathindu.danushka@example.com', 'password789', 'staff', 3),
('dinushka.sandeepa@example.com', 'password000', 'staff', 4);

INSERT INTO stock_alert (product_id, message, alert_date) 
VALUES 
(301, 'Low stock for Mushroom substrate', '2025-05-03'),
(302, 'Low stock for Mushroom spores', '2025-05-06'),
(303, 'Low stock for Mushroom Grow Kit', '2025-05-04'),
(304, 'Low stock for Compost', '2025-05-08');

INSERT INTO report (report_type, report_format) 
VALUES 
('Sales Report-Monthly', 'pdf'),
('Inventory Report', 'pdf'),
('Lab Report', 'pdf');


#Queries
#Invetory Managemnet

SELECT item_id, item_name, stock, units
FROM inventory_item;

SELECT item_id, item_name, stock, threshold
FROM inventory_item
WHERE stock < threshold;

UPDATE inventory_item
SET stock = 500
WHERE item_id = 103;

UPDATE supplier
SET contact_number = '0779876543'
WHERE supplier_id = 1;

DELETE FROM material_transfer
WHERE transfer_id = 202;

DELETE FROM purchased_raw_material
WHERE purchase_id = 1003;

SELECT item_id, item_name, category, stock
FROM inventory_item
WHERE category = 'seed';

SELECT * FROM supplier;



#Lab Management
SELECT * FROM mushroom_type WHERE growth_duration = 2;

SELECT batch_id, (successful_count * 100) / initial_quantity AS success_rate
FROM batch;

SELECT * FROM batch WHERE status = 'Active';

SELECT batch_id, SUM(contaminated_today) AS total_contaminated FROM daily_update GROUP BY batch_id;

SELECT * FROM daily_update WHERE contaminated_reason IS NOT NULL;

SELECT batch_id, SUM(quantity) AS total_allocated FROM batch_allocation GROUP BY batch_id;



#Sales and Distribution
UPDATE Product
SET Unit_price = 475.00
WHERE Product_id = 302;

SELECT Product_id, Name, Quantity, Unit_price
FROM Product;

SELECT Preorder_id, Customer_name, Product_id, Quantity, Total_price, Delivery_date
FROM Preorder
WHERE Status = 'pending';

SELECT Preorder_id, Customer_name, Product_id, Quantity, Delivery_date
FROM Preorder
WHERE Delivery_date = CURDATE();

SELECT SUM(Quantity * Unit_price) AS Total_Revenue
FROM WalkinSales;




#Admin and management
INSERT INTO employee (name, nic, phone, address, sex, role) 
VALUES ('Akith Imsara', '200032345678', '0771234567', 'Colombo', 'M', 'lab');

UPDATE employee 
SET name = 'Sakith Nethma', phone = '0777654321', address = 'Padukka', sex = 'M', role = 'inventory' 
WHERE employee_id = 2;

DELETE FROM employee WHERE employee_id = 5;

SELECT * FROM employee;

SELECT * FROM employee;

SELECT * FROM employee WHERE employee_id = 1;

##user
INSERT INTO user (username, password, role, employee_id) 
VALUES ('akith.desilva@example.com', 'password123', 'admin', 1);

UPDATE user 
SET password = 'newpassword123' 
WHERE username = 'akith.desilva@example.com';

DELETE FROM user WHERE username = 'akith.desilva@example.com';

SELECT * FROM user WHERE username = 'akith.desilva@example.com';

SELECT * FROM user WHERE employee_id = 1;

##report
INSERT INTO report (report_type, report_format) 
VALUES ('Sales Report', 'pdf');

SELECT * FROM report;

SELECT * FROM report WHERE report_type IN ('Sales Report', 'Inventory Report');

SELECT * FROM report WHERE rid = 1;

##Alert
SELECT * FROM stock_alert;

SELECT * FROM stock_alert 
WHERE alert_date >= CURDATE() - INTERVAL 7 DAY;

SELECT sa.alert_id, sa.message, sa.alert_date, p.name 
FROM stock_alert sa
JOIN product p ON sa.product_id = p.product_id;



