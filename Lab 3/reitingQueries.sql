-- Сумарний рейтинг студента з кожної дисципліни
SELECT s.Sname,s.Name,s.Fname,p.Nazva, SUM(r.Reiting) AS Total_Rating
FROM student s JOIN Reiting r ON s.Kod_stud = r.Kod_student JOIN Rozklad_pids rp ON r.K_zapis = rp.K_zapis
JOIN Predmet_plan pp ON rp.K_predm_pl = pp.K_predm_pl JOIN predmet p ON pp.K_predmet = p.K_predmet
GROUP BY s.Sname, s.Name, s.Fname, p.Nazva;

-- Розрахувати кількість студентів у кожній групі
SELECT g.Kod_group,COUNT(s.Kod_stud) AS Student_Count
FROM groups g LEFT JOIN student s ON g.Kod_group = s.Kod_group
GROUP BY g.Kod_group;

-- Розрахувати кількість дисциплі́н за групою
SELECT g.Kod_group,COUNT(DISTINCT pp.K_predmet) AS Subject_Count
FROM groups g JOIN Rozklad_pids rp ON g.Kod_group = rp.Kod_group
JOIN Predmet_plan pp ON rp.K_predm_pl = pp.K_predm_pl
GROUP BY g.Kod_group;

-- Розрахувати кількість проведених занять у кожній групі
SELECT g.Kod_group,COUNT(rp.K_zapis) AS Classes_Count
FROM  groups g JOIN Rozklad_pids rp ON g.Kod_group = rp.Kod_group
GROUP BY g.Kod_group;

-- Розрахувати середній бал за групою
SELECT  g.Kod_group,AVG(r.Reiting) AS Average_Score
FROM groups g
JOIN Rozklad_pids rp ON g.Kod_group = rp.Kod_group
JOIN Reiting r ON rp.K_zapis = r.K_zapis
GROUP BY g.Kod_group;

-- Розрахувати середній бал з дисципліни
SELECT p.Nazva, AVG(r.Reiting) AS Average_Score
FROM predmet p JOIN Predmet_plan pp ON p.K_predmet = pp.K_predmet
JOIN Rozklad_pids rp ON pp.K_predm_pl = rp.K_predm_pl
JOIN Reiting r ON rp.K_zapis = r.K_zapis
GROUP BY p.Nazva;

-- Розрахувати поточний рейтинг студента з кожної дисципліни
SELECT s.Sname,s.Name,s.Fname,p.Nazva,r.Reiting AS Current_Rating
FROM student s JOIN Reiting r ON s.Kod_stud = r.Kod_student
JOIN Rozklad_pids rp ON r.K_zapis = rp.K_zapis
JOIN Predmet_plan pp ON rp.K_predm_pl = pp.K_predm_pl
JOIN predmet p ON pp.K_predmet = p.K_predmet;

-- Відобразити найменший рейтинг студентів з дисципліни
SELECT p.Nazva, MIN(r.Reiting) AS Lowest_Rating
FROM predmet p JOIN Predmet_plan pp ON p.K_predmet = pp.K_predmet
JOIN Rozklad_pids rp ON pp.K_predm_pl = rp.K_predm_pl
JOIN Reiting r ON rp.K_zapis = r.K_zapis
GROUP BY p.Nazva;

-- Відобразити найбільший студентський рейтинг з дисципліни
SELECT p.Nazva,MAX(r.Reiting) AS Highest_Rating
FROM predmet p JOIN Predmet_plan pp ON p.K_predmet = pp.K_predmet
JOIN Rozklad_pids rp ON pp.K_predm_pl = rp.K_predm_pl
JOIN Reiting r ON rp.K_zapis = r.K_zapis
GROUP BY p.Nazva;

-- Розрахувати кількість проведених занять за видами для кожної дисципліни
SELECT p.Nazva,rp.Zdacha_type,COUNT(rp.K_zapis) AS Classes_Count
FROM predmet p JOIN Predmet_plan pp ON p.K_predmet = pp.K_predmet
JOIN Rozklad_pids rp ON pp.K_predm_pl = rp.K_predm_pl
GROUP BY p.Nazva, rp.Zdacha_type;

-- Розрахувати кількість груп за кожною спеціальністю
SELECT sp.Nazva,COUNT(g.Kod_group) AS Group_Count
FROM Spetsialnost sp LEFT JOIN  Navch_plan np ON sp.K_spets = np.K_spets
LEFT JOIN groups g ON np.K_navch_plan = g.K_navch_plan
GROUP BY sp.Nazva;

-- Запит на знищення даних з таблиці «Reiting» за визначеним кодом студента
DELETE FROM Reiting
WHERE Kod_student = (SELECT Kod_stud FROM student WHERE Sname = 'Melnyk');

-- Запит на знищення даних з таблиці «Para» за визначеним кодом дисципліни
DELETE FROM Rozklad_pids
WHERE K_predm_pl = (SELECT K_predmet FROM predmet WHERE Nazva = 'Art');

-- Запит на оновлення даних у таблиці «Reiting» – передбачити збільшення балів за модульні контролі на 15%
select * from Reiting
UPDATE Reiting
SET Reiting = Reiting * 1.15
WHERE K_zapis IN (SELECT K_zapis FROM Rozklad_pids WHERE Zdacha_type = 0);

select * from Reiting
-- Запит на оновлення даних в таблиці «Reiting»– передбачити зменшення балів за іспит на 15%
UPDATE Reiting
SET Reiting = Reiting * 0.85
WHERE K_zapis IN (SELECT K_zapis FROM Rozklad_pids WHERE Zdacha_type = 1);

-- Запит на вставку даних до таблиці «Reiting» – передбачити вставку даних студентів визначеної групи
INSERT INTO Reiting (K_zapis, Kod_student, Reiting, Prisutn)
SELECT 0, Kod_stud, 70, 1 FROM student WHERE Kod_group = 'GRP005';

-- Запит на вставку даних до таблиці «Para» – передбачити вставку всіх дисциплін, назва яких починається з літери «М»
INSERT INTO Rozklad_pids (Date, K_predm_pl, Kod_group, k_vilkad, N_vedomost, Zdacha_type)
SELECT'2023-09-01',pp.K_predm_pl,'GRP003',1,101,0
FROM Predmet p JOIN Predmet_plan pp ON p.K_predmet = pp.K_predmet
WHERE p.Nazva LIKE 'M%';

-- Запит на оновлення даних (зміна порядкового номера змістовного модуля за певною дисципліною):
UPDATE Predmet_plan 
SET Kilk_modul = 2  
WHERE K_predmet = 3;

-- Запит на знищення студентів з таблиці «Students» за визначеним номером групи:
DELETE FROM student
WHERE Kod_group = 'GRP001';

-- Запит на вставку даних до таблиці «Reiting» (вставка даних студентів визначеної групи):
INSERT INTO Reiting (K_zapis, Kod_student, Prisutn)  
SELECT 11, Kod_stud, 1 
FROM student
WHERE Kod_group = 'GRP001'; 

-- Запит на оновлення даних у таблиці «Reiting» (для студента з визначеним прізвищем):
UPDATE Reiting SET Prisutn = 1  WHERE Kod_student IN (SELECT Kod_stud FROM student WHERE Sname = 'Petrov'); 