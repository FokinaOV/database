	-- Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

select *
from vk.users u 
where u.id in (select m.to_user_id
				from vk.users u 
				join vk.friend_requests fr on fr.initiator_user_id = u.id 
				join vk.messages m on m.to_user_id = fr.target_user_id 
				where u.id = 75
				and m.from_user_id  = 75
				and fr.status = 'approved'
				group by 1
				having count(m.id ) = (select max(tbl.cnt)
										from (select m.to_user_id as sddd, count(m.id) as cnt
										from vk.users u 
										join vk.friend_requests fr on fr.initiator_user_id = u.id 
										join vk.messages m on m.to_user_id = fr.target_user_id 
										where u.id = 75
										and m.from_user_id  = 75
										and fr.status = 'approved'
										group by 1) as tbl)) 



-- Подсчитать общее количество лайков, которые получили пользователи младше 10 лет..
-- с джойнами
select count(l.id) 
from vk.users u 
join vk.profiles p on p.user_id = u.id 
join vk.media m on m.user_id = u.id 
join vk.likes l on l.media_id = m.id 
where (p.birthday + INTERVAL 10 year) > now()

-- с вложенными запросами
select count(l.id ) 
from vk.likes l 
where l.media_id in (select m.id 
					from vk.media m 
					where m.user_id in (select p.user_id 
										from vk.profiles p 
										where (birthday + INTERVAL 10 YEAR) > now()))





-- Определить кто больше поставил лайков (всего): мужчины или женщины.
select p.gender, count(l.id) 
from vk.likes l 
join vk.users u on l.user_id = u.id 
join vk.profiles p on u.id = p.user_id 
group by 1