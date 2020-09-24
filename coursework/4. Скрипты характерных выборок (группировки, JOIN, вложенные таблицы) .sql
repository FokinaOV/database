-- --1. Кол-во клиентов у каждого сотрудника
select concat(e.firstname, ' ', e.lastname, ' ', e.patronymic) as 'fio employee', count(distinct cp.client_id) as 'count clients'  
from employee e 
join client_portfolio cp on cp.employee_id = e.id 
group by 1;


-- --2. Кол-во типов продуктов на каждого клиента
select 
CASE
    WHEN cp.type_of_client = 'individual'
        THEN concat(ci.firstname, ' ', ci.lastname, ' ', ci.patronymic)
    WHEN cp.type_of_client = 'corp'
        THEN cc.full_name 
END AS 'Client name',
count(distinct tp.id) as 'count of top'
from client_prime cp 
left join client_individual ci on ci.id = cp.id 
left join client_corp cc on cc.id  = cp.id 
join client_portfolio c_port on c_port.client_id = cp.id 
join program_prime pp on pp.id = c_port.program_id 
join product p on p.id = pp.product_id 
join type_of_product tp on tp.id = p.type_of_product_id 
group by 1;

-- --3. Кол-во сделок у каждого клиента
select cp.id as id,
CASE
    WHEN cp.type_of_client = 'individual'
        THEN concat(ci.firstname, ' ', ci.lastname, ' ', ci.patronymic)
    WHEN cp.type_of_client = 'corp'
        THEN cc.full_name 
END AS 'Client name',
count(distinct c_port.contract_number) as 'count of contract'
from client_portfolio c_port 
join client_prime cp on cp.id = c_port.client_id 
left join client_individual ci on ci.id = cp.id 
left join client_corp cc on cc.id  = cp.id 
group by 1, 2;


-- --4. клиенты с максимальным кол-вом сделок
select cp.id as id,
count(distinct c_port.contract_number) as 'count of contract'
from client_portfolio c_port 
join client_prime cp on cp.id = c_port.client_id 
group by 1
having count(distinct c_port.contract_number) = (select max(tbl.cnt)
from (select cp.id as id,
CASE
    WHEN cp.type_of_client = 'individual'
        THEN concat(ci.firstname, ' ', ci.lastname, ' ', ci.patronymic)
    WHEN cp.type_of_client = 'corp'
        THEN cc.full_name 
END AS 'Client name',
count(distinct c_port.contract_number) as 'cnt'
from client_portfolio c_port 
join client_prime cp on cp.id = c_port.client_id 
left join client_individual ci on ci.id = cp.id 
left join client_corp cc on cc.id  = cp.id 
group by 1, 2) as tbl);