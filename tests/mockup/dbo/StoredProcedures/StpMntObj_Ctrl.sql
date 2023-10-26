

-- ==========================================================================================
-- Entity Name:   StpMntObj_Ctrl
-- Author:        Dav
-- Create date:   26.01.19
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:	Write custom note here
-- Description:	Controlla presenza oggetti Stpx da verificare
--				Per lanciare un comando su tutti i db
--				DECLARE @command varchar(1000) 
--				SELECT @command = 'USE ? SELECT name FROM sysobjects WHERE xtype = ''U'' ORDER BY name' 
--				EXEC sp_MSforeachdb @command 
-- History:
-- dav 200113 Aggiunto controllo su data alter
-- dav 200727 RECORD effettua il conteggio
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntObj_Ctrl]

(
	@TipoControllo as nvarchar(20),	--OBJ controlla presenza Object su tutti gli oggetti del db corrente 
									--		Execute StpMntObj_Ctrl 'OBJ', 'StpForFat_KyIns'
									--OBJX controlla presenza Object su tutti gli oggetti X del db corrente 
									--		Execute StpMntObj_Ctrl 'OBJX', 'StpForFat_KyIns'
									--OBJXDB  controlla presenza Object su tutti gli oggetti X di tutti i database 
									--		Execute StpMntObj_Ctrl 'OBJXDB', 'StpForFat_KyIns'
									--EXISTS controlla Esistenza di Object su tutti i db
									--		Execute StpMntObj_Ctrl 'EXISTS', 'StpXOdlDet'
									--ALTER controlla Esistenza di Object su tutti i db con data modifica superiore a data
									--		Execute StpMntObj_Ctrl 'ALTER', 'StpOdlDet_KyIns', '2020-12-31'
									--RECORD controlla se ci sono record in Object 
									--		Execute StpMntObj_Ctrl 'RECORD', 'TbCliFat WHERE (ScontoFatCondz IS NOT NULL)'
									--		Execute StpMntObj_Ctrl 'RECORD', 'TbArticoli where IdMage not in (Select IdMage from DbName.dbo.TbMageAnag)' NB usare DbName per indicare il db in analisi
									--RECORDX controlla se ci sono record in Object 
									--		Execute StpMntObj_Ctrl 'RECORDX', 'Select 1 From DbName.Dbo.TbArticoli TbArticoli inner join DbName.dbo.TbMageAnag TbMageAnag ON TbArticoli.IdMage = TbMageAnag.IdMage' NB usare DbName per indicare il db in analisi
									--VALUE Espone valore di un campo Object su Stutti i db 
									--		Execute StpMntObj_Ctrl 'VALUE',  'TbSettingKey WHERE (idkey =''RptCliFatScheda'')', 'Value'
	@Object as nvarchar(4000),
	@Campo as nvarchar(4000) = ''
)

As
Begin

	-- Ricerca su tabella
	--SELECT t.name AS table_name, SCHEMA_NAME(schema_id) AS schema_name, c.name AS column_name 
	--FROM sys.tables AS t INNER JOIN sys.columns c ON t.OBJECT_ID = c.OBJECT_ID 
	--WHERE c.name LIKE '%IdCliente%' 
	--ORDER BY schema_name, table_name

	-- Ricerca relazioni
	--Select
	--object_name(rkeyid) Parent_Table,
	--object_name(fkeyid) Child_Table,
	--object_name(constid) FKey_Name,
	--c1.name FKey_Col,
	--c2.name Ref_KeyCol
	--From
	--sys.sysforeignkeys s
	--Inner join sys.syscolumns c1
	--on ( s.fkeyid = c1.id And s.fkey = c1.colid )
	--Inner join syscolumns c2
	--on ( s.rkeyid = c2.id And s.rkey = c2.colid )
	--where c1.name = 'IdCliente'
	--Order by Parent_Table,Child_Table

	/*
		-- conteggio parametri
		SELECT  count(parameter_name)
		FROM    INFORMATION_SCHEMA.PARAMETERS where SPECIFIC_NAME = 'stpcliart_sel'
	*/

	DECLARE @name as nvarchar(200)
	DECLARE @KyRes int
	DECLARE @Sql as nvarchar(4000)
	Declare @Valore as nvarchar(200)

	/*********************************************************
	 * OBJ
	 * Controlla esecuzione Object su STPX db corrente
	 * Execute StpMntObj_Ctrl 'OBJ', 'StpForFat_KyIns'
	 *********************************************************/
	IF @TipoControllo = 'OBJ'
		BEGIN
			Print 'Verifica esecuzione di ' + @Object + ' nel database corrente'
			
			DECLARE @StpDef as nvarchar(MAX)

			DECLARE db_cursor CURSOR FOR 
			
			SELECT DISTINCT
			o.name AS Object_Name,  m.definition
			--, o.type_desc
			FROM  sys.sql_modules m
			INNER JOIN
			sys.objects o
			ON m.object_id = o.object_id
			WHERE
			( 
			m.definition Like '%' + @Object +'%'
			)
			--and (o.name like 'Stp%'
			--OR o.name like 'Vtp%'
			--OR o.name like 'Fnc%')

			OPEN db_cursor  
			FETCH NEXT FROM db_cursor INTO @name, @StpDef  

			WHILE @@FETCH_STATUS = 0  
			BEGIN 
				--PRINT '## Attenzione ' + @Object + ' utilizzato in ' + @name

				/********************************
				 * Scansione della stringa
				 ********************************/

				DECLARE @Go as bit
				DECLARE @Pos as int
				DECLARE @PosInit as int
				DECLARE @PosEnd as int
				DECLARE @LenObj as int
				DECLARE @Dummy as nvarchar(max)
				DECLARE @Dummy1 as nvarchar(max)
				DECLARE @Ascii0 as int -- Codiec ascii del carattere precedente alla stringa cercata, per vedere se è uno spazio o ritorno a capo
				DECLARE @Ascii1 as int -- Codiec ascii del carattere successivo alla stringa cercata, per vedere se è uno spazio o ritorno a capo

				SET @LenObj = len (@Object)

				SET @Go = 1

				IF @name = @Object
					BEGIN
						SET @Go = 0
						PRINT '0. Definizione ' + @name 
					END
				
				while @Go = 1
					BEGIN
						SET @Pos = CHARINDEX(@Object,@StpDef)
						SET @Ascii0 = AsCII(substring (@StpDef,@Pos-1,1))
						SET @Ascii1 = AsCII(substring (@StpDef,@Pos+ @LenObj,1))
						
						SET @Dummy1 = LEFT (@StpDef,@Pos)
						SET @Dummy1 = REVERSE(@Dummy1)
						SET @PosInit = CHARINDEX(CHAR(10), @Dummy1)
						SET @PosInit =  LEN(@Dummy1) - @PosInit
						SET @Dummy1 = SUBSTRING (@StpDef, @PosInit + 3,9999)
						--PRINT LEFT(@Dummy1,99)
						SET @PosEnd = CHARINDEX(CHAR(10), @Dummy1)
						SET @Dummy1 = LEFT (@Dummy1, @PosEnd -1)
						SET @Dummy1 = REPLACE(@Dummy1, CHAR(13),' ')
						SET @Dummy1 = REPLACE(@Dummy1, CHAR(10),' ')
						SET @Dummy1 = REPLACE(@Dummy1, CHAR(9),' ')
						SET @Dummy1 = LTRIM(@Dummy1)
						SET @Dummy1 = RTRIM(@Dummy1)

						SET @Dummy = LEFT (@StpDef,@Pos + @LenObj)

						SET @StpDef = Substring (@StpDef,@Pos + @LenObj, 999999)
						SET @Dummy =  REVERSE( @Dummy)
						SET @Pos = CHARINDEX(char(13),@Dummy)
					 

						SET @Dummy = left (@Dummy,@Pos)
						SET @Dummy = REVERSE( @Dummy)
						
						IF @Ascii1 NOT IN (10,13,32) OR @Ascii0 NOT IN (10,13,32,46)
							BEGIN
								--PRINT substring (@StpDef,@Pos+ @LenObj-20,40) 
								--PRINT AsCII(substring (@StpDef,@Pos+ @LenObj,1))
								SET @Pos = CHARINDEX('--',@Dummy)
								PRINT '1. ' + @name + ' ' + @Dummy1
							END
						ELSE IF CHARINDEX('--',@Dummy)>0 
							BEGIN
								SET @Pos = CHARINDEX('--',@Dummy)
								PRINT '2. ' + @name + ' ' + + @Dummy1 -- SUBSTRING(@Dummy,@Pos,9999)
							END
						ELSE
							BEGIN
								SET @Pos = CHARINDEX(CHAR(13),@Dummy)
								PRINT '>>> ' + @name  + ' ' + + @Dummy1 --SUBSTRING(@Dummy,@Pos,9999)
							END

						SET @Pos = CHARINDEX(@Object,@StpDef)
							IF @Pos =0
								BEGIN
									SET @Go = 0
								END
					END

				FETCH NEXT FROM db_cursor INTO @name, @StpDef
			END 

			CLOSE db_cursor  
			DEALLOCATE db_cursor
			
		END

	/*********************************************************
	 * OBJX
	 * Controlla esecuzione Object su STPX db corrente
	 * Execute StpMntObj_Ctrl 'OBJX', 'StpForFat_KyIns'
	 *********************************************************/
	ELSE IF @TipoControllo = 'OBJX'
		BEGIN
			Print 'Verifica esecuzione di ' + @Object + ' nelle StpX, FncX, VstX del database corrente'
			
			DECLARE db_cursor CURSOR FOR 
			
			SELECT DISTINCT
			o.name AS Object_Name
			--, o.type_desc
			FROM  sys.sql_modules m
			INNER JOIN
			sys.objects o
			ON m.object_id = o.object_id
			WHERE
			( 
			m.definition Like '%' + @Object +'%'
			)
			and 
			(o.name like 'Stpx%'
			OR o.name like 'Vstx%'
			OR o.name like 'Fncx%')

			OPEN db_cursor  
			FETCH NEXT FROM db_cursor INTO @name  

			WHILE @@FETCH_STATUS = 0  
			BEGIN 
				Print '## Attenzione ' + @Object + ' utilizzato in ' + @name
				FETCH NEXT FROM db_cursor INTO @name 
			END 

			CLOSE db_cursor  
			DEALLOCATE db_cursor
			
		END

	/*********************************************************
	 * OBJXDB
	 * Controlla presenza Object su STPX, DNCX, VSTX su tutti i db
	 * Execute StpMntObj_Ctrl 'OBJXDB', 'StpForFat_KyIns'
	 *********************************************************/

	ELSE IF @TipoControllo = 'OBJXDB'
		BEGIN

			Print 'Verifica esecuzione di ' + @Object + ' nelle StpX, VstX, FncX di tutti i database'

			DECLARE db_cursor CURSOR FOR 
			SELECT name 
			FROM MASTER.dbo.sysdatabases 
			WHERE name NOT IN ('master','model','msdb','tempdb') 
			and  ( (512 & status) <> 512 ) -- Toglie offline
			and  ( (128 & status) <> 128 ) -- Toglie in ripristino
			ORDER BY name


			OPEN db_cursor  
			FETCH NEXT FROM db_cursor INTO @name  

			WHILE @@FETCH_STATUS = 0  
			BEGIN  
      
				 -- Controllo utilizzo Stp in una stpx
				 Set @KyRes = 0
				 set @Sql='

				 If exists(
					SELECT DISTINCT
					o.name AS Object_Name,
					o.type_desc
					FROM ' + @name +'.sys.sql_modules m
					INNER JOIN
					'+ @name +'.sys.objects o
					ON m.object_id = o.object_id
					WHERE
					( 
					m.definition Like ''%' + @Object +'%''
					)
					and 
					(
					o.name  like ''Stpx%''
					OR o.name like ''Vtpx%''
					OR o.name like ''Fncx%''
					)) set @KyRes = 1  '

				exec sp_executesql @SQL, N'@KyRes int out', @KyRes out

				If @KyRes = 1 Print  @name +' ## DA CONTROLLARE ##' --else print  @name   + ' OK'
				

				FETCH NEXT FROM db_cursor INTO @name 
				END 

			CLOSE db_cursor  
			DEALLOCATE db_cursor
		END

	/*********************************************************
	 * EXISTS
	 * Controlla Esistenza Object su Stutti i db
	 * Execute StpMntObj_Ctrl 'EXISTS', 'StpXOdlDet'
	 *********************************************************/

	ELSE IF @TipoControllo = 'EXISTS'
		BEGIN
	
			Print 'Verifica esistenza di ' + @Object + ' in tutti i database'

			DECLARE db_cursor CURSOR FOR 
			SELECT name  
			FROM MASTER.dbo.sysdatabases 
			WHERE name NOT IN ('master','model','msdb','tempdb') 
			and  ( (512 & status) <> 512 ) -- Toglie offline
			and  ( (128 & status) <> 128 ) -- Toglie in ripristino
			ORDER BY name


			OPEN db_cursor  
			FETCH NEXT FROM db_cursor INTO @name  

			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				SET @KyRes = 0

				set @Sql='
				
				 If exists(
					SELECT DISTINCT
					o.name AS Object_Name,
					o.type_desc
					FROM ' + @name +'.sys.sql_modules m
					INNER JOIN
					'+ @name +'.sys.objects o
					ON m.object_id = o.object_id
					WHERE
					(
					o.name  = '''+ @Object +'''
					)) set @KyRes = 1  '

				exec sp_executesql @SQL, N'@KyRes int out', @KyRes out

				If @KyRes = 1 Print  '# ' + @name +' ## DA CONTROLLARE ##' else print  'NON PRESENTE ' + @name 

				FETCH NEXT FROM db_cursor INTO @name 
				END 

			CLOSE db_cursor  
			DEALLOCATE db_cursor
		END

	/*********************************************************
	 * ALTER
	 * Controlla data maggiore di data per  Alter Object su Stutti i db
	 * Execute StpMntObj_Ctrl 'ALTER', 'StpOdlDet_KyIns','2001-01-01'
	 *********************************************************/

	ELSE IF @TipoControllo = 'ALTER'
		BEGIN
	
			Print 'Verifica esistenza di ' + @Object + ' in tutti i database'

			DECLARE db_cursor CURSOR FOR 
			SELECT name  
			FROM MASTER.dbo.sysdatabases 
			WHERE name NOT IN ('master','model','msdb','tempdb') 
			and  ( (512 & status) <> 512 ) -- Toglie offline
			and  ( (128 & status) <> 128 ) -- Toglie in ripristino
			ORDER BY name


			OPEN db_cursor  
			FETCH NEXT FROM db_cursor INTO @name  

			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				
				set @KyRes = 0

				set @Sql='

				 If exists(
					SELECT name 
					FROM ' + @name +'.sys.objects
					WHERE  name = '''+ @Object +'''
					AND modify_date >= convert(date, ''' + @Campo + ''',120)
					) set @KyRes = 1  '

				exec sp_executesql @SQL, N'@KyRes int out', @KyRes out

				If @KyRes = 1 Print  @name +' ## DA CONTROLLARE ##' --else print  @name   + ' OK'

				FETCH NEXT FROM db_cursor INTO @name 
				END 

			CLOSE db_cursor  
			DEALLOCATE db_cursor
		END

	/*********************************************************
	 * RECORD
	 * Controlla Esistenza Object su Stutti i db
	 * Esempio  Execute StpMntObj_Ctrl 'RECORD', 'TbCliFat WHERE (ScontoFatCondz IS NOT NULL)'
	 *********************************************************/

	ELSE IF @TipoControllo = 'RECORD'
		BEGIN
			
			Print 'Verifica esistenza dati in ' + @Object + ' in tutti i database'

			DECLARE db_cursor CURSOR FOR 
			SELECT name 
			FROM MASTER.dbo.sysdatabases 
			WHERE name NOT IN ('master','model','msdb','tempdb') 
			and  ( (512 & status) <> 512 ) -- Toglie offline
			and  ( (128 & status) <> 128 ) -- Toglie in ripristino
			ORDER BY name


			OPEN db_cursor  
			FETCH NEXT FROM db_cursor INTO @name  

			WHILE @@FETCH_STATUS = 0  
			BEGIN 
					
				Set @KyRes = 0
				if left(@name,3)= 'dbo'
					BEGIN

						--set @Sql='
						--If exists(
						--SELECT 1
						--FROM ' + @name +'.DBO.' + @Object +'
						--) set @KyRes = 1  '

						set @Sql='
						SELECT @KyRes = count( 1)
						FROM ' + @name +'.DBO.' + @Object 

						Set @Sql = Replace (@Sql,'DbName', @name)
						--print @Sql

						exec sp_executesql @SQL, N'@KyRes int out', @KyRes out

						--If @KyRes = 1 Print  @name +' ## DA CONTROLLARE ##' --else print  @name   + ' OK'
						If IsNull(@KyRes,0) > 0 Print  @name +' ## DA CONTROLLARE ## (' + convert(nvarchar(20),@KyRes) + ')' --else print  @name   + ' OK'
					END
				FETCH NEXT FROM db_cursor INTO @name 
			END 

			CLOSE db_cursor  
			DEALLOCATE db_cursor
		END

	/*********************************************************
	 * RECORDX
	 * Controlla Esistenza Object su Stutti i db
	 * Esempio  Execute StpMntObj_Ctrl 'RECORDX', 'Select 1 from @TbCliFat TbCliFat WHERE (TbCliFat.ScontoFatCondz IS NOT NULL)'
	 *********************************************************/

	ELSE IF @TipoControllo = 'RECORDX'
		BEGIN
			
			Print 'Verifica esistenza dati in ' + @Object + ' in tutti i database'

			if charindex (@Sql,'DbName') = 0
			BEGIN
				Print 'Definisci le tabelle con DbName.dbo.TbName'
			END
			ELSE
			BEGIN
				DECLARE db_cursor CURSOR FOR 
				SELECT name 
				FROM MASTER.dbo.sysdatabases 
				WHERE name NOT IN ('master','model','msdb','tempdb') 
				and  ( (512 & status) <> 512 ) -- Toglie offline
				and  ( (128 & status) <> 128 ) -- Toglie in ripristino
				ORDER BY name


				OPEN db_cursor  
				FETCH NEXT FROM db_cursor INTO @name  

				WHILE @@FETCH_STATUS = 0  
				BEGIN 
					
					Set @KyRes = 0
					if left(@name,3)= 'dbo'
						BEGIN
							set @KyRes = 0

							set @Sql='
							If exists('
							+ @Object +
							') set @KyRes = 1  '

							Set @Sql = Replace (@Sql,'DbName', @name)
							--print @Sql

							exec sp_executesql @SQL, N'@KyRes int out', @KyRes out

							If @KyRes = 1 Print  @name +' ## DA CONTROLLARE ##' else print  @name   + ' OK'
						END
					FETCH NEXT FROM db_cursor INTO @name 
				END 

				CLOSE db_cursor  
				DEALLOCATE db_cursor
			END
		END
	/*********************************************************
	 * VALUE
	 * Espone valore di un campo Object su Stutti i db
	 * Esempio  Execute StpMntObj_Ctrl 'VALUE',  'TbSettingKey WHERE (idkey =''RptCliFatScheda'')', 'Value'
	 *********************************************************/

	ELSE IF @TipoControllo = 'VALUE'
		BEGIN
	
			Print 'Controlla valore ' + @Object + ' in tutti i database'

			DECLARE db_cursor CURSOR FOR 
			SELECT name 
			FROM MASTER.dbo.sysdatabases 
			WHERE name NOT IN ('master','model','msdb','tempdb') 
			and  ( (512 & status) <> 512 ) -- Toglie offline
			and  ( (128 & status) <> 128 ) -- Toglie in ripristino
			ORDER BY name


			OPEN db_cursor  
			FETCH NEXT FROM db_cursor INTO @name  

			WHILE @@FETCH_STATUS = 0  
			BEGIN 
				-- Analisi valore campo
				Set @Valore = ''

				if left(@name,3)= 'dbo'
				BEGIN
					Print '-------------------------'
					Print  @name

					set @Sql='
					set  @Valore = (
					SELECT ' + @Campo + '
					FROM ' + @name +'.DBO.' + @Object +'
					)
					'
					exec sp_executesql @SQL, N'@Valore nvarchar(200) out', @Valore out

					Print  @name + ' ' +  @Object + ': '  + @Valore
				END
				
				FETCH NEXT FROM db_cursor INTO @name 
			END 

			CLOSE db_cursor  
			DEALLOCATE db_cursor
		END
	
	/*********************************************************
	 * Opzione non valida
	 *********************************************************/

	ELSE 
		BEGIN
			Print 'Opzione non valida'
		END
END

GO

