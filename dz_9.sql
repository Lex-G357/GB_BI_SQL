/*
Практическое задание по теме “Транзакции, переменные, 
представления”
1) В базе данных shop и sample присутствуют одни и те же таблицы, 
учебной базы данных. Переместите запись id = 1 из таблицы 
shop.users в таблицу sample.users. Используйте транзакции.

2) Создайте представление, которое выводит название name товарной 
позиции из таблицы products и соответствующее название каталога 
name из таблицы catalogs.
 */

-- 1


USE shop;
SELECT id, name, birthday_at, created_at, updated_at FROM users;

START TRANSACTION;
	INSERT INTO sample.users (name) 
		SELECT name FROM shop.users WHERE id = 1;
		DELETE FROM shop.users WHERE id=1;
COMMIT;

USE sample;
SELECT id, name FROM users;

USE shop;
SELECT id, name FROM users;


-- 2


CREATE OR REPLACE VIEW products_catalogs AS
	SELECT 
		p.name AS product, 
		c.name AS catalog 
	FROM 
		products p 
	JOIN 
	catalogs c ON p.catalog_id=c.id;

SELECT product, catalog FROM products_catalogs;


/*
Практическое задание по теме “Хранимые процедуры и функции, 
триггеры"
В таблице products есть два текстовых поля: name с названием 
товара и description с его описанием. Допустимо присутствие 
обоих полей или одно из них. Ситуация, когда оба поля принимают 
неопределенное значение NULL неприемлема. Используя триггеры, 
добейтесь того, чтобы одно из этих полей или оба поля были 
заполнены. При попытке присвоить полям NULL-значение необходимо 
отменить операцию.
*/


DROP TRIGGER IF EXISTS name_description_insert;

CREATE TRIGGER name_description_insert BEFORE INSERT ON products 
FOR EACH ROW BEGIN 
	IF NEW.name IS NULL AND NEW.description IS NULL THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Both name description are NULL';
	END IF;
END;


INSERT into products (name,description,price,catalog_id) VALUES (NULL,NULL, 1233, 2);












