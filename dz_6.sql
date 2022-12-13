/*
1. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, 
который больше всех общался с нашим пользователем.
2. Подсчитать общее количество лайков, которые получили пользователи младше 11 лет.
3. Определить кто больше поставил лайков (всего): мужчины или женщины.
 */

-- 1

SELECT 	from_user_id,
	(SELECT concat(firstname, ' ', lastname)  FROM users WHERE id=messages.from_user_id) AS name,
	COUNT(id) AS cnt
FROM messages
WHERE to_user_id = 1
AND from_user_id IN (
	SELECT initiator_user_id FROM friend_requests
	WHERE (target_user_id = 1) AND status ='approved'
	UNION 
	SELECT target_user_id FROM friend_requests
	WHERE (initiator_user_id = 1) AND status ='approved'
)
GROUP BY from_user_id 
ORDER BY cnt DESC 
LIMIT 1;

-- 2

SELECT count(id)
FROM likes
WHERE media_id IN (
	SELECT id
	FROM media
	WHERE user_id IN (
		SELECT user_id
		FROM profiles AS p
		WHERE timestampdiff(YEAR,birthday,now())<11)
);

-- 3

SELECT gender, count(user)
FROM (
	SELECT user_id AS user,	(
		SELECT gender
		FROM profiles
		WHERE user_id = user 
		)
	AS  gender
	FROM likes
	)
AS dummy
GROUP BY gender;
















