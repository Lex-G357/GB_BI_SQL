/*
Задание 2.
Создайте базу данных example, разместите 
в ней таблицу users, состоящую из двух 
столбцов, числового id и строкового name.
*/
create database example;

create table users (
	id int auto_increment primary key,
	name varchar(100)
);


create database sample;


/*
Задание 3.
Создайте дамп базы данных example из предыдущего 
задания, разверните содержимое дампа в новую 
базу данных sample.

Действия в командной строке:

C:\Users\alexe>mysqldump example > example.sql

C:\Users\alexe>dir
 ...
16.10.2022  14:58             1 903 example.sql
...

C:\Users\alexe>mysql sample < example.sql

C:\Users\alexe>mysql
Welcome to the MySQL monitor...
mysql> use sample;
Database changed
mysql> show tables;
+------------------+
| Tables_in_sample |
+------------------+
| users            |
+------------------+
1 row in set (0.00 sec)
*/