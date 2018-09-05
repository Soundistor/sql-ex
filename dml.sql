/*Задание: 11 (Serge I: 2004-09-09)
Для каждой группы блокнотов с одинаковым номером модели добавить запись в таблицу PC со следующими характеристиками: 
код: минимальный код блокнота в группе +20; 
модель: номер модели блокнота +1000; 
скорость: максимальная скорость блокнота в группе; 
ram: максимальный объем ram блокнота в группе *2; 
hd: максимальный объем hd блокнота в группе *2; 
cd: cd c максимальной скоростью среди всех ПК; 
цена: максимальная цена блокнота в группе, уменьшенная в 1,5 раза*/

Insert into PC (code, model, speed, ram, hd, cd, price)
Select
	min(code)+20 as code,
	model+1000 as model,
	max(speed) as speed,
	max(ram)*2 as ram,
	max(hd)*2 as hd,
	CAST((SELECT MAX(CAST (SUBSTRING(cd,1,LEN(cd) - 1) AS int)) FROM PC) AS VARCHAR) + 'x' AS cd,
	max(price)/1.5	
From
	Laptop
Group by model

/*Задание: 12 (Serge I: 2004-09-09)
Добавьте один дюйм к размеру экрана каждого блокнота,
выпущенного производителями E и B, и уменьшите его цену на $100.*/

Update 	Laptop 
Set screen=screen+1, price = price - 100
From
	Laptop lt
	Join Product p On lt.model=p.model
Where 
	p.maker in ('E','B')

/*Задание: 13 (Serge I: 2004-09-09)
Ввести в базу данных информацию о том, что корабль Rodney был потоплен в битве, произошедшей 25/10/1944, а корабль Nelson поврежден - 28/01/1945.
Замечание: считать, что дата битвы уникальна в таблице Battles.*/


Insert into Outcomes (ship, battle, result) 
Values ('Rodney', (Select name From Battles where date = '1944-10-25  00:00:00.000'), 'sunk'),
('Nelson', (Select name From Battles where date = '1945-01-28  00:00:00.000'), 'damaged')

/*Задание: 14 (Serge I: 2004-09-09)
Удалите классы, имеющие в базе данных менее трех кораблей (учесть корабли из Outcomes).*/

Delete From Classes
Where class not in 
	(select t.class 
		From
		(
			Select class, count(class) numb
			From Ships
			Group by class
			Union All
			Select ship class, count(ship) numb
			From outcomes
			Where ship not in (
				Select name 
				from Ships)
			Group by ship
		) t
		Group by t.class
		Having sum(t.numb)>=3
	)

/*Задание: 15 (Serge I: 2009-06-05)
Из каждой группы ПК с одинаковым номером модели в таблице PC удалить все строки кроме строки с наибольшим для этой группы кодом (столбец code).*/

Delete From PC
Where code not in (
	Select 
		max(code) code
	From
		PC
	Group by model
)

/*Задание: 16 (Serge I: 2004-09-09)
Удалить из таблицы Product те модели, которые отсутствуют в других таблицах.*/

Delete From Product
Where model not in (
Select model from PC
Union
Select model from Laptop
Union
Select model from Printer)

/*Задание: 17 (Serge I: 2017-04-14)
Удалить из таблицы PC компьютеры, у которых величина hd попадает в тройку наименьших значений.*/

Delete From PC
Where hd in (
	Select Top 3 hd
	From PC
	Group by hd
	Order by hd)

/*Задание: 18 (Serge I: 2015-12-21)
Перенести все концевые пробелы, имеющиеся в названии каждого сражения в таблице Battles, в начало названия.*/

UPDATE Battles
SET name = SPACE(DATALENGTH(name) - LEN(name))+RTRIM(name)

/*Задание: 19 (Shurgenz: 2005-01-02)
Потопить в следующем сражении суда, которые в первой своей битве были повреждены и больше не участвовали ни в каких сражениях. Если следующего сражения для такого судна не существует в базе данных, не вносить его в таблицу Outcomes. Замечание: в базе данных нет двух сражений, которые состоялись бы в один день.*/

WITH nbb AS
(SELECT row_number() over(
ORDER BY date) bn,
*
FROM battles),
abo AS
(SELECT *
FROM nbb b
JOIN outcomes o ON o.battle = b.name)
INSERT INTO outcomes (ship, battle, RESULT)
SELECT ship,
name,
'sunk'
FROM
(SELECT ship,
min(bn)+1 bn
FROM abo
GROUP BY ship
HAVING count(*)=1
AND min(RESULT)='damaged') sss
JOIN nbb ON nbb.bn = sss.bn

/*Задание: 20 (Serge I: 2007-03-23)
Заменить любое количество повторяющихся пробелов в названиях кораблей из таблицы Ships на один пробел.*/

UPDATE Ships
SET name = REPLACE(REPLACE(REPLACE(name, '  ', ' *'), '* ', ''), '*', '')
