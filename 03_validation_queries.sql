USE olist_delivery_db;
GO

-- row counts
SELECT COUNT(*) AS customers_count
FROM customers;
GO

SELECT COUNT(*) AS sellers_count
FROM sellers;
GO

SELECT COUNT(*) AS order_items_count
FROM order_items;
GO

SELECT COUNT(*) AS orders_count
FROM orders;
GO

-- quick data check
SELECT TOP 5 *
FROM customers;
GO

SELECT TOP 5 *
FROM sellers;
GO

SELECT TOP 5 *
FROM order_items;
GO

SELECT TOP 5 *
FROM orders;
GO

-- order status values
SELECT DISTINCT order_status
FROM orders;
GO

-- delivery status values
SELECT DISTINCT delivery_status
FROM orders;
GO

-- order status counts
SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;
GO

-- delivery status counts
SELECT
    delivery_status,
    COUNT(*) AS delivery_count
FROM orders
GROUP BY delivery_status
ORDER BY delivery_count DESC;
GO

-- join integrity check: orders without matching customer (expect 0)
SELECT COUNT(*) AS orders_missing_customer
FROM orders O
LEFT JOIN customers C ON O.customer_id = C.customer_id
WHERE C.customer_id IS NULL;
GO

-- join integrity check: order items without matching seller (expect 0)
SELECT COUNT(*) AS items_missing_seller
FROM order_items OI
LEFT JOIN sellers S ON OI.seller_id = S.seller_id
WHERE S.seller_id IS NULL;
GO

-- delivery days sanity check
SELECT
    MIN(CAST(delivery_days AS INT)) AS min_days,
    MAX(CAST(delivery_days AS INT)) AS max_days,
    AVG(CAST(delivery_days AS INT)) AS avg_days
FROM orders
WHERE order_status = 'delivered';
GO