USE olist_delivery_db;
GO

IF OBJECT_ID('dbo.customers', 'U') IS NOT NULL
    DROP TABLE dbo.customers;
GO

CREATE TABLE dbo.customers (
    customer_id NVARCHAR(100),
    customer_unique_id NVARCHAR(100),
    customer_zip_code_prefix NVARCHAR(20),
    customer_city NVARCHAR(100),
    customer_state NVARCHAR(20)
);
GO

IF OBJECT_ID('dbo.sellers', 'U') IS NOT NULL
    DROP TABLE dbo.sellers;
GO

CREATE TABLE dbo.sellers (
    seller_id NVARCHAR(100),
    seller_zip_code_prefix NVARCHAR(20),
    seller_city NVARCHAR(200),
    seller_state NVARCHAR(20)
);
GO

IF OBJECT_ID('dbo.order_items', 'U') IS NOT NULL
    DROP TABLE dbo.order_items;
GO

CREATE TABLE dbo.order_items (
    order_id NVARCHAR(100),
    order_item_id NVARCHAR(20),
    product_id NVARCHAR(100),
    seller_id NVARCHAR(100),
    shipping_limit_date NVARCHAR(50),
    price NVARCHAR(50),
    freight_value NVARCHAR(50)
);
GO

IF OBJECT_ID('dbo.orders', 'U') IS NOT NULL
    DROP TABLE dbo.orders;
GO

CREATE TABLE dbo.orders (
    order_id NVARCHAR(100),
    customer_id NVARCHAR(100),
    order_status NVARCHAR(50),
    order_purchase_timestamp NVARCHAR(50),
    order_approved_at NVARCHAR(50),
    order_delivered_carrier_date NVARCHAR(50),
    order_delivered_customer_date NVARCHAR(50),
    order_estimated_delivery_date NVARCHAR(50),
    delivery_status NVARCHAR(20),
    delivery_days NVARCHAR(20)
);
GO