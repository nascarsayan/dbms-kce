drop table if exists bank_balance;

create table if not exists bank_balance (
    name varchar(255) primary key,
    balance int
);

insert into bank_balance values
('Tom', 200), ('Jerry', 500);

drop procedure if exists money_transfer;

delimiter $$@@
create procedure money_transfer(
    amount int,
    debitor varchar(255),
    creditor varchar(255)
)
begin
    start transaction;

    create table if not exists logs(message varchar(1000));
    truncate table logs;

    select balance into @debitor_balance
    from bank_balance where name = debitor;

    insert into logs select
        concat('bank balance for debitor is ', @debitor_balance, '. ');

    if @debitor_balance < amount
        then
            insert into logs select
            concat('transaction not possible as ', @debitor_balance, ' < ', amount);
        rollback;
    else
        insert into logs select
            concat('starting transaction as ', @debitor_balance, ' >= ', amount);
        update bank_balance
        set balance = balance - amount
        where name = debitor;

        insert into logs select
            concat('debited amount from ', debitor);

        update bank_balance
        set balance = balance + amount
        where name = creditor;

        insert into logs select
            concat('credited amount to ', creditor);

        commit;
    end if;

    insert into logs
        select concat('bank balance of ', name, ' is ', balance)
        from bank_balance
        where name in ('Tom', 'Jerry');

    select * from logs;
end $$@@

call money_transfer(
     50, 'Tom', 'Jerry'
);