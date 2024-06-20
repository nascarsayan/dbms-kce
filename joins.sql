/*

 PC

 1. Find all PC models which are not commercially available.

 product table - pc table on the model

 We need outer join here.
 product left outer join PC
 because we need all models,
 which is available in the product table.
 */

select product.model from (
product left outer join pc
on product.model = pc.model)
where product.type = 'PC'
and pc.model is null;

/*
 2. Find all PCs which are commercially available.
 */

select distinct product.model from (
product left outer join pc
on product.model = pc.model)
where product.type = 'PC'
and pc.model is not null;

-- below one is better

select distinct model from pc;

/*
 Find all products which are commercially available.

 */

select distinct model, type from laptop, (select 'Laptop' as type) as q1
union
select distinct model, type from pc, (select 'PC' as type) as q1
union
select distinct model, q1.type from printer, (select 'Printer' as type) as q1

/*
 Question: Find all products which are not commercially available.
 */

