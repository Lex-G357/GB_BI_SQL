/*
Урок 4. Вебинар. CRUD-операции

	Практическое задание по теме “CRUD - операции”
	
	...
	2 Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке.
	3 Первые пять пользователей пометить как удаленные.
	4 Написать скрипт, удаляющий сообщения «из будущего» (дата больше сегодняшней).
	5 Написать название темы курсового проекта.
*/

USE vk;

SELECT DISTINCT firstname FROM users
ORDER BY firstname ASC ;


-- DELETE FROM users
-- WHERE id<5;

DELETE FROM users
WHERE id>0
LIMIT 5;


DELETE FROM messages
WHERE created_at > current_timestamp();
