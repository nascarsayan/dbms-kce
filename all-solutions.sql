-- Exercise: 7 (Serge I: 2002-11-02)
-- Get the models and prices for all commercially available products (of any type) produced by maker B.

select model, price from (
(select product.model, maker, price from product inner join laptop on product.model = laptop.model)
union
(select product.model, maker, price from product inner join pc on product.model = pc.model)
union
(select product.model, maker, price from product inner join printer on product.model = printer.model)
) as pr where maker = 'B';

-- Exercise: 8 (Serge I: 2003-02-03)
-- Find the makers producing PCs but not laptops.

--  NOTE: Both of the following are wrong, because the type is there in the product type

select mk2, maker from (
    (select distinct maker from product inner join pc on product.model = pc.model) as t1
    left outer join
    (select distinct maker as mk2 from product inner join laptop on product.model = laptop.model) as t2
    on t1.maker = t2.mk2
) as makermap where mk2 is null;

(select distinct maker from product inner join pc on product.model = pc.model)
except
(select distinct maker from product inner join laptop on product.model = laptop.model);

-- NOTE : Both of these works

select distinct maker from product where type = 'PC'
except
select distinct maker from product where type = 'Laptop';

select * from (select distinct maker from product where type = 'PC') as q1
where maker not in (select distinct maker from product where type = 'Laptop');

with
pc_makers as (select distinct maker from product where type = 'PC'),
laptop_makers as (select distinct maker from product where type = 'Laptop')
select * from pc_makers left join laptop_makers on pc_makers.maker = laptop_makers.maker
where laptop_makers.maker is null;

-- Exercise: 9 (Serge I: 2002-11-02)
-- Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker.

select distinct maker from product inner join pc on product.model = pc.model
where speed >= 450;

-- Exercise: 10 (Serge I: 2002-09-23)
-- Find the printer models having the highest price. Result set: model, price.

select model, price from printer
where price = (select max(price) from printer);

-- Exercise: 11 (Serge I: 2002-11-02)
-- Find out the average speed of PCs.

select avg(speed) from pc;

-- Exercise: 12 (Serge I: 2002-11-02)
-- Find out the average speed of the laptops priced over $1000.

select avg(speed) from laptop where price > 1000;

-- Exercise: 13 (Serge I: 2002-11-02)
-- Find out the average speed of the PCs produced by maker A.

select avg(speed) from pc inner join product on pc.model = product.model where maker = 'A';

-- Exercise: 14 (Serge I: 2002-11-05)
-- For the ships in the Ships table that have at least 10 guns, get the class, name, and country.

select ships.class, name, country from ships inner join classes on ships.class = classes.class
where numguns >= 10;

-- Exercise: 15 (Serge I: 2003-02-03)
-- Get hard drive capacities that are identical for two or more PCs.
-- Result set: hd.

select hd from pc
group by hd
having count(hd) >= 2;

-- Exercise: 16 (Serge I: 2003-02-03)
--
-- Get pairs of PC models with identical speeds and the same RAM capacity.
-- Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i).
-- Result set: model with the bigger number, model with the smaller number, speed, and RAM.

select distinct pc1.model as model1, pc2.model as model2, pc1.speed, pc1.ram as model1
from pc as pc1 inner join pc as pc2 on pc1.speed = pc2.speed and pc1.ram = pc2.ram
where pc1.model > pc2.model;

-- Exercise: 17 (Serge I: 2003-02-03)
--
-- Get the laptop models that have a speed smaller than the speed of any PC.
-- Result set: type, model, speed.

select distinct type, laptop.model, speed
from laptop inner join product on laptop.model = product.model
where speed < (select min(speed) from pc);

-- Exercise: 18 (Serge I: 2003-02-03)
--
-- Find the makers of the cheapest color printers.
-- Result set: maker, price.

select distinct maker, price
from printer inner join product on printer.model = product.model
where color = 'y' and price = (select min(price) from printer where color = 'y');

-- Exercise: 19 (Serge I: 2003-02-13)
--
-- For each maker having models in the Laptop table,
-- find out the average screen size of the laptops he produces.
-- Result set: maker, average screen size.

select maker, avg(screen) from product inner join laptop on product.model = laptop.model
group by maker;

-- Exercise: 20 (Serge I: 2003-02-13)
--
-- Find the makers producing at least three distinct models of PCs.
-- Result set: maker, number of PC models.

select maker, count(model) from product
where type = 'PC'
group by maker
having count(model) >= 3;

-- Exercise: 21 (Serge I: 2003-02-13)
--
-- Find out the maximum PC price for each maker having models in the PC table.
-- Result set: maker, maximum price.

select maker, max(price) from product inner join pc on product.model = pc.model
group by maker;

-- Exercise: 22 (Serge I: 2003-02-13)
--
-- For each value of PC speed that exceeds 600 MHz,
-- find out the average price of PCs with identical speeds.
-- Result set: speed, average price.

select speed, avg(price) from pc
where speed > 600
group by speed;

-- Exercise: 23 (Serge I: 2003-02-14)
--
-- Get the makers producing both PCs having a speed of 750 MHz
-- or higher and laptops with a speed of 750 MHz or higher.
-- Result set: maker

select distinct maker
from pc inner join product on pc.model = product.model
where speed >= 750
intersect
select distinct maker
from laptop inner join product on laptop.model = product.model
where speed >= 750;

-- Exercise: 24 (Serge I: 2003-02-03)
--
-- List the models of any type having the highest price of all products present in the database.

with all_prices as (
    select distinct model, price from laptop
    union
    select distinct model, price from pc
    union
    select distinct model, price from printer
) select model from all_prices
where price = (select max(price) from all_prices);

-- Exercise: 25 (Serge I: 2003-02-14)
--
-- Find the printer makers also producing PCs with the lowest RAM capacity
-- and the highest processor speed of all PCs having the lowest RAM capacity.
-- Result set: maker.

with printer_maker_pcs as (
    select speed, ram, maker from (
        select * from product
        where maker in (select distinct maker from product where type = 'Printer')
    ) as printer_maker_products inner join pc on printer_maker_products.model = pc.model
), pcs_min_ram as (
    select *
    from printer_maker_pcs
    where ram = (select min(ram) from pc) -- interestingly from printer_pc_models does not work, why??
) select distinct maker from pcs_min_ram where speed = (select max(speed) from pcs_min_ram);

-- alternatively

with
pcplusprinter as(
    select distinct maker from product where type='Printer'
    intersect
    select distinct maker from product where type='PC'
),
pc_products as (
    select c.model, c.maker, c.type from
    product as c inner join pcplusprinter p on c.maker=p.maker
    where c.type='PC'
),
pcs as (select speed, ram, t2.model, maker
  from pc as p inner join pc_products as t2 on t2.model=p.model
  where ram = (select min(ram) from pc))
select distinct maker from pcs
where pcs.speed=(select max(speed) from pcs);

-- Exercise: 26 (Serge I: 2003-02-14)
-- Find out the average price of PCs and laptops produced by maker A.
-- Result set: one overall average price for all items.

with prices as (
select price, model from pc
union all
select price, model from laptop
) select avg(price) from prices inner join product on prices.model = product.model
where maker = 'A';

-- Exercise: 27 (Serge I: 2003-02-03)
-- Find out the average hard disk drive capacity of PCs produced by makers who also manufacture printers.
-- Result set: maker, average HDD capacity.

with printer_makers as (
    select distinct maker from product
    where type = 'Printer'
) select maker, avg(hd) from pc inner join product on pc.model = product.model
where maker in (select * from printer_makers) group by maker;

-- Exercise: 28 (Serge I: 2012-05-04)
-- Using Product table, find out the number of makers who produce only one model.

select count(maker) from (select maker from product group by maker having count(model) = 1) as q;

/*
Exercise: 29 (Serge I: 2012-05-04)
Under the assumption that receipts of money (inc) and payouts (out)
are registered not more than once a day for each collection point
[i.e. the primary key consists of (point, date)],
write a query displaying cash flow data (point, date, income, expense).
Use Income_o and Outcome_o tables.
 */

select i.point, i.date, inc, `out`
 from Income_o i left outer join Outcome_o o on (i.date, i.point) = (o.date, o.point)
union
select o.point, o.date, inc, `out`
 from Income_o i right outer join Outcome_o o on (i.date, i.point) = (o.date, o.point);

/*
 Exercise: 30 (Serge I: 2003-02-14)
 Under the assumption that receipts of money (inc) and payouts (out)
 can be registered any number of times a day for each collection point
 [i.e. the code column is the primary key],
 display a table with one corresponding row for each operating date of each collection point.

Result set: point, date, total payout per day (out), total money intake per day (inc).
 Missing values are considered to be NULL.
 */

with
i as (select point, date, sum(inc) as inc from Income group by point, date),
o as (select point, date, sum(`out`) as `out` from Outcome group by point, date)
select i.point, i.date, `out`, inc from i left join o on (i.date, i.point) = (o.date, o.point)
union
select o.point, o.date, `out`, inc from i right join o on (i.date, i.point) = (o.date, o.point);

/*
 Exercise: 31 (Serge I: 2002-10-22)
For ship classes with a gun caliber of 16 in. or more, display the class and the country.
 */

select class, country from Classes where bore >= 16;

/*
One of the characteristics of a ship is
one-half the cube of the calibre of its main guns (mw).
Determine the average ship mw with an accuracy of two decimal places
for each country having ships in the database.
 */

select country, round(avg(0.5 * pow(bore, 3)), 2) from (
    select country, bore, name from Ships inner join Classes on Ships.class = Classes.class
    union
    select country, bore, ship from Outcomes inner join Classes on Outcomes.ship = Classes.class
) all_ships group by country;

/*
 Q33.
 Get the ships sunk in the North Atlantic battle.
 Result set: ship.
 */

select distinct ship from Outcomes where result = 'sunk' and battle = 'North Atlantic';

/*
 Q34.
 In accordance with the Washington Naval Treaty concluded in the beginning of 1922,
 it was prohibited to build battle ships with a displacement of more than 35 thousand tons.
Get the ships violating this treaty (only consider ships for which the year of launch is known).
List the names of the ships.
 */

-- Skip for now, hw

/* 35, 40, 41, 58,
 */

/* Q58 */

with
total_products_by_maker as (
    select maker, count(maker) as total
    from Product
    group by maker
)
select product.maker, type, round(count(model) * 100 / total , 2) as percentage from product
inner join total_products_by_maker on product.maker = total_products_by_maker.maker
group by maker, type;

-- below one will work

with
all_types as (
    select distinct type from Product
),
total_products_by_maker as (
select maker, count(maker) as total
from Product
group by maker),
all_makers as (
    select distinct maker from total_products_by_maker
),
product_percentage as (
select product.maker, type, round(count(model) * 100 / total , 2) as percentage from product
inner join total_products_by_maker on product.maker = total_products_by_maker.maker
group by maker, type)
select all_makers.maker, all_types.type, ifnull(percentage, 0) as percentage from
product_percentage as p right join (all_makers, all_types)
on p.type = all_types.type and p.maker = all_makers.maker
order by maker, type;

/* Q41 */

with commercial_models as (
    select model, price from PC
    union
    select model, price from Laptop
    union
    select model, price from Printer
), models as (
    select maker, price from commercial_models inner join Product
    on commercial_models.model = Product.model
), null_makers as (
    select distinct maker from models where price is null
)
select models.maker, if(null_makers.maker is not null, null, max(price)) as price
from models left join null_makers
on models.maker = null_makers.maker
group by models.maker;

