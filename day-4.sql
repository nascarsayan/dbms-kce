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

#############################################

/*
 https://sql-ex.ru/exercises.php?N=1%20&X=1
 */

/*
   The model numbers of Vitya's printer and Olya's laptop
   differ by the ten's digit only.
   Find all possible model combinations of Vitya's printer and Olya's laptop.
*/

delimiter %%
create function remove_tens_digit
    (
        val int
    ) returns int
    reads sql data
    begin
        # 1579 : 159
        # 1579 / 100 = 15
        # 15 * 10 + 9
        return (val div 100) * 10 + val % 10;
    end
%%
with
printer as (select *, remove_tens_digit(model)
    as v from product where type = 'Printer'),
laptop as (select *, remove_tens_digit(model)
    as v from product where type = 'Laptop')
select *
from printer inner join laptop on printer.v = laptop.v;

/*
 Dima and Misha use products by the same maker.
 */

select *
from product p1 inner join product p2
where p1.maker = p2.maker;

/*
 The type of Tanya's printer differs from the Vitya’s one,
 but their color properties have the same value.
 */

select * from printer p1 inner join printer p2
on p1.type != p2.type and p1.color = p2.color;

/*
 The screen of Dima's laptop
 is 3 inches bigger than the screen of Olya's one.
 */

select * from laptop l1 inner join laptop l2
where l1.screen = l2.screen + 3;

/*
 Misha's PC is 4 times more expensive than Tanya's printer.
 */

select * from pc p1 inner join printer p2
where p1.price = p2.price * 4;

/*
 Kostya's PC has
 a processor speed like Misha's PC;
 a hard drive capacity like Dima's laptop;
 a RAM capacity like Olya's laptop;
 and costs like Vitya's printer
 */

drop function if exists is_palindrome;

delimiter %%
create function is_palindrome(
    num int
) returns varchar(1)
deterministic
begin
    set @reversed := 0, @tmpNum := num;
    label:
    while (@tmpNum > 0) do
        set @reversed = @reversed * 10 + @tmpNum % 10;
        set @tmpNum = @tmpNum div 10;
    end while label;
    if @reversed = num
        then return 'y';
    else
        return 'n';
    end if;
end %%

drop function if exists is_palindrome_2;
delimiter %%
create function is_palindrome_2(
    num int
) returns varchar(1)
deterministic
begin
    set @n := concat(num);
    return if(
           strcmp(@n, reverse(@n)) = 0,
           'y', 'n');
end %%

select is_palindrome_2(1331);
select is_palindrome_2(123);
