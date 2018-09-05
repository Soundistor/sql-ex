Product(maker, model, type)
PC(code, model, speed, ram, hd, cd, price)
Laptop(code, model, speed, ram, hd, price, screen)
Printer(code, model, color, type, price)

--23--
select distinct Product.maker
from Product
inner join pc on Product.model=pc.model
Where pc.speed >= 750 and exists(
select pd.maker
from Product Pd
inner join Laptop lt on pd.model=lt.model 
Where Product.maker=pd.maker and lt.speed >= 750)

--24--
select distinct model from (
	select model, price
from pc 
Where price = (select max(price) from pc pcc)
Union
	select model, price
from Laptop
Where price = (select max(price) from Laptop lpt)
Union 
	select model, price
from Printer
Where price = (select max(price) from Printer prt))
Where price = (select max(price) from (
select model, price
from pc 
Where price = (select max(price) from pc pcc)
Union
	select model, price
from Laptop
Where price = (select max(price) from Laptop lpt)
Union 
	select model, price
from Printer
Where price = (select max(price) from Printer prt))) 

--25--
select distinct Product.maker
from Product, pc
Where Product.model=pc.model and product.type = 'PC' 
and pc.ram = (select min(pcc.ram) from pc pcc where pcc.ram <> 0) and pc.speed = (select max(pccc.speed) from pc pccc
where pccc.ram = (select min(pcc.ram) from pc pcc where pcc.ram <> 0))
and exists(select p.maker from Product p
where p.type = 'Printer' and p.maker=product.maker)

--26--
select avg(price) from (
	select pc.price as price, pc.model as model, product.type 
	from pc, product Where pc.model = product.model and product.maker = 'A' and product.type='PC'
Union all
select lpt.price as price, lpt.model as model, product.type 
	from Laptop lpt, product Where lpt.model = product.model and product.maker = 'A' and product.type='Laptop')

--27--
select product.maker, avg(pc.hd)
from product, pc
Where product.model=pc.model and product.type='PC' and exists(select pr.model from product pr where pr.maker = product.maker and pr.type='Printer')
Group by maker

--28--
select count(maker) qty
from product
Where (select count(model) from product pr where product.maker=pr.maker) = 1


