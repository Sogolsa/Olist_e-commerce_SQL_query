/* The Business Task:
1.Find and Compare Revenue per month from 2 different years.
2. Which product category has the highest revenue?
*/

-------------------------------------------------------------------
--Cleaning order_items table

--A. Order_item_id is nvarchar, which i'm going to convert it to integer or tinyint

SELECT*
FROM [e-commerce].dbo.olist_order_items
ORDER BY OrderItemID

SELECT DISTINCT(OrderItemID)
FROM [e-commerce].dbo.olist_order_items
ORDER BY OrderItemID DESC


SELECT CAST(order_item_id AS tinyint) AS OrderItemID
FROM [e-commerce].dbo.olist_order_items

UPDATE [e-commerce].dbo.olist_order_items
SET order_item_id = CAST(order_item_id AS tinyint)

ALTER TABLE [e-commerce].dbo.olist_order_items
ADD OrderItemID tinyint;

UPDATE [e-commerce].dbo.olist_order_items
SET OrderItemID = CAST(order_item_id AS tinyint)


SELECT*
FROM [e-commerce].dbo.olist_order_items  --product Id/order_id

--B. Deleting duplicates in order_items table

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY product_id,
				 OrderItemID,
				 ShippingLimitDate,
				 price,
				 Seller_id,
				 freight_value
				 ORDER BY
					order_id
					) AS row_num

FROM [e-commerce].dbo.olist_order_items
)
DELETE FROM RowNumCTE
WHERE row_num > 1
--3541 rows were deleted

-------------------------------------------------------------------------------------------
--Exploting the products table

SELECT*
FROM [e-commerce].dbo.olist_products
--all columns are in right formatting

--Checking for Duplicates/There is not any duplicates in products table

WITH ProductCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY product_id,
				 product_category_name,
				 product_description_lenght,
				 Product_weight_g,
				 product_length_cm,
				 product_height_cm,
				 product_width_cm,
				 product_photos_qty
				 ORDER BY
					product_id
					) AS row_num

FROM [e-commerce].dbo.olist_products
)
select* FROM ProductCTE
WHERE row_num > 1
order by product_id

-----------------------------------------------------------------
--Slight adjustments in translation column
--Transfered the first row as the column name
SELECT*
FROM [e-commerce].dbo.product_category_name_translation

DELETE FROM [e-commerce].dbo.product_category_name_translation
WHERE column1 = 'product_category_name'
AND column2 = 'product_category_name_english'


----------------------------------------------

SELECT*
FROM [e-commerce].dbo.olist_orders_dataset


-- Exploring and cleaning the orders_dataset
SELECT order_id, order_approved_at, Order_delivered_customer_date, order_delivered_carrier_date, order_status
FROM [e-commerce].dbo.olist_orders_dataset
WHERE order_delivered_customer_date is null

SELECT order_id, order_approved_at, Order_delivered_customer_date, order_delivered_carrier_date, order_status
FROM [e-commerce].dbo.olist_orders_dataset
WHERE order_approved_at is null


SELECT DISTINCT(order_status), Count(order_status)
FROM [e-commerce].dbo.olist_orders_dataset
GROUP BY order_status
ORDER BY 2

--Duplicates Check For order dataset /No duplicates

WITH OrderCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY order_id,
				 customer_id,
				 order_status,
				 order_purchase_timestamp,
				 order_approved_at,
				 order_delivered_carrier_date,
				 order_delivered_customer_date,
				 order_estimated_delivery_date
				 ORDER BY
					order_id
					) AS row_num

FROM [e-commerce].dbo.olist_orders_dataset
)
SELECT* FROM OrderCTE
WHERE row_num > 1
ORDER BY order_id

--------------------------------------------------
--Exploring the Payments table
SELECT* 
FROM [e-commerce].dbo.olist_order_payments

--Changing payment_installment formatting for later use
SELECT CAST(payment_installments AS int)
FROM [e-commerce].dbo.olist_order_payments
 
UPDATE [e-commerce].dbo.olist_order_payments
SET payment_installments = CAST(payment_installments AS int)

ALTER TABLE [e-commerce].dbo.olist_order_payments
ADD PaymentInstallments INT;

UPDATE [e-commerce].dbo.olist_order_payments
SET PaymentInstallments = CAST(payment_installments AS INT)

--No duplicates in payment table
WITH PaymentCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY order_id,
				 payment_sequential,
				 payment_type,
				 payment_installments,
				 payment_value
				 ORDER BY
					order_id
					) AS row_num

FROM [e-commerce].dbo.olist_order_payments
)
SELECT* FROM PaymentCTE
WHERE row_num > 1


------------------------------------------------------------------------------
---Joining tables together
SELECT a.order_id, a.payment_value, b.OrderItemID, b.product_id, b.price, 
YEAR(e.order_purchase_timestamp) AS year, MONTH(e.order_purchase_timestamp) AS month, 
d.product_category_name_english, e.order_status
FROM  [e-commerce].dbo.olist_order_payments a
JOIN [e-commerce].dbo.olist_order_items b
ON a.order_id = b.order_id
JOIN [e-commerce].dbo.olist_products c
ON b.product_id = c.product_id
JOIN [e-commerce].dbo.product_category_name_translation d
ON c.product_category_name = d.product_category_name
JOIN [e-commerce].dbo.olist_orders_dataset e
ON a.order_id = e.order_id
WHERE e.order_status <> 'canceled' AND e.order_status <> 'unavailable' 
AND YEAR(e.order_purchase_timestamp) = 2017
ORDER BY month(e.order_purchase_timestamp)



----Create vusualization for 2017 revenue
SELECT 
YEAR(e.order_purchase_timestamp) AS year, MONTH(e.order_purchase_timestamp) AS month, 
SUM(a.payment_value) AS Revenue
FROM  [e-commerce].dbo.olist_order_payments a
JOIN [e-commerce].dbo.olist_order_items b
ON a.order_id = b.order_id
JOIN [e-commerce].dbo.olist_products c
ON b.product_id = c.product_id
JOIN [e-commerce].dbo.product_category_name_translation d
ON c.product_category_name = d.product_category_name
JOIN [e-commerce].dbo.olist_orders_dataset e
ON a.order_id = e.order_id
WHERE e.order_status <> 'canceled' AND e.order_status <> 'unavailable' 
AND YEAR(e.order_purchase_timestamp) = 2017
GROUP BY YEAR(e.order_purchase_timestamp), MONTH(e.order_purchase_timestamp)
ORDER BY MONTH(e.order_purchase_timestamp)

CREATE VIEW MonthlyRevenue2017 AS
SELECT YEAR(e.order_purchase_timestamp) AS year, MONTH(e.order_purchase_timestamp) AS month, 
SUM(a.payment_value) AS Revenue
FROM  [e-commerce].dbo.olist_order_payments a
JOIN [e-commerce].dbo.olist_order_items b
ON a.order_id = b.order_id
JOIN [e-commerce].dbo.olist_products c
ON b.product_id = c.product_id
JOIN [e-commerce].dbo.product_category_name_translation d
ON c.product_category_name = d.product_category_name
JOIN [e-commerce].dbo.olist_orders_dataset e
ON a.order_id = e.order_id
WHERE e.order_status <> 'canceled' AND e.order_status <> 'unavailable' 
AND YEAR(e.order_purchase_timestamp) = 2017
GROUP BY YEAR(e.order_purchase_timestamp), MONTH(e.order_purchase_timestamp)

---Monthly Revenue for 2018
SELECT 
YEAR(e.order_purchase_timestamp) AS year, MONTH(e.order_purchase_timestamp) AS month, 
SUM(a.payment_value) AS Revenue
FROM  [e-commerce].dbo.olist_order_payments a
JOIN [e-commerce].dbo.olist_order_items b
ON a.order_id = b.order_id
JOIN [e-commerce].dbo.olist_products c
ON b.product_id = c.product_id
JOIN [e-commerce].dbo.product_category_name_translation d
ON c.product_category_name = d.product_category_name
JOIN [e-commerce].dbo.olist_orders_dataset e
ON a.order_id = e.order_id
WHERE e.order_status <> 'canceled' AND e.order_status <> 'unavailable' 
AND YEAR(e.order_purchase_timestamp) = 2018
GROUP BY YEAR(e.order_purchase_timestamp), MONTH(e.order_purchase_timestamp)
order by MONTH(e.order_purchase_timestamp)



--Revenue for 2017 and 2018/creating year over year visualization
SELECT 
YEAR(e.order_purchase_timestamp) AS year, MONTH(e.order_purchase_timestamp) AS month,
SUM(a.payment_value) AS Revenue
FROM  [e-commerce].dbo.olist_order_payments a
JOIN [e-commerce].dbo.olist_order_items b
ON a.order_id = b.order_id
JOIN [e-commerce].dbo.olist_products c
ON b.product_id = c.product_id
JOIN [e-commerce].dbo.product_category_name_translation d
ON c.product_category_name = d.product_category_name
JOIN [e-commerce].dbo.olist_orders_dataset e
ON a.order_id = e.order_id
WHERE e.order_status <> 'canceled' AND e.order_status <> 'unavailable' 
AND YEAR(e.order_purchase_timestamp) = 2017 OR YEAR(e.order_purchase_timestamp) = 2018
GROUP BY YEAR(e.order_purchase_timestamp), MONTH(e.order_purchase_timestamp)
order by YEAR(e.order_purchase_timestamp), MONTH(e.order_purchase_timestamp)



--Revenue based on product category

SELECT 
d.product_category_name_english, SUM(a.payment_value) AS ProductRevenue
FROM  [e-commerce].dbo.olist_order_payments a
JOIN [e-commerce].dbo.olist_order_items b
ON a.order_id = b.order_id
JOIN [e-commerce].dbo.olist_products c
ON b.product_id = c.product_id
JOIN [e-commerce].dbo.product_category_name_translation d
ON c.product_category_name = d.product_category_name
JOIN [e-commerce].dbo.olist_orders_dataset e
ON a.order_id = e.order_id
WHERE e.order_status <> 'canceled' AND e.order_status <> 'unavailable' 
GROUP BY d.product_category_name_english
ORDER BY ProductRevenue DESC


