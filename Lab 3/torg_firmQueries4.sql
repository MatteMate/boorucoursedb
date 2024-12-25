-- Загальна кількість товарів на підприємстві
SELECT SUM(NaSklade) AS TotalQuantity
FROM tovar;
-- Загальна кількість співробітників підприємства
SELECT COUNT(*) AS TotalEmployees
FROM sotrudnik;
-- Загальна кількість постачальників підприємства
SELECT COUNT(DISTINCT id_postav) AS TotalSuppliers
FROM tovar;
-- Кількість за кожним товаром, що придбані у поточному місяці
SELECT t.Nazva, SUM(zt.Kilkist) AS TotalQuantity
FROM zakaz_tovar zt
JOIN tovar t ON zt.id_tovar = t.id_tovar
JOIN zakaz z ON zt.id_zakaz = z.id_zakaz
WHERE MONTH(z.date_rozm) = 08
  AND YEAR(z.date_rozm) = 2022
GROUP BY t.Nazva;
-- Сума, на яку були придбані товари у поточному місяці
SELECT SUM(zt.Kilkist * t.Price) AS TotalAmount
FROM zakaz_tovar zt
JOIN tovar t ON zt.id_tovar = t.id_tovar
JOIN zakaz z ON zt.id_zakaz = z.id_zakaz
WHERE MONTH(z.date_rozm) = 01
  AND YEAR(z.date_rozm) = 2023
-- Сума продажу товарів за кожним постачальником
SELECT p.Nazva AS SupplierName, SUM(zt.Kilkist * t.Price) AS TotalSales
FROM zakaz_tovar zt
JOIN tovar t ON zt.id_tovar = t.id_tovar
JOIN postachalnik p ON t.id_postav = p.id_postach
GROUP BY p.Nazva;
-- Загальна кількість замовлень за кожним постачальником, що продає молоко
SELECT p.Nazva AS SupplierName, COUNT(z.id_zakaz) AS TotalOrders
FROM postachalnik p
JOIN tovar t ON p.id_postach = t.id_postav
JOIN zakaz_tovar zt ON t.id_tovar = zt.id_tovar
JOIN zakaz z ON zt.id_zakaz = z.id_zakaz
WHERE t.Nazva LIKE '%Молоко%'
GROUP BY p.Nazva;
-- Середня суму, на яку замовлявся товар
SELECT AVG(zt.Kilkist * t.Price) AS AverageOrderAmount
FROM zakaz_tovar zt
JOIN tovar t ON zt.id_tovar = t.id_tovar;
-- Вартість замовлень усіх клієнтів, що мешкають у Житомирі
SELECT SUM(zt.Kilkist * t.Price) AS TotalAmount
FROM zakaz_tovar zt
JOIN tovar t ON zt.id_tovar = t.id_tovar
JOIN zakaz z ON zt.id_zakaz = z.id_zakaz
JOIN klient k ON z.id_klient = k.id_klient
WHERE k.City = 'Житомир';
-- Середня ціну на товари по кожному постачальнику
SELECT p.Nazva AS SupplierName, AVG(t.Price) AS AveragePrice
FROM postachalnik p
JOIN tovar t ON p.id_postach = t.id_postav
GROUP BY p.Nazva;