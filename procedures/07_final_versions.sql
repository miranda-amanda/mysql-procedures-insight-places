
USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_45`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_45`(vClienteNome VARCHAR(150), vHospedagem VARCHAR(10),
vDataInicio DATE, vDias INT, vPrecoUnitario DECIMAL(10,2))
BEGIN
	-- Declara a vReserva VARCHAR(10)
    DECLARE vReserva VARCHAR(10);
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
		SELECT CAST(MAX(CAST(reserva_id AS UNSIGNED)) + 1 AS CHAR) INTO vReserva FROM reservas;
		CALL CalculaDataFinal_43 (vDataInicio, vDataFinal, vDias);
		SET vPrecoTotal = vDias * vPrecoUnitario;
		SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
		INSERT INTO reservas VALUES (vReserva, vCliente, vHospedagem, vDataInicio,
		vDataFinal, vPrecoTotal);
		SET vMensagem = CONCAT('Aluguel incluído na base com sucesso.ID:', vReserva);
		SELECT vMensagem;
	WHEN vNumClientes > 1 THEN
		SET vMensagem = 'Mais de um cliente com esse mesmo nome na base.';
        SELECT vMensagem;
	END CASE;
END$$

DELIMITER ;
;

-- -----------------------------------------------------------------------------------------------


USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`looping_cursor_54`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `looping_cursor_54`()
BEGIN
	-- variavel que vai declarar o fim do cursor
	DECLARE fimCursor INT DEFAULT 0;
    -- variavel que vai receber o 'nome' que o cursor vai ler no FETCH 
    DECLARE vnome VARCHAR(100);
    -- declarando o cursor
    DECLARE cursor1 CURSOR FOR SELECT nome FROM temps_nome;
    -- excecao para o cursor mudar o valor para 1 quando chegar no fim 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimCursor = 1;
    -- abrindo cursor
    OPEN cursor1;
    FETCH cursor1 INTO vnome;
    -- iniciando looping
    WHILE fimCursor = 0 DO 
        SELECT vnome;
        FETCH cursor1 INTO vnome;
	END WHILE;
	CLOSE cursor1;
END$$

DELIMITER ;
;



-- ---------------------------------------------------------------------------------------------------

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novosAlugueis_55`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novosAlugueis_55`(lista VARCHAR(255), vHospedagem VARCHAR(10),
vDataInicio DATE, vDias INT, vPrecoUnitario DECIMAL(10,2) )
BEGIN
	DECLARE vClienteNome VARCHAR (150);
	DECLARE fimCursor INT DEFAULT 0;
    DECLARE vnome VARCHAR(100);
    DECLARE cursor1 CURSOR FOR SELECT nome FROM temps_nome;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimCursor = 1;
    DROP TEMPORARY TABLE IF EXISTS temps_nome;
	CREATE TEMPORARY TABLE temps_nome (nome VARCHAR(255));
    CALL inclui_usuarios_lista_52 (lista);
    OPEN cursor1;
    FETCH cursor1 INTO vnome;
    WHILE fimCursor = 0 DO 
        SET vClienteNome = vnome;
        CALL novoAluguel_45 (vClienteNome, vHospedagem, vDataInicio, vDias, vPrecoUnitario);
        FETCH cursor1 INTO vnome;
	END WHILE;
	CLOSE cursor1;
    DROP TEMPORARY TABLE IF EXISTS temps_nome;
END$$

DELIMITER ;
;


