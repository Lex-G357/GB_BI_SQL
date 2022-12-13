/*
Тема курсового проекта:
Описание модели хранения данных пользователей банковской системы
(banking_system).

Данный проект показывает пример хранения, использования и обработку данных 
в рамках одной банковской системы. Сама система состоит из 10 подразделений 
банка c 600 сотрудниками, 2500 клиентами и 500 клиентами-компаниями.
Каждый из клиентов-компаний имеет аккаунт (счет), а каждый клиентов 
имеет акаунт (счет) и карту.
У каждого аккаунта и карты есть пароли, которые хранятся в отдельных
таблицах.
Так же в базе присутствуют таблицы с совершенными транзакциями между счтеами
клиентов и отдельно между счетами клиентов-компаний. 

Наполнение базы происходило при помощи ресурса filldb.info

В базе присутствуют:
	12 таблиц,
	3 представления,
	2 функции,
	3 хранимые процедуры,
	2 триггера
 */


DROP DATABASE IF EXISTS banking_system;
CREATE DATABASE banking_system;
USE banking_system;


DROP TABLE IF EXISTS banks;
CREATE TABLE banks (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) UNIQUE,
    city VARCHAR(100),
    phone BIGINT UNIQUE
     
);

ALTER TABLE banks 
	ADD COLUMN email VARCHAR(100) UNIQUE;

ALTER TABLE banks 
	ADD COLUMN money BIGINT;

INSERT INTO banks VALUES ();


-- SELECT id, name, city, phone, email, money FROM banks

TRUNCATE TABLE banks;


DROP TABLE IF EXISTS banks;
CREATE TABLE banks (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) UNIQUE,
    city VARCHAR(100),
    phone BIGINT UNIQUE,
    email VARCHAR(100) UNIQUE,
    money BIGINT
    
);

INSERT INTO banks VALUES ();


DELETE FROM banks 
WHERE id>10
LIMIT 11;


DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	firstname VARCHAR(100),
    lastname VARCHAR(100),
    birthday DATE,
    gender CHAR(1),
    city VARCHAR(100),
    phone BIGINT UNIQUE,
    email VARCHAR(100) UNIQUE
    
);


INSERT INTO users VALUES ();


DROP TABLE IF EXISTS user_accounts;
CREATE TABLE user_accounts (   
    id SERIAL PRIMARY KEY,
	user_id  BIGINT UNSIGNED NOT NULL,
	bank_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	money BIGINT,
	INDEX (user_id, bank_id),
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (bank_id) REFERENCES banks(id) ON UPDATE CASCADE ON DELETE CASCADE
    
);


INSERT INTO user_accounts VALUES ();


DROP TABLE IF EXISTS user_account_passwords;
CREATE TABLE user_account_passwords ( 
	id SERIAL PRIMARY KEY,
    user_account_id BIGINT UNSIGNED NOT NULL,
    password_of_account BIGINT,
    FOREIGN KEY (user_account_id) REFERENCES user_accounts(id) ON UPDATE CASCADE ON DELETE CASCADE
    
); 


INSERT INTO user_account_passwords VALUES ();


DROP TABLE IF EXISTS cards;
CREATE TABLE cards ( 
	id SERIAL PRIMARY KEY,
    user_account_id BIGINT UNSIGNED NOT NULL,
    card_number BIGINT UNIQUE,
    cvv BIGINT,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (user_account_id) REFERENCES user_accounts(id) ON UPDATE CASCADE ON DELETE CASCADE
    
); 


INSERT INTO cards VALUES ();


DROP TABLE IF EXISTS card_passwords;
CREATE TABLE card_passwords ( 
	id SERIAL PRIMARY KEY,
    card_id BIGINT UNSIGNED NOT NULL,
    password_of_card BIGINT,
    FOREIGN KEY (card_id) REFERENCES cards(id) ON UPDATE CASCADE ON DELETE CASCADE
    
); 


INSERT INTO card_passwords VALUES ();


DROP TABLE IF EXISTS companies;
CREATE TABLE companies (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) UNIQUE,
	taxpayer_identification_number BIGINT UNIQUE,
    city VARCHAR(100),
    phone BIGINT UNIQUE,
    email VARCHAR(100) UNIQUE
    
);


INSERT INTO companies VALUES ();


DROP TABLE IF EXISTS company_accounts;
CREATE TABLE company_accounts (   
    id SERIAL PRIMARY KEY,
	company_id  BIGINT UNSIGNED NOT NULL,
	bank_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	money BIGINT,
	INDEX (company_id, bank_id),
	FOREIGN KEY (company_id) REFERENCES companies(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (bank_id) REFERENCES banks(id) ON UPDATE CASCADE ON DELETE CASCADE
    
);


INSERT INTO company_accounts VALUES ();


DROP TABLE IF EXISTS company_account_passwords;
CREATE TABLE company_account_passwords ( 
	id SERIAL PRIMARY KEY,
    company_account_id BIGINT UNSIGNED NOT NULL,
    password_of_account BIGINT,
    FOREIGN KEY (company_account_id) REFERENCES company_accounts(id) ON UPDATE CASCADE ON DELETE CASCADE
    
); 


INSERT INTO company_account_passwords VALUES ();


DROP TABLE IF EXISTS bank_employees;
CREATE TABLE bank_employees (
	id SERIAL PRIMARY KEY,
    bank_id BIGINT UNSIGNED NOT NULL, 
    user_id BIGINT UNSIGNED NOT NULL, 
    user_account_id BIGINT UNSIGNED NOT NULL, 
    firstname VARCHAR(100),
    lastname VARCHAR(100),
    birthday DATE,
    phone BIGINT,
    email VARCHAR(100) UNIQUE,
    first_work_day DATETIME DEFAULT NOW(),
    INDEX (user_id, bank_id, user_account_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE CASCADE,
    FOREIGN KEY (bank_id) REFERENCES banks(id) ON UPDATE RESTRICT ON DELETE CASCADE,
    FOREIGN KEY (user_account_id) REFERENCES user_accounts(id) ON UPDATE RESTRICT ON DELETE CASCADE
        
);


INSERT INTO bank_employees VALUES ();


DROP TABLE IF EXISTS user_transactions;
CREATE TABLE user_transactions (   
    id SERIAL PRIMARY KEY,
    date_of_transaction DATETIME DEFAULT NOW(),
    from_user_account_id BIGINT UNSIGNED NOT NULL,
    to_user_account_id BIGINT UNSIGNED NOT NULL,
    transaction_amount BIGINT,
    INDEX (from_user_account_id, to_user_account_id),
    FOREIGN KEY (from_user_account_id) REFERENCES user_accounts(id) ON UPDATE RESTRICT ON DELETE CASCADE, 
    FOREIGN KEY (to_user_account_id) REFERENCES user_accounts(id) ON UPDATE RESTRICT ON DELETE CASCADE
    
);     


INSERT INTO user_transactions VALUES ();


DROP TABLE IF EXISTS company_transactions;
CREATE TABLE company_transactions (   
    id SERIAL PRIMARY KEY,
    date_of_transaction DATETIME DEFAULT NOW(),
    from_company_account_id BIGINT UNSIGNED NOT NULL,
    to_company_account_id BIGINT UNSIGNED NOT NULL,
    transaction_amount BIGINT,
    INDEX (from_company_account_id, to_company_account_id),
    FOREIGN KEY (from_company_account_id) REFERENCES company_accounts(id) ON UPDATE RESTRICT ON DELETE CASCADE, 
    FOREIGN KEY (to_company_account_id) REFERENCES company_accounts(id) ON UPDATE RESTRICT ON DELETE CASCADE
    
);  


INSERT INTO company_transactions VALUES ();


-- Определим, кто сделал больше транзакций среди пользователей, мужчины или женщины

 SELECT gender,COUNT(gender) AS gender_count
  	FROM users u 
  	JOIN user_transactions ut ON ut.from_user_account_id = u.id
 	GROUP BY gender;
 
 
-- Определим кол-во пользователей у каждого подразделения банка
 
SELECT name, COUNT(name) AS 'users count'
	FROM banks b  
	JOIN user_accounts usa ON usa.bank_id = b.id  
	GROUP BY name;


 -- Определим кол-во сотрудников у каждого подразделения банка
 
SELECT name AS bank_name, COUNT(name) AS emp_count
	FROM banks b  
	JOIN bank_employees be ON be.bank_id = b.id  
	GROUP BY name;


 -- Определим кол-во пользователей старше 18 лет в подразделение банка с id = 2

 SELECT b.id AS bank_id, b.name AS bank_name ,COUNT(firstname) AS users_count
 FROM users u
  	JOIN user_accounts usa ON usa.user_id = u.id 
  	JOIN banks b ON  b.id = usa.bank_id 
  		WHERE timestampdiff(YEAR,birthday,now())>17 AND b.id = 2	
  		
  		
 -- Выкатим список компаний-клиентов, c городами и номерами телефонов, у подразделения банка с названием Wilkinson-Dooley
  		
 SELECT 
 b.name AS bank_name, c.id AS company_id, c.name AS company_name, c.city AS company_city, c.phone AS company_phone
 FROM companies c 
  	JOIN company_accounts ca  ON ca.company_id = c.id 
  	JOIN banks b ON  b.id = ca.bank_id 
  		WHERE b.name = "Wilkinson-Dooley"
  	ORDER BY company_id;	 
  
  
 -- Узнаем номера аккаунтов пользователей и компаний, которые отправляли одинаковые суммы меньше 1000 000р
  
 SELECT 
 ct.from_company_account_id AS 'from company account id', ut.from_user_account_id  AS 'from user account id', ct.transaction_amount AS 'transaction amount'  
 FROM company_transactions ct  
	JOIN user_transactions ut ON  ut.transaction_amount = ct.transaction_amount 
	WHERE ut.transaction_amount < 100000
	
	
-- Узнаем более подробную информацию о пользователях и компаниях, которым приходили одинаковые суммы больше 100 000р

 SELECT
 	CONCAT (usa.bank_id,' / ' ,usa.id,' // ', u.id,' / ', u.firstname,' ', u.lastname,' / ', u.city) 
 		AS 'to user, inform.(bank.id / usa.id // u.id / name / u.city)',
 	CONCAT (ca.bank_id,' / ' , ca.id,' // ' , c.id,' / ' , c.name,' / ' , c.city) 
 		AS 'to comp., inform.(bank.id / ca.id // c.id / name / c.city)', 
 	ct.transaction_amount AS 'transaction amount'
 FROM company_transactions ct
 	JOIN user_transactions ut ON ut.transaction_amount = ct.transaction_amount 
 	JOIN company_accounts ca ON ca.id = ct.to_company_account_id 
 	JOIN user_accounts usa ON usa.id =  ut.to_user_account_id 
 	JOIN companies c ON c.id = ca.company_id 
 	JOIN users u ON u.id = usa.user_id 
		WHERE ut.transaction_amount > 100000
		ORDER BY ct.transaction_amount DESC;
	
	
/* 
Сделаем перевод денежных средств в размере 300 000р от пользователя с 
номером user_accounts.id = 324, пользовтелю с номером user_accounts.id = 1169,
в рамках одного подразделения банка с номером bank.id = 5.
Так же сделаем новую запись с информацией о переводе в таблицу 
user_transactions с текущей датой.
 */
  
SELECT id, date_of_transaction, from_user_account_id, to_user_account_id, transaction_amount 
	FROM user_transactions 
		ORDER BY date_of_transaction DESC;

SELECT id, money 
	FROM user_accounts usa WHERE bank_id = 5 AND id IN (324, 1169)

START TRANSACTION;  		
	UPDATE user_accounts SET money = money - 300000 WHERE id = 324;
	UPDATE user_accounts SET money = money + 300000 WHERE id = 1169;
	INSERT INTO user_transactions (date_of_transaction,from_user_account_id,to_user_account_id,transaction_amount)
	VALUES (now(),324,1169,300000);
COMMIT;  		
  		
  		 
/* 
Сделаем перевод денежных средств в размере 1 000 000р от комапании под 
номером company_accounts.id = 187 c bank.id = 4, компании под номером 
company_accounts.id = 250 с bank.id = 8. 
Так же сделаем новую запись с информацией о переводе в таблицу 
company_transactions с текущей датой.
Дополнительные условия: вычесть комиссию в 1% от суммы перевода у 
отправителя, за перевод между разными подразделениями банка. Далее 
изменить балансы банков относительно переведенных средств.
 */
  
SELECT id, date_of_transaction, from_company_account_id, to_company_account_id, transaction_amount 
	FROM company_transactions  
		ORDER BY date_of_transaction DESC;

SELECT id, company_id, bank_id, money
	FROM company_accounts  WHERE id IN (187, 250)
	
SELECT id, name, money
	FROM banks WHERE id IN (4, 8)
	
START TRANSACTION;  		
	UPDATE company_accounts SET money = money - 1000000-1000000*0.01 WHERE id = 187;
	UPDATE company_accounts SET money = money + 1000000 WHERE id = 250;
	INSERT INTO company_transactions (date_of_transaction, from_company_account_id, to_company_account_id, transaction_amount)
		VALUES (now(),187,250,1000000);
	UPDATE banks SET money = money - 1000000 WHERE id = 4;
	UPDATE banks SET money = money + 1000000 WHERE id = 8;
COMMIT;    		
  		
	
-- 	Представление на вывод общего кол-ва пользователей и компаний-клиентов во всех подразделениях	

DROP VIEW IF EXISTS view_users_count;

CREATE VIEW view_users_count AS SELECT count(id) AS count_users_id
	FROM user_accounts 

SELECT count_users_id FROM view_users_count 


DROP VIEW IF EXISTS view_companies_count;

CREATE VIEW view_companies_count AS 
	SELECT count(id) AS count_companies_id
		FROM company_accounts 

SELECT count_companies_id FROM view_companies_count


-- Создадим представление, которое выводит данные о транзакциях пользователей
-- подразделения банка с bank.id =1

DROP VIEW IF EXISTS view_transactions;

CREATE OR REPLACE VIEW view_transactions AS 
	SELECT ut.id, ut.date_of_transaction, ut.from_user_account_id, ut.to_user_account_id, 	
	ut.transaction_amount, b.name 
		FROM user_transactions ut 
		JOIN  user_accounts usa  ON usa.id = ut.from_user_account_id
		JOIN banks b ON b.id = usa.bank_id 
		WHERE b.id = 1		
UNION
	SELECT ut.id, ut.date_of_transaction, ut.from_user_account_id, ut.to_user_account_id, 	
	ut.transaction_amount, b.name 
		FROM user_transactions ut 
		JOIN  user_accounts usa  ON usa.id = ut.to_user_account_id
		JOIN banks b ON b.id = usa.bank_id 
		WHERE b.id = 1;

SELECT id, date_of_transaction, from_user_account_id, to_user_account_id, transaction_amount FROM view_transactions
WHERE from_user_account_id = 5 ORDER BY date_of_transaction DESC;

SELECT id, date_of_transaction, from_user_account_id, to_user_account_id, transaction_amount FROM view_transactions
WHERE to_user_account_id = 5 ORDER BY date_of_transaction DESC;


-- Создадим хранимую процедуру с выводом пользователей и банка из одного города

UPDATE users SET city = 'Moscow'
WHERE birthday < '1990-01-01';

UPDATE banks SET city = 'Moscow'
WHERE id = 1;

DROP PROCEDURE IF EXISTS sp_cities_m;

DELIMITER //
CREATE PROCEDURE sp_cities_m(m_city VARCHAR(255))
BEGIN
	SELECT u.id,concat(u.firstname,' ',u.lastname) AS 'name of user', u.city, b.name AS 'bank' FROM users u
	JOIN banks b ON u.city = b.city
	WHERE b.city  = m_city ;
END//

CALL sp_cities_m('Moscow');


-- Создадим хранимую процедуру с выводом информации о сотрудниках подразделений банка

DROP PROCEDURE IF EXISTS sp_bank_n;

DELIMITER //
CREATE PROCEDURE sp_bank_n(num_bank BIGINT)
BEGIN
	SELECT b.id AS 'bank id',b.name AS bank,be.id, concat(be.firstname,' ',be.lastname) AS name, u.city,u.gender,be.first_work_day FROM bank_employees be
	JOIN users u ON be.user_id = u.id 
	JOIN banks b ON be.bank_id = b.id 
	WHERE b.id = num_bank;
END//

CALL sp_bank_n(2);


-- Создадим функцию с выводом соотношения совершенных к принятым транзакциям

DROP FUNCTION IF EXISTS count_transaction_users;

DELIMITER // 
CREATE FUNCTION count_transaction_users(check_usa_id INT)
RETURNS FLOAT READS SQL DATA
	BEGIN
   		DECLARE to_user INT;
    	DECLARE from_user INT;
    SET to_user = ( SELECT COUNT(id) FROM user_transactions ut WHERE to_user_account_id = check_usa_id);
	SET from_user = ( SELECT COUNT(id) FROM user_transactions ut WHERE from_user_account_id = check_usa_id);
RETURN to_user/from_user;
END//
    
SELECT truncate(count_transaction_users(25), 2) AS 'Соотношение совершенных к принятым транзакциям пользователя';


-- Создадим функцию с выводом общего кол-ва совершенных к принятых транзакций

DROP FUNCTION IF EXISTS count_transaction_comp;

DELIMITER // 
CREATE FUNCTION count_transaction_comp(check_comp_ac_id BIGINT)
RETURNS FLOAT READS SQL DATA
	BEGIN
   		DECLARE to_comp INT;
    	DECLARE from_comp INT;
    SET to_comp = ( SELECT COUNT(id) FROM company_transactions ct WHERE to_company_account_id = check_comp_ac_id);
	SET from_comp = ( SELECT COUNT(id) FROM company_transactions ct WHERE from_company_account_id = check_comp_ac_id);
RETURN to_comp + from_comp;
END//
    
SELECT count_transaction_comp(99) AS 'Общее кол-во входящих и исходящих транзакций компании';


-- Используя триггер выведем сообщение об ошибке, при попытке заполнить поля NULL-значениями в таблицу banks

DROP TRIGGER IF EXISTS all_insert;

DELIMITER //
CREATE TRIGGER all_insert BEFORE INSERT ON banks 
FOR EACH ROW 
BEGIN 
	IF NEW.name IS NULL OR NEW.city IS NULL OR NEW.phone IS NULL OR NEW.email IS NULL OR NEW.money IS NULL 
		THEN SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Необходимо ввести все данные';
	END IF;
END//

INSERT INTO banks (name, city, phone, email, money) VALUES (NULL,'Stocholm',1002829,NULL,4510400070);


-- Создадим триггер, который срабатывает при добавление нового пользователя и заполняет
-- значение в колонке created_ad текущими датой и временем

DROP TRIGGER IF EXISTS user_accounts_created_at;

DELIMITER //
CREATE TRIGGER user_accounts_created_at BEFORE UPDATE ON user_accounts 
	FOR EACH ROW 
	BEGIN
		SET NEW.created_at = NOW();
END//

DROP PROCEDURE IF EXISTS sp_correct_insert;

DELIMITER //
CREATE PROCEDURE sp_correct_insert()
	BEGIN
		DECLARE _rollback BIT DEFAULT b'0';
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
			SET _rollback = b'1';
		END;
	START TRANSACTION;

	INSERT INTO users (firstname, lastname, birthday, gender, city, phone, email) 
		VALUES ('Lorena','Arias','2000-03-31','f','Bogota',9010010101,'lorena@example.org');

	SET @last_user_id = last_insert_id();
	INSERT INTO user_accounts (user_id, bank_id, money) 
		VALUES (@last_user_id,2,1000000);

	IF _rollback THEN ROLLBACK;
		ELSE 
			COMMIT;
	END IF;
END//

CALL sp_correct_insert;

SELECT id,firstname, lastname, birthday, gender, city, phone, email FROM users ORDER BY id DESC;

SELECT id, user_id, bank_id, created_at, money FROM user_accounts ORDER BY id DESC;
































