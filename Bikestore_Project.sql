/* Find the city name of the customer first name starts with 'E' and last name ends with 'Lopez' */ 

SELECT 
    CONCAT(cus.first_name, ' ', cus.last_name) AS Customer,
	cus.city
FROM sales.orders ord
JOIN sales.customers cus 
ON ord.customer_id = cus.customer_id
WHERE 
    cus.first_name LIKE 'E%' 
    AND cus.last_name LIKE '%Lopez%';



/* Top 5 solded bike types */
SELECT Top 5
	cat.category_name,
	SUM(ite.quantity) AS 'total_units'
From sales.orders ord
JOIN sales.order_items ite
ON ord.order_id = ite.order_id
JOIN production.products pro
ON ite.product_id = pro.product_id
JOIN production.categories cat
ON pro.category_id = cat.category_id
GROUP BY
	cat.category_name
ORDER BY
	total_units DESC;


/* Bikes that have average unit price greater than 1000 */
SELECT
    cat.category_name,
    AVG(ite.list_price) AS avg_price_per_unit
FROM sales.order_items ite
JOIN production.products pro 
ON ite.product_id = pro.product_id
JOIN production.categories cat 
ON pro.category_id = cat.category_id
GROUP BY
    cat.category_name
HAVING
    AVG(ite.list_price) > 1000;

/* Total revenue of each store */
select
	sto.store_name,
	SUM(ite.quantity * ite.list_price) AS 'revenue'
From sales.orders ord
JOIN sales.order_items ite
ON ord.order_id = ite.order_id
JOIN sales.stores sto
ON ord.store_id = sto.store_id
GROUP BY sto.store_name
ORDER BY revenue DESC;

/* Revenue of each store in date wise for january month in 2016 */
select
	ord.order_date,
	sto.store_name,
	SUM(ite.quantity * ite.list_price) AS 'revenue'
From sales.orders ord
JOIN sales.order_items ite
ON ord.order_id = ite.order_id
JOIN sales.stores sto
ON ord.store_id = sto.store_id
WHERE
    ord.order_date >= '2016-01-01' AND ord.order_date < '2016-02-01'
GROUP BY 
	ord.order_date,
	sto.store_name
ORDER BY 
	ord.order_date;

/* selecting all the necessary columns from all the tables to further analyze*/

Select 
	ord.order_id,
	CONCAT(cus.first_name,' ',cus.last_name) AS 'Customer',
	cus.city,
	cus.state,
	ord.order_date,
	SUM(ite.quantity) AS 'total units',
	SUM(ite.quantity * ite.list_price) AS 'revenue',
	pro.product_name,
	cat.category_name,
	sto.store_name,
	CONCAT(sta.first_name,' ',sta.last_name) AS 'sales_rep'
From sales.orders ord
JOIN sales.customers cus
ON ord.customer_id = cus.customer_id
JOIN sales.order_items ite
ON ord.order_id = ite.order_id
JOIN production.products pro
ON ite.product_id = pro.product_id
JOIN production.categories cat
ON pro.category_id = cat.category_id
JOIN sales.stores sto
ON ord.store_id = sto.store_id
JOIN sales.staffs sta
ON ord.staff_id = sta.staff_id
GROUP BY
	ord.order_id,
	CONCAT(cus.first_name,' ',cus.last_name),
	cus.city,
	cus.state,
	ord.order_date,
	pro.product_name,
	cat.category_name,
	sto.store_name,
	CONCAT(sta.first_name,' ',sta.last_name)
