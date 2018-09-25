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
	t1.country,
	cast(avg(power(t1.bore,3)/2) as numeric(6,2)) as weight
From (
	Select c.country, c.bore, s.name
	From Classes c
		Left Join Ships s On c.class=s.class
	Union
	Select c.country, c.bore, o.ship name
	From Classes c
		Left Join Outcomes o on c.class=o.ship
		) t1
Where name is not null
Group by t1.country


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

Select chr, value 
From (
Select 
	cast(model as NVARCHAR(10)) as model, 
	cast(speed as NVARCHAR(10)) as speed, 
	cast(ram as NVARCHAR(10)) as ram, 
	cast(hd as NVARCHAR(10)) as hd, 
	cast(cd as NVARCHAR(10)) as cd, 
	cast(price as NVARCHAR(10)) as price
From PC
Where code in (Select max(code) from PC)
) as t1

unpivot
(
value for chr in (model, speed, ram, hd, cd, price)
) as unpvt

Case When out1.sum1 is Null Then 0
	Else out1.sum1
	End

Select chr, value 
From (
Select 
	cast(model as NVARCHAR(10)) as model, 
	cast(speed as NVARCHAR(10)) as speed, 
	cast(ram as NVARCHAR(10)) as ram, 
	cast(hd as NVARCHAR(10)) as hd, 
	cast(cd as NVARCHAR(10)) as cd, 
	Case When price is Null 
	Then '0'
	Else cast(price as NVARCHAR(10))
	End price
From PC
Where code in (Select max(code) from PC)
) as t1

unpivot
(
value for chr in (model, speed, ram, hd, cd, price)
) as unpvt


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

Select count(*) OVER (order by t1.numb DESC, t1.maker, t1.model) no, t1.maker, t1.model
From
(Select 
	count (*) OVER (partition by maker) numb, maker, model
From Product
) t1

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

/*Задание: 51 (Serge I: 2003-02-17)
Найдите названия кораблей, имеющих наибольшее число орудий среди всех имеющихся кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).
Примите во внимание случай, когда максимальное число орудий присутствует у класса, у которого нет кораблей в базе данных. 
В данной задаче речь идет именно о кораблях, а не о классах.*/

/*With t1 AS 
(
	Select max(c.numGuns) MaxGuns, c.displacement, s.name
	From Classes c
		Left Join Ships s On c.class=s.class
	Group by c.displacement, s.name
	Union
	Select max(c.numGuns) MaxGuns, c.displacement, o.ship name
	From Classes c
		Left Join Outcomes o on c.class=o.ship
	Group by c.displacement, o.ship
), t2 AS
(
	Select max(c.numGuns) MaxGuns, c.displacement, s.name
	From Classes c
		Left Join Ships s On c.class=s.class
	Group by c.displacement, s.name
	Union
	Select max(c.numGuns) MaxGuns, c.displacement, o.ship name
	From Classes c
		Left Join Outcomes o on c.class=o.ship
	Group by c.displacement, o.ship
)

Select name, MaxGuns, displacement 
From t1
Where name is not null*/

With t1 AS 
(
	Select numGuns, displacement, name
	From 
		(Select s.name, s.class
		From Ships s
		Union
		Select o.ship, o.ship
		From Outcomes o) as tt1		
		Join Classes c On c.class=tt1.class
), t2 AS
(
	Select max(numGuns) MaxGuns, displacement
	From 
		(Select s.name, s.class
		From Ships s
		Union
		Select o.ship, o.ship
		From Outcomes o) as tt2
		Join Classes c on c.class=tt2.class
	Group by displacement
)

Select t1.name/*, t2.MaxGuns, t1.displacement*/
From t1
	Join t2 On t2.MaxGuns=t1.numGuns and t2.displacement=t1.displacement


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



/*Задание: 59 (Serge I: 2003-02-15)
Посчитать остаток денежных средств на каждом пункте приема для базы данных с отчетностью не чаще одного раза в день. Вывод: пункт, остаток.*/

Select
	in1.point,
	in1.sum1-
(Case When out1.sum1 is Null Then 0
	Else out1.sum1
	End)
From
(
	Select point, sum(inc) sum1 
	from Income_o 
	group by point
) in1
Left Join
(
	Select point, sum(out) sum1 
	from Outcome_o 
	group by point
) out1
On out1.point=in1.point

/*Задание: 60 (Serge I: 2003-02-15)
Посчитать остаток денежных средств на начало дня 15/04/01 на каждом пункте приема для базы данных с отчетностью не чаще одного раза в день. Вывод: пункт, остаток.
Замечание. Не учитывать пункты, информации о которых нет до указанной даты.*/

Select
	in1.point,
	in1.sum1-
(Case When out1.sum1 is Null Then 0
	Else out1.sum1
	End)
From
(
	Select point, sum(inc) sum1 
	from Income_o 
	Where date < '2001-04-15'
	group by point
) in1
Left Join
(
	Select point, sum(out) sum1 
	from Outcome_o 
	Where date < '2001-04-15'
	group by point
) out1
On out1.point=in1.point

/*Задание: 61 (Serge I: 2003-02-14)
Посчитать остаток денежных средств на всех пунктах приема для базы данных с отчетностью не чаще одного раза в день.*/

Select
	sum(t1.sum1)
From
(
	Select point, sum(inc) sum1 
	from Income_o 
	group by point
Union
	Select point, -sum(out) sum1 
	from Outcome_o 
	group by point
) t1

/*Задание: 62 (Serge I: 2003-02-15)
Посчитать остаток денежных средств на всех пунктах приема на начало дня 15/04/01 для базы данных с отчетностью не чаще одного раза в день.*/

Select
	sum(t1.sum1)
From
(
	Select sum(inc) sum1 
	from Income_o 
	Where date < '2001-04-15'
Union
	Select -sum(out) sum1 
	from Outcome_o 
	Where date < '2001-04-15'
) t1

--Задание: 63 (Serge I: 2003-04-08)
--Определить имена разных пассажиров, когда-либо летевших на одном и том же месте более одного раза.

Select name
From Passenger
Where ID_psg in 
	(select ID_psg 
	From Pass_in_trip
	Group by ID_psg, place
	Having count(*)>1)

/*Задание: 64 (Serge I: 2010-06-04)
Используя таблицы Income и Outcome, для каждого пункта приема определить дни, когда был приход, но не было расхода и наоборот.
Вывод: пункт, дата, тип операции (inc/out), денежная сумма за день.*/

Select t1.point, t1.date, t1.type, t1.sum1
From
	(
		Select point, date, 'inc' type, sum(inc) sum1
			 COALESCE(sum(inc),'eqv') type
		End
		From Income
		Group by point, date
		Union
		Select point, date, 'out' type, sum(out) sum1
		From Outcome
		Group by point, date
	) t1


	Select t1.point, t1.date, t1.type, t1.sum1,
		--COALESCE(t1.type,'eqv') t1.sum1
		 CASE WHEN t1.sum1 is null THEN t1.type = 'eqv' ELSE t1.type END
From
	(
		Select point, date, CASE WHEN sum(inc) is null THEN 'eqv' as type ELSE 'inc' as type END, sum(inc) sum1
		From Income
		Group by point, date
	) t1

		Select t1.point, t1.date, 
		CASE WHEN t1.sum1 is null 
		THEN 'eqv'
		WHEN t1.sum1 < 0 
		THEN 'out', t1.sum1=-t1.sum1 
		ELSE 'inc' 
		END, 
		t1.sum1
		From (
			Select point, date, sum(inc) sum1
			From Income
			Group by point, date
			Join
			Select point, date, -sum(out) sum1
			From Outcome
			Group by point, date
			) t1



SELECT i1.point, i1.date, 'inc', sum(inc) FROM Income,
(SELECT point, date FROM Income
EXCEPT
SELECT Income.point, Income.date FROM Income
JOIN Outcome ON (Income.point=Outcome.point) AND
(Income.date=Outcome.date)
) AS i1
WHERE i1.point=Income.point AND i1.date=Income.date
GROUP BY i1.point, i1.date
UNION
SELECT o1.point, o1.date, 'out', sum(out) FROM Outcome,
(SELECT point, date FROM Outcome
EXCEPT
SELECT Income.point, Income.date FROM Income
JOIN Outcome ON (Income.point=Outcome.point) AND
(Income.date=Outcome.date)
) AS o1
WHERE o1.point=Outcome.point AND o1.date=Outcome.date
GROUP BY o1.point, o1.date


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

Select
	count(*) qty
From
	(Select Top 1 With TIES
		sum(qty) qty, p1, p2
			From
		(
			Select 
				count(*) qty, town_from p1, town_to p2
			From
				Trip
			Where town_from>=town_to
			Group by town_from, town_to
			Union ALL
			Select
				 count(*) qty, town_to p1, town_from p2
			From
				Trip
			Where town_to>town_from
			Group by town_from, town_to
	) as t1 
		Group by p1, p2
		Order by qty desc) as t2


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
	Where t.trip_no=pt.trip_no and t.town_from = 'Rostov'
	Group by pt.date) t1
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

Select
	(SELECT name FROM Passenger WHERE ID_psg = t1.ID_psg) AS name,
	t1.qty, 
	(SELECT name FROM Company WHERE ID_comp = t1.ID_comp) AS Company
	FROM (
select 
	pt.ID_psg as ID_psg, count(*) as qty, MIN(t.ID_comp) as ID_comp, MAX(COUNT(*)) OVER() AS Max_Qty
from
	Pass_in_trip pt, Trip t
Where 
	pt.trip_no=t.trip_no
Group by pt.ID_psg
Having MAX(t.ID_comp)=MIN(t.ID_comp)) t1
WHERE t1.Max_Qty=t1.qty

--Задание: 89 (Serge I: 2012-05-04)
--Найти производителей, у которых больше всего моделей в таблице Product, а также тех, у которых меньше всего моделей.
--Вывод: maker, число моделей

With sr as (select count(model) qty from Product Group by maker)

Select maker, count(model) qty from Product
Group by maker
Having count(model) = (select MAX(qty) from sr)
	or
count(model) = (select MIN(qty) from sr) 


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

Select name, trip_no, date
From
(
	Select 
		row_number() over (order by pt.date, t.time_out, pt.ID_psg) as numb,
		c.name, 
		t.trip_no, 
		pt.date
	From
		Company c
		Join Trip t On t.ID_comp=c.ID_comp
		Join Pass_in_trip pt On t.trip_no=pt.trip_no
	Where t.town_from = 'Rostov' and year(pt.date) = 2003 and month(pt.date) = 4
) t1
Where numb = 5

/*Задание: 108 (Baser: 2013-10-16)
Реставрация экспонатов секции "Треугольники" музея ПФАН проводилась согласно техническому заданию. Для каждой записи таблицы utb малярами подкрашивалась сторона любой фигуры, если длина этой стороны равнялась b_vol.
Найти окрашенные со всех сторон треугольники, кроме равносторонних, равнобедренных и тупоугольных. 
Для каждого треугольника (но без повторений) вывести три значения X, Y, Z, где X - меньшая, Y - средняя, а Z - большая сторона.*/

Select DISTINCT
	b1.b_vol x, b2.b_vol y, b3.b_vol z
From
	utB b1
	Join utB b2 On b2.b_vol>b1.b_vol
	Join utB b3 On b3.b_vol>b2.b_vol
Where not (b3.b_vol>SQRT(SQUARE(b2.b_vol)+SQUARE(b1.b_vol)))

/*Задание: 110 (Serge I: 2003-12-24)
Определить имена разных пассажиров, когда-либо летевших рейсом, который вылетел в субботу, а приземлился в воскресенье.*/

Select 
	name
From
		Passenger
Where ID_psg in 
(
	Select
		pt.ID_psg
	From
		Trip t 
		Join Pass_in_trip pt On t.trip_no=pt.trip_no
	Where DATEPART(dw, pt.date) = 7	and t.time_out > t.time_in
)
