-- Only declares variables and returns using SELECT.

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_21`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_21`()
BEGIN
	DECLARE vAluguel VARCHAR(10) DEFAULT 10001;
    DECLARE vCliente VARCHAR(10) DEFAULT 1002;
    DECLARE vHospedagem VARCHAR(10) DEFAULT 8635;
    DECLARE vDataInicio DATE DEFAULT '2023-03-01';
    DECLARE vDataFinal DATE DEFAULT '2023-03-05';
    DECLARE vPrecoTotal DECIMAL(10,2) DEFAULT 550.23;
    SELECT vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal;
END$$

DELIMITER ;
;

-- ---------------------------------------------------------------------------
-- Inserts fixed/static data into the reservas table.

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_22`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_22`()
BEGIN
	DECLARE vReserva VARCHAR(10) DEFAULT 12345;
    DECLARE vCliente VARCHAR(10) DEFAULT 1002;
    DECLARE vHospedagem VARCHAR(10) DEFAULT 8635;
    DECLARE vDataInicio DATE DEFAULT '2023-03-01';
    DECLARE vDataFinal DATE DEFAULT '2023-03-05';
    DECLARE vPrecoTotal DECIMAL(10,2) DEFAULT 550.23;
    INSERT INTO reservas VALUES (vReserva, vCliente, vHospedagem, vDataInicio,
    vDataFinal, vPrecoTotal);
END$$

DELIMITER ;
;

-- -------------------------------------------------------------------------------------------------
-- First version with parameters, but without validations or calculations. Still a basic one.

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_23`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_23`(vReserva VARCHAR(10),vCliente VARCHAR(10), vHospedagem VARCHAR(10),
vDataInicio DATE, vDataFinal DATE, vPrecoTotal DECIMAL(10,2))
BEGIN
    INSERT INTO reservas VALUES (vReserva, vCliente, vHospedagem, vDataInicio,
    vDataFinal, vPrecoTotal);
END$$

DELIMITER ;
;

