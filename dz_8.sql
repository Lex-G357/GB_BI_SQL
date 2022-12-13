/*
1. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, 
который больше всех общался с нашим пользователем.
2. Подсчитать общее количество лайков, которые получили пользователи младше 11 лет.
3. Определить кто больше поставил лайков (всего): мужчины или женщины.
 */

-- 1

SELECT from_user_id ,to_user_id, concat(u.firstname, ' ', u.lastname) AS name, COUNT(to_user_id) AS cnt
	FROM users u 
	JOIN messages m ON u.id = m.from_user_id 
		WHERE m.to_user_id = 1
		GROUP BY m.from_user_id 
		ORDER BY cnt DESC 
		LIMIT 1;

	
-- 2

SELECT COUNT(birthday) AS cnt
	FROM profiles p
	JOIN likes l ON p.user_id=l.user_id
		WHERE timestampdiff(YEAR,birthday,now())<11

	
-- 3 
 
 SELECT gender,count(gender) as likes_count
  	FROM profiles p 
  	JOIN likes l ON l.user_id = p.user_id
 	GROUP BY gender;
 
