/*
1. Составьте список пользователей users, которые 
осуществили хотя бы один заказ orders в интернет 
магазине.
2. Выведите список товаров products и разделов 
catalogs, который соответствует товару.
 */

-- 1

SELECT u.id, u.name 
	FROM users u
	JOIN orders o ON o.user_id = u.id
	ORDER BY u.name

-- 2

SELECT p.id, p.name, c.name
	FROM products p
	LEFT JOIN catalogs c ON p.catalog_id = c.id
	ORDER BY p.id

