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