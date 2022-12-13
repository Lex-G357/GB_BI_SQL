/*
 Практическое задание по теме 
 «Операторы, фильтрация, сортировка и ограничение»
 
 1 Пусть в таблице users поля created_at и updated_at 
 оказались незаполненными. Заполните их текущими датой и временем.
 
 2 Таблица users была неудачно спроектирована. 
 Записи created_at и updated_at были заданы типом VARCHAR и в них 
 долгое время помещались значения в формате 20.10.2017 8:10. Необходимо 
 преобразовать поля к типу DATETIME, сохранив введённые ранее значения.
 
 3 В таблице складских запасов storehouses_products в поле value могут 
 встречаться самые разные цифры: 0, если товар закончился и выше нуля, 
 если на складе имеются запасы. Необходимо отсортировать записи таким 
 образом, чтобы они выводились в порядке увеличения значения value. 
 Однако нулевые запасы должны выводиться в конце, после всех записей.
  
  */


CREATE DATABASE lesson_5;

-- 1

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Имя покупателя',
	birthday_at DATE COMMENT 'Дата рождения',
	created_at DATETIME,
	updated_at DATETIME 
) 
COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
	('Геннадий', '1990-10-05'),
	('Наталья', '1984-11-12'),
	('Александр', '1985-05-20'),
	('Сергей', '1988-02-14'),
	('Иван', '1998-01-12'),
	('Мария', '1992-08-29');
 
UPDATE users 
SET 
	created_at = CURRENT_TIMESTAMP, 
	updated_at = CURRENT_TIMESTAMP;


-- 2

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Имя покупателя',
	birthday_at DATE COMMENT 'Дата рождения',
	created_at VARCHAR(25),
	updated_at VARCHAR(25)
) 
COMMENT = 'Покупатели';


INSERT INTO users (created_at, updated_at) VALUES
	('20.10.2017 8:10', '20.10.2017 8:10'),
	('20.10.2017 8:10', '20.10.2017 8:10'),
	('20.10.2017 8:10', '20.10.2017 8:10'),
	('20.10.2017 8:10', '20.10.2017 8:10'),
	('20.10.2017 8:10', '20.10.2017 8:10'),
	('20.10.2017 8:10', '20.10.2017 8:10');

ALTER TABLE users
	ADD new_created_at DATETIME,
	ADD new_updated_at DATETIME;

UPDATE users
SET
	new_created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i:%S'),
	new_updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i:%S');

ALTER TABLE users
	DROP COLUMN created_at,
 	DROP COLUMN updated_at;

ALTER TABLE users
	CHANGE new_created_at created_at DATETIME,
	CHANGE new_updated_at updated_at DATETIME;
 
 
-- 3

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
	id SERIAL PRIMARY KEY,
	storehouse_id INT UNSIGNED,
	product_id INT UNSIGNED,
	value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)
COMMENT = 'Запасы на складе';


INSERT INTO storehouses_products(value) VALUES
	(1),
	(2),
	(5),
	(7),
	(3),
	(9),
	(4),
	(0);

SELECT id, storehouse_id, product_id,value,created_at, updated_at 
	FROM storehouses_products ORDER BY IF(value>0,0,1), value;

