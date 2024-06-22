/*
 Placements
 https://www.hackerrank.com/challenges/placements/problem
 */

/*
 1. We have the list of salaries by the student id.
 2. We can first find out the tuples (my_id, friend_id, friend_salary).
 3. Once we have my friend salary, we can compare to my own salary.
 4. To compare, we just join salary and friend_salary, both table have my id common.
 5. Once we join, we just filter out the rows where friend salary is greater.
 */

select name
from (
    select f.id, f.friend_id, salary as friend_salary from
    packages p inner join friends f
    on p.id = f.friend_id
) friend_packages
inner join packages
on friend_packages.id = packages.id
inner join students on packages.id = students.id
where friend_salary > salary
order by friend_salary;

-- alternatively.

with friend_packages as (
    select f.id, f.friend_id, salary as friend_salary from
    packages p inner join friends f
    on p.id = f.friend_id
), my_and_friend_package as (
    select f.id, f.friend_id, f.friend_salary, p.salary from
    friend_packages f inner join packages p
    on f.id = p.id
) select name from
my_and_friend_package inner join students
on my_and_friend_package.id = students.id
where friend_salary > salary
order by friend_salary;

/*
 Top Competitors
 https://www.hackerrank.com/challenges/full-score/problem
 */

select h.hacker_id, h.name from
submissions s inner join challenges c
on s.challenge_id = c.challenge_id
# and s.hacker_id = c.hacker_id
    # why is it wrong if we add above condition?
    # because c.hacker_id is the id of the hacker who created the challenge,
    # not the hacker who is taking part in the challenge.
inner join difficulty d
on c.difficulty_level = d.difficulty_level
inner join hackers h
on s.hacker_id = h.hacker_id
where s.score = d.score
group by h.hacker_id, h.name
having count(h.hacker_id) > 1
order by count(h.hacker_id) desc, h.hacker_id;

/*
 The Report
 https://www.hackerrank.com/challenges/the-report/problem
 */

select if(grade >= 8, name, null),
       grade, marks from students s, grades g
where s.marks >= g.min_mark and s.marks <= g.max_mark
order by grade desc,
case
    when grade >= 8 then name
    else marks
end;

