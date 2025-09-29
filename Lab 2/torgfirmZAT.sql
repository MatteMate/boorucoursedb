SELECT p.Nazva
FROM postachalnik p
LEFT JOIN tovar t ON p.id_postach = t.id_postav
WHERE p.Nazva LIKE '«¿“%' 
  AND t.id_tovar IS NULL;