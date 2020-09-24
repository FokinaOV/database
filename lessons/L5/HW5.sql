-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем. 

update users 
set users.created_at = now(),
users.birthday_at = now();


-- Таблица users была неудачно спроектирована. 
-- Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". 
-- Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения. 

update users 
set column1 = STR_TO_DATE(column1 , "%d.%m.%Y %h:%i");

ALTER TABLE shop.users MODIFY COLUMN shop.users.created_at DATETIME;
ALTER TABLE shop.users MODIFY COLUMN shop.users.updated_at DATETIME;


-- В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. 
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей. 

select *
from storehouses_products sp 
order by if(sp.value = 0, 1, 0), sp.value;


-- (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
Месяцы заданы в виде списка английских названий ('may', 'august') 
select * 
from users u 
where monthname(u.birthday_at) in ('may', 'august'); 


-- (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. 
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
-- Отсортируйте записи в порядке, заданном в списке IN. 

SELECT * FROM catalogs WHERE id IN (5, 1, 2) 
ORDER BY FIELD(id, 5, 1, 2); 







-- Подсчитайте средний возраст пользователей в таблице users 

select round(avg(DATEDIFF(now(), u.birthday_at)/365), 0)
from users u 


-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения. 

select 
case
	when weekday( date_add(u.birthday_at , interval year(CURDATE())-YEAR(u.birthday_at ) YEAR)) = 0 then 'пн'
	when weekday( date_add(u.birthday_at , interval year(CURDATE())-YEAR(u.birthday_at ) YEAR)) = 1 then 'вт'
	when weekday( date_add(u.birthday_at , interval year(CURDATE())-YEAR(u.birthday_at ) YEAR)) = 2 then 'ср'
	when weekday( date_add(u.birthday_at , interval year(CURDATE())-YEAR(u.birthday_at ) YEAR)) = 3 then 'чт'
	when weekday( date_add(u.birthday_at , interval year(CURDATE())-YEAR(u.birthday_at ) YEAR)) = 4 then 'пт'
	when weekday( date_add(u.birthday_at , interval year(CURDATE())-YEAR(u.birthday_at ) YEAR)) = 5 then 'сб'
	when weekday( date_add(u.birthday_at , interval year(CURDATE())-YEAR(u.birthday_at ) YEAR)) = 6 then 'вс'
end as 'day of week',
count(weekday( date_add(u.birthday_at , interval year(CURDATE())-YEAR(u.birthday_at ) YEAR))) as 'count'
from users u 
group by 1

