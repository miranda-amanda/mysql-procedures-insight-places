-- Receives the number of rental days instead of an end date, calculates the final date by adding days, 
-- validates customer name, and inserts the reservation.

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_41`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_41`(vReserva VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10),
vDataInicio DATE, vDias INT, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vCliente VARCHAR(150);
	DECLARE vDataFinal DATE;
    DECLARE vNumClientes INT;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumClientes = (SELECT COUNT(*) FROM CLIENTES WHERE nome = vClienteNome);
    CASE
    WHEN vNumClientes = 0 THEN
		SET vMensagem = 'Este cliente nao esta na base de dados.';
        SELECT vMensagem;
	WHEN vNumClientes = 1 THEN
		-- SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
        SET vDataFinal = (SELECT vDataInicio + INTERVAL vDias DAY);
		SET vPrecoTotal = vDias * vPrecoUnitario;
		SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
		INSERT INTO reservas VALUES (vReserva, vCliente, vHospedagem, vDataInicio,
		vDataFinal, vPrecoTotal);
		SET vMensagem = 'Aluguel incluído na base com sucesso.';
		SELECT vMensagem;
	WHEN vNumClientes > 1 THEN
		SET vMensagem = 'Mais de um cliente com esse mesmo nome na base.';
        SELECT vMensagem;
	END CASE;
END$$

DELIMITER ;
;

-- -------------------------------------------------------------------------------------------
-- Generates the final rental date by counting only business days via a loop, 
-- validates the customer name, calculates total price, and inserts the reservation.

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_42`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_42`(vReserva VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10),
vDataInicio DATE, vDias INT, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vCliente VARCHAR(150);
    -- Implementa 2 variaveis, o contador e dia da semana 
    DECLARE vContador INT;
    DECLARE vDiaSemana INT;
	DECLARE vDataFinal DATE;
    DECLARE vNumClientes INT;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumClientes = (SELECT COUNT(*) FROM CLIENTES WHERE nome = vClienteNome);
    CASE
    WHEN vNumClientes = 0 THEN
		SET vMensagem = 'Este cliente nao esta na base de dados.';
        SELECT vMensagem;
	WHEN vNumClientes = 1 THEN
		-- SET vDataFinal = (SELECT vDataFinal + INTERVAL vDias DAY);
        -- Inicializando o contador. Contador comeca em 1 e a DataFinal conta apartir da data incial
        SET vContador = 1;
        SET vDataFinal = vDataInicio;
        -- Inicio do Looping. No looping, primeiro testaremos o dia da semana. 
        WHILE vContador < vDias
        DO
        -- Testar qual o dia da semana
			SET vDiaSemana = DAYOFWEEK(vDataFinal);
            IF (vDiaSemana <> 7 AND vDiaSemana <> 1) THEN
				SET vContador = vContador + 1;
            END IF;
            SET vDataFinal = (SELECT vDataFinal + INTERVAL 1 DAY);
		END WHILE;
		SET vPrecoTotal = vDias * vPrecoUnitario;
		SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
		INSERT INTO reservas VALUES (vReserva, vCliente, vHospedagem, vDataInicio,
		vDataFinal, vPrecoTotal);
		SET vMensagem = 'Aluguel incluído na base com sucesso.';
		SELECT vMensagem;
	WHEN vNumClientes > 1 THEN
		SET vMensagem = 'Mais de um cliente com esse mesmo nome na base.';
        SELECT vMensagem;
	END CASE;
END$$

DELIMITER ;
;

-- ---------------------------------------------------------------------------------------------
-- Performs the full rental insertion process in a single procedure. Validates whether the client exists, 
-- calculates the final date, computes the total price, and inserts the rental directly into the RESERVAS table.
-- Includes an error handler for foreign key issues.

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_43`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_43`(vReserva VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10),
vDataInicio DATE, vDias INT, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vCliente VARCHAR(10);
	DECLARE vDataFinal DATE;
    DECLARE vNumClientes INT;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumClientes = (SELECT COUNT(*) FROM CLIENTES WHERE nome = vClienteNome);
    CASE
    WHEN vNumClientes = 0 THEN
		SET vMensagem = 'Este cliente nao esta na base de dados.';
        SELECT vMensagem;
	WHEN vNumClientes = 1 THEN
	CALL CalculaDataFinal_43 (vDataInicio, vDataFinal, vDias);
		SET vPrecoTotal = vDias * vPrecoUnitario;
		SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
		INSERT INTO reservas VALUES (vReserva, vCliente, vHospedagem, vDataInicio,
		vDataFinal, vPrecoTotal);
		SET vMensagem = 'Aluguel incluído na base com sucesso.';
		SELECT vMensagem;
	WHEN vNumClientes > 1 THEN
		SET vMensagem = 'Mais de um cliente com esse mesmo nome na base.';
        SELECT vMensagem;
	END CASE;
END$$

DELIMITER ;
;

-- ---------------------------------------------------------------------------------------------
-- Version 44 refactors the insertion logic by delegating the INSERT operation to the auxiliary procedure inclusao_aluguel_43. 
-- Version 43 performs the INSERT directly inside the procedure. 

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_44`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_44`(vReserva VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10),
vDataInicio DATE, vDias INT, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vCliente VARCHAR(10);
	DECLARE vDataFinal DATE;
    DECLARE vNumClientes INT;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumClientes = (SELECT COUNT(*) FROM CLIENTES WHERE nome = vClienteNome);
    CASE
    WHEN vNumClientes = 0 THEN
		SET vMensagem = 'Este cliente nao esta na base de dados.';
        SELECT vMensagem;
	WHEN vNumClientes = 1 THEN
		SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
		CALL CalculaDataFinal_43 (vDataInicio, vDataFinal, vDias);
        CALL inclusao_aluguel_43 (vReserva, vCliente, vHospedagem, vDataInicio,
        vDataFinal, vDias, vPrecoUnitario);
		SET vMensagem = 'Aluguel incluído na base com sucesso.';
		SELECT vMensagem;
	WHEN vNumClientes > 1 THEN
		SET vMensagem = 'Mais de um cliente com esse mesmo nome na base.';
        SELECT vMensagem;
	END CASE;
END$$

DELIMITER ;
;


