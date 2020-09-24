-- Создайте таблицу logs типа Archive. 
-- Пусть при каждом создании записи в таблицах users,
-- catalogs и products в таблицу logs помещается время и дата создания записи, название
-- таблицы, идентификатор первичного ключа и содержимое поля name.

drop table if exists logs_user_cat_prod;
create table logs_user_cat_prod (
	id bigint AUTO_INCREMENT primary key,
	created_at datetime not null default CURRENT_TIMESTAMP,
	table_name varchar(255) not null,
	id_object bigint not null,
	name varchar(255) not null
)ENGINE=ARCHIVE;


DELIMITER //

create trigger trigger_insert_user_log after insert ON users
for each row
begin
	insert into logs_user_cat_prod(table_name, id_object, name)
	VALUES ('users', new.id, new.name);
	
end//

create trigger trigger_insert_catalogs_log after insert ON catalogs
for each row
begin
	insert into logs_user_cat_prod(table_name, id_object, name)
	VALUES ('catalogs', new.id, new.name);
	
end//

create trigger trigger_insert_products_log after insert ON products
for each row
begin
	insert into logs_user_cat_prod(table_name, id_object, name)
	VALUES ('products', new.id, new.name);
	
end//

DELIMITER ;



-- В базе данных Redis подберите коллекцию для подсчета посещений с определенных
-- IP-адресов.
set ip1 1
incr ip1



-- При помощи базы данных Redis решите задачу поиска имени пользователя по электронному
-- адресу и наоборот, поиск электронного адреса пользователя по его имени.

hmset user1 name ivan email ivan@ya.ru
HSCAN user 0 macth *ivan*



-- Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД
-- MongoDB.
> use shop 
> processor=({"name" : "Процессоры"})
> matherBord=({"name" : "Материнские платы"})
> videoCard=({"name" : "Видеокарты"})
> hdd=({"name" : "Жесткие диски"})
> ram=({"name" : "Оперативная память"})
> db.catalogs.save(processor)
> db.catalogs.save(matherBord)
> db.catalogs.save(videoCard)
> db.catalogs.save(hdd)
> db.catalogs.save(ram)
> prod1=({"name" : "Intel Core i3-8100", "description" : "Процессор для настольных персональных компьютеров, основанных на платформе Intel.", "price" : 7890.00, catalog : new DBRef('catalogs', processor._id)})
> prod2=({"name" : "Intel Core i5-7400", "description" : "Процессор для настольных персональных компьютеров, основанных на платформе Intel.", "price" : 12700.00, catalog : new DBRef('catalogs', processor._id)})
> prod3=({"name" : "AMD FX-8320E", "description" : "Процессор для настольных персональных компьютеров, основанных на платформе AMD.", "price" : 4780.00, catalog : new DBRef('catalogs', processor._id)})
> prod4=({"name" : "AMD FX-8320", "description" : "Процессор для настольных персональных компьютеров, основанных на платформе AMD.", "price" : 7120.00, catalog : new DBRef('catalogs', processor._id)})
> prod5=({"name" : "ASUS ROG MAXIMUS X HERO", "description" : "Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX", "price" : 19310.00, catalog : new DBRef('catalogs', matherBord._id)})
> prod6=({"name" : "Gigabyte H310M S2H", "description" : "Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX", "price" : 4790.00, catalog : new DBRef('catalogs', matherBord._id)})
> prod7=({"name" : "MSI B250M GAMING PRO", "description" : "Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX", "price" : 5060.00, catalog : new DBRef('catalogs', matherBord._id)})
> db.products.save(prod1)
> db.products.save(prod2)
> db.products.save(prod3)
> db.products.save(prod4)
> db.products.save(prod5)
> db.products.save(prod6)
> db.products.save(prod7)
