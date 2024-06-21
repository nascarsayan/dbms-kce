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

/*
 Exercise: 58
 For each product type and maker in the Product table,
 find out, with a precision of two decimal places,

 the percentage ratio of the number of models of the
 actual type produced by the actual maker
 to
 the total number of models by this maker.

 Result set: maker, product type, the percentage ratio mentioned above.
 */

-- The following does not have the values with 0 percentage

with
total_products_by_maker as (
    select maker, count(maker) as total
    from Product
    group by maker
)
select product.maker, type,
       round(count(model) * 100 / total , 2) as percentage from product
inner join total_products_by_maker
    on product.maker = total_products_by_maker.maker
group by maker, type;

-- Alternate to above,
-- The following does not have the values with 0 percentage

with
total_products_by_maker as (
select product.maker,
count(model) as total from product
group by maker),
total_products_per_type_by_maker as (
select product.maker, type,
count(model) as total_per_type from product
group by maker, type
) select t1.maker, type,
         round((total_per_type * 100 / total), 2) as percentage
  from total_products_by_maker as t1,
        total_products_per_type_by_maker as t2
where t1.maker = t2.maker;

-- The following is right

with
all_types as (
    select distinct type from Product
),
total_products_by_maker as (
    select maker, count(maker) as total
    from Product
    group by maker
),
all_makers as (
    select distinct maker from total_products_by_maker
),
total_products_per_type_by_maker as (
    select product.maker, type,
    count(model) as total_per_type from product
    group by maker, type
),
product_percentage as (
    select t1.maker, type,
         round((total_per_type * 100 / total), 2) as percentage
    from total_products_by_maker as t1,
        total_products_per_type_by_maker as t2
    where t1.maker = t2.maker
)
select all_makers.maker, all_types.type,
       ifnull(percentage, 0) as percentage
from
product_percentage as p right join (all_makers, all_types)
on p.type = all_types.type and p.maker = all_makers.maker
order by maker, type;

/*
 get third most costly item
 */

select *
from pc
order by price
limit 1 offset 1;

/*
 get all the items except for top 3 by desc
 price, hd, speed
 */

# idea is to exclude the top 3 products using their primary key
# i.e., the code.

with excluded_results as (select code
from pc
order by price desc, hd desc, speed desc
limit 3)
select * from pc where code not in (
select * from excluded_results)
order by price desc, hd desc, speed desc;

-- alternatively, get the ranks,

with pc_with_rank as (
select *, row_number()
over (order by price desc, hd desc, speed desc)
as _rank
from pc)
select * from pc_with_rank where _rank > 3;
