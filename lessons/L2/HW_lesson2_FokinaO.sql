/* Задача 2
Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.
*/

-- создание базы данных example
create database example;

-- создание таблицы users
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id int NOT NULL AUTO_INCREMENT,
  name VARCHAR(100),
  PRIMARY KEY (id)
  );

-- наполнение данными
 INSERT INTO users(name) VALUES
  ('user1'),
  ('user2'),
  ('user3');



/* Задача 3
Создайте дамп базы данных example из предыдущего задания, разверните содержимое дампа в новую базу данных sample.
*/

-- создание dump
mysqldump -u oksana -p example > D:dump_20200313.sql

-- создание базы данных sample
create database sample;

--разверните содержимое дампа в новую базу данных sample
mysql -u oksana -p sample < D:\dump_20200313.sql



/* Задача 4 
Создайте дамп единственной таблицы help_keyword базы данных mysql. Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы.
*/

mysqldump -u oksana -p --where="true limit 100"  mysql help_keyword > D:\first100row.sql
