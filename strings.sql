select substring_index(cd, 'x', 1), cd from pc;

# Get last 2 characters for every cd in pc
select *, substr(cd, -2) from pc;

# For string check, you can use like or regexp_like operator

# list all pc where last 2 chars is '4x'
select * from pc where substr(cd, -2) = '4x';

# get all pc where cd starts with 1 and ends with x.
select * from pc
where regexp_like(cd, '^1.*x');

# same as above

select * from pc
where cd like '1%x';
