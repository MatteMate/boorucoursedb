SELECT DISTINCT k.Nazva
FROM klient k
JOIN zakaz z ON k.id_klient = z.id_klient
JOIN zakaz_tovar zt ON z.id_zakaz = zt.id_zakaz
WHERE k.Nazva LIKE 'оо%' 
  AND z.date_rozm >= '2017-06-01' 
  AND z.date_rozm < '2017-07-01';
