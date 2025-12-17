USE olist;

CREATE TABLE `df_customers` (
`customer_id` Varchar(50),
`customer_unique_id` Varchar(50),
`customer_zip_code_prefix` int not null,
`customer_city` TINYTEXT,
`customer_state` TEXT,
PRIMARY KEY (`customer_id`)
);



SELECT * FROM df_customers;
SELECT * FROM df_order_items;
SELECT * FROM df_order_payments;	
SELECT * FROM df_orders;
SELECT * FROM df_sellers;	

SELECT * FROM df_all;


SELECT *
FROM df_order_items oi
JOIN df_sellers s on oi.seller_id=s.seller_id;


SELECT *
FROM df_customers c 
JOIN df_orders o ON c.customer_id= o.customer_id
JOIN df_order_payments op ON o.order_id = op.order_id;


SELECT *
FROM df_customers c 
JOIN df_orders o ON c.customer_id= o.customer_id
JOIN df_order_payments op ON o.order_id = op.order_id
JOIN df_order_items oi on o.order_id = oi.order_id
JOIN df_sellers s on oi.seller_id=s.seller_id;

SELECT distinct payment_type from df_order_payments;


SELECT
    payment_type,
    ROUND(100.0 * SUM(payment_value) / SUM(SUM(payment_value)) OVER (),2) AS pourcentage
FROM df_order_payments
GROUP BY payment_type;



SELECT *
FROM df_customers c 
JOIN df_orders o ON c.customer_id= o.customer_id
JOIN df_order_payments op ON o.order_id = op.order_id
JOIN df_order_items oi on o.order_id = oi.order_id
JOIN df_sellers s on oi.seller_id=s.seller_id;



SELECT 
    payment_type, 
    COUNT(*) AS nombre_utilisations
FROM 
    df_order_payments
GROUP BY 
    payment_type
ORDER BY 
    nombre_utilisations DESC;
    
CREATE VIEW df_all AS
SELECT 
     o.order_id,
     o.order_purchase_timestamp,
     o.order_approved_at,
     o.order_delivered_customer_date,
     op.payment_type, 
     op.payment_value, 
     oi.product_id,
     oi.price,
     oi.freight_value,
	 s.seller_id,
     s.seller_city
FROM df_customers c
JOIN df_orders o ON c.customer_id = o.customer_id
JOIN df_order_payments op ON o.order_id = op.order_id
JOIN df_order_items oi ON o.order_id = oi.order_id
JOIN df_sellers s ON oi.seller_id = s.seller_id;


SELECT 
    YEAR(order_purchase_timestamp) AS year, 
    ROUND(SUM(payment_value),2) AS turnover
FROM 
    df_all
GROUP BY 
    YEAR(order_purchase_timestamp)
ORDER BY 
    year;
    
    
SELECT title, length AS duration_in_minutes 
FROM film 
ORDER BY length DESC LIMIT 10;


SELECT 
    seller_city, 
    ROUND(SUM(payment_value), 2) AS turnover
FROM 
    df_all
GROUP BY 
    seller_city
ORDER BY 
    turnover DESC
LIMIT 5;	


SELECT 
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    FORMAT(SUM(payment_value) / COUNT(DISTINCT order_id), 2, 'fr_FR') AS AOV
FROM 
    df_all
GROUP BY 
    month
ORDER BY 
    month;
    
SELECT 
    CONCAT(YEAR(order_purchase_timestamp), '-Q', QUARTER(order_purchase_timestamp)) AS QUARTER,
    FORMAT(SUM(payment_value) / COUNT(DISTINCT order_id), 2, 'fr_FR') AS AOV
FROM 
    df_all
GROUP BY 
    QUARTER
ORDER BY 
    QUARTER;
    
    
SELECT 
    YEAR(order_purchase_timestamp) AS year,
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_approved_at)), 2) AS avg_delivery_time_days
FROM 
    df_all
WHERE 
    order_delivered_customer_date IS NOT NULL
GROUP BY 
    year
ORDER BY 
    year;
