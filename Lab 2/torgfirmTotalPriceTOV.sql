SELECT SUM(zt.Kilkist * t.Price) AS TotalValue
FROM zakaz z
JOIN zakaz_tovar zt ON z.id_zakaz = zt.id_zakaz
JOIN tovar t ON zt.id_tovar = t.id_tovar
JOIN postachalnik p ON t.id_postav = p.id_postach
WHERE p.Nazva LIKE 'ÒÎÂ%'
  AND z.date_rozm >= '2017-06-01';