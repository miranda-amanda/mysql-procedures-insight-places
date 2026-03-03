-- Introduces basic client verification: checks whether the client exists before inserting the rental. 

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_32`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_32`(vReserva VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10),
vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vCliente VARCHAR(150);
	DECLARE vDias INT DEFAULT 0;
    -- Declarar uma nova variavel para saber o numero de clientes com o mesmo nome.
    DECLARE vNumClientes INT;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    -- Antes de efetuar a inclusao do aluguel, buscar o numero de clientes com aquele nome
    SET vNumClientes = (SELECT COUNT(*) FROM CLIENTES WHERE nome = vClienteNome);
    -- Teste para saber se tem mais de um. Se nao, seguir com o codigo normal
    IF vNumClientes > 1 THEN
		SET vMensagem = 'Mais de um cliente com esse mesmo nome na base.';
        SELECT vMensagem;
    ELSE
        SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
		SET vPrecoTotal = vDias * vPrecoUnitario;
		SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
		INSERT INTO reservas VALUES (vReserva, vCliente, vHospedagem, vDataInicio,
		vDataFinal, vPrecoTotal);
		SET vMensagem = 'Aluguel incluído na base com sucesso.';
		SELECT vMensagem;
    END IF;
END$$

DELIMITER ;
;

-- -------------------------------------------------------------------------------------------------------
-- Enhances client verification by counting how many clients match the name. 
-- Begins differentiating between “client not found” and “client found”.

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_33`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_33`(vReserva VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10),
vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vCliente VARCHAR(150);
	DECLARE vDias INT DEFAULT 0;
    -- Declarar uma nova variavel para saber o numero de clientes com o mesmo nome.
    DECLARE vNumClientes INT;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    -- Antes de efetuar a inclusao do aluguel, buscar o numero de clientes com aquele nome
    SET vNumClientes = (SELECT COUNT(*) FROM CLIENTES WHERE nome = vClienteNome);
    -- Teste para saber se tem mais de um. Se nao, seguir com o codigo normal
    IF vNumClientes > 1 THEN
		SET vMensagem = 'Mais de um cliente com esse mesmo nome na base.';
        SELECT vMensagem;
    ELSEIF vNumClientes =0 THEN
		SET vMensagem = 'Este cliente nao esta na base de dados.';
        SELECT vMensagem;
    ELSE
        SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
		SET vPrecoTotal = vDias * vPrecoUnitario;
		SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
		INSERT INTO reservas VALUES (vReserva, vCliente, vHospedagem, vDataInicio,
		vDataFinal, vPrecoTotal);
		SET vMensagem = 'Aluguel incluído na base com sucesso.';
		SELECT vMensagem;
    END IF;
END$$

DELIMITER ;
;

-- ---------------------------------------------------------------------------------------------------
-- Adds full branching logic for client verification: handles three cases separately: no client found, exactly one client found, and more than one client.
-- This prevents ambiguous insertions when duplicate names exist.

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_34`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_34`(vReserva VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10),
vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vCliente VARCHAR(150);
	DECLARE vDias INT DEFAULT 0;
    -- Declarar uma nova variavel para saber o numero de clientes com o mesmo nome.
    DECLARE vNumClientes INT;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    -- Antes de incluir os dados, inserir valor na variavel declarada vNumClientes
    SET vNumClientes = (SELECT COUNT(*) FROM CLIENTES WHERE nome = vClienteNome);
    -- Verificacao de etapas para seguir.
    CASE vNumClientes
    WHEN 0 THEN
		SET vMensagem = 'Este cliente nao esta na base de dados.';
        SELECT vMensagem;
	WHEN 1 THEN
		SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
		SET vPrecoTotal = vDias * vPrecoUnitario;
		SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
		INSERT INTO reservas VALUES (vReserva, vCliente, vHospedagem, vDataInicio,
		vDataFinal, vPrecoTotal);
		SET vMensagem = 'Aluguel incluído na base com sucesso.';
		SELECT vMensagem;
	ELSE
		SET vMensagem = 'Mais de um cliente com esse mesmo nome na base.';
        SELECT vMensagem;
	END CASE;
END$$

DELIMITER ;
;

-- ---------------------------------------------------------------------------------------------------
-- Refines the multi-client verification logic by improving the returned messages and ensuring no insertion occurs when duplicates exist. 
-- Provides clearer user  feedback and more robust validation before inserting the rental.

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_35`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_35`(vReserva VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10),
vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vCliente VARCHAR(150);
	DECLARE vDias INT DEFAULT 0;
    -- Declarar uma nova variavel para saber o numero de clientes com o mesmo nome.
    DECLARE vNumClientes INT;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    -- Antes de incluir os dados, inserir valor na variavel declarada vNumClientes
    SET vNumClientes = (SELECT COUNT(*) FROM CLIENTES WHERE nome = vClienteNome);
    -- Verificacao de etapas para seguir.
    CASE
    WHEN vNumClientes = 0 THEN
		SET vMensagem = 'Este cliente nao esta na base de dados.';
        SELECT vMensagem;
	WHEN vNumClientes = 1 THEN
		SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
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

-- 
