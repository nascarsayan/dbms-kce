/*
 Get the models and prices for all commercially available products (of any type)
 produced by maker B.
 */

with products_by_B as (select * from product
where maker = 'B'), all_available_models as (
select model, price from printer
union
select model, price from pc
union
select model, price from laptop)
select distinct model, price from all_available_models
where model in (select model from products_by_B);

-- equivalent to above

select * from (
select model, price from printer
union
select model, price from pc
union
select model, price from laptop
) as q1
where model in (select model from product
where maker = 'B');


/*
 join is cartesian product followed by some filter.
 Example: T1 contains (a, b). T2 contains (d, e, f).
 T1 X T2 will contain ((a, d), (a, e), (a, f), (b, d), (b, e), (b, f)).
 */

select * from product, printer;

select * from product left outer join printer
on product.model = printer.model;

/*
 Q4 Find all records from the Printer table
 containing data about color printers.
 */

 select * from printer
 where color = 'y';

/*
 Q5
 Find the model number, speed and hard drive capacity of PCs
 cheaper than $600 having a 12x or a 24x CD drive.
 */

select distinct model, speed, hd from pc
where
    price < 600
    and
    (cd = '12x' or cd = '24x');

/*
 Q6
 For each maker producing laptops
 with a hard drive capacity of 10 Gb or higher,
 find the speed of such laptops.
 Result set: maker, speed.

 P1: we need to filter using maker
   + maker should produce at least 1 Laptop with
     a hard drive capacity of 10 Gb or higher

 P2: we need to fetch all the laptops and their makers,
    and filter using P1
 */

# table1 - product ; table2 - Laptop

with makers_with_10gb_laptops as (
select distinct maker from product
where model in
(select model
 from laptop
 where hd >= 10
)), laptop_and_makers_10gb as (
    select product.model, maker, speed from
    laptop inner join product
    on laptop.model = product.model
    where hd >= 10
) select distinct maker, speed from laptop_and_makers_10gb
where maker in (select * from makers_with_10gb_laptops);
