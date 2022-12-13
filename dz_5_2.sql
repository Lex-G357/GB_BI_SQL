/*
 Практическое задание теме «Агрегация данных»
 
 1 Подсчитайте средний возраст пользователей в таблице users.
 
 2 Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
 Следует учесть, что необходимы дни недели текущего года, а не года рождения.
 
 
*/


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
 
 
 -- 1
 
ALTER TABLE users ADD COLUMN age int;

SELECT name, 
	FLOOR((to_days(now()) - to_days(birthday_at))/ 365.25) age
FROM users;

-- 2

SELECT
	DAYNAME(CONCAT(DATE_FORMAT(NOW(), '%Y-'), 
	DATE_FORMAT(birthday_at, '%m-%d'))) 
	AS day_of_the_week,
	COUNT(CONCAT(DATE_FORMAT(NOW(), '%Y-'), 
	DATE_FORMAT(birthday_at, '%m-%d'))) 
	AS total_birthdays
FROM users
GROUP BY day_of_the_week
ORDER BY
	DAYOFWEEK(day_of_the_week);





