/*Задание: 111 (Serge I: 2003-12-24)
Найти НЕ белые и НЕ черные квадраты, которые окрашены разными цветами в пропорции 1:1:1. Вывод: имя квадрата, количество краски одного цвета*/

Select 
	utQ.Q_NAME,
	utB.B_VOL
From
	utQ
	Join utB On utQ.Q_ID=utB.B_Q_ID


-- ??????????????


/*Задание: 114 (Serge I: 2003-04-08)
Определить имена разных пассажиров, которым чаще других доводилось лететь на одном и том же месте. Вывод: имя и количество полетов на одном и том же месте.*/

With t1 as 
(	Select 
		ID_psg,
		count(*) numb
	FROM
		Pass_In_Trip
	GROUP BY ID_psg, place),
t2 as 
(	Select DISTINCT
		ID_psg,
		numb
	From t1
	Where numb = (Select max(numb) from t1))
Select name, numb From t2 Join Passenger p On t2.ID_psg=p.ID_psg