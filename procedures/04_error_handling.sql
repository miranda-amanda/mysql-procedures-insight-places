-- -- Same structure as previous versions, but introduces an EXIT HANDLER to catch foreign key constraint errors (error 1452). 
-- This makes the procedure more robust by returning a clear message when invalid client or lodging references are provided. 

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

--------------------------------------------------------------------------------------------------------------

-- Improves the error-handling logic by refining the EXIT HANDLER for foreign key constraint violations. 
-- Provides a clearer and more informative message, making debugging and user feedback more precise.

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

DELIMITER ;
;

---------------------------------------------------------------------------------------------------------------

