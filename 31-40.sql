--Задание: 31
--Для классов кораблей, калибр орудий которых не менее 16 дюймов, укажите класс и страну.

Select 
	class, 
	country
From Classes
Where bore >= 16

--Задание: 32
--Одной из характеристик корабля является половина куба калибра его главных орудий (mw). С точностью до 2 десятичных знаков определите среднее значение mw для кораблей каждой страны, у которой есть корабли в базе данных.

Select 
	country,
	cast (avg(power(bore,3)/2) as numeric(6,2)) as weight
From Classes
Group by country

--???????????????????????
Select country, cast(avg((power(bore,3)/2)) as numeric(6,2)) as weight
from (select country, classes.class, bore, name from classes left join ships on classes.class=ships.class
union all
select distinct country, class, bore, ship from classes t1 left join outcomes t2 on t1.class=t2.ship
where ship=class and ship not in (select name from ships) ) a
where name IS NOT NULL group by country

--Задание: 33
--Укажите корабли, потопленные в сражениях в Северной Атлантике (North Atlantic). Вывод: ship.

Select 
	ship
From Outcomes
Where battle = 'North Atlantic' and result = 'sunk'

--Задание: 35 (qwrqwr: 2012-11-23)
--В таблице Product найти модели, которые состоят только из цифр или только из латинских букв (A-Z, без учета регистра). Вывод: номер модели, тип модели.

Select 
	model, type
From Product
Where upper(model) not like '%[^A-Z]%' or model not like '%[^0-9]%'

--Задание: 36 (Serge I: 2003-02-17)
--Перечислите названия головных кораблей, имеющихся в базе данных (учесть корабли в Outcomes).

Select 
	name
From Ships
Where name = class
Union
Select 
	ship as name
From Outcomes
Join Classes ON Outcomes.ship = Classes.class

--Задание: 37 (Serge I: 2003-02-17)
--Найдите классы, в которые входит только один корабль из базы данных (учесть также корабли в Outcomes).

Select 
	c.class 
From Classes c
Left Join (Select class, name 
	From Ships
	Union
Select 
	Classes.class as class, Outcomes.ship as name
From Outcomes
Join Classes ON Outcomes.ship = Classes.class) as s On c.class = s.class
Group by c.class
Having count(s.name)=1

--Задание: 38 (Serge I: 2003-02-19)
--Найдите страны, имевшие когда-либо классы обычных боевых кораблей ('bb') и имевшие когда-либо классы крейсеров ('bc').

Select 
	country
From Classes
Where type = 'bb' 
INTERSECT
Select 
	country
From Classes
Where type = 'bc'

--Задание: 39 (Serge I: 2003-02-14)
--Найдите корабли, `сохранившиеся для будущих сражений`; т.е. выведенные из строя в одной битве (damaged), они участвовали в другой, произошедшей позже.

Select 
	distinct o.ship
From Outcomes o, Battles b
Where o.battle=b.name and o.ship in
(
Select 
	 o1.ship
From Outcomes o1, Battles b1
Where o1.battle=b1.name and o1.result = 'damaged' and b.date>b1.date)


--Задание: 40 (Serge I: 2002-11-05)
--Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.

Select 
	Ships.class, Ships.name, Classes.country
From Ships
Join Classes On Ships.class=Classes.class
Where Classes.numGuns >= 10

--Задание: 41 (Serge I: 2008-08-30)
--Для ПК с максимальным кодом из таблицы PC вывести все его характеристики (кроме кода) в два столбца:
-- название характеристики (имя соответствующего столбца в таблице PC);
-- значение характеристики

Select 
	chr, value
From PC
Having max(code)
select
case a 
when 
then
else
end
from
cast speed
ram
hd
price
screen

select fields,A from
(
Select
  cast(model as NVARCHAR(10)) as model
, cast (speed as NVARCHAR(10)) as speed
, cast(ram as NVARCHAR(10)) as ram
,cast(hd as NVARCHAR(10)) as hd
, cast(cd as NVARCHAR(10)) as cd
, cast(price as NVARCHAR(10)) as price from PC
where code = (Select max(code) from PC)
) as t

unpivot
(
A for fields in (model, speed, ram, hd, cd, price)
) as unpvt

--???????????????????????

--Задание: 42 (Serge I: 2002-11-05)
--Найдите названия кораблей, потопленных в сражениях, и название сражения, в котором они были потоплены.


Select 
	ship, battle
From Outcomes
Where result = 'sunk'

--Задание: 43 (qwrqwr: 2011-10-28)
--Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

Select 
	distinct Battles.name, year(Battles.date)
From Battles
Where year(Battles.date) not in (
	Select Ships.launched
	From Ships
	Where Ships.launched is not null
)

--Задание: 44 (Serge I: 2002-12-04)
--Найдите названия всех кораблей в базе данных, начинающихся с буквы R.

Select r.name from (
	Select Ships.name as name
From Ships
Union
Select 
	Outcomes.ship as name
From Outcomes) as r
Where r.name like 'R%'


--Задание: 45 (Serge I: 2002-12-04)
--Найдите названия всех кораблей в базе данных, состоящие из трех и более слов (например, King George V).
--Считать, что слова в названиях разделяются единичными пробелами, и нет концевых пробелов.

select name from ships
where name like '% % %'
union
select ship from outcomes
where ship like '% % %'

--Задание: 46 (Serge I: 2003-02-14)
--Для каждого корабля, участвовавшего в сражении при Гвадалканале (Guadalcanal), вывести название, водоизмещение и число орудий.

Select 
	otc.ship, displacement, numGuns From (
Select name, displacement, numGuns from Ships sh
	Join Classes cls On sh.class=cls.class
Union
Select class as name, displacement, numGuns from Classes) as sel1
Right Join Outcomes otc On sel1.name=otc.ship
Where otc.battle = 'Guadalcanal'

--Задание: 47 (Serge I: 2011-02-11)
--Пронумеровать строки из таблицы Product в следующем порядке: имя производителя в порядке убывания числа производимых им моделей (при одинаковом числе моделей имя производителя в алфавитном порядке по возрастанию), номер модели (по возрастанию).
--Вывод: номер в соответствии с заданным порядком, имя производителя (maker), модель (model) 

Select 
	count (*) numb, maker, model
From Product
Order by maker

--??????????????????????????????????

--Задание: 48 (Serge I: 2003-02-16)
--Найдите классы кораблей, в которых хотя бы один корабль был потоплен в сражении.

Select
	Ships.class
From
	Ships, Outcomes 
Where Outcomes.ship = Ships.name and Outcomes.result = 'sunk'
Union
Select
	Classes.class
From
	Classes, Outcomes 
Where Outcomes.ship = Classes.class and Outcomes.result = 'sunk'



--Задание: 49 (Serge I: 2003-02-17)
--Найдите названия кораблей с орудиями калибра 16 дюймов (учесть корабли из таблицы Outcomes).

Select r.name from (
	Select 
		Ships.name as name,
		Classes.bore as bore
From Ships
Join Classes On Ships.class = Classes.class
Union
Select 
	Outcomes.ship as name,
	Classes.bore as bore
From Outcomes
Join Classes On Outcomes.ship = Classes.class) as r

Where r.bore = 16


--Задание: 50 (Serge I: 2002-11-05)
--Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select distinct battle 
from Outcomes
Join Ships On Outcomes.ship=Ships.name
Where Ships.class='Kongo'

--Задание: 52 (qwrqwr: 2010-04-23)
--Определить названия всех кораблей из таблицы Ships, которые могут быть линейным японским кораблем, имеющим число главных орудий не менее девяти, калибр орудий менее 19 дюймов и водоизмещение не более 65 тыс.тонн

Select
	distinct Ships.name
From
	Ships, Classes
Where Ships.class=Classes.class and Classes.type='bb' and
upper(Classes.country) = 'JAPAN' and (Classes.numGuns >= 9 Or Classes.numGuns is Null) and (Classes.bore < 19 Or Classes.bore is Null) and (Classes.displacement <= 65000 Or Classes.displacement  is Null)

--Задание: 53 (Serge I: 2002-11-05)
--Определите среднее число орудий для классов линейных кораблей. Получить результат с точностью до 2-х десятичных знаков.

Select 
	cast(avg(numGuns) as numeric (10,2))
From
	Classes
Where type = 'bb'

--Задание: 54 (Serge I: 2003-02-14)
--С точностью до 2-х десятичных знаков определите среднее число орудий всех линейных кораблей (учесть корабли из таблицы Outcomes).

Select 
	cast(avg(numGuns) as numeric (10,2)) as AVG_NUMG
From
	(Select Ships.name ship, numGuns From Ships, Classes
		Where Ships.class=Classes.class and type = 'bb'
	Union
	Select Outcomes.ship, numGuns from Outcomes, Classes
	Where Outcomes.ship=Classes.class
	and type = 'bb')

--Задание: 55 (Serge I: 2003-02-16)
--Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

Select
	launched, class
From Classes, Ships
Where Ships.class=Classes.class and 

Select c.class, t1.year
From Classes c left join (
Select class, min(launched) as year From Ships
Group by class) as t1 On c.class=t1.class

--Задание: 56 (Serge I: 2003-02-16)
--Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.

Select
	c.class, 
	count (t2.ship)
From
	Classes c 
		Left join
		(
			Select 
				Ships.class, Outcomes.ship
			From
				Outcomes
				Left Join Ships On Ships.name=Outcomes.ship
			Where
				Outcomes.result = 'sunk') as t2 On t2.ship=c.class Or t2.class = c.class
Group by 
	c.class

--Задание: 57 (Serge I: 2003-02-14)
--Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

Select
	c.class, sum(.ship) as sunk
From
	Classes c
	Join (
		Select name, class
		Case When o.result = 'sunk' )
Where o.ship = c.class and  and c.class in (
Select count(name) as numb, class
From Ships
Group by class
)
Group by c.class



--Задание: 59 (Serge I: 2003-02-15)
--Посчитать остаток денежных средств на каждом пункте приема для базы данных с отчетностью не чаще одного раза в день. Вывод: пункт, остаток.

select Income_o.point, sum(Income_o.inc)-sum(Outcome_o.out) as mon
From Income_o, Outcome_o
Where Income_o.point=Outcome_o.point
Group by Income_o.point
Income_o(point, date, inc)
Outcome_o(point, date, out)

--Задание: 63 (Serge I: 2003-04-08)
--Определить имена разных пассажиров, когда-либо летевших на одном и том же месте более одного раза.

Select name
From Passenger
Where ID_psg in 
	(select ID_psg 
	From Pass_in_trip
	Group by ID_psg, place
	Having count(*)>1)

--Задание: 67 (Serge I: 2010-03-27)
--Найти количество маршрутов, которые обслуживаются наибольшим числом рейсов.
--Замечания. 
--1) A - B и B - A считать РАЗНЫМИ маршрутами.
--2) Использовать только таблицу Trip

Select
	count(*) qty
From
	(Select
		Top 1 With TIES count(*) qty, town_from, town_to
	From
		Trip
	Group by town_from, town_to
	Order by qty desc) as t1
 
--Задание: 68 (Serge I: 2010-03-27)
--Найти количество маршрутов, которые обслуживаются наибольшим числом рейсов.
--Замечания. 
--1) A - B и B - A считать ОДНИМ И ТЕМ ЖЕ маршрутом.
--2) Использовать только таблицу Trip

???????

--Задание: 70 (Serge I: 2003-02-14)
--Укажите сражения, в которых участвовало по меньшей мере три корабля одной и той же страны.


--1
Select distinct t1.battle
From
	(
	Select
		Outcomes.battle, Outcomes.ship, Classes.country
	From
		Outcomes, Classes 
	Where Outcomes.ship=Classes.class and Classes.country is not Null
	Union
	Select
		Outcomes.battle, Outcomes.ship, Classes.country
	From
		Outcomes, Ships, Classes
	Where Outcomes.ship=Ships.name and Ships.class=Classes.class and Classes.country is not Null
	) as t1
Group by t1.country, t1.battle
Having count(t1.ship)>=3


--2
Select
	distinct o.battle
From
	Outcomes o
	Left Join ships s On o.ship=s.name
	Left Join Classes c On o.ship=c.class OR s.class=c.class
Where c.country is not Null
Group by c.country, o.battle
Having count (o.ship) >= 3


--Задание: 71 (Serge I: 2008-02-23)
--Найти тех производителей ПК, все модели ПК которых имеются в таблице PC.

Select 
	p.maker
From
	Product p
	Left Join pc On pc.model=p.model
Where p.type = 'PC'
Group by p.maker
Having count(pc.model) = count(p.model)

--Задание: 72 (Serge I: 2003-04-29)

--Cреди тех, кто пользуется услугами только какой-нибудь одной компании, определить имена разных пассажиров, летавших чаще других. 
--Вывести: имя пассажира и число полетов.

Select
	TOP 1 WITH TIES p.name, count(*) as qty
From
	Passenger p, Pass_in_trip pt, Trip t
Where 
	p.ID_psg=pt.ID_psg and pt.trip_no=t.trip_no
Group by t.ID_comp, p.name
Order by qty desc

select TOP 1 WITH TIES name, c3 from passenger
join
(select c1, max(c3) c3 from
(
select pass_in_trip.ID_psg c1, Trip.ID_comp c2, count(*) c3 from pass_in_trip
join trip on trip.trip_no=pass_in_trip.trip_no
group by pass_in_trip.ID_psg, Trip.ID_comp
) as t
group by c1
having count(*)=1) as tt
on ID_psg=c1
order by c3 desc

--Задание: 73 (Serge I: 2009-04-17)
--Для каждой страны определить сражения, в которых не участвовали корабли данной страны.
--Вывод: страна, сражение

Select
	c.country, b.name
From
	Classes c, Battles b
EXCEPT
Select
	c.country, o.battle
From
	Outcomes o
	Left Join ships s On o.ship=s.name
	Left Join Classes c On o.ship=c.class OR s.class=c.class
Where c.country is not null
Group by c.country, o.battle

--Задание: 74 (dorin_larsen: 2007-03-23)
--Вывести классы всех кораблей России (Russia). Если в базе данных нет классов кораблей России, вывести классы для всех имеющихся в БД стран. 
--Вывод: страна, класс

Select
	c.country, c.class
From
	Classes c
Where upper(c.country)='RUSSIA' and EXISTS (
	Select
		c.country, c.class
	From
		Classes c, Ships s
	Where upper(c.country)='RUSSIA')
Union all
SELECT 
	c.country, c.class
FROM 
	classes c
WHERE NOT EXISTS (
	SELECT c.country, c.class
	FROM classes c
	WHERE UPPER(c.country) = 'RUSSIA' )

--Задание: 77 (Serge I: 2003-04-09)
--Определить дни, когда было выполнено максимальное число рейсов из Ростова ('Rostov'). Вывод: число рейсов, дата.

Select TOP 1 WITH TIES * FROM
(Select
	count(distinct(pt.trip_no)) qty, pt.date
From
	Trip t, Pass_in_trip pt
Where t.trip_no=pt.trip_no and t.town_from = ('Rostov')
Group by pt.trip_no, pt.date) t1
Order by t1.qty Desc

--Задание: 78 (Serge I: 2005-01-19)
--Для каждого сражения определить первый и последний день месяца, в котором оно состоялось. 
--Вывод: сражение, первый день месяца, последний день месяца.
--Замечание: даты представить без времени в формате "yyyy-mm-dd".

Select
	b.name, 
From
	Battles b

--Задание: 79 (Serge I: 2003-04-29)
--Определить пассажиров, которые больше других времени провели в полетах. 
--Вывод: имя пассажира, общее время в минутах, проведенное в полетах

Select
	p.name, sum(t.time_out - t.time_in) as flytime
From
	Passenger p, Pass_in_trip pt, Trip t
Where 
	
--Задание: 80 (Baser: 2011-11-11)
--Найти производителей компьютерной техники, у которых нет моделей ПК, не представленных в таблице PC.

Select
	distinct maker 
From
	Product
Where maker not in 
(
	Select
		distinct maker 
	From
		Product
	Where type = 'PC' and model not in 
	(
		Select 
			model 
		From 
			PC
	)
)

--Задание: 81 (Serge I: 2011-11-25)
--Из таблицы Outcome получить все записи за тот месяц (месяцы), с учетом года, в котором суммарное значение расхода (out) было максимальным.

--Задание: 83 (dorin_larsen: 2006-03-14)
--Определить названия всех кораблей из таблицы Ships, которые удовлетворяют, по крайней мере, комбинации любых четырёх критериев из следующего списка: 
/*numGuns = 8 
bore = 15 
displacement = 32000 
type = bb 
launched = 1915 
class=Kongo 
country=USA*/

Select
	s.name
From
	ships s 
	Join classes c On s.class=c.class
Where 
	Case WHEN c.numGuns = 8 THEN 1 ELSE 0 END + 
	Case WHEN c.bore = 15 THEN 1 ELSE 0 END +
	Case WHEN c.displacement = 32000 THEN 1 ELSE 0 END +
	Case WHEN c.type = 'bb' THEN 1 ELSE 0 END +
	Case WHEN s.launched = 1915 THEN 1 ELSE 0 END +
	Case WHEN c.class='Kongo' THEN 1 ELSE 0 END +
	Case WHEN c.country='USA'THEN 1 ELSE 0 END >= 4

--Задание: 84 (Serge I: 2003-06-05)
--Для каждой компании подсчитать количество перевезенных пассажиров (если они были в этом месяце) по декадам апреля 2003. При этом учитывать только дату вылета. 
--Вывод: название компании, количество пассажиров за каждую декаду

--Задание: 85 (Serge I: 2012-03-16)
--Найти производителей, которые выпускают только принтеры или только PC.
--При этом искомые производители PC должны выпускать не менее 3 моделей.

select 
	maker
from 
	product
group by maker
having count(distinct type) = 1 and
       (min(type) = 'printer' or
       (min(type) = 'pc' and count(model) >= 3))

--Задание: 86 (Serge I: 2012-04-20)
--Для каждого производителя перечислить в алфавитном порядке с разделителем "/" все типы выпускаемой им продукции.
--Вывод: maker, список типов продукции

Select
	maker,
	CASE count(distinct type) when 2 then MIN(type) + '/' + MAX(type)
		WHEN 1 THEN MAX(type)
		WHEN 3 THEN 'Laptop/PC/Printer' END
FROM Product
GROUP BY maker

--Задание: 88 (Serge I: 2003-04-29)
--Среди тех, кто пользуется услугами только одной компании, определить имена разных пассажиров, летавших чаще других. 
--Вывести: имя пассажира, число полетов и название компании.

Select TOP 1 WITH TIES * FROM (
select 
	p.name as Pass, count(t.trip_no) as qty, c.name as Company
from
	Passenger p, Pass_in_trip pt, Trip t, Company c
Where 
	p.ID_psg=pt.ID_psg and
	pt.trip_no=t.trip_no and
	t.ID_comp=c.ID_comp
Group by p.name, c.name) t1
Order by t1.qty desc


????????????????????????????

--Задание: 89 (Serge I: 2012-05-04)
--Найти производителей, у которых больше всего моделей в таблице Product, а также тех, у которых меньше всего моделей.
--Вывод: maker, число моделей

Select TOP 1 WITH TIES * FROM (
Select t1.maker, max(t1.qty) as qty from (
select 
	maker, count(model) as qty
from
	Product
Group by maker) t1
Group by t1.maker) t11
Order by t11.qty desc
Union
Select TOP 1 WITH TIES * FROM (
Select t2.maker, min(t2.qty) as qty from (
select 
	maker, count(model) as qty
from
	Product
Group by maker) t2
Group by t2.maker) t22
Order by t22.qty

?????????????????????????

--Задание: 90 (Serge I: 2012-05-04)
--Вывести все строки из таблицы Product, кроме трех строк с наименьшими номерами моделей и трех строк с наибольшими номерами моделей.

Select 
	t1.maker, t1.model, t1.type
From
	(
		Select
		row_number() over (order by model) p1,
		row_number() over (order by model desc) p2,
		*
		from product
	) t1
Where p1 > 3 and p2 > 3


--Задание: 93 (Serge I: 2003-06-05)
--Для каждой компании, перевозившей пассажиров, подсчитать время, которое провели в полете самолеты с пассажирами. 
--Вывод: название компании, время в минутах.

--Задание: 95 (qwrqwr: 2013-02-08)
/*На основании информации из таблицы Pass_in_Trip, для каждой авиакомпании определить:
1) количество выполненных перелетов;
2) число использованных типов самолетов;
3) количество перевезенных различных пассажиров;
4) общее число перевезенных компанией пассажиров.
Вывод: Название компании, 1), 2), 3), 4).*/

Select 
	Company.name, 
	COUNT(DISTINCT CONVERT(CHAR(24),pt.date)+CONVERT(CHAR(4),t.trip_no)) flights, 
	count(distinct t.plane) planes,
	count(distinct pt.ID_psg) diff_psngrs,
	count(pt.ID_psg) total_psngrs
From
	Company
	Join Trip t On Company.ID_comp=t.ID_comp
	Join Pass_in_Trip pt On pt.trip_no=t.trip_no
Group by Company.name

--Задание: 96 (ZrenBy: 2003-09-01)
--При условии, что баллончики с красной краской использовались более одного раза, выбрать из них такие, которыми окрашены квадраты, имеющие голубую компоненту. 
--Вывести название баллончика

Select
	utV.V_NAME
From
	utV, utB
Where utB.B_V_ID = utV.V_ID and utV.V_COLOR = 'R'

--Задание: 102 (Serge I: 2003-04-29)
--Определить имена разных пассажиров, которые летали только между двумя городами (туда и/или обратно).

Select
	p.name
From
	Passenger p
Where p.id_psg in (
Select pt.id_psg
From
	Pass_in_Trip pt
	Join Trip t On pt.trip_no=t.trip_no
group by pt.id_psg
Having count(distinct case when t.town_from<=t.town_to then t.town_from+t.town_to else t.town_to+t.town_from end) = 1
)

/*Задание: 103 (qwrqwr: 2013-05-17)
Выбрать три наименьших и три наибольших номера рейса. Вывести их в шести столбцах одной строки, расположив в порядке от наименьшего к наибольшему. 
Замечание: считать, что таблица Trip содержит не менее шести строк.*/

select
	min(t1.trip_no) min1, min(t2.trip_no) min2, min(t3.trip_no) min3,
	max(t1.trip_no) max, max(t2.trip_no) max2, max(t3.trip_no) max3
From
	Trip t1,
	Trip t2,
	Trip t3
Where t1.trip_no < t2.trip_no and t2.trip_no < t3.trip_no

/*Задание: 104 (Serge I: 2013-07-19)
Для каждого класса крейсеров, число орудий которого известно, пронумеровать (последовательно от единицы) все орудия.
Вывод: имя класса, номер орудия в формате 'bc-N'.*/

With guns as 
	(
		Select
			c1.class,
			c1.numGuns,
			row_number() over(partition by c1.class order by c1.numGuns) numb
		From
			Classes c1, Classes c2
		Where c1.type = 'bc'
	)
Select distinct class, 'bc-'+cast(numb as varchar(2))
From
	guns
Where numGuns >= numb

/*Задание: 105 (qwrqwr: 2013-09-11)
Статистики Алиса, Белла, Вика и Галина нумеруют строки у таблицы Product.
Все четверо упорядочили строки таблицы по возрастанию названий производителей.
Алиса присваивает новый номер каждой строке, строки одного производителя она упорядочивает по номеру модели.
Трое остальных присваивают один и тот же номер всем строкам одного производителя.
Белла присваивает номера начиная с единицы, каждый следующий производитель увеличивает номер на 1.
У Вики каждый следующий производитель получает такой же номер, какой получила бы первая модель этого производителя у Алисы.
Галина присваивает каждому следующему производителю тот же номер, который получила бы его последняя модель у Алисы.
Вывести: maker, model, номера строк получившиеся у Алисы, Беллы, Вики и Галины соответственно.*/

Select
	maker, 
	model,
	row_number() over(order by maker, model) as Alice,
	dense_rank() over(order by maker) as Bella,
	rank() over(order by maker) as Vika,
	count(*) over(order by maker) as Galina
From
	Product


/*Задание: 107 (VIG: 2003-09-01)
Для пятого по счету пассажира из числа вылетевших из Ростова в апреле 2003 года определить компанию, номер рейса и дату вылета.
Замечание. Считать, что два рейса одновременно вылететь из Ростова не могут.*/

