

-- ==========================================================================================
-- Entity Name:   StpMntObjProcParams_Ctrl
-- Author:        Mik
-- Create date:   12.04.21
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:	Write custom note here
-- Description:	Dato il nome di una STP controlla tutte le sue invocazione nelle altre STP presenti nel DB
--				e ritorna un resoconto di quanti parametri sono presenti per ogni invocazione
-- History:
-- mik 210412 Creazione
-- mik 210413 Aggiunto conta dei parametri con valore di default e parametri di output nonchè irrobustito la ricerca.
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntObjProcParams_Ctrl]
(
	@ProcedureName as nvarchar(200) --Nome della Stored Procedure per cui controllare l'invocazione nella altre STP 					
)
As
Begin
	SET NOCOUNT ON
	---------------------------------------
	--
	-- Logica per rintracciare l'invocazione della STP_Da_Controllare:
	-- All'interno della definizione di una STP viene cercato se è presente STP_Da_Controllare + ' '
	-- se si viene identificatola terminazione dell'invocazione cercando il possibile comando successivo (es.: dopo ci potrebbe essere un altro EXECUTE oppure SELECT etc).
	-- siccome alcuni comandi come IF potrebbe essere male interpretato singolarmente (esempio se esistesse un parametro che contiene IF) allora ogni comando viene ricercato anteponendo tab, newline o spazio.
	-- L'identificazione funzione poichè prendo l'indice più piccolo della ricerca effettuata per identificare il comando successivo.
	-- In caso non si riuscisse a identifcare alcun comando successivo all'invocazione viene restituito come numero parametri -1 e popolato il campo Note.
	---------------------------------------

	IF OBJECT_ID('tempdb..#TmpStpParamsCheck') IS NOT NULL
		DROP TABLE #TmpStpParamsCheck

	CREATE TABLE #TmpStpParamsCheck
	(
		StpNameToCheck NVARCHAR(200), -- STP da controllare
		StpName NVARCHAR(200), -- STP in cui è invocata la STP da controllare
		NumParams INT, -- Numero di parametri della STP da controllare
		NumParamsOutput INT, -- Numero di parametri di output della STP da controllare
		NumParamsDefaultValue INT, -- Numero di parametri con valore di default della STP da controllare
		NumParamsExecution INT, -- Numero di parametri messi su una invocazione della STP da controllare
		NumParamsOutputExecution INT, -- Numero di parametri di putput messi su una invocazione della STP da controllare
		CharPosExecution BIGINT, --numero di caratteri dall'inizio della STP in cui è stata identificata la invocazione corrente
		Note NVARCHAR(200) -- eventuali note
	)

	--select  sp.name, 
	--        spa.name, 
	--        spa.is_output,
	--		spa.has_default_value
	--from sys.parameters spa
	--inner join sys.procedures sp on spa.object_id = sp.object_id 
	--inner join sys.types on spa.system_type_id = types.system_type_id AND spa.user_type_id = types.user_type_id
	--where sp.name = @ProcedureName

	declare @NumParams as int
	declare @NumParamsDefaultValue as int
	declare @NumParamsOutput as int

	select  @NumParams=COUNT(spa.parameter_id), @NumParamsDefaultValue=SUM(CASE WHEN spa.has_default_value = 1 THEN 1 ELSE 0 END), @NumParamsOutput=SUM(CASE WHEN spa.is_output = 1 THEN 1 ELSE 0 END)
	from sys.parameters spa
	inner join sys.procedures sp on spa.object_id = sp.object_id 
	inner join sys.types on spa.system_type_id = types.system_type_id AND spa.user_type_id = types.user_type_id
	where sp.name = @ProcedureName
	

	--select @paramCount

	DECLARE @stpname as nvarchar(200)
	DECLARE @definition as nvarchar(MAX)
	DECLARE @indexStart as bigint
	DECLARE @indexEnd as bigint
	DEclare @indexTmp as bigint
	DECLARE @definitionLen as bigint
	DECLARE @txtTmp as nvarchar(max)
	DECLARE @paramCountExec as int
	DECLARE @paramCountOutputExec as int

	DECLARE @NewLine as nvarchar(10)
	DECLARE @Tab as nvarchar(10)
	DECLARE @whitespace as nvarchar(1)
	SET @NewLine = CHAR(13)+CHAR(10)
	SET @Tab = CHAR(9)
	SET @whitespace = ' '

	DECLARE db_cursor CURSOR FOR 
	SELECT DISTINCT
		   o.name AS Object_Name,
		   m.definition
	  FROM sys.sql_modules m
		   INNER JOIN
		   sys.objects o
			 ON m.object_id = o.object_id
	 WHERE (m.definition Like '%'+@ProcedureName+' %' OR m.definition Like '%'+@ProcedureName+']%' OR m.definition Like '%'+ @ProcedureName + @NewLine + '%' OR m.definition Like '%'+ @ProcedureName + @Tab + '%')
	 AND (o.name <> @ProcedureName) -- escludo la STP da controllare
	 AND (o.name NOT LIKE 'zzz%') -- escludo STP che iniziano per ZZZ che per convenzione sono solo copie
	 AND (o.name LIKE 'StpX%') -- escludo STP che iniziano per ZZZ che per convenzione sono solo copie
	 AND (Type='P') --solo stored procedure

	OPEN db_cursor  
	FETCH NEXT FROM db_cursor INTO @stpname, @definition

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		SET @paramCountExec = 0
		SET @indexStart = 1
		--print @stpname
		SET @definitionLen = LEN(@definition)

		WHILE(@indexStart<@definitionLen)
		BEGIN
			
			SET @indexEnd = 999999
			SET @indexTmp = 0
			SET @txtTmp = NULL
			--print 'indexStart pre:'
			--print cast(@indexStart as nvarchar(20))

			SET @indexTmp = CHARINDEX(@ProcedureName+' ',@definition,@indexStart)
			IF(@indexTmp<=0)
			BEGIN
				SET @indexTmp = CHARINDEX(@ProcedureName+']',@definition,@indexStart)
				IF(@indexTmp<=0)
				BEGIN
					SET @indexTmp = CHARINDEX(@ProcedureName+@NewLine,@definition,@indexStart)
					IF(@indexTmp<=0)
					BEGIN
						SET @indexTmp = CHARINDEX(@ProcedureName+@Tab,@definition,@indexStart)
						--IF(@indexStart<=0)
						--BEGIN

						--END
					END
				END
			END

			IF(@indexTmp>0)
			BEGIN
				SET @indexStart = @indexTmp

				--print 'indexStart:'
				--print cast(@indexStart as nvarchar(20))
				--se c'è il nome della STP da controllare
				--controllo la terminazione del richiamo della STP verificando la successiva istruzione 
				SET @indexTmp = CHARINDEX(@Tab+'END',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@WhiteSpace+'END',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@NewLine+'END',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END

				SET @indexTmp = CHARINDEX(@Tab+'RETURN',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@whitespace+'RETURN',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@NewLine+'RETURN',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END

				SET @indexTmp = CHARINDEX(@Tab+'DECLARE',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@whitespace+'DECLARE',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@NewLine+'DECLARE',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END

				SET @indexTmp = CHARINDEX(@Tab+'SET',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@whitespace+'SET',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@NewLine+'SET',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END

				SET @indexTmp = CHARINDEX(@Tab+'IF',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@whitespace+'IF',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@NewLine+'IF',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END

				SET @indexTmp = CHARINDEX(@Tab+'ELSE',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@whitespace+'ELSE',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@NewLine+'ELSE',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END

				SET @indexTmp = CHARINDEX(@Tab+'WHILE',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@whitespace+'WHILE',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@NewLine+'WHILE',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END

				SET @indexTmp = CHARINDEX(@Tab+'EXEC ',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@whitespace+'EXEC ',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@NewLine+'EXEC ',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END

				SET @indexTmp = CHARINDEX(@Tab+'EXECUTE ',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@Whitespace+'EXECUTE ',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@NewLine+'EXECUTE ',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END

				SET @indexTmp = CHARINDEX(@Tab+'SELECT ',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@whitespace+'SELECT ',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@NewLine+'SELECT ',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END

				SET @indexTmp = CHARINDEX(@Tab+'INSERT ',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@whitespace+'INSERT ',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@NewLine+'INSERT ',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END

				SET @indexTmp = CHARINDEX(@Tab+'UPDATE ',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@whitespace+'UPDATE ',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@NewLine+'UPDATE ',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END

				SET @indexTmp = CHARINDEX(@Tab+'DELETE ',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@whitespace+'DELETE ',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END
				SET @indexTmp = CHARINDEX(@NewLine+'DELETE ',@definition,@indexStart)
				IF(@indexTmp>0)
				BEGIN
					IF(@indexTmp<@indexEnd)
					BEGIN
						SET @indexEnd = @indexTmp
					END
				END

				--print 'indexEnd:'
				--print CAST(@indexEnd as nvarchar(20))
				IF(@indexEnd<999999)
				BEGIN
					
					--è stato trovato la fine dell'invocazione della STP
					SET @txtTmp = SUBSTRING(@definition, @indexStart, (@indexEnd-@indexStart)+1)
					--print @txtTmp

					--conto le , e sommo 1 per avere il numero di parametri immessi nel richiamo della STP
					SET @paramCountExec = len(@txtTmp) - len(replace(@txtTmp, ',', '')) + 1
					--conto ' out' per avere il numero di parametri di out immessi nel richiamo della STP
					set @paramCountOutputExec = (len(@txtTmp) - len(replace(@txtTmp,' out', '')))/4 --len(' out') = 4
					INSERT INTO #TmpStpParamsCheck (StpNameToCheck,StpName,  NumParams, NumParamsOutput, NumParamsDefaultValue, NumParamsExecution, NumParamsOutputExecution, CharPosExecution)
					VALUES (@ProcedureName, @stpname, @NumParamsOutput, @NumParamsOutput, @NumParamsDefaultValue, @paramCountExec, @paramCountOutputExec, @indexStart)

					SET @indexStart = @indexEnd + 1

				END
				ELSE
				BEGIN
					--anomalia
					--Non è stata trovata la terminazione dell'invocazione della STP
					INSERT INTO #TmpStpParamsCheck (StpNameToCheck,StpName, NumParams, NumParamsOutput, NumParamsDefaultValue, NumParamsExecution, NumParamsOutputExecution, CharPosExecution, Note)
					VALUES (@ProcedureName, @stpname, @NumParamsOutput, @NumParamsOutput, @NumParamsDefaultValue, NULL, NULL, NULL, 'ATTENZIONE: Non è stata trovata la terminazione dell''invocazione della STP')

					--uscire dal loop
					SET @indexStart = @definitionLen
				END
			END
			ELSE
			BEGIN
				--Non si è trovato pù alcun richiamo della STP nella successiva parte della definizione
				--uscire dal loop
				SET @indexStart = @definitionLen
			END
	
		END
		FETCH NEXT FROM db_cursor INTO @stpname, @definition
	END 

	CLOSE db_cursor  
	DEALLOCATE db_cursor 

	SELECT *
	FROM #TmpStpParamsCheck
	WHERE ISNULL(NumParams,0) <> ISNULL(NumParamsExecution,0) OR ISNULL(NumParamsOutput,0) <> ISNULL(NumParamsOutputExecution,0)

END

GO

