/*Задание: 1 ($erges: 2008-06-21) 
Дима и Миша пользуются продуктами от одного и того же производителя.
Тип Таниного принтера не такой, как у Вити, но признак "цветной или нет" - совпадает.
Размер экрана Диминого ноутбука на 3 дюйма больше Олиного.
Мишин ПК в 4 раза дороже Таниного принтера.
Номера моделей Витиного принтера и Олиного ноутбука отличаются только третьим символом.
У Костиного ПК скорость процессора, как у Мишиного ПК; объем жесткого диска, как у Диминого ноутбука; объем памяти, как у Олиного ноутбука, а цена - как у Витиного принтера.
Вывести все возможные номера моделей Костиного ПК.*/

/*
Номера моделей не обязательно 4-х значные.
Количество символов в номере модели ограничено лишь размером столбца.
Обратите внимание, что модели
22
и
222
не различаются третьим символом, т.к. у первой модели третьего символа попросту нет.
*/

-- 6 выборок из одной группы таблиц


Имя	Таблица	Параметр		Имя	Таблица	Параметр
Дима	P	maker	 =		Миша	P	maker 	5
Таня	Pr	type	<>		Витя	Pr	type
Таня	Pr	Color	 =		Витя	Pr	Color
Дима	L	screen	> +3	Оля		L	screen
Миша	PC	price	> *4	Таня	Pr	price 	6
Витя	Pr	model	<> 3 симв	Оля	L	model 	7++
Костя	PC	speed	=		Миша	PC	speed 	1
Костя	PC	hd		=		Дима	L	hd		2
Костя	PC	ram		=		Оля		L	ram		3
Костя	PC	price	=		Витя	Pr	price	4

Дима 
Laptop + Product

Таня
Printer

Витя
Printerы

Костя
PC

Миша
PC + Product

Оля
Laptop


Select
	kost.model
From
	PC kost
Where 
	kost.speed in 
	(
		select speed 
		From pc
		Where 
			model in (Select model From Product) as dima2 
		and
			price in (((select 4*price from printer) as tanya))
		) as misha
	and
	kost.hd in
	(
		select hd
		From laptop) as dima
	and
	kost.ram in 
	(
		select ram
		From laptop) as ola
	and
	kost.price in
		(
		select price
		From printer) as vita




Select
	kost.model
From
	PC kost
Where 
	kost.speed in 
	(
		select speed 
		From pc
		Where 
			model in (Select model From Product) /*as dima2 - 5*/ 
		and
			price in ((select 4*price from printer) /*as tanya - 6*/)
		) /*as misha - 1*/
	and
	kost.hd in
	(
		select hd
		From laptop) /*as dima - 2*/
	and
	kost.ram in 
	(
		select ram
		From laptop) /*as ola - 3*/
	and
	kost.price in
		(
		select price
		From printer
		Where stuff(model,3,1,'0') = (Select stuff(laptop.model,3,1,'0') From laptop)
			) /*as vita - 4*/


select distinct kostya.model from
(Select p.maker, l.screen, l.hd from product p join laptop l on p.model=l.model) Dima,
(Select p.maker, pc.price, pc.speed from product p join PC on p.model=pc.model) Misha,
(Select p.type, p.color, p.price from printer p) Tanya,
(Select p.model, p.type, p.color, p.price from printer p) Vitya,
(Select l.screen, l.model, l.ram from laptop l ) Olya,
(Select pc.model,pc.price, pc.speed, pc.hd, pc.ram from PC) Kostya
where 
  dima.maker=misha.maker and 
  tanya.type<>vitya.type and
  tanya.color=vitya.color and
  dima.screen=olya.screen+3 and
  misha.price=4*tanya.price and
  stuff(vitya.model,3,1,'')=stuff(olya.model,3,1,'') and
  kostya.speed=misha.speed and
  kostya.hd=dima.hd and
  kostya.ram=olya.ram and
  kostya.price=vitya.price



/*Задание: 2 (Serge I: 2009-08-11) 
Для таблицы Outcomes преобразовать названия кораблей, содержащих более одного пробела, следующим образом.
Заменить все символы между первым и последним пробелами (исключая сами эти пробелы) на символы звездочки (*)
в количестве, равном числу замененных символов.
Вывод: название корабля, преобразованное название корабля

Для этой задачи запрещено использовать:
CTE*/

REPLACE(REPLACE(REPLACE(name, '  ', ' *'), '* ', ''), '*', '')

Select ship
From Outcomes