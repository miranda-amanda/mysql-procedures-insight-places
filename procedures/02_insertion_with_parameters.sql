-- Calculates the total rental price based on the number of days between the start and end dates, multiplies by the unit price, 
-- and inserts the reservation into the database.

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_24`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_24`(vReserva VARCHAR(10),vCliente VARCHAR(10), vHospedagem VARCHAR(10),
vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vDias INT DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    INSERT INTO reservas VALUES (vReserva, vCliente, vHospedagem, vDataInicio,
    vDataFinal, vPrecoTotal);
END$$

-- ----------------------------------------------------------------------------------------------------
-- Searches the customer ID based on the provided customer name, calculates total price, and inserts the reservation. 
-- Adds foreign key error handling and returns success or error messages.

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_25`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_25`(vReserva VARCHAR(10),vCliente VARCHAR(10), vHospedagem VARCHAR(10),
vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vDias INT DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    INSERT INTO reservas VALUES (vReserva, vCliente, vHospedagem, vDataInicio,
    vDataFinal, vPrecoTotal);
    SET vMensagem = 'Aluguel incluído na base com sucess.';
    SELECT vMensagem;
END$$

DELIMITER ;
; 

-- -----------------------------------------------------------------------------------------------------
-- Searches the customer ID based on the provided customer name, calculates total price, and inserts the reservation. 
-- Adds foreign key error handling and returns success or error messages.

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_31`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_31`(vReserva VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10),
vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vCliente VARCHAR(150);
	DECLARE vDias INT DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
    INSERT INTO reservas VALUES (vReserva, vCliente, vHospedagem, vDataInicio,
    vDataFinal, vPrecoTotal);
    SET vMensagem = 'Aluguel incluído na base com sucess.';
    SELECT vMensagem;
END$$

  --

DELIMITER ;
;
