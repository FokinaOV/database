-- 5. представление: расчет процентного дохода/расхода по сделкам
create or replace view interest_income_for_client as 
select cp.client_id, cp.contract_number, cp.transfer_rate, 
CASE
    WHEN pp.type_of_program = 'crediting_corp'
        THEN pcc.min_interest_rate 
    WHEN pp.type_of_program = 'crediting_individual'
        THEN pci.min_interest_rate         
    WHEN pp.type_of_program = 'contribution_individual'
        THEN p_contreb_i.interest_rate 
   	WHEN pp.type_of_program = 'card_individual'
        THEN p_card_i.min_interest_rate 
    WHEN pp.type_of_program = 'depozit_corp'
        THEN pdc.interest_rate 
   	WHEN pp.type_of_program = 'mno_corp'
        THEN pmc.interest_rate 
   	WHEN pp.type_of_program = 'current_account_corp'
        THEN pcac.interest_rate 
END AS 'interest rate',
CASE
    WHEN pp.type_of_program = 'crediting_corp'
        THEN pcc.max_loan_period 
    WHEN pp.type_of_program = 'crediting_individual'
        THEN pci.max_loan_period 
   	WHEN pp.type_of_program = 'contribution_individual'
        THEN p_contreb_i.term 
   	WHEN pp.type_of_program = 'card_individual'
        THEN 365
    WHEN pp.type_of_program = 'depozit_corp'
        THEN pdc.term 
   	WHEN pp.type_of_program = 'mno_corp'
        THEN pmc.term 
   	WHEN pp.type_of_program = 'current_account_corp'
        THEN 365
END AS 'period', 
CASE
    WHEN pp.type_of_program = 'crediting_corp'
        THEN pcc.min_interest_rate - cp.transfer_rate
    WHEN pp.type_of_program = 'crediting_individual'
        THEN pci.min_interest_rate - cp.transfer_rate
   	WHEN pp.type_of_program = 'contribution_individual'
        THEN cp.transfer_rate - p_contreb_i.interest_rate 
   	WHEN pp.type_of_program = 'card_individual'
        THEN cp.transfer_rate - p_card_i.min_interest_rate 
    WHEN pp.type_of_program = 'depozit_corp'
        THEN cp.transfer_rate - pdc.interest_rate 
   	WHEN pp.type_of_program = 'mno_corp'
        THEN cp.transfer_rate - pmc.interest_rate 
   	WHEN pp.type_of_program = 'current_account_corp'
        THEN cp.transfer_rate - pcac.interest_rate 
END AS 'margin',
cp.amount, 
CASE
    WHEN pp.type_of_program = 'crediting_corp'
        THEN round(cp.amount * (pcc.min_interest_rate - cp.transfer_rate) / 365 * pcc.max_loan_period, 4)
    WHEN pp.type_of_program = 'crediting_individual'
        THEN round(cp.amount * (pci.min_interest_rate - cp.transfer_rate) / 365 * pci.max_loan_period, 4)
	WHEN pp.type_of_program = 'contribution_individual'
        THEN round(cp.amount * (cp.transfer_rate - p_contreb_i.interest_rate) / 365 * p_contreb_i.term , 4)
   	WHEN pp.type_of_program = 'card_individual'
        THEN round(cp.amount * (cp.transfer_rate - p_card_i.min_interest_rate) / 365 * 365, 4) 
    WHEN pp.type_of_program = 'depozit_corp'
        THEN round(cp.amount * (cp.transfer_rate - pdc.interest_rate) / 365 * pdc.term , 4) 
   	WHEN pp.type_of_program = 'mno_corp'
        THEN round(cp.amount * (cp.transfer_rate - pmc.interest_rate) / 365 * pmc.term , 4) 
   	WHEN pp.type_of_program = 'current_account_corp'
        THEN round(cp.amount * (cp.transfer_rate - pcac.interest_rate) / 365 * 365, 4) 
END AS 'interest_income'
from client_portfolio cp 
join program_prime pp on pp.id = cp.program_id 
left join program_crediting_corp pcc on pcc.id = pp.id 
left join program_crediting_individual pci on pci.id = pp.id 
left join program_current_account_corp pcac on pcac.id = pp.id 
left join program_mno_corp pmc on pmc.id = pp.id
left join program_depozit_corp pdc on pdc.id = pp.id
left join program_contribution_individual p_contreb_i on p_contreb_i.id = pp.id
left join program_card_individual p_card_i on p_card_i.id = pp.id 
order by 1, 2;


select * from interest_income_for_client iifc 



-- 6. представление: расчет дохода в разрезе филиалов
create or replace view income_for_branch as 
select bo.name, sum(iifc.interest_income + cp.commission_income + cp.other_income - cp.commission_expense - cp.other_expense) as 'income'
from branch_office bo
left join office o on o.branch_office_id = bo.id 
left join employee e on e.office_id = o.id 
left join client_portfolio cp on cp.employee_id = e.id 
left join interest_income_for_client iifc on iifc.client_id = cp.client_id 
group  by 1

select * from income_for_branch 