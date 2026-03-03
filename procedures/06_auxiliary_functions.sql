-- Calculates the rental end date by iterating day by day and counting only business days (skipping Saturdays and Sundays). 
-- Returns the final date through an INOUT parameter.

CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculaDataFinal_43`(vDataInicio DATE, INOUT vDataFinal DATE, vDias INT)
BEGIN
DECLARE vContador INT;
DECLARE vDiaSemana INT;
SET vContador = 1;
SET vDataFinal = vDataInicio;
WHILE vContador < vDias DO
    SET vDiaSemana = (SELECT DAYOFWEEK(STR_TO_DATE(vDataFinal,'%Y-%m-%d')));
    IF (vDiaSemana <> 7 AND vDiaSemana <> 1) THEN
		SET vContador = vContador + 1;
	END IF;
	SET vDataFinal = (SELECT vDataFinal + INTERVAL 1 DAY);
END WHILE;
END

----------------------------------------------------------------------------------------------------------------------------------
-- Auxiliary procedure that performs the actual INSERT into the RESERVAS table. 
-- It calculates the total price and centralizes the insertion logic to reduce duplication in higher-level procedures.

  
CREATE DEFINER=`root`@`localhost` PROCEDURE `inclusao_aluguel_43`(vReserva VARCHAR(10), vCliente VARCHAR(10), vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vDias INT, vPrecoUnitario DECIMAL(10,2))
BEGIN
DECLARE vPrecoTotal DECIMAL(10,2);
SET vPrecoTotal = vDias * vPrecoUnitario;
		INSERT INTO reservas VALUES (vReserva, vCliente, vHospedagem, vDataInicio,
		vDataFinal, vPrecoTotal);
END
  
--------------------------------------------------------------------------------------------------------------------------------
-- Splits a comma-separated list of names and inserts each name into the temporary table temps_nome. 
-- Used to prepare multiple clients for batch rental insertion.
  
CREATE DEFINER=`root`@`localhost` PROCEDURE `inclui_usuarios_lista_52`(lista VARCHAR(255))
BEGIN
	DECLARE nome VARCHAR(255);
    DECLARE restante VARCHAR(255);
    DECLARE pos INT; 
    SET restante = lista;
    WHILE INSTR(restante, ',') > 0 DO
		SET pos = INSTR(restante, ',');
        SET nome = LEFT(restante, pos - 1);
        INSERT INTO temps_nome VALUES (nome);
        SET restante = SUBSTRING(restante, pos + 1);
	END WHILE;
    IF TRIM(restante) <> '' THEN
		INSERT INTO temps_nome VALUES (TRIM(restante));
	END IF;
END

-------------------------------------------------------------------------------------------------------------------------------
-- Demonstrates the use of a cursor in MySQL. Iterates through all rows  in temps_nome and prints each name until the cursor reaches the end. 
-- Serves as a base example for cursor-based looping.

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
ENDCREATE DEFINER=`root`@`localhost` PROCEDURE `looping_cursor_54`()
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
END



--
