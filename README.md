### Prerequisites

1. Use MYSQL version >= 8 for `with (<subquery) as` syntax.

### Getting started

Download the script files from [mysql_script](./mysql_script), and run them to create seed data.
The files are also available at [sql-ex.ru](https://sql-ex.ru/db_script_download.php).

Run them to create the tables with seed data.

### Exercises

Do the exercises from [sql-ex.ru](https://sql-ex.ru/exercises/index.php?act=learn&LN=4).

#### Steps to do the exercises without login.

1. Enter without login. <br/>
    ![step-1](./assets/sqlex1.jpg)
2. SELECT (learning stage, choosing DBMS) <br/>
    ![step-2](./assets/sqlex2.jpg)
3. Reload page <br/>
    ![step-3](./assets/sqlex3.jpg)
4. Now, you can practice the exercises. <br/>
    ![step-4](./assets/sqlex4.jpg)

### Joins

Suppose these are the two tables.

Table 1

| row_number | id |
|------------|----|
| A          | 1  |
| B          | 2  |
| C          | 3  |

Table 1

| row_number | id |
|------------|----|
| D          | 2  |
| E          | 4  |
| F          | 2  |
| G          | 1  |

The left outer join will give these tuples.

```
(A, G)
(B, D), (B, F)
(C, null)
```

The right outer join will give these:

```
(B, D),
(null, E),
(B, F),
(A, G)
```

The inner join will give these:

```
(B, D), (B, F),
(A, G)
```
