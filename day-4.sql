/*
 Q8
 Find the makers producing PCs but not laptops.
 1. makers producing PCs
 2. makers producing laptops.
 3. get the set difference
(A - B) : set_difference
 */

(select distinct maker from product where type = 'PC')
except
(select distinct maker from product where type = 'Laptop');

-- alternatively
/*
 pc_makers and laptop_makers
 left outer join
 we need to find out all the entries in the join,
 */

with pc_makers as
    (select distinct maker from product where type = 'PC'),
    laptop_makers as
    (select distinct maker from product where type = 'Laptop')
select pc_makers.maker from
(pc_makers left outer join laptop_makers
on pc_makers.maker = laptop_makers.maker
) where laptop_makers.maker is null;

/*
 Q9
 Find the makers of PCs with a processor speed
 of 450 MHz or more. Result set: maker.
 */

with pc_450 as (select * from pc where speed >= 450)
select distinct maker
from pc_450 inner join product on pc_450.model = product.model;

/*
 Q 10
 Find the printer models having the highest price. Result set: model, price.
 */

with max_price as (select max(price) from printer)
select distinct model, price from printer where price = (select * from max_price);

/*
 Q 11.
 Find out the average speed of PCs.
 */

select avg(speed) from pc;

/*
 Q12.
 Find out the average speed of the laptops priced over $1000.
 */

select avg(speed) from laptop where price > 1000;

/*
 Find out the average speed of the PCs produced by maker A.
 */

select avg(speed)
from pc inner join product on pc.model = product.model
where maker = 'A';

/*
 Q15
 Get hard drive capacities that are identical for two or more PCs.
 */

select hd from pc group by hd
having count(hd) > 1;

with hd_count as (select hd, count(hd) as cnt from pc group by hd)
select hd from hd_count where cnt > 1;

/*
 Q16
 Get pairs of PC models with identical speeds
 and the same RAM capacity. Each resulting pair should be
 displayed only once, i.e. (i, j) but not (j, i).
Result set: model with the bigger number,
 model with the smaller number, speed, and RAM.
 */

select distinct pc1.model, pc2.model, pc1.speed, pc1.ram
from pc as pc1, pc as pc2
where pc1.speed = pc2.speed and
      pc1.ram = pc2.ram and
      pc1.model > pc2.model;

-- alternatively

select distinct pc1.model, pc2.model, pc1.speed, pc1.ram
from pc as pc1 join pc as pc2
    on pc1.speed = pc2.speed
    and pc1.ram = pc2.ram
    and pc1.model > pc2.model;

/* Q17
 Get the laptop models that
 have a speed smaller than the speed of any PC.
 */

select distinct type, laptop.model, speed from laptop
    inner join product p on laptop.model = p.model
where speed < (select min(speed) from pc);

/*
 Find the makers of the cheapest color printers.
Result set: maker, price.
 */

with color_printers as
    (select * from printer where color = 'y')
select distinct maker
from color_printers as c inner join product p on c.model = p.model
where price = (select min(price) from color_printers);

-- alternatively

with color_printers as (select * from printer where color = 'y'),
min_price as (select min(price) from color_printers),
printer_products as (
select maker, price from color_printers c
    inner join product p on c.model = p.model
                        and c.price = (select * from min_price)
)
select distinct maker, price from printer_products;

/*
 Q19
 For each maker having models in the Laptop table,
 find out the average screen size of the laptops he produces.
 */

select maker, avg(screen) from product, laptop
where product.model = laptop.model
group by maker;

/*
 Q20
 Find the makers producing at least three distinct models of PCs.
 */

## below one will not work, because there are multiple items with same model.
# select maker, count(maker) as cnt from pc, product
# where pc.model = product.model
# group by maker
# having cnt >= 3;

select maker, count(type) as cnt from product
where type = 'PC'
group by maker
having cnt >= 3;
