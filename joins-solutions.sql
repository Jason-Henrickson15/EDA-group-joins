BASE MODE:
Get all customers and their addresses.
SELECT "customers"."id", "customers"."first_name", "customers"."last_name", "addresses"."street", "addresses"."city", "addresses"."state", "addresses"."zip",
"addresses"."address_type"
FROM "customers"
JOIN "addresses" ON "customers"."id" = "addresses"."customer_id";

Get all orders and their line items (orders, quantity and product).
SELECT "orders"."id", "line_items"."quantity", "products"."description" FROM "orders"
JOIN "line_items" ON "orders"."id" = "line_items"."order_id"
JOIN "products" ON "line_items"."product_id" = "products"."id";

Which warehouses have cheetos?
delta
SELECT "warehouse"."warehouse", "products"."description" FROM "warehouse"
JOIN "warehouse_product" ON "warehouse"."id" = "warehouse_product"."warehouse_id"
JOIN "products" ON "warehouse_product"."product_id" = "products"."id"
WHERE "products"."description" = 'cheetos';


Which warehouses have diet pepsi?
alpha, delta, gamma
SELECT "warehouse"."warehouse", "products"."description" FROM "warehouse"
JOIN "warehouse_product" ON "warehouse"."id" = "warehouse_product"."warehouse_id"
JOIN "products" ON "warehouse_product"."product_id" = "products"."id"
WHERE "products"."description" = 'diet pepsi';

Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT "customers"."id", "customers"."first_name", "customers"."last_name",
count("orders"."id") as "numOrders"
FROM "orders"
JOIN "addresses" ON "orders"."address_id" = "addresses"."id"
JOIN "customers" ON "addresses"."customer_id" = "customers"."id"
GROUP BY "customers"."id";

How many customers do we have?
4
SELECT count("customers"."id") FROM "customers";

How many products do we carry?
11
SELECT count("warehouse_product"."product_id") FROM "warehouse_product";

What is the total available on-hand quantity of diet pepsi?
92
SELECT sum("warehouse_product"."on_hand") FROM "warehouse_product"
JOIN "products" ON "warehouse_product"."product_id" = "products"."id"
WHERE "products"."description" = 'diet pepsi';

STRETCH MODE:
How much was the total cost for each order?
1 = 70
2 = 18.99
3 = 7.20
4 = 138.43
5 = 96.71
6 = 85.86
7 = 64.91

SELECT "orders"."id", sum("line_items"."quantity"*"products"."unit_price") as "total" FROM "orders"
JOIN "line_items" ON "orders"."id" = "line_items"."order_id"
JOIN "products" ON "line_items"."product_id" = "products"."id"
GROUP BY "orders"."id"
ORDER BY "orders"."id";

How much has each customer spent in total?
Lisa = 161.10
Charles = 138.43
Lucy = 182.57

SELECT "customers"."id", "customers"."first_name", "customers"."last_name", sum("line_items"."quantity"*"products"."unit_price") AS "total spent" FROM "orders"
JOIN "line_items" ON "orders"."id" = "line_items"."order_id"
JOIN "products" ON "line_items"."product_id" = "products"."id"
JOIN "addresses" ON "orders"."address_id" = "addresses"."id"
JOIN "customers" ON "addresses"."customer_id" = "customers"."id"
GROUP BY "customers"."id"
ORDER BY "customers"."id";


How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).
