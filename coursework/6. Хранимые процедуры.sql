-- 7. процедура 1.
DELIMITER //

drop procedure if exists insert_client_individual//
create procedure insert_client_individual(in lastname varchar(100), in firstname varchar(100), in patronymic varchar(100), in citizenship varchar(100), in birthday date, in passport varchar(100))
begin
	declare exit HANDLER for sqlexception
	begin
		rollback;
	end;
  
	start transaction;
		insert into client_prime (type_of_client) values('individual');
		insert into client_individual (id, firstname, lastname, patronymic, citizenship, birthday, passport) 
		values(LASt_INSERT_ID(), firstname, lastname, patronymic, citizenship, birthday, passport);
	commit;

end//

DELIMITER ;




-- 8. процедура 2.
DELIMITER //

drop procedure if exists insert_client_corp//
create procedure insert_client_corp(in full_name varchar(255), in abbreviated_name varchar(255), in INN varchar(10), in KPP varchar(9), in OGRN varchar(13), in OKPO varchar(14), in OKVED varchar(20), in address_u varchar(250), in address_f varchar(250), in email varchar(120))
begin
	declare exit HANDLER for sqlexception
	begin
		rollback;
	end;
  
	start transaction;
		insert into client_prime (type_of_client) values('corp');
		insert into client_corp (id, full_name, abbreviated_name, INN, KPP, OGRN, OKPO, OKVED, address_u, address_f, email) 
		values(LASt_INSERT_ID(), full_name, abbreviated_name, INN, KPP, OGRN, OKPO, OKVED, address_u, address_f, email);
	commit;

end//

DELIMITER ;


