/*
1) Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
catalogs и products в таблицу logs помещается время и дата создания записи, название 
таблицы, идентификатор первичного ключа и содержимое поля name.
2) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
*/

-- 1

USE shop;
DROP TABLE IF EXISTS logs;
CREATE TABLE logs(
	tablename VARCHAR(255),
	extenal_id INT,
	name VARCHAR(255),
	created_ad DATETIME DEFAULT CURRENT_TIMESTAMP
	);

DROP TRIGGER IF EXISTS log_after_insert_to_users
DELIMITER //
CREATE TRIGGER log_after_insert_to_users AFTER INSERT ON users
FOR EACH ROW BEGIN 
	INSERT INTO logs(tablename, extenal_id, name) VALUES('users', NEW.id, NEW.name);
END//

INSERT INTO users (name, birthday_at) 
	VALUES ('Геннадий', '1990-10-05');

DROP TRIGGER IF EXISTS log_after_insert_to_catalogs;
DELIMITER //
CREATE TRIGGER log_after_insert_to_catalogs AFTER INSERT ON catalogs
FOR EACH ROW BEGIN 
	INSERT INTO logs(tablename, extenal_id, name) VALUES('catalogs', NEW.id, NEW.name);
END//

INSERT INTO catalogs (name) 
VALUES ('Оперативная память'),('Жессткие диски'),('Блоки питания');

DROP TRIGGER IF EXISTS log_after_insert_to_products;
DELIMITER //
CREATE TRIGGER log_after_insert_to_products AFTER INSERT ON products
FOR EACH ROW BEGIN 
	INSERT INTO logs(tablename, extenal_id, name) VALUES('products', NEW.id, NEW.name);
END//

INSERT INTO products (name, description, price, catalog_id) 
	VALUES ('ASUS PRIME Z370-P', 'HDMI, SATA3, PCI Exspress 3.0, USB 3.1', 9360.00, 2);

SELECT tablename, extenal_id, name,created_ad FROM logs;


-- 2

DROP TABLE IF EXISTS samples;
CREATE TABLE samples (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  birthday_at DATE ,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO samples (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

INSERT INTO users (name, birthday_at)
SELECT fst.name, fst.birthday_at 
	FROM samples AS fst, samples AS snd,samples AS thd, samples AS fth,samples AS fif,samples AS sth;

SELECT count(id) FROM users

























