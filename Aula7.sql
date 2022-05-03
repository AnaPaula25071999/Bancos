USE aula7;

Create table base (base_id integer,
base_name varchar(50), 
founded date);
alter table base add primary key (base_id);

create table visitor(visitor_id integer,
host_id integer,
first_name varchar(30),
last_name varchar(80));
alter table visitor add primary key (visitor_id); 

create table supply(supply_id integer primary key,
nome varchar(80),
description varchar(120),
quantity integer);


create table inventory (inventory_id integer primary key auto_increment, base_id integer,
supply_id integer,
quantity integer,
foreign key(base_id) references base(base_id),
foreign key(supply_id) references supply(supply_id));

Create table martian_confidential
(martian_id integer primary key,
first_name varchar(40),
last_name varchar(80),
base_id int,
super_id int,
salary decimal(8,2),
dna_id varchar(30),
foreign key(base_id) references base (base_id)
);









########### 
## Criar uma view com o nome base_storage
# com a quantidade de suprimentos em cada base
### Exercício 5 ############


#### Resultado do CROSS JOIN ##################
## conecta cada linha na tabela da esquerda com cada linha
## na tabela da direita. Isso nos dá todas as combinações de base supply
## 5 bases x 10 supply itens = 50 linhas. Veja abaixo:

