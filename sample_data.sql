USE ecommerce_dw;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE Fact_Order_Line;
TRUNCATE TABLE Dim_Date;
TRUNCATE TABLE Dim_Customer;
TRUNCATE TABLE Dim_Product;
TRUNCATE TABLE Dim_Category;
TRUNCATE TABLE Dim_Payment;
TRUNCATE TABLE Dim_Shipping;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- 1. DIM_DATE
-- ============================================================
INSERT INTO Dim_Date (date_key, full_date, day, month, month_name, quarter, year, week_number)
WITH RECURSIVE date_series AS (
    SELECT DATE('2023-01-01') AS dt
    UNION ALL
    SELECT dt + INTERVAL 1 DAY
    FROM date_series
    WHERE dt < '2024-12-31'
)
SELECT DATE_FORMAT(dt, '%Y%m%d'), dt, DAY(dt), MONTH(dt), MONTHNAME(dt), QUARTER(dt), YEAR(dt), WEEK(dt)
FROM date_series;

-- ============================================================
-- 2. DIM_CUSTOMER
-- ============================================================
INSERT INTO Dim_Customer (customer_key, customer_id, gender, age_group, city, region, registration_date, customer_segment) VALUES
(1, 'CUST001','Male',  '25-34','Cairo',          'North','2022-03-15','VIP'),
(2, 'CUST002','Female','18-24','Alexandria',      'North','2022-06-20','Regular'),
(3, 'CUST003','Male',  '35-44','Giza',            'North','2021-11-10','VIP'),
(4, 'CUST004','Female','25-34','Luxor',           'South','2023-01-05','New'),
(5, 'CUST005','Male',  '45-54','Aswan',           'South','2021-08-22','VIP'),
(6, 'CUST006','Female','18-24','Cairo',           'North','2023-03-18','New'),
(7, 'CUST007','Male',  '35-44','Mansoura',        'Delta','2022-05-30','Regular'),
(8, 'CUST008','Female','25-34','Tanta',           'Delta','2022-09-14','Regular'),
(9, 'CUST009','Male',  '18-24','Port Said',       'East', '2023-07-01','New'),
(10,'CUST010','Female','45-54','Suez',            'East', '2021-12-25','VIP'),
(11,'CUST011','Male',  '25-34','Cairo',           'North','2022-04-11','Regular'),
(12,'CUST012','Female','35-44','Alexandria',      'North','2021-07-19','VIP'),
(13,'CUST013','Male',  '18-24','Giza',            'North','2023-02-28','New'),
(14,'CUST014','Female','25-34','Ismailia',        'East', '2022-10-03','Regular'),
(15,'CUST015','Male',  '45-54','Hurghada',        'South','2021-05-17','VIP'),
(16,'CUST016','Female','18-24','Cairo',           'North','2023-08-09','New'),
(17,'CUST017','Male',  '35-44','Zagazig',         'Delta','2022-01-23','Regular'),
(18,'CUST018','Female','25-34','Sharm El Sheikh', 'South','2022-11-30','Regular'),
(19,'CUST019','Male',  '55+',  'Cairo',           'North','2020-06-14','VIP'),
(20,'CUST020','Female','35-44','Alexandria',      'North','2021-09-08','Regular');

-- ============================================================
-- 3. DIM_CATEGORY
-- ============================================================
INSERT INTO Dim_Category (category_key, category_name, parent_category, seasonal_flag) VALUES
(1,'Electronics',  'Technology',FALSE),
(2,'Fashion',      'Lifestyle', TRUE),
(3,'Home & Living','Lifestyle', FALSE),
(4,'Sports',       'Health',    TRUE),
(5,'Books',        'Education', FALSE);

-- ============================================================
-- 4. DIM_PRODUCT
-- ============================================================
INSERT INTO Dim_Product (product_key, product_id, product_name, brand, subcategory, launch_date, stock_available) VALUES
(1, 'PROD001','Samsung Galaxy S24',    'Samsung',  'Smartphones', '2024-01-15',85),
(2, 'PROD002','Apple iPhone 15',       'Apple',    'Smartphones', '2023-09-22',60),
(3, 'PROD003','Sony WH-1000XM5',       'Sony',     'Headphones',  '2023-05-10',120),
(4, 'PROD004','Dell XPS 15 Laptop',    'Dell',     'Laptops',     '2023-03-01',40),
(5, 'PROD005','Nike Air Max 270',      'Nike',     'Sneakers',    '2023-02-14',200),
(6, 'PROD006','Adidas Ultraboost 23',  'Adidas',   'Sneakers',    '2023-04-20',175),
(7, 'PROD007','Zara Slim Fit Shirt',   'Zara',     'Shirts',      '2023-06-01',300),
(8, 'PROD008','H&M Winter Jacket',     'H&M',      'Jackets',     '2023-09-15',95),
(9, 'PROD009','Dyson V15 Vacuum',      'Dyson',    'Appliances',  '2023-01-20',55),
(10,'PROD010','IKEA KALLAX Shelf',     'IKEA',     'Furniture',   '2022-11-05',80),
(11,'PROD011','Nespresso Vertuo',      'Nespresso','Kitchen',     '2023-07-12',110),
(12,'PROD012','Philips Air Purifier',  'Philips',  'Appliances',  '2023-08-30',45),
(13,'PROD013','Yoga Mat Premium',      'Decathlon','Yoga',        '2023-03-10',250),
(14,'PROD014','Protein Whey 2kg',      'MyProtein','Supplements', '2023-05-25',400),
(15,'PROD015','Garmin Forerunner 255', 'Garmin',   'Smartwatches','2023-06-18',70),
(16,'PROD016','Resistance Band Set',   'Decathlon','Fitness',     '2023-02-28',320),
(17,'PROD017','Atomic Habits',         'Penguin',  'Self-Help',   '2018-10-16',500),
(18,'PROD018','Clean Code',            'Prentice', 'Programming', '2008-08-01',350),
(19,'PROD019','Psychology of Money',   'Morgan',   'Finance',     '2020-09-08',420),
(20,'PROD020','Designing Data Systems','OReilly',  'Programming', '2017-03-16',280);

-- ============================================================
-- 5. DIM_PAYMENT 
-- ============================================================
INSERT INTO Dim_Payment (payment_key, payment_method) VALUES
(1,'Credit Card'),
(2,'Debit Card'),
(3,'Digital Wallet'),
(4,'Cash on Delivery');

-- ============================================================
-- 6. DIM_SHIPPING 
-- ============================================================
INSERT INTO Dim_Shipping (shipping_key, shipping_type, delivery_days) VALUES
(1,'Standard', 5),
(2,'Express',  2),
(3,'Same-Day', 1);

-- ============================================================
-- 7. FACT_ORDER_LINE
-- ============================================================
INSERT INTO Fact_Order_Line (
    order_line_id, order_id, date_key, customer_key, product_key, 
    category_key, payment_key, shipping_key, quantity, 
    gross_amount, discount_amount, net_amount, cost_amount, profit_amount
)
WITH RECURSIVE seq AS (
    SELECT 1 AS id
    UNION ALL
    SELECT id + 1 FROM seq WHERE id < 1000
),
seeded_data AS (
    -- We use RAND(id + constant) to 'lock' the random values for each row
    SELECT 
        id AS order_line_id,
        1000 + FLOOR(id / 2) AS order_id,
        -- Random date between 2023-01-01 and 2024-12-31
        CAST(DATE_FORMAT(DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND(id + 1) * 730) DAY), '%Y%m%d') AS UNSIGNED) AS date_key,
        FLOOR(1 + RAND(id + 2) * 20) AS customer_key,
        FLOOR(1 + RAND(id + 3) * 20) AS product_key,
        FLOOR(1 + RAND(id + 4) * 4) AS payment_key,
        FLOOR(1 + RAND(id + 5) * 3) AS shipping_key,
        FLOOR(1 + RAND(id + 6) * 5) AS qty,
        (50 + RAND(id + 7) * 500) AS unit_price,
        (RAND(id + 8) * 0.2) AS disc_percent -- Max 20% discount
    FROM seq
),
final_calculations AS (
    -- Perform math in a single pass using the locked values
    SELECT 
        order_line_id, order_id, date_key, customer_key, product_key,
        CEIL(product_key / 4) AS category_key,
        payment_key, shipping_key, qty,
        ROUND(qty * unit_price, 2) AS gross,
        ROUND((qty * unit_price) * disc_percent, 2) AS disc,
        ROUND((qty * unit_price) * 0.60, 2) AS cost -- 60% base cost
    FROM seeded_data
)
SELECT 
    order_line_id, order_id, date_key, customer_key, product_key, category_key, 
    payment_key, shipping_key, qty,
    gross, 
    disc, 
    (gross - disc) AS net_amount, 
    cost AS cost_amount, 
    ((gross - disc) - cost) AS profit_amount
FROM final_calculations;

-- ============================================================
-- VERIFY
-- ============================================================
SELECT 'Dim_Date'        AS tbl, COUNT(*) AS `rows` FROM Dim_Date        UNION ALL
SELECT 'Dim_Customer',           COUNT(*)            FROM Dim_Customer    UNION ALL
SELECT 'Dim_Product',            COUNT(*)            FROM Dim_Product     UNION ALL
SELECT 'Dim_Category',           COUNT(*)            FROM Dim_Category    UNION ALL
SELECT 'Dim_Payment',            COUNT(*)            FROM Dim_Payment     UNION ALL
SELECT 'Dim_Shipping',           COUNT(*)            FROM Dim_Shipping    UNION ALL
SELECT 'Fact_Order_Line',        COUNT(*)            FROM Fact_Order_Line;