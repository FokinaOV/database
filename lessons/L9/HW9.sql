-- В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции. 

start transaction;
insert into sample.users (name)
select u.name
from shop.users u 
where u.id  = 1;

delete from shop.orders -- удаляем т.к. есть fk на users и действия дефолтные с fk при удалении.
where user_id = 1;
delete from shop.users 
where id = 1;
commit;



-- Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs. 

create view prod_cat_name as 
select p.name 'name of prod', c.name 'name of cat'
from shop.products p 
join shop.catalogs c on c.id = p.catalog_id;


-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", 
-- с 00:00 до 6:00 — "Доброй ночи". 

DELIMITER //

drop procedure if exists hello//
create procedure hello()
begin
	declare hour_current int default hour(now());
	
	if(hour_current >= 6 && hour_current < 12) then
		select 'Доброе утро' as msg;
	elseif(hour_current >= 12 && hour_current < 18) then
		select 'Добрый день' as msg;
	elseif(hour_current >= 18 && hour_current <= 23) then
		select 'Добрый вечер' as msg;
	elseif(hour_current >= 0 && hour_current < 6) then
		select 'Доброй ночи' as msg;
	else
		select 'что-то пошло не так!';
	end if; 
end//

DELIMITER ;




-- В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. 
-- Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

DELIMITER //

create trigger trigger_insert_prod_check_null before insert ON products
for each row
begin
	if(new.name is null && new.description is null) then 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'only one attribute can be null (name or description)';
	end if;
	
end//

create trigger trigger_update_prod_check_null before insert ON products
for each row
begin
	if(new.name is null && new.description is null) then 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'only one attribute can be null (name or description)';
	end if;
	
end//

DELIMITER ;


