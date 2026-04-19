USE olist_delivery_db;
GO

-- delivered orders
SELECT COUNT(*) AS delivered_orders
FROM orders
WHERE order_status = 'delivered';
GO

-- avg delivery days for delivered orders
SELECT AVG(CAST(delivery_days AS INT)) AS avg_delivery_days
FROM orders
WHERE order_status = 'delivered';
GO

-- delivery status split for delivered orders
SELECT
    delivery_status,
    COUNT(*) AS delivery_count
FROM orders
WHERE order_status = 'delivered'
GROUP BY delivery_status
ORDER BY delivery_count DESC;
GO

-- top 10 cities by delivered orders
SELECT TOP 10
    C.customer_city,
    COUNT(*) AS delivered_orders
FROM orders O
JOIN customers C
    ON O.customer_id = C.customer_id
WHERE O.order_status = 'delivered'
GROUP BY C.customer_city
ORDER BY delivered_orders DESC;
GO

-- top 10 cities by late delivered orders
SELECT TOP 10
    C.customer_city,
    COUNT(*) AS late_orders
FROM orders O
JOIN customers C
    ON O.customer_id = C.customer_id
WHERE O.order_status = 'delivered'
  AND O.delivery_status = 'Late'
GROUP BY C.customer_city
ORDER BY late_orders DESC;
GO

-- delivered orders by customer state
SELECT
    C.customer_state,
    COUNT(*) AS delivered_orders
FROM orders O
JOIN customers C
    ON O.customer_id = C.customer_id
WHERE O.order_status = 'delivered'
GROUP BY C.customer_state
ORDER BY delivered_orders DESC;
GO

-- late delivered orders by customer state
SELECT
    C.customer_state,
    COUNT(*) AS late_orders
FROM orders O
JOIN customers C
    ON O.customer_id = C.customer_id
WHERE O.order_status = 'delivered'
  AND O.delivery_status = 'Late'
GROUP BY C.customer_state
ORDER BY late_orders DESC;
GO

-- delivered sales by customer state
SELECT
    C.customer_state,
    ROUND(SUM(CAST(OI.price AS FLOAT)), 2) AS total_sales
FROM orders O
JOIN order_items OI
    ON O.order_id = OI.order_id
JOIN customers C
    ON O.customer_id = C.customer_id
WHERE O.order_status = 'delivered'
GROUP BY C.customer_state
ORDER BY total_sales DESC;
GO

-- delivered freight by customer state
SELECT
    C.customer_state,
    ROUND(SUM(CAST(OI.freight_value AS FLOAT)), 2) AS total_freight
FROM orders O
JOIN order_items OI
    ON O.order_id = OI.order_id
JOIN customers C
    ON O.customer_id = C.customer_id
WHERE O.order_status = 'delivered'
GROUP BY C.customer_state
ORDER BY total_freight DESC;
GO

-- avg delivery days by customer state
SELECT TOP 10
    C.customer_state,
    AVG(CAST(O.delivery_days AS INT)) AS avg_delivery_days
FROM orders O
JOIN customers C
    ON O.customer_id = C.customer_id
WHERE O.order_status = 'delivered'
GROUP BY C.customer_state
ORDER BY avg_delivery_days DESC;
GO

-- top 10 cities by avg delivery days
SELECT TOP 10
    C.customer_city,
    AVG(CAST(O.delivery_days AS INT)) AS avg_delivery_days
FROM orders O
JOIN customers C
    ON O.customer_id = C.customer_id
WHERE O.order_status = 'delivered'
GROUP BY C.customer_city
ORDER BY avg_delivery_days DESC;
GO

-- top seller cities by item count
SELECT TOP 10
    S.seller_city,
    COUNT(*) AS order_item_count
FROM order_items OI
JOIN sellers S
    ON OI.seller_id = S.seller_id
GROUP BY S.seller_city
ORDER BY order_item_count DESC;
GO

-- seller contribution by sales
SELECT TOP 10
    S.seller_id,
    S.seller_city,
    ROUND(SUM(CAST(OI.price AS FLOAT)), 2) AS total_sales
FROM order_items OI
JOIN sellers S
    ON OI.seller_id = S.seller_id
GROUP BY S.seller_id, S.seller_city
ORDER BY total_sales DESC;
GO

-- orders with highest delivery days
SELECT TOP 10
    order_id,
    customer_id,
    delivery_status,
    CAST(delivery_days AS INT) AS delivery_days
FROM orders
WHERE order_status = 'delivered'
ORDER BY CAST(delivery_days AS INT) DESC;
GO

-- late delivery rate % by city (min 100 orders)
SELECT TOP 10
    C.customer_city,
    C.customer_state,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN O.delivery_status = 'Late' THEN 1 ELSE 0 END) AS late_orders,
    ROUND(
        SUM(CASE WHEN O.delivery_status = 'Late' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2) AS late_rate_pct
FROM orders O
JOIN customers C ON O.customer_id = C.customer_id
WHERE O.order_status = 'delivered'
GROUP BY C.customer_city, C.customer_state
HAVING COUNT(*) >= 100
ORDER BY late_rate_pct DESC;
GO

-- total sales + freight combined
SELECT
    ROUND(SUM(CAST(OI.price AS FLOAT)), 2)         AS total_sales_brl,
    ROUND(SUM(CAST(OI.freight_value AS FLOAT)), 2) AS total_freight_brl,
    ROUND(SUM(CAST(OI.price AS FLOAT)
        + CAST(OI.freight_value AS FLOAT)), 2)      AS total_revenue_brl
FROM order_items OI
JOIN orders O ON OI.order_id = O.order_id
WHERE O.order_status = 'delivered';
GO

-- monthly order and late delivery trend
SELECT
    YEAR(CAST(order_purchase_timestamp AS DATETIME))  AS order_year,
    MONTH(CAST(order_purchase_timestamp AS DATETIME)) AS order_month,
    COUNT(*)                                           AS total_orders,
    SUM(CASE WHEN delivery_status = 'Late'
        THEN 1 ELSE 0 END)                            AS late_orders
FROM orders
WHERE order_status = 'delivered'
GROUP BY
    YEAR(CAST(order_purchase_timestamp AS DATETIME)),
    MONTH(CAST(order_purchase_timestamp AS DATETIME))
ORDER BY order_year, order_month;
GO