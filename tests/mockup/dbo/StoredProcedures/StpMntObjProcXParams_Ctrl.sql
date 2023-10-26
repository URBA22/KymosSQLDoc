

-- ==========================================================================================
-- Entity Name:   StpMntObjProcXParams_Ctrl
-- Author:        Mik
-- Create date:   01.07.22
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:	Write custom note here
-- Description:	Cerca in tutte le StpX quelle che contengono invocazioni di Stp per cui il numero di parametri di invocazione è diverso rispetto la definizione
-- History:
-- mik 220701 Creazione
-- mik 220701 Affinata
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntObjProcXParams_Ctrl]

As
Begin
	SET NOCOUNT ON

	---------------------------------------
	-- MIK220701
	-- 1) ATTENZIONE NON è ANCOAR GESTITO LO SCHEMA QUINDI HA UNA FALLA 
	-- 2) ATTENZIONE LE INVOCAZIONI DI STP TRAMITE NOME DI PARAMETRI ESPLICITI E CON PRESENZA DI PARAMETRI DI DEFAULT RITORNA DEI RISULTATI NON CONGRUI (è corretto che il numero di parametri nell'invocazione non matcha ma l'invocazione potrebbe non andare in errore)
	---------------------------------------

	---------------------------------------
	-- Questa procedura ha lo scopo di cercare tutte le dipendenze di tipo 'Stored Procedure' delle STPX (STP personalizzate)
	-- Una volta identificate verranno caricati il numero di loro parametri e verrà laniata una ricerca nel testo della StpX in cui vengono invocate
	-- per verificare sse il numero è congruo.
	-- Se il numero non è congruo allora viene restituita una riga con tutte le informazioni utili.
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
		StpNameReferencing NVARCHAR(200), -- STP in cui una STP è invocata
		StpNameReferenced NVARCHAR(200), -- STP invocata
		NumTotalParams INT, -- Numero totale di parametri della STP invocata (sia parametri INPUT, sia parametri OUTPUT)
		NumOutputParams INT, -- Numero di parametri di output della STP invocata
		NumTotalParamsExecution INT, -- Numero di parametri messi su una invocazione della STP (sia parametri INPUT, sia parametri OUTPUT)
		NumOutputParamsExecution INT, -- Numero di parametri di output messi su una invocazione della STP da controllare
		NumExplicitParamsExecution INT, -- Numero di parametri passati come espliciti ossia col nome del parametro esplicitato (es.: @IdCliPrv = @PIdCliPrv) messi su una invocazione della STP da controllare
		RowNum BIGINT, --numero di riga in cui inizia l'invocazione della STP
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
	
	DECLARE @NewLine as nvarchar(10)
	DECLARE @Tab as nvarchar(10)
	DECLARE @whitespace as nvarchar(1)
	SET @NewLine = CHAR(13)+CHAR(10)
	SET @Tab = CHAR(9)
	SET @whitespace = ' '

	declare @CurrProcedureNameReferencing as nvarchar(200)
	declare @CurrProcedureNameReferenced as nvarchar(200)
	declare @NumParams as int
	declare @NumParamsOutput as int

	Declare curStpNameCheck Cursor FAST_FORWARD for
	SELECT 
	OBJECT_NAME(referencing_id) AS referencing_entity_name,   
    --o.type_desc AS referencing_desciption,   
    --COALESCE(COL_NAME(referencing_id, referencing_minor_id), '(n/a)') AS referencing_minor_id,   
    --referencing_class_desc,  
    --referenced_server_name, 
	--referenced_database_name, 
	--referenced_schema_name,  
    referenced_entity_name  
    --COALESCE(COL_NAME(referenced_id, referenced_minor_id), '(n/a)') AS referenced_column_name,  
    --is_caller_dependent, 
	--is_ambiguous  
	FROM sys.sql_expression_dependencies AS sed  
	INNER JOIN sys.objects AS o ON sed.referencing_id = o.object_id  
	where o.type_desc='SQL_STORED_PROCEDURE'
	and OBJECT_NAME(referencing_id) LIKE 'STPX%'
	AND referenced_entity_name LIKE 'STP%'
	AND referenced_entity_name NOT IN ('StpUteMsg','StpUteMsg_Ins')
	ORDER BY referenced_entity_name, OBJECT_NAME(referencing_id)

	Open curStpNameCheck
	Fetch Next from curStpNameCheck into @CurrProcedureNameReferencing, @CurrProcedureNameReferenced
	WHILE @@FETCH_STATUS = 0
	BEGIN

		select  @NumParams=COUNT(spa.parameter_id), 
		@NumParamsOutput=SUM(CASE WHEN spa.is_output = 1 THEN 1 ELSE 0 END)
		from sys.parameters spa
		inner join sys.procedures sp on spa.object_id = sp.object_id 
		inner join sys.types on spa.system_type_id = types.system_type_id AND spa.user_type_id = types.user_type_id
		where sp.name = @CurrProcedureNameReferenced
	
		SET @NumParamsOutput = ISNULL(@NumParamsOutput,0)

		--select @paramCount

		DECLARE @stpname as nvarchar(200)
		DECLARE @definition as nvarchar(MAX)
		DECLARE @indexStart as bigint
		DECLARE @rowNum as bigint
		DECLARE @indexEnd as bigint
		DEclare @indexTmp as bigint
		DECLARE @definitionLen as bigint
		DECLARE @txtTmp as nvarchar(max)
		DECLARE @intTmp as int
		DECLARE @paramCountExec as int
		DECLARE @paramCountOutputExec as int
		DECLARE @paramCountExplicitExec as int


		SELECT DISTINCT
			   @stpname = o.name,
			   @definition = m.definition
		  FROM sys.sql_modules m
			   INNER JOIN
			   sys.objects o
				 ON m.object_id = o.object_id
		 WHERE  (o.name = @CurrProcedureNameReferencing) 

			SET @paramCountExec = 0
			SET @indexStart = 1
			--print @stpname
			SET @definitionLen = LEN(@definition)

			--print @definition

			WHILE(@indexStart<@definitionLen)
			BEGIN
			
				SET @indexEnd = 999999
				SET @indexTmp = 0
				SET @txtTmp = NULL
				--print 'indexStart pre:'
				--print cast(@indexStart as nvarchar(20))

				SET @indexTmp = CHARINDEX(@CurrProcedureNameReferenced+' ',@definition,@indexStart)
				IF(@indexTmp<=0)
				BEGIN
					SET @indexTmp = CHARINDEX(@CurrProcedureNameReferenced+']',@definition,@indexStart)
					IF(@indexTmp<=0)
					BEGIN
						SET @indexTmp = CHARINDEX(@CurrProcedureNameReferenced+@NewLine,@definition,@indexStart)
						IF(@indexTmp<=0)
						BEGIN
							SET @indexTmp = CHARINDEX(@CurrProcedureNameReferenced+@Tab,@definition,@indexStart)
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

					--END
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

					--RETURN
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

					--DECLARE
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

					--SET
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

					--IF
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

					--ELSE
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

					--WHILE
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

					--EXEC 
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

					--EXECUTE 
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

					--SELECT 
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

					--INSERT 
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

					--UPDATE 
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

					--FETCH
					SET @indexTmp = CHARINDEX(@Tab+'FETCH',@definition,@indexStart)
					IF(@indexTmp>0)
					BEGIN
						IF(@indexTmp<@indexEnd)
						BEGIN
							SET @indexEnd = @indexTmp
						END
					END
					SET @indexTmp = CHARINDEX(@whitespace+'FETCH',@definition,@indexStart)
					IF(@indexTmp>0)
					BEGIN
						IF(@indexTmp<@indexEnd)
						BEGIN
							SET @indexEnd = @indexTmp
						END
					END
					SET @indexTmp = CHARINDEX(@NewLine+'FETCH',@definition,@indexStart)
					IF(@indexTmp>0)
					BEGIN
						IF(@indexTmp<@indexEnd)
						BEGIN
							SET @indexEnd = @indexTmp
						END
					END

					--BEGIN
					SET @indexTmp = CHARINDEX(@Tab+'BEGIN',@definition,@indexStart)
					IF(@indexTmp>0)
					BEGIN
						IF(@indexTmp<@indexEnd)
						BEGIN
							SET @indexEnd = @indexTmp
						END
					END
					SET @indexTmp = CHARINDEX(@whitespace+'BEGIN',@definition,@indexStart)
					IF(@indexTmp>0)
					BEGIN
						IF(@indexTmp<@indexEnd)
						BEGIN
							SET @indexEnd = @indexTmp
						END
					END
					SET @indexTmp = CHARINDEX(@NewLine+'BEGIN',@definition,@indexStart)
					IF(@indexTmp>0)
					BEGIN
						IF(@indexTmp<@indexEnd)
						BEGIN
							SET @indexEnd = @indexTmp
						END
					END

					--PRINT
					SET @indexTmp = CHARINDEX(@Tab+'PRINT',@definition,@indexStart)
					IF(@indexTmp>0)
					BEGIN
						IF(@indexTmp<@indexEnd)
						BEGIN
							SET @indexEnd = @indexTmp
						END
					END
					SET @indexTmp = CHARINDEX(@whitespace+'PRINT',@definition,@indexStart)
					IF(@indexTmp>0)
					BEGIN
						IF(@indexTmp<@indexEnd)
						BEGIN
							SET @indexEnd = @indexTmp
						END
					END
					SET @indexTmp = CHARINDEX(@NewLine+'PRINT',@definition,@indexStart)
					IF(@indexTmp>0)
					BEGIN
						IF(@indexTmp<@indexEnd)
						BEGIN
							SET @indexEnd = @indexTmp
						END
					END

					--Commento (--)
					SET @indexTmp = CHARINDEX(@Tab+'--',@definition,@indexStart)
					IF(@indexTmp>0)
					BEGIN
						IF(@indexTmp<@indexEnd)
						BEGIN
							SET @indexEnd = @indexTmp
						END
					END
					SET @indexTmp = CHARINDEX(@whitespace+'--',@definition,@indexStart)
					IF(@indexTmp>0)
					BEGIN
						IF(@indexTmp<@indexEnd)
						BEGIN
							SET @indexEnd = @indexTmp
						END
					END
					SET @indexTmp = CHARINDEX(@NewLine+'--',@definition,@indexStart)
					IF(@indexTmp>0)
					BEGIN
						IF(@indexTmp<@indexEnd)
						BEGIN
							SET @indexEnd = @indexTmp
						END
					END

					--Commento aperuta/chiusura (/*)
					SET @indexTmp = CHARINDEX(@Tab+'/*',@definition,@indexStart)
					IF(@indexTmp>0)
					BEGIN
						IF(@indexTmp<@indexEnd)
						BEGIN
							SET @indexEnd = @indexTmp
						END
					END
					SET @indexTmp = CHARINDEX(@whitespace+'/*',@definition,@indexStart)
					IF(@indexTmp>0)
					BEGIN
						IF(@indexTmp<@indexEnd)
						BEGIN
							SET @indexEnd = @indexTmp
						END
					END
					SET @indexTmp = CHARINDEX(@NewLine+'/*',@definition,@indexStart)
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
						print '--'+@stpname+'--'
						print @txtTmp

						--conto le , e sommo 1 per avere il numero di parametri immessi nel richiamo della STP
						SET @intTmp = len(@txtTmp) - len(replace(@txtTmp, ',', ''))
						IF(@intTmp=0)
						BEGIN
							--non c'è il separatore , dunque è 0
							SET @paramCountExec = 0
						END
						ELSE
						BEGIN
							--faccio +1 perchè la , fa da separatore quindi la sua presenza indica 2 parametri
							SET @paramCountExec = @intTmp + 1
						END
						--conto ' out' per avere il numero di parametri di out immessi nel richiamo della STP
						set @paramCountOutputExec = (len(@txtTmp) - len(replace(@txtTmp,' out', '')))/4 --len(' out') = 4
						--MIK220702
						--conto gli = per avere il numero di parametri immessi col richiamo esplicito (es.: @IdCliPrv = @PIdCliPrv)
						set @paramCountExplicitExec = len(@txtTmp) - len(replace(@txtTmp, '=', ''))

						--MIK220702: calcolo il numero di riga in cui inizia l'invocazione
						--			Ho messo fisso un + 8 poichè nella definizione non c'è il seguente pezzo che viene aggiunto in testa
						--			dal management all'apertura della STP
						-- USE [DboGmbT1]
						--GO
						--/****** Object:  StoredProcedure [dbo].[StpXCliOffDet_KyIns]    Script Date: 02/07/2022 13:13:13 ******/
						--SET ANSI_NULLS ON
						--GO
						--SET QUOTED_IDENTIFIER ON
						--GO
						SET @txtTmp = SUBSTRING(@definition, 0, @indexStart)
						SET @rowNum = (len(@txtTmp) - len(replace(@txtTmp, @NewLine, '')))/LEN(@NewLine) + 8
						
						INSERT INTO #TmpStpParamsCheck (StpNameReferencing,StpNameReferenced,  NumTotalParams, NumOutputParams, NumTotalParamsExecution, NumOutputParamsExecution, NumExplicitParamsExecution, RowNum, CharPosExecution, Note)
						VALUES (@stpname, @CurrProcedureNameReferenced, @NumParams, @NumParamsOutput, @paramCountExec, @paramCountOutputExec, @paramCountExplicitExec, @rowNum, @indexStart, (CASE WHEN (ISNULL(@NumParams,0) <> ISNULL(@paramCountExec,0)) AND ISNULL(@paramCountExplicitExec,0)=0 THEN 'ATTENZIONE: possibile errore di invocazione.' ELSE NULL END))

						SET @indexStart = @indexEnd + 1

					END
					ELSE
					BEGIN
						--anomalia
						--Non è stata trovata la terminazione dell'invocazione della STP
						INSERT INTO #TmpStpParamsCheck (StpNameReferencing,StpNameReferenced, NumTotalParams, NumOutputParams, NumTotalParamsExecution, NumOutputParamsExecution, CharPosExecution, Note)
						VALUES (@stpname, @CurrProcedureNameReferenced, @NumParamsOutput, @NumParamsOutput, NULL, NULL, NULL, 'ATTENZIONE: Non è stata trovata la terminazione dell''invocazione della STP')

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
			
	Fetch Next from curStpNameCheck into @CurrProcedureNameReferencing, @CurrProcedureNameReferenced
	END
	Close curStpNameCheck
	Deallocate curStpNameCheck

	SELECT *
	FROM #TmpStpParamsCheck
	WHERE ISNULL(NumTotalParams,0) <> ISNULL(NumTotalParamsExecution,0) --OR ISNULL(NumOutputParams,0) <> ISNULL(NumOutputParamsExecution,0)

END

GO

