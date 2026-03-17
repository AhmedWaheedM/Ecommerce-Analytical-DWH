DROP DATABASE IF EXISTS ecommerce_dw;
CREATE DATABASE ecommerce_dw;
USE ecommerce_dw;

DROP TABLE IF EXISTS Fact_Order_Line;
DROP TABLE IF EXISTS Dim_Date;
DROP TABLE IF EXISTS Dim_Customer;
DROP TABLE IF EXISTS Dim_Product;
DROP TABLE IF EXISTS Dim_Category;
DROP TABLE IF EXISTS Dim_Payment;
DROP TABLE IF EXISTS Dim_Shipping;

-- ============================================================
-- 1. DIM_DATE
-- ============================================================
CREATE TABLE Dim_Date (
    date_key     INT          NOT NULL,
    full_date    DATE         NOT NULL,
    day          INT          NOT NULL,
    month        INT          NOT NULL,
    month_name   VARCHAR(20)  NOT NULL,
    quarter      INT          NOT NULL,
    year         INT          NOT NULL,
    week_number  INT          NOT NULL,
    CONSTRAINT pk_dim_date PRIMARY KEY (date_key)
);

-- ============================================================
-- 2. DIM_CUSTOMER
-- ============================================================
CREATE TABLE Dim_Customer (
    customer_key       INT          NOT NULL,
    customer_id        VARCHAR(20)  NOT NULL,
    gender             VARCHAR(10),
    age_group          VARCHAR(20),
    city               VARCHAR(50),
    region             VARCHAR(50),
    registration_date  DATE,
    customer_segment   VARCHAR(30),
    CONSTRAINT pk_dim_customer PRIMARY KEY (customer_key)
);

-- ============================================================
-- 3. DIM_PRODUCT
-- ============================================================
CREATE TABLE Dim_Product (
    product_key      INT           NOT NULL,
    product_id       VARCHAR(20)   NOT NULL,
    product_name     VARCHAR(100)  NOT NULL,
    brand            VARCHAR(50),
    subcategory      VARCHAR(50),
    launch_date      DATE,
    stock_available  INT           DEFAULT 0,
    CONSTRAINT pk_dim_product PRIMARY KEY (product_key)
);

-- ============================================================
-- 4. DIM_CATEGORY
-- ============================================================
CREATE TABLE Dim_Category (
    category_key     INT          NOT NULL,
    category_name    VARCHAR(50)  NOT NULL,
    parent_category  VARCHAR(50),
    seasonal_flag    BOOLEAN      DEFAULT FALSE,
    CONSTRAINT pk_dim_category PRIMARY KEY (category_key)
);

-- ============================================================
-- 5. DIM_PAYMENT
-- ============================================================
CREATE TABLE Dim_Payment (
    payment_key     INT          NOT NULL,
    payment_method  VARCHAR(30)  NOT NULL,
    CONSTRAINT pk_dim_payment PRIMARY KEY (payment_key)
);

-- ============================================================
-- 6. DIM_SHIPPING
-- ============================================================
CREATE TABLE Dim_Shipping (
    shipping_key   INT          NOT NULL,
    shipping_type  VARCHAR(30)  NOT NULL,
    delivery_days  INT          NOT NULL,
    CONSTRAINT pk_dim_shipping PRIMARY KEY (shipping_key)
);

-- ============================================================
-- 7. FACT_ORDER_LINE 
-- ============================================================
CREATE TABLE Fact_Order_Line (
    order_line_id   INT            NOT NULL,
    order_id        INT            NOT NULL,
    date_key        INT            NOT NULL,
    customer_key    INT            NOT NULL,
    product_key     INT            NOT NULL,
    category_key    INT            NOT NULL,
    payment_key     INT            NOT NULL,
    shipping_key    INT            NOT NULL,
    quantity        INT            NOT NULL,
    gross_amount    DECIMAL(12,2)  NOT NULL,
    discount_amount DECIMAL(12,2)  DEFAULT 0,
    net_amount      DECIMAL(12,2)  NOT NULL,
    cost_amount     DECIMAL(12,2)  NOT NULL,
    profit_amount   DECIMAL(12,2)  NOT NULL,

    CONSTRAINT pk_fact_order_line PRIMARY KEY (order_line_id),
    CONSTRAINT fk_fact_date     FOREIGN KEY (date_key)     REFERENCES Dim_Date(date_key),
    CONSTRAINT fk_fact_customer FOREIGN KEY (customer_key) REFERENCES Dim_Customer(customer_key),
    CONSTRAINT fk_fact_product  FOREIGN KEY (product_key)  REFERENCES Dim_Product(product_key),
    CONSTRAINT fk_fact_category FOREIGN KEY (category_key) REFERENCES Dim_Category(category_key),
    CONSTRAINT fk_fact_payment  FOREIGN KEY (payment_key)  REFERENCES Dim_Payment(payment_key),
    CONSTRAINT fk_fact_shipping FOREIGN KEY (shipping_key) REFERENCES Dim_Shipping(shipping_key)
);

-- ============================================================
-- INDEXES
-- ============================================================
CREATE INDEX idx_fact_date     ON Fact_Order_Line(date_key);
CREATE INDEX idx_fact_customer ON Fact_Order_Line(customer_key);
CREATE INDEX idx_fact_product  ON Fact_Order_Line(product_key);
CREATE INDEX idx_fact_category ON Fact_Order_Line(category_key);
CREATE INDEX idx_fact_order    ON Fact_Order_Line(order_id);