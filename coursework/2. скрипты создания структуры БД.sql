drop database if exists bank_db;
create database bank_db;
use bank_db;

drop table if exists branch_office;
create table branch_office (
id serial primary key,
number smallint unsigned unique not null,
name varchar (100) unique not null,
macroregion varchar (255) not null,
city varchar (255) not null
);


drop table if exists office;
create table office (
id serial primary key,
number smallint unsigned unique not null,
name varchar (100) unique not null,
branch_office_id bigint unsigned not null,
constraint fk_brainch_office_id foreign key (branch_office_id) references branch_office (id)
);


drop table if exists employee;
create table employee (
id serial primary key,
lastname varchar(100) not null,
firstname varchar(100) not null,
patronymic varchar(100),
positions varchar(100) not null,
date_of_employment DATE not null,
date_of_termination DATE,
office_id bigint unsigned not null,
constraint fk_office_id foreign key (office_id) references office (id)
);


drop table if exists client_prime;
create table client_prime (
id serial primary key,
type_of_client varchar (100) not null, 
constraint check_type_of_client check (type_of_client IN ('corp','individual'))
);


drop table if exists client_corp;
create table client_corp (
id BIGINT UNSIGNED NOT NULL,
full_name varchar (250) not null,
abbreviated_name varchar (250) not null,
INN varchar(10) unique not null,
KPP varchar(9) not null,
OGRN varchar(13) not null,
OKPO varchar(14) not null,
OKVED varchar(20) not null,
address_u varchar(250) not null, 
address_f varchar(250) not null,
email varchar(120) unique not null,
primary key (id),
foreign key (id) references client_prime (id),
INDEX INN_idx(INN),
INDEX name_client_corp_idx(full_name)
);
	

drop table if exists client_individual;
create table client_individual (
id BIGINT UNSIGNED NOT NULL,
lastname varchar(100) not null,
firstname varchar(100) not null,
patronymic varchar(100),
citizenship varchar(100) not null,
birthday date not null,
passport varchar(100) not null,
primary key (id),
foreign key (id) references client_prime (id),
INDEX name_client_ind_idx(firstname, lastname, patronymic),
INDEX passport_idx(passport)
);


drop table if exists type_of_product;
create table type_of_product (
id serial primary key,
name varchar (100) not null,
type_of_client varchar (100) not null, 
check (type_of_client IN ('corp','individual'))
);


drop table if exists product;
create table product (
id serial primary key,
name varchar (100) not null,
is_functioning BOOLEAN not null,
closing_date DATE,
type_of_product_id bigint unsigned not null,
foreign key (type_of_product_id) references type_of_product (id)
);


drop table if exists program_prime;
create table program_prime (
id serial primary key,
name varchar (100) not null unique,
type_of_program varchar (100) not null,
validity_start date not null,
expiration_date date,
product_id bigint unsigned not null,
foreign key (product_id) references product (id),
check (type_of_program IN ('crediting_individual','contribution_individual','card_individual','depozit_corp','mno_corp','current_account_corp','crediting_corp'))
);


drop table if exists program_crediting_individual;
create table program_crediting_individual (
id BIGINT UNSIGNED NOT NULL,
min_loan_amount bigint unsigned not null,
max_loan_amount bigint unsigned not null,
min_loan_period tinyint unsigned not null, -- в месяцах
max_loan_period tinyint unsigned not null, -- в месяцах
type_of_payment varchar (50) not null,
min_initial_payment decimal (5,4) not null, 
min_interest_rate decimal (5,4) not null,
max_interest_rate decimal (5,4) not null, 
primary key (id),
foreign key (id) references program_prime (id),
check (type_of_payment IN ('annuity','differentiated'))
);


drop table if exists program_contribution_individual;
create table program_contribution_individual (
id BIGINT UNSIGNED NOT NULL,
min_amount bigint unsigned not null,
term int unsigned not null, -- в днях
interest_rate decimal (5,4) not null,
type_of_interest_payment varchar (50) not null,
is_capitalization boolean not null,
currency varchar (50) not null,
is_replenishment boolean not null,
is_partial_withdrawal boolean not null,
is_autoprolongation boolean not null,
is_early_termination boolean not null,
primary key (id),
foreign key (id) references program_prime (id),
check (type_of_interest_payment IN ('in end','monthly', 'yearly')),
check (currency IN ('rur','usd', 'eur'))
);


drop table if exists program_card_individual;
create table program_card_individual (
id BIGINT UNSIGNED NOT NULL,
type_of_payment_system varchar (50) not null,
type_of_card varchar (50) not null,
interest_on_balance decimal (5,4) not null,
service_cost int unsigned not null,
contactless_payment boolean not null,
currency varchar (50) not null,
credit_limit boolean not null,
min_loan_amount bigint unsigned not null,
max_loan_amount bigint unsigned not null,
min_interest_rate decimal (5,4) not null,
max_interest_rate decimal (5,4) not null, 
primary key (id),
foreign key (id) references program_prime (id),
check (type_of_payment_system IN ('visa','mir', 'master card')),
check (type_of_card IN ('standart','gold', 'platium')),
check (currency IN ('rur','usd', 'eur'))
);


drop table if exists program_depozit_corp;
create table program_depozit_corp (
id BIGINT UNSIGNED NOT NULL,
currency varchar (50) not null,
min_amount bigint unsigned not null,
term int unsigned not null, -- в днях
interest_rate decimal (5,4) not null,
increase_deposit_amount boolean not null, 
partial_revocation_amount boolean not null, 
early_review boolean not null, 
type_of_interest_payment varchar (50) not null,
contract_extension boolean not null, 
primary key (id),
foreign key (id) references program_prime (id),
check (type_of_interest_payment IN ('in end','monthly', 'yearly')),
check (currency IN ('rur','usd', 'eur'))
);


drop table if exists program_mno_corp;
create table program_mno_corp (
id BIGINT UNSIGNED NOT NULL,
currency varchar (50) not null,
min_amount bigint unsigned not null,
term int unsigned not null, -- в днях
interest_rate decimal (5,4) not null,
contract_extension bool not null, 
primary key (id),
foreign key (id) references program_prime (id),
check (currency IN ('rur','usd', 'eur'))
);


drop table if exists program_current_account_corp;
create table program_current_account_corp (
id BIGINT UNSIGNED NOT NULL,
currency varchar (50) not null,
interest_rate decimal (5,4) not null,
primary key (id),
foreign key (id) references program_prime (id),
check (currency IN ('rur','usd', 'eur'))
);


drop table if exists program_crediting_corp;
create table program_crediting_corp (
id BIGINT UNSIGNED NOT NULL,
min_loan_amount bigint unsigned not null,
max_loan_amount bigint unsigned not null,
min_loan_period tinyint unsigned not null, -- в месяцах
max_loan_period tinyint unsigned not null, -- в месяцах
type_of_payment varchar (50) not null,
type_of_transfer varchar (50) not null,
collateral boolean not null, 
lending_modes varchar (50) not null,
min_interest_rate decimal (5,4) not null,
max_interest_rate decimal (5,4) not null, 
primary key (id),
foreign key (id) references program_prime (id),
check (type_of_payment IN ('annuity','differentiated')),
check (type_of_transfer IN ('monetary','veksel')),
check (lending_modes IN ('lump sum payment','credit line'))
);


drop table if exists client_portfolio;
create table client_portfolio (
id serial primary key,
client_id bigint unsigned not null,
employee_id bigint unsigned not null,
program_id bigint unsigned not null,
contract_number varchar (50) not null,
amount decimal(30,4) not null,
validity_start date not null,
expiration_date date,
transfer_rate decimal (5,4) not null,
commission_income bigint unsigned not null,
commission_expense bigint unsigned not null,
other_income bigint unsigned not null,
other_expense bigint unsigned not null,
foreign key (client_id) references client_prime (id), 
foreign key (employee_id) references employee (id), 
foreign key (program_id) references program_prime (id),
INDEX contract_number_idx(contract_number)
);




