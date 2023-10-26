

-- ==========================================================================================
-- Entity Name:   StpMntData_Exprt
-- Author:        dav
-- Create date:   200329
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   Genera file di script con dati e logica
--				  Attenzione WriteFile non accetta caratteri 'strani' che possono essere nel testo
--				  Comparare eventualmente il campo da esportare  con convert(varchar(max),nomecampo)
--				
--				  Per avere output da execute esempio
--
--				  Execute StpMntData_Exprt 'Select IdCliente, RagSoc From TbClienti', NULL, NULL, NULL, NULL 
--
--			      NB:
--				  Non inserire campi SysRowVersion, non usare *
--
-- History:
-- dav 200329 Creazione
-- dav 200406 Aggiunto  COLLATE DATABASE_DEFAULT
-- dav 200601 Gestione errori
-- dav 210110 Gestione output
-- dav 210819 Gestione money e corretto decimal con dimensione
-- dav 220128 Gestione ERROR_MESSAGE
-- dav 220530 Gestione DateTime
-- ==========================================================================================
      
CREATE PROCEDURE [dbo].[StpMntData_Exprt]
	(
		@StrSelect as nvarchar(max),
		@TbOutName as nvarchar(256),
		@FileName as nvarchar(256),
		@ActionFile as nvarchar(256),
		@SqlScript as nvarchar(max) OUT
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @TbOutName = ISNULL(@TbOutName,'TmpTable')
	/*******************************
	Gestione con xml
	Crea però un file di soli dati, senza logica
	
	Declare @StrXml as nvarchar(max)
	Declare @StrXmlData as nvarchar(max)
	Declare @SqlSelect as nvarchar (max)
	set @SqlSelect = 'SELECT NameCommand, DescCommand, TypeCommand, FormKey, TableStart, ColumnsStart, TableOpen, FormOpen, Command, StoreProcedure, CodFnzPos, Ordinamento, Gruppo, TimeoutCommand, IdGuid, ViewInfo, Disabilita FROM  dbo.dbo.TbSettingCommand'
	-- Genera stringa con xml
	DECLARE @ParmDefinition nvarchar(500)
	SET @ParmDefinition = N'@StrXmlData nvarchar(MAX) OUTPUT'
	set @StrXml =' SET @StrXmlData =(' + @SqlSelect + ' FOR XML PATH(''Record''), ROOT(''TbSettingCommand''))'
	EXECUTE sp_executesql @StrXml ,@ParmDefinition,@StrXmlData OUTPUT;
	print @StrXmlData
	-- Genera con bcp (serve nome tabella preceduto da nomedb.dbo.
	Declare @SqlCmd as varchar(4000)
	set @SqlCmd = 'bcp "' + @SqlSelect +' FOR XML PATH(''Record''), ROOT(''Data'')" queryout "F:\TestFile\test.xml" -T -c -t,'
	EXEC xp_cmdshell @SqlCmd
	*******************************/

	Declare @SqlColumn as nvarchar(max)
	Declare @SqlTmpSelect as nvarchar(max)
	Declare @SqlSelect as nvarchar(max)
	Declare @SqlInsert as nvarchar(max)
	Declare @SqlDrop as nvarchar(max)
	Declare @SqlData as nvarchar(max)
	Declare @StrCreate as nvarchar(max)
	Declare @data_lenght as int
	Declare @numeric_precision as int
	Declare @numeric_scale as int

	IF OBJECT_ID('tempdb..##TmpTable') IS NOT NULL DROP TABLE ##TmpTable
	IF OBJECT_ID('tempdb..##TmpTableData') IS NOT NULL DROP TABLE ##TmpTableData

	-- Crea select in tabella temporanea con il select
	SET @SqlTmpSelect = 'select * into ##Tmptable From (' + @StrSelect + ') x '
	EXECUTE sp_executesql @SqlTmpSelect

	/****************************************
	 * Cicla sulle colonne della tabella
	 ****************************************/

	Declare @column_name varchar(256)
	Declare @data_type varchar(256)

	--debug
	--select * FROM tempdb.information_schema.columns
	--WHERE table_name = '##Tmptable'

	Declare tbCursor cursor for

	SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE
	FROM tempdb.information_schema.columns
	WHERE table_name = '##Tmptable'
	ORDER BY ordinal_position
        
	Open tbCursor
	
	Fetch next from tbCursor into @column_name, @data_type, @data_lenght, @numeric_precision, @numeric_scale

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		

		IF @SqlColumn is not null  
			BEGIN
				Set @SqlColumn = @SqlColumn + ','
				Set @SqlSelect = @SqlSelect + '+ '  + '''' + ',' + '''' + ' +'  -- '''' + ',' + ' + ' + '''' 
				Set @StrCreate = @StrCreate + ','  + char(13) + char(10)
			END
		ELSE
			BEGIN
				Set @SqlColumn = ''
				Set @SqlSelect = '' 
				Set @StrCreate = ''
			END

		------------------------------
		-- Crea stringa column
		------------------------------

		SET @SqlColumn = @SqlColumn + @column_name

		------------------------------
		-- Crea stringa per creare la tabella
		------------------------------

		SET @StrCreate = @StrCreate + @column_name + ' ' + @data_type 
	
		IF  @data_lenght > 0
			BEGIN
				SET @StrCreate = @StrCreate + ' (' + CONVERT(NVARCHAR(20),@data_lenght) + ')  COLLATE DATABASE_DEFAULT '
			END
		else IF  @data_lenght = -1
			BEGIN
				SET @StrCreate = @StrCreate + ' (MAX)  COLLATE DATABASE_DEFAULT '
			END

		IF @data_type in ('decimal')
		BEGIN
			SET @StrCreate = @StrCreate + '(' + CONVERT(NVARCHAR(20),@numeric_precision)  + ',' + CONVERT(NVARCHAR(20), @numeric_scale) + ')'
		END

		SET @StrCreate = @StrCreate + ' NULL'

		
		------------------------------
		-- Crea stringa per select
		------------------------------
	
		IF @data_type in ('nvarchar','char','varchar')
			BEGIN
				SET @column_name = 'REPLACE (' + @column_name +','''''''','''''''''''')'
			END
		ELSE IF @data_type in ('int','real','float','decimal','money')
			BEGIN 
				SET @column_name = ' CONVERT (NVARCHAR(MAX), ' + @column_name + ')'
				SET @column_name = ' REPLACE (' + @column_name +','','',''.'')' 
			END
		ELSE IF @data_type in ('bit')
			BEGIN 
				SET @column_name = ' CONVERT (NVARCHAR(MAX), ' + @column_name + ')'
			END
		ELSE IF @data_type in ('uniqueidentifier')
			BEGIN
				SET @column_name = ' CONVERT (NVARCHAR(50), ' + @column_name + ')'
			END
		ELSE IF @data_type in ('Date')
			BEGIN
				SET @column_name = ' CONVERT (NVARCHAR(50), ' + @column_name + ',112)'
			END
		ELSE IF @data_type in ('DateTime')
			BEGIN
				SET @column_name = ' CONVERT (NVARCHAR(50), ' + @column_name + ',120)'
			END
	
		-- se nullo mette una stringa poi sostituita da NULL altrimenti converte '' in 0
		SET @column_name = ' ISNULL('+ @column_name + ',''##NULL##'') '
		
		SET @column_name = + ''''''''''   + ' + '  + @column_name + ' + '  + '''''''''' 

		IF @data_type in ('Date')
		BEGIN

			 SET @column_name = ''' CONVERT (date,''' + '+' +  @column_name + '+' + ''',112)'''

		END
		ELSE IF @data_type in ('DateTime')
		BEGIN

			 SET @column_name = ''' CONVERT (datetime,''' + '+' +  @column_name + '+' + ''',120)'''

		END

		SET @SqlSelect = @SqlSelect  + @column_name
		
		FETCH NEXT FROM tbCursor INTO @column_name , @data_type, @data_lenght, @numeric_precision, @numeric_scale
	END 

	close tbCursor
	deallocate tbCursor
	
	/**********************************************
	 * Crea la tabella di appoggio con i dati in unica stringa
	 **********************************************/

	SET @SqlSelect = 'SELECT ' + @SqlSelect + ' AS StrData INTO ##TmpTableData FROM ##TmpTable'

	EXECUTE sp_executesql @SqlSelect
	
	/**********************************************
	 * Cicla su tabella con unica stringa
	 **********************************************/
	 
	declare dataCursor cursor for

	select StrData
	from  ##TmpTableData
        
	open dataCursor
	fetch next from dataCursor into @SqlData

	WHILE @@FETCH_STATUS = 0  
	BEGIN  

		IF @SqlInsert is not null  
			BEGIN
				Set @SqlInsert = @SqlInsert + char (13) + char(10)
			END
		ELSE
			BEGIN
				Set @SqlInsert =''
			END

		SET @SqlData = REPLACE (@SqlData,'''##NULL##''','NULL')
		Set @SqlInsert = @SqlInsert  + 'INSERT INTO ##' + @TbOutName + ' ('+ @SqlColumn + ') VALUES (' + @SqlData + ')'

		FETCH NEXT FROM dataCursor INTO @SqlData 
	END 

	close dataCursor
	deallocate dataCursor

	/**********************************************
	 * Crea la tabella temporanea per i risultati
	 **********************************************/

	SET @SqlDrop = 'IF OBJECT_ID(''tempdb..##' + @TbOutName  +'''' + ' ) IS NOT NULL DROP TABLE ##' + @TbOutName 
	EXECUTE sp_executesql @SqlDrop

	set @StrCreate = 'CREATE TABLE ##'+ @TbOutName + CHAR(13) + CHAR(10) +'(' + CHAR(13) + CHAR(10) + + @StrCreate + CHAR(13) + CHAR(10) +  ')'
	EXECUTE sp_executesql @StrCreate

	/**********************************************
	 * Esegue script con i risultati
	 **********************************************/

	EXECUTE sp_executesql @SqlInsert

	/**********************************************
	 * Crea script globale
	 **********************************************/
	Declare @SqlScriptOut as varchar(max)

	IF charindex('Update',@SqlScript) > 1 or charindex('Insert',@SqlScript) > 1 
		BEGIN
			SET @SqlScript = dbo.FncStr ('BEGIN TRY', @SqlScript)
			SET @SqlScript = dbo.FncStr (@SqlScript,'PRINT ''      >> Script eseguito '' ')
			SET @SqlScript = dbo.FncStr (@SqlScript,'END TRY')
			SET @SqlScript = dbo.FncStr (@SqlScript,'BEGIN CATCH')
			SET @SqlScript = dbo.FncStr (@SqlScript,'PRINT ''      >> ## Errore su script aggiornamento ##'' ' )
			SET @SqlScript = dbo.FncStr (@SqlScript,'PRINT ERROR_MESSAGE() ' )
			SET @SqlScript = dbo.FncStr (@SqlScript,'END CATCH')
		END

	SET @SqlScriptOut = ''
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '------------------------------')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '-- Script di inserimento valori')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '-- GenAut')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '-- ' + convert(nvarchar(20),getdate(),120))
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '------------------------------')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '')
	IF @ActionFile = 'DEL'
	BEGIN
		SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, 'Print ' + '''Versione del '  + convert(nvarchar(20),getdate(),120) + '''')
		SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '')
		SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, 'IF DB_NAME() = ''DBO'' RETURN')
		SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '')
	END
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, 'SET NOCOUNT ON')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, 'BEGIN')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, 'Print ''   -> Elaborazione ' + @TbOutName +  '''')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '------------------------------')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '-- Elimina tabella')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '------------------------------')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, @SqlDrop)
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '------------------------------')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '-- Crea Tabella')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '------------------------------')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, @StrCreate)
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '------------------------------')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '-- Inserisce valori')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '------------------------------')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, @SqlInsert)
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '------------------------------')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '-- Esegue script')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '------------------------------')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, @SqlScript)
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, 'END')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '------------------------------')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '-- END')
	SET @SqlScriptOut = dbo.FncStr (@SqlScriptOut, '------------------------------')

	SET @SqlScript = @SqlScriptOut

	If @FileName is not null
	BEGIN
		DECLARE @OLE INT
		DECLARE @FileID INT

		If @ActionFile = 'DEL'
			BEGIN
				DECLARE @cmd NVARCHAR(MAX) 
				SET @cmd = 'xp_cmdshell ''del "' + @FileName + '"'''
				EXEC (@cmd)
			END
		DECLARE @hr INT
		EXECUTE sp_OACreate 'Scripting.FileSystemObject', @OLE OUT
			

		--EXECUTE sp_OASetProperty @OLE,'Type', 2                           --1 = binary, 2 = text
		--EXECUTE sp_OASetProperty @OLE,'Mode', 2                           --0 = not set, 1 read, 2 write, 3 read/write
		--EXECUTE sp_OASetProperty @OLE,'Charset', 'utf-8'                     --"ISO-8859-1"
		--EXECUTE sp_OASetProperty @OLE,'LineSeparator','adLF'
		--EXECUTE sp_OAMethod                  @OLE,    "Open"
		EXECUTE sp_OAMethod @OLE, 'OpenTextFile', @FileID OUT, @FileName , 8, 1

		EXECUTE  @hr = sp_OAMethod @FileID, 'WriteLine', Null, @SqlScriptOut
		IF @hr <> 0  
		BEGIN  
			RAISERROR('Error %d writing line - Verifica caratteri non ammessi (compara con convert(varchar(max)).', 16, 1, @hr)
			RETURN
		END

		--WHILE LEN(@SqlScriptOut) > 1
		--	BEGIN
		--		DECLARE @LEN AS INT
		--		SET @LEN = 100000
		--		SET @SqlScriptWrite = LEFT(@SqlScriptOut,@LEN)
		--		SET @SqlScriptOut = SUBSTRING(@SqlScriptOut,@LEN+1,99999999)

		--		EXECUTE  @hr = sp_OAMethod @FileID, 'WriteLine', Null, @SqlScriptWrite
					
		--		IF @hr <> 0  
		--		BEGIN  
		--			RAISERROR('Error %d writing line.', 16, 1, @hr)
		--			RETURN
		--		END
		--		EXECUTE  @hr = sp_OAMethod @FileID, 'WriteLine', Null, '######################'
		--	END

		EXECUTE sp_OADestroy @FileID
		EXECUTE sp_OADestroy @OLE
	END
	
	-- Se non c'è file name crea l'output con print
	IF @FileName IS NULL
	BEGIN
		declare @pos  as int
		while len(@SqlScript) > 1
		begin
			set @pos = charindex(char(13) + char(10),@SqlScript) 
			if @pos = 0 set @pos = len(@SqlScript)
			print left(@SqlScript,@pos-1)
			set @SqlScript = substring(@SqlScript, @pos+2, len(@SqlScript))
		end
		print ''
		print 'select * from ##' + @TbOutName
	END

END

GO

