--Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке

select distinct u.firstname 
from vk.users u
order by u.firstname


--Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = false). Предварительно добавить такое поле в таблицу profiles со значением по умолчанию = true (или 1)

ALTER TABLE vk.profiles ADD `is_active` BOOL DEFAULT true NOT NULL;

update vk.profiles 
set is_active = false 
where  DATEDIFF(now(), birthday )/365 < 18;


--Написать скрипт, удаляющий сообщения «из будущего» (дата больше сегодняшней)

delete from vk.messages 
where created_at > now();