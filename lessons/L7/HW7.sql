-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине. 

select distinct u.*
from shop.users u 
join shop.orders o on o.user_id = u.id 



 -- Выведите список товаров products и разделов catalogs, который соответствует товару. 

select p.*, c.name as 'name catalog'
from shop.products p 
join shop.catalogs c on c.id = p.catalog_id 




 -- (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
 -- Поля from, to и label содержат английские названия городов, поле name — русское. 
 -- Выведите список рейсов flights с русскими названиями городов. 

select f.id, c.name, c1.name 
from air.flights f 
join air.cities c on c.label = f.`from` 
join air.cities c1 on c1.label  = f.`to` 