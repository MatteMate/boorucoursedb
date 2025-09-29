SELECT z.id_zakaz, z.id_klient, z.id_sotrud, z.date_rozm, z.date_naznach
FROM zakaz z
JOIN zakaz_tovar zt ON z.id_zakaz = zt.id_zakaz
JOIN tovar t ON zt.id_tovar = t.id_tovar
WHERE t.Nazva = 'Молоко' AND z.date_naznach < '2017-07-03'
