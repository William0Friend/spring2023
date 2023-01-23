USE CoffeeMerchant
GO
SET NOCOUNT ON
SELECT 'Consumers' AS "Table", COUNT(*) AS "Rows"
FROM   Consumers
     UNION
SELECT 'Countries', COUNT(*)
FROM   Countries
     UNION
SELECT 'Employees', COUNT(*)
FROM   Employees
     UNION
SELECT 'Inventory', COUNT(*)
FROM   Inventory
     UNION
SELECT 'Orderlines', COUNT(*)
FROM   Orderlines
     UNION
SELECT 'Orders', COUNT(*)
FROM   Orders
     UNION
SELECT 'States', COUNT(*)
FROM   States
ORDER BY 1;
SET NOCOUNT OFF
GO