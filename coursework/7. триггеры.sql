
-- 9. триггер 1.
DELIMITER //

create trigger trigger_insert_client_check before insert ON client_prime
for each row
begin
	if(new.type_of_client != 'individual' && new.type_of_client != 'corp') then 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'wrong type of client';
	end if;
	
end//


create trigger trigger_update_client_check before update ON client_prime
for each row
begin
	if(new.type_of_client != 'individual' && new.type_of_client != 'corp') then 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'wrong type of client';
	end if;
	
end//

DELIMITER ;

-- 10. триггер 2.
DELIMITER //

create trigger trigger_insert_program_prime_check before insert ON program_prime
for each row
begin
	if(new.type_of_program != 'crediting_individual' 
	&& new.type_of_program != 'contribution_individual' 
	&& new.type_of_program != 'card_individual' 
	&& new.type_of_program != 'depozit_corp'
	&& new.type_of_program != 'mno_corp'
	&& new.type_of_program != 'current_account_corp'
	&& new.type_of_program != 'crediting_corp') then 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'wrong type of program';
	end if;
end//


create trigger trigger_update_program_prime_check before update ON program_prime
for each row
begin
	if(new.type_of_program != 'crediting_individual' 
	&& new.type_of_program != 'contribution_individual' 
	&& new.type_of_program != 'card_individual' 
	&& new.type_of_program != 'depozit_corp'
	&& new.type_of_program != 'mno_corp'
	&& new.type_of_program != 'current_account_corp'
	&& new.type_of_program != 'crediting_corp') then 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'wrong type of program';
	end if;
end//

DELIMITER ;


