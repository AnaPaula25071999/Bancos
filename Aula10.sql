##1_a)
USE classicmodels;
DELIMITER $$
create procedure GetCustomers()
begin
	select
		customerName,
        city,
        state,
        postalCode,
        country
	FROM
		customers
	order by customerName;
END$$
DELIMITER;

CALL GetCustomers();

##1_b)
DELIMITER $$
create procedure Selecionar_Produtos(IN quantidade int)
begin
	select * FROM products
	limit quantidade;
END$$
DELIMITER ;

call Selecionar_Produtos(2);

##1_c)
DELIMITER $$
create procedure tentativa1(IN codigo varchar)
begin
	select 
    employeeNumber
    concat(firstName, " ", lastName) AS fullname
    FROM employees
	limit officeCode;
END$$
DELIMITER ;

call tentativa1();


##2_a)
DELIMITER $$
create procedure verificar_quantidade_produtos(OUT quant INT)
begin
    select COUNT(*) INTO quant FROM products;
END$$
DELIMITER ;
call verificar_quantidade_produtos(@total);
select @total as 'quantidade de produtos';


##2_b)
DELIMITER $$
create procedure verificar_quantidade_empregados(OUT quant INT)
begin
    select COUNT(*) employeeNumber INTO quant FROM employees;
END$$
DELIMITER ;

call verificar_quantidade_empregados(@total);
select @total as ' numero total de funcionarios';

##1_c)
DELIMITER $$
create procedure Elevar_ao_Quadrado(INOUT numero INT)
begin
    set numero = numero * numero;
END$$
DELIMITER ;
set @valor = 9;
call Elevar_ao_Quadrado(@valor);
select @valor as ' numero ao quadrado';

##2_c)
DELIMITER $$
create procedure valor_venda(INOUT numero INT)
begin
    set numero = 1.5 * numero;
END$$
DELIMITER ;
set @valor = 10;
call valor_venda(@valor);
select @valor as 'Valor de venda';

##### BANCO DE DADOS AP
##1_d)
####################### Procedimento armazenado que utiliza variáveis ################################
####################### Procedimento armazenado que utiliza variáveis ################################
DELIMITER // 
CREATE PROCEDURE test() 
BEGIN 
    DECLARE max_invoice_total DECIMAL (9, 2);
    DECLARE min_invoice_total DECIMAL (9, 2);
    DECLARE percent_difference DECIMAL (9, 2);
    DECLARE count_invoice_id INT;
    DECLARE vendor_id_var INT;
    SET     vendor_id_var = 95;
    SELECT MAX(invoice_total),
           MIN(invoice_total),
           COUNT(invoice_id) INTO max_invoice_total,
           min_invoice_total,
           count_invoice_id
    FROM   invoices
    WHERE  vendor_id = vendor_id_var;
    SET percent_difference = (max_invoice_total - min_invoice_total) / min_invoice_total * 100;
    SELECT CONCAT('$', max_invoice_total) AS 'Maximum invoice',
           CONCAT('$', min_invoice_total) AS 'Minimum invoice',
           CONCAT(' % ', ROUND (percent_difference, 2 ) ) AS ' Percent difference ',
           count_invoice_id AS ' Number of invoices ';
END//

############################
DELIMITER // 
CREATE PROCEDURE test(IN vendor_id_var INT) 
BEGIN 
    DECLARE max_invoice_total DECIMAL (9, 2);
    DECLARE min_invoice_total DECIMAL (9, 2);
    DECLARE percent_difference DECIMAL (9, 2);
    DECLARE count_invoice_id INT;
    ##DECLARE vendor_id_var INT;
    SELECT MAX(invoice_total),
           MIN(invoice_total),
           COUNT(invoice_id) INTO max_invoice_total,
           min_invoice_total,
           count_invoice_id
    FROM   invoices
    WHERE  vendor_id = vendor_id_var;
    SET percent_difference = (max_invoice_total - min_invoice_total) / min_invoice_total * 100;
    SELECT CONCAT('$', max_invoice_total) AS 'Maximum invoice',
           CONCAT('$', min_invoice_total) AS 'Minimum invoice',
           CONCAT(' % ', ROUND (percent_difference, 2 ) ) AS ' Percent difference ',
           count_invoice_id AS ' Number of invoices ';
END//
##SET  vendor_id_var = 95;
set @valor = 10;
call test(@valor);
select @valor as 'test';

##2_d)
##3_d)
USE classicmodels;
##################    Para esses exemplos utilizar o banco de dados classicmodels #####################################
################################### Procedimento armazenado que utiliza IF e com parâmetro de entrada e saída ################
DELIMITER $$

CREATE PROCEDURE GetCustomerLevel(
    IN  pCustomerNumber INT, 
    OUT pCustomerLevel  VARCHAR(20))
BEGIN
    DECLARE credit DECIMAL(10,2) DEFAULT 0;

    SELECT creditLimit 
    INTO credit
    FROM customers
    WHERE customerNumber = pCustomerNumber;

    IF credit > 50000 THEN
        SET pCustomerLevel = 'PLATINUM';
    ELSEIF credit <= 50000 AND credit > 10000 THEN
        SET pCustomerLevel = 'GOLD';
    ELSE
        SET pCustomerLevel = 'SILVER';
    END IF;
END$$

DELIMITER ;

CALL GetCustomerLevel(447, @level);
SELECT @level;

#### licao
DELIMITER $$

CREATE PROCEDURE GetCustomerLevel2(
    IN  pCustomerNumber INT, 
    OUT pCustomerLevel  VARCHAR(20),
	OUT pcustomerName  VARCHAR(50))
BEGIN
    DECLARE credit DECIMAL(10,2) DEFAULT 0;

    SELECT creditLimit 
    INTO credit
    FROM customers
    WHERE customerNumber = pCustomerNumber AND customerName = pCustomerName;

    IF credit > 50000 THEN
        SET pCustomerLevel = 'PLATINUM';
    ELSEIF credit <= 50000 AND credit > 10000 THEN
        SET pCustomerLevel = 'GOLD';
    ELSE
        SET pCustomerLevel = 'SILVER';
    END IF;
END$$

DELIMITER ;

CALL GetCustomerLevel2(114, @level, @cnome);
SELECT @level as 'status do cliente', @cnome 'nome do cliente';
#### licao
DELIMITER $$

CREATE PROCEDURE GetCustomerLevel3(
    IN  pCustomerNumber INT, 
    OUT pCustomerLevel  VARCHAR(20),
	OUT customerName  VARCHAR(50))
BEGIN
    DECLARE credit DECIMAL(10,2) DEFAULT 0;

    SELECT creditLimit 
    INTO credit
    FROM customers
    WHERE customerNumber = pCustomerNumber;

    IF credit > 50000 THEN
        SET pCustomerLevel = 'PLATINUM';
    ELSEIF credit <= 50000 AND credit > 10000 THEN
        SET pCustomerLevel = 'GOLD';
    ELSE
        SET pCustomerLevel = 'SILVER';
    END IF;
END$$

DELIMITER ;

CALL GetCustomerLevel3(447, @level, @cnome);
SELECT @level as 'status do cliente', @cnome 'nome do cliente';

##4_d)






################################# CURSOR ##################################
USE `classicmodels`;

DECLARE finished INTEGER DEFAULT 0;
DECLARE emailAddress varchar(100) DEFAULT "";

DECLARE curEmail 
	CURSOR FOR
		SELECT email FROM employees;
DECLARE CONTINUE HANDLER
FOR NOT FOUND SET finished = 1;

OPEN curEmail;
getEmail: LOOP
	FETCH curEmail INTO emailAddress;
    IF finished = 1 THEN
		LEAVE getEmail;
        END IF;
        --build email list
        SET emailList = CONCAT(emailAddress,";", emailList);
        END LOOP getEmail;
CLOSE email_cursor;



drop procedure createEmailList;
DELIMITER $$
CREATE PROCEDURE createEmailList (
	INOUT emailList varchar(4000)
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE emailAddress varchar(100) DEFAULT "";

	-- declare cursor for employee email
	DEClARE curEmail 
		CURSOR FOR 
			SELECT email FROM employees;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curEmail;

	getEmail: LOOP
		FETCH curEmail INTO emailAddress;
		IF finished = 1 THEN 
			LEAVE getEmail;
		END IF;
		-- build email list
		SET emailList = CONCAT(emailAddress,";",emailList);
	END LOOP getEmail;
	CLOSE curEmail;

END$$
DELIMITER ;

SET @emailList = ""; 
CALL createEmailList(@emailList); 
SELECT @emailList;



##
# https://www.mysqltutorial.org/mysql-error-handling-in-stored-procedures/
# Criação da tabela
##
CREATE TABLE SupplierProducts (
    supplierId INT,
    productId INT,
    PRIMARY KEY (supplierId , productId)
);
###
# Criando a procedure que irá tratar o erro
###
DELIMITER $$
CREATE PROCEDURE InsertSupplierProduct(
    IN inSupplierId INT, 
    IN inProductId INT
)
BEGIN
    -- exit if the duplicate key occurs
    -- troque o EXIT pelo CONTINUE e veja a diferença
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
 	SELECT CONCAT('Duplicate key (',inSupplierId,',',inProductId,') occurred') AS message;
    END;
    
    -- insert a new row into the SupplierProducts
    INSERT INTO SupplierProducts(supplierId,productId)
    VALUES(inSupplierId,inProductId);
    
    -- return the products supplied by the supplier id
    SELECT COUNT(*) 
    FROM SupplierProducts
    WHERE supplierId = inSupplierId;
    
END$$

DELIMITER ;
#
# Testando
#
CALL InsertSupplierProduct(1,1);
CALL InsertSupplierProduct(1,2);
CALL InsertSupplierProduct(1,3);
CALL InsertSupplierProduct(1,3);
#

#########################
# Erros customizados
################################
DROP PROCEDURE IF EXISTS TestProc;
DELIMITER $$
CREATE PROCEDURE TestProc()
BEGIN
    DECLARE TableNotFound CONDITION for 1146 ; 
    DECLARE EXIT HANDLER FOR TableNotFound 
	SELECT 'Please create table abc first' Message; 
    SELECT * FROM abc;
END$$
DELIMITER ;
#
call TestProc();
#
########################################
# Levantando erros https://www.mysqltutorial.org/mysql-signal-resignal/
########################################
DELIMITER $$

CREATE PROCEDURE AddOrderItem(
		         in orderNo int,
			 in productCode varchar(45),
			 in qty int, 
                         in price double, 
                         in lineNo int )
BEGIN
	DECLARE C INT;

	SELECT COUNT(orderNumber) INTO C
	FROM orders 
	WHERE orderNumber = orderNo;

	-- check if orderNumber exists
	IF(C != 1) THEN 
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Order No not found in orders table';
	END IF;
	-- more code below
	-- ...
END$$


CALL AddOrderItem(10,'S10_1678',1,95.7,1);