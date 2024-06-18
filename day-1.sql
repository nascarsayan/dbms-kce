create database if not exists kce;

drop table if exists Book;

create table Book (
    title VARCHAR(255),
    isbn VARCHAR(255) primary key,
    author VARCHAR(255),
    genre VARCHAR(255),
    price DECIMAL(10,2)
);

insert into Book
(title, isbn, author, genre, price)
values
('Harry Potter and the Philosopher\'s Stone','1-56619-909-3', 'JK Rowling', 'Fantasy Thriller', 200),
('Harry Potter and the Chamber of Secrets','1-56619-909-4', 'JK Rowling', 'Fantasy Thriller', 200),
('Harry Potter and the Prisoner of Azkaban','1-56619-909-5', 'JK Rowling', 'Fantasy Thriller', 200);

/* 1. List all printer makers. Result set: maker.
 */

select distinct maker
 from product
 where type = 'Printer';

/*
 Find the model number, RAM and screen size of the laptops with prices over $1000.
 */

select distinct model, ram, screen from laptop
where price >= 1000;

select model, avg(speed), avg(ram), avg(hd), avg(price) from pc
# where price > 500
group by model
having min(price) > 500;

select * from (
select model, avg(speed), avg(ram), avg(hd), avg(price), min(price) as min_price
from pc
group by model) as q1
where min_price > 500;


