

-- ==========================================================================================
-- Entity Name:   StpMntObjSetCompatibility
-- Author:        Mik
-- Create date:   11.05.21
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:	 
-- Description:	  Procedura che ha il compito di ricercare in tutte le STP, VST, FNC per commentare/scommentare pezzi di codice che sono compatibiliti solo con versione specifiche di SQL Server
-- History:
-- mik 210511 Creazione
-- mik 210512 Impostato per sicurezza che la funzionalità non sia disponibile per il database DBO
--				messo come logica >= @CompatibilityVersion così da prender dentro anche versioni più recenti
-- dav 210517 Note e limitazione alle viste
-- mik 210524 Aggiunto logica per intervallo di versioni.
--				Esempio per codice che deve essere attivo per SS da 2005 a 2012:
--				/*§§V05-12
--				§§V05-12*/
--				Esempio per codice che deve essere attivo per SS da 2016 in su:
--				/*§§V16-99
--				§§V16-99*/
--				Aggiunto esempi di utilizzo nei commenti ad inizio procedura.	
-- dav 210604 Aggiunto 'P'
-- dav 211206 Gesitone SERVERPROPERTY
-- dav 220104 Modifica SERVERPROPERTY - dava 14 ivece che 17
-- dav 230719 Gestione 'FN' per funzioni
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntObjSetCompatibility]
(
	@CompatibilityVersion as nvarchar(200) --versione di Compatibilità minima: 12, 16, 17, 19 etc. (sono le varie versioni di SQL Server).
									--					se NULL prende la versione del database corrente. 
)
As
Begin
	SET NOCOUNT ON

	DECLARE @SqlVer AS NVARCHAR(200)
	DECLARE @EngineEdition AS NVARCHAR(20)


	---------------------------------------
	--
	-- --PEZZO NON ATTIVO
	--
	-- /*§§V16-99
	-- SELECT IdArticolo, STRING_AGG(CONVERT(NVARCHAR(MAX), DescQlaControllo), CHAR(13) + CHAR(10)) AS DescQlaControlli
	-- FROM  dbo.TbArtQlaControlli
	-- WHERE (Disabilita = 0)
	-- GROUP BY IdArticolo
	-- §§V16-99*/
	--
	-- PEZZO ATTIVO (QUELLO DI DEFAULT)
	--
	-- --/*§§V05-12
	-- SELECT DISTINCT IdArticolo,  LEFT(REPLACE(Substring
	-- ((SELECT        '#' + CONVERT(nvarchar(max), DescQlaControllo)   AS [data()]
	-- FROM            TbArtQlaControlli t2
	-- WHERE        t2.IdArticolo = t1.IdArticolo and disabilita=0
	-- ORDER BY NControllo FOR XML PATH('')), 2, 4000), '#', char(13) + char(10)), 4000) AS DescQlaControlli
	-- FROM           TbArtQlaControlli t1
	-- --§§V05-12*/
	--
	--------------------------------------

	---------------------------------------
	--
	-- Logica per segnare le STP, VST e FNC:
	-- Per demarcare una sezione compatibile con una versione specifica di SQL Server all'interno della definizione va messo 
	-- facendo un esempio con per abilitare il codice da SS2016 in su (SS2099 se mai esisterà)
	-- come inizio della sezione
	-- /*§§V16-99
	-- come fine della sezione
	-- §§V16-99*/
	-- ossia §§V + numero di  version (2 cifre) con al'inizio/fine l'apertura/chiusura commento (/* */)
	--
	-- StpMntObjSetCompatibility si farà il lavoro di fare il parsing di tutti gli oggetti e commentare/scommentare l'inizio/fine
	-- a seconda della versione di compatibilità specificata
	-- storico dav
	--DECLARE @sql as nvarchar(max)
	--DECLARE @Name as nvarchar(256)
	--DECLARE @SqlVersion nvarchar(50)

	--set @SqlVersion = CONVERT(NVARCHAR(50), SERVERPROPERTY('productversion'))

	--DECLARE db_cursor CURSOR FOR 
        
	--SELECT Table_Name, view_definition
	--FROM   INFORMATION_SCHEMA.VIEWS 
	--WHERE  VIEW_DEFINITION like '%/**COMPILE#2012*/%'
       
	--OPEN db_cursor  
	--FETCH NEXT FROM db_cursor INTO @Name, @sql  

	--WHILE @@FETCH_STATUS = 0  
	--BEGIN  
			
	--	IF LEFT(@SqlVersion,2) >= '14' AND CHARINDEX ('/*COMPILE#2017**', @sql) > 0
	--	BEGIN
	--		SET @sql = REPLACE (@sql,'/*COMPILE#2017**','/*COMPILE#2017**/')
	--		SET @sql = REPLACE (@sql,'**COMPILE#2017*/','/**COMPILE#2017*/')
	--		SET @sql = REPLACE (@sql,'/*COMPILE#2012**/','/*COMPILE#2012**')
	--		SET @sql = REPLACE (@sql,'/**COMPILE#2012*/','**COMPILE#2012*/')
	--		SET @sql = REPLACE (@sql,'CREATE VIEW','ALTER VIEW')
	--		print ' >> Compile 2107 - ' + @Name
	--		--PRINT @sql
	--		execute sp_executesql  @sql  
	--	END
	--	ELSE
	--	BEGIN
	--		print ' >> Skip ' + @Name
	--	END

	--	FETCH NEXT FROM db_cursor INTO @Name, @sql   
	--END 

	--CLOSE db_cursor  
	--DEALLOCATE db_cursor 
	---------------------------------------
	IF DB_NAME() <> 'DBO'
	BEGIN

		IF(@CompatibilityVersion IS NULL)
		BEGIN
			-- dav 211206 @@version è la verisone in formato stringa, ma in azure non è coerente con on-premise
			SET @EngineEdition = convert(nvarchar(20), SERVERPROPERTY('EngineEdition'))
			
			IF @EngineEdition = 8
				BEGIN
					SET @CompatibilityVersion = '19'
					print ' >> Versione SQL Azure - 19'
				END
			ELSE
				BEGIN
					SET @SqlVer = (select @@version)
					SET @CompatibilityVersion = SUBSTRING(@SqlVer,24,2)
					--SET @SqlVer = convert(nvarchar(20),SERVERPROPERTY('ProductVersion'))
					--SET @CompatibilityVersion = LEFT(@SqlVer,2)
					print ' >> Versione SQL ' + @CompatibilityVersion
				END
			

		END

		IF(NOT ISNUMERIC(@CompatibilityVersion)=1)
		BEGIN
			PRINT 'La versione @Compatibility non è un numero valido'
			RETURN -1
		END

		--print @CompatibilityVersion

		DECLARE @objid as INT
		DECLARE @objname as nvarchar(200)
		DECLARE @objtype as nvarchar(200)
		DECLARE @definition as nvarchar(MAX)
		DECLARE @indexStart as bigint
		--DECLARE @indexEnd as bigint
		DEclare @indexTmp as bigint
		DECLARE @definitionLen as bigint
		DECLARE @txtTmp as nvarchar(max)
		DECLARE @FlgInizioSezione as bit = 0
		DECLARE @currentLowerVersion as int -- limite inferiore della versione
		DECLARE @currentUpperVersion as int -- limite superiore della versione

		--DECLARE @NewLine as nvarchar(10)
		--DECLARE @Tab as nvarchar(10)
		--DECLARE @whitespace as nvarchar(1)
		--SET @NewLine = CHAR(13)+CHAR(10)
		--SET @Tab = CHAR(9)
		--SET @whitespace = ' '

		DECLARE db_cursor CURSOR FOR 
		SELECT DISTINCT
			   o.name AS Object_Name,
			   o.Type,
			   m.definition
		  FROM sys.sql_modules m
			   INNER JOIN
			   sys.objects o
				 ON m.object_id = o.object_id
		 WHERE (m.definition Like '%/*§§V%')
		 AND (o.name <> 'StpMntObjSetCompatibility') -- escludo STP che iniziano per ZZZ che per convenzione sono solo copie
		 --AND (o.Type In ('P','V', 'FN', 'IF', 'TF')) --STP, VST, FFNC (pure, inline, tbale value)
		 AND (o.Type In ('P','V', 'FN'))

		OPEN db_cursor  
		FETCH NEXT FROM db_cursor INTO @objname, @objtype, @definition

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			SET @indexStart = 1
			print ' >> Modifica Compatibilità ' + @objname
			SET @definitionLen = LEN(@definition)

			WHILE(@indexStart<@definitionLen)
			BEGIN
			
				SET @currentLowerVersion = NULL
				SET @currentUpperVersion = NULL
				SET @indexTmp = 0
				SET @txtTmp = NULL
			
				SET @indexTmp = CHARINDEX('§§V',@definition,@indexStart)
				IF(@indexTmp<=0)
				BEGIN
					-- non è stato trovato nulla
					-- esci da ciclo
					SET @indexStart = @definitionLen
				END
				ELSE
				BEGIN
					--è stato trovato un inizio/fine sezione di compatibilità versione
					--verifica versione
					SET @indexTmp = CHARINDEX('§§V',@definition,@indexStart)
					SET @txtTmp = SUBSTRING(@definition,@indexTmp+3,5)

					IF(ISNUMERIC(SUBSTRING(@txtTmp,1,2))=1 AND ISNUMERIC(SUBSTRING(@txtTmp,4,2))=1)
					BEGIN
						SET @currentLowerVersion = CAST(SUBSTRING(@txtTmp,1,2) as INT)
						SET @currentUpperVersion = CAST(SUBSTRING(@txtTmp,4,2) as INT)

						--verifica se è inizio fine
						SET @txtTmp = SUBSTRING(@definition,@indexTmp-2,2)
						IF(@txtTmp='/*')
							SET @FlgInizioSezione = 1
						ELSE
							SET @FlgInizioSezione = 0

						IF(@FlgInizioSezione=1)
						BEGIN
							--caso /*§§V16-99 end
							IF(@currentLowerVersion <= @CompatibilityVersion AND @currentUpperVersion >= @CompatibilityVersion)
							BEGIN
								--Bisogna aggiungere commento se assente
								--così che il testo contenuto nella sezione sia attivo
								IF(SUBSTRING(@definition,@indexTmp-4,2)<>'--')
								BEGIN
									SET @definition = SUBSTRING(@definition,1,@indexTmp-3) + '--' + SUBSTRING(@definition,@indexTmp-2,(@definitionLen-(@indexTmp-2))+1)
									SET @definitionLen = @definitionLen + 2
								END
							END
							ELSE
							BEGIN
								--Bisogna togliere commento se presente
								--così che il testo conentuto nella sezione sia commentato/disabilitato
								IF(SUBSTRING(@definition,@indexTmp-4,2)='--')
								BEGIN
									SET @definition = SUBSTRING(@definition,1,@indexTmp-5) + SUBSTRING(@definition,@indexTmp-2,(@definitionLen-(@indexTmp-2))+1)
									SET @definitionLen = @definitionLen - 2
								END
							END
						END
						ELSE
						BEGIN
							--caso §§V16-99*/ end
							IF(@currentLowerVersion <= @CompatibilityVersion AND @currentUpperVersion >= @CompatibilityVersion)
							BEGIN
								--Bisogna aggiungere commento se assente
								--così che il testo conentuto nella sezione sia attivo
								IF(SUBSTRING(@definition,@indexTmp-2,2)<>'--')
								BEGIN
									SET @definition = SUBSTRING(@definition,1,@indexTmp-1) + '--' + SUBSTRING(@definition,@indexTmp,(@definitionLen-(@indexTmp))+1)
									SET @definitionLen = @definitionLen + 2
								END
							END
							ELSE
							BEGIN
								--Bisogna togliere commento se presente
								--così che il testo conentuto nella sezione sia commentato/disabilitato
								IF(SUBSTRING(@definition,@indexTmp-2,2)='--')
								BEGIN
									SET @definition = SUBSTRING(@definition,1,@indexTmp-3) + SUBSTRING(@definition,@indexTmp,(@definitionLen-(@indexTmp))+1)
									SET @definitionLen = @definitionLen - 2
								END
							END
						END
					END

					SET @indexStart = @indexTmp + 5

				END

			END

			IF(@objtype = 'P')
			BEGIN
				SET @indexTmp = CHARINDEX('CREATE PROCEDURE ',@definition,1)
				SET @definition = SUBSTRING(@definition, 1, @indexTmp-1) + 'Alter' + SUBSTRING(@definition, @indexTmp+6, (LEN(@definition)-(@indexTmp+6))+1)
				--print RIGHT(@definition,10)
				--print @definition
				--select @definition
				EXEC (@definition)
			END

			IF(@objtype = 'V')
			BEGIN
				SET @indexTmp = CHARINDEX('CREATE VIEW ',@definition,1)
				SET @definition = SUBSTRING(@definition, 1, @indexTmp-1) + 'Alter' + SUBSTRING(@definition, @indexTmp+6, (LEN(@definition)-(@indexTmp+6))+1)
				--print RIGHT(@definition,10)
				--print @definition
				--select @definition
				EXEC (@definition)
			END

			IF(@objtype IN ('FN', 'IF', 'TF'))
			BEGIN
				SET @indexTmp = CHARINDEX('CREATE FUNCTION ',@definition,1)
				SET @definition = SUBSTRING(@definition, 1, @indexTmp-1) + 'Alter' + SUBSTRING(@definition, @indexTmp+6, (LEN(@definition)-(@indexTmp+6))+1)
				--print RIGHT(@definition,10)
				--print @definition
				--select @definition
				EXEC (@definition)
			END

			print ' >> Settata compatibilià minima a SQL20' + @CompatibilityVersion + ' - ' + @objname

			FETCH NEXT FROM db_cursor INTO @objname, @objtype, @definition
		END 

		CLOSE db_cursor  
		DEALLOCATE db_cursor 
	END
END

GO

