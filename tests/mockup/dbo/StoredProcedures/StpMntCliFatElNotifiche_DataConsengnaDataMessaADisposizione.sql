

-- ==========================================================================================
-- Entity Name:   StpMntCliFatElNotifiche_DataConsengnaDataMessaADisposizione
-- Author:        mik
-- Create date:   14/07/2021
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:  Write custom note here
-- Description:	This stored procedure is intended for control a specific row from TbCliFat table
-- History
-- mik 210714 Creazione
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntCliFatElNotifiche_DataConsengnaDataMessaADisposizione]
(
	@SysUserUpdate nvarchar(256),
	@KYStato int = NULL output,
	@KYMsg nvarchar(max) = NULL output,
	@KYRes int = NULL
)
As
Begin
	/*
	return -1: Normal; return -2: Refresh data; return -3: Chiude la maschera; -4: Non fa nulla	
	Tipo Messaggio: INF Informativo, ALR Allert, WRN Warning, QST Question	
	*/
	Declare @Msg nvarchar(300)
	Declare @Msg1 nvarchar(300)
	Declare @MsgObj nvarchar(300)

	DECLARE @IdCliFat AS NVARCHAR(20)
	DECLARE @NotificaTesto AS VARCHAR(MAX)
	DECLARE @StatoTesto AS NVARCHAR(5)
	DECLARE @TipoFattura as nvarchar(10)
	DECLARE @MessageId AS bigint
	DECLARE @Descrizione as Nvarchar(300)
	DECLARE @DataRicezione as datetime
	DECLARE @Cmd as nvarchar(20)
	Declare @xmlDocument as xml
							

	--MIK210713
	DECLARE @DataOraConsegna as datetime = NULL
	DECLARE @DataMessaADisposizione as datetime = NULL

	DECLARE @FatelNotificheCursor as CURSOR

	SET @Msg= 'Manutenzione'
	SET @MsgObj='MntCliFatElNotifiche'

	Declare @PrInfo  nvarchar(300)
	--Set @PrInfo  = (SELECT IdManutentore  FROM TbMntManutentori WHERE (IdManutentore = @IdManutentore))
	--Set @PrInfo  = 'Riga ' + isnull(@PrInfo ,'--')
	--Set @PrInfo  = 'Doc ' + @IdManutentore

	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0
	BEGIN
		SET @Msg1= 'Confermi la manutenzone delle notifiche delle fatture elettroniche ?'
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'QST',@SysUserUpdate,
				@KYStato,@KYRes,'', '(1):Ok;0:Cancel',@KYMsg out
		SET @KYStato = 1
		RETURN
	END


	/****************************************************************
	* Stato 1 - risposta affermativa
	****************************************************************/
	IF @KYStato IS NULL OR (@KYStato = 1 and @KYRes = 1)
	BEGIN
		/****************************************************************
		* Controlla se esistono righe collegate nele tabelle dipendenti
		****************************************************************/
		/*
		If Exists(SELECT IdManutentore  FROM TbMntManutentori WHERE (IdManutentore = @IdManutentore))
		BEGIN
			SET @Msg1= 'Operazione annullata, ci sono record correlati'
				EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'ALR',@SysUserUpdate,
					@KYStato,@KYRes,'Righe Documento', Null,@KYMsg out
				SET @KYStato = -2
		RETURN
		END
		*/

		-- Elimina

		BEGIN TRY
			BEGIN TRANSACTION

			SET @FatelNotificheCursor = CURSOR FAST_FORWARD FOR
			SELECT IdCliFat, NotificaTesto,StatoNotifica
			FROM 
			(
			SELECT row_number() over (partition by TbCliFatElNotifiche.IdCliFat order by TbCliFatElNotifiche.DataNotifica desc) as rownumber,
			TbCliFatElNotifiche.IdCliFat,
			CAST(TbCliFatElNotifiche.XMLNotifica AS VARCHAR(MAX)) AS NotificaTesto,
			TbCliFatElNotifiche.StatoNotifica
			FROM TbCliFatElNotifiche
			INNER JOIN TbCliFatElInvio
			ON TbCliFatElNotifiche.IdCliFat = TbCliFatElInvio.IdCliFat
			WHERE TbCliFatElInvio.DataInvio >= CAST('210101' AS DATE)
			--GROUP BY TbCliFatElNotifiche.IdCliFat
			) as Drv
			where Drv.RowNumber = 1
			ORDER BY IdCliFat
 
			OPEN @FatelNotificheCursor
			FETCH NEXT FROM @FatelNotificheCursor INTO @IdCliFat, @NotificaTesto, @StatoTesto
			 WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @DataOraConsegna = NULL
				SET @DataMessaADisposizione = NULL
		
				SET @TipoFattura = 'FPR12'
				
				 IF(ISNULL(@NotificaTesto,'')<>'')
				 BEGIN
					IF OBJECT_ID(N'tempdb..#drvNotificaFPR') IS NOT NULL
					BEGIN
						DROP TABLE #drvNotificaFPR
					END

					IF OBJECT_ID(N'tempdb..#drvNotificaFPA') IS NOT NULL
					BEGIN
						DROP TABLE #drvNotificaFPA
					END

					IF OBJECT_ID(N'tempdb..#drvNotifica1FPR') IS NOT NULL
					BEGIN
						DROP TABLE #drvNotifica1FPR
					END

					IF OBJECT_ID(N'tempdb..#drvNotifica1FPA') IS NOT NULL
					BEGIN
						DROP TABLE #drvNotifica1FPA
					END

					IF OBJECT_ID(N'tempdb..#drvNotificaNSFPR') IS NOT NULL
					BEGIN
						DROP TABLE #drvNotificaNSFPR
					END

					IF OBJECT_ID(N'tempdb..#drvNotificaNSFPA') IS NOT NULL
					BEGIN
						DROP TABLE #drvNotificaNSFPA
					END

					SET @Cmd = @StatoTesto
					IF(CHARINDEX('http://www.fatturapa.gov.it/sdi/messaggi/v1.0',@NotificaTesto)>0)
					BEGIN
						SET @TipoFattura = 'FPA12'
					END
					Set @xmlDocument = @NotificaTesto

					If @Cmd = 'RC'
					BEGIN
						--MIK210407
						--gestione delle notifiche per tipo fattura (le notifiche sono infatti diverse se riferite a fatture aprivati o PA)
						IF(@TipoFattura = 'FPR12')
						BEGIN
							--Privati
							;WITH XMLNAMESPACES('http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fattura/messaggi/v1.0' AS ns3)
							SELECT
							
							Col.value('(/ns3:RicevutaConsegna/IdentificativoSdI)[1]', 'nvarchar(300)') AS IdentificativoSdI,
							Col.value('(/ns3:RicevutaConsegna/NomeFile)[1]', 'nvarchar(300)') AS NomeFile,
							Col.value('(/ns3:RicevutaConsegna/Hash)[1]', 'nvarchar(300)') AS Hash,
							Col.value('(/ns3:RicevutaConsegna/DataOraRicezione)[1]', 'nvarchar(300)') AS DataOraRicezione,
							Col.value('(/ns3:RicevutaConsegna/DataOraConsegna)[1]', 'nvarchar(300)') AS DataOraConsegna,
							Col.value('(/ns3:RicevutaConsegna/DataMessaADisposizione)[1]', 'nvarchar(300)') AS DataMessaADisposizione,
							Col.value('(/ns3:RicevutaConsegna/Destinatario/Codice)[1]', 'nvarchar(300)') AS Codice,
							Col.value('(/ns3:RicevutaConsegna/Descrizione)[1]', 'nvarchar(300)') AS Descrizione,
							Col.value('(/ns3:RicevutaConsegna/MessageId)[1]', 'nvarchar(300)') AS MessageId

							INTO #drvNotificaFPR
									
							FROM
							@xmlDocument.nodes('.') AS Tab(Col)

							Select 
							@MessageId = MessageId, 
							@Descrizione = left(@Descrizione,300),
							--@DataRicezione = convert (datetimeoffset, DataOraRicezione, 127),
							@DataRicezione = convert (datetime2, DataOraRicezione, 127),
							@DataOraConsegna = convert (datetime2, DataOraConsegna, 127),
							@DataMessaADisposizione = convert (datetime2, DataMessaADisposizione, 127)
							from #drvNotificaFPR
						END
						ELSE IF (@TipoFattura = 'FPA12')
						BEGIN
							--Pubblica Amministrazione
							;WITH XMLNAMESPACES('http://www.fatturapa.gov.it/sdi/messaggi/v1.0' AS ns3)
							SELECT
							
							Col.value('(/ns3:RicevutaConsegna/IdentificativoSdI)[1]', 'nvarchar(300)') AS IdentificativoSdI,
							Col.value('(/ns3:RicevutaConsegna/NomeFile)[1]', 'nvarchar(300)') AS NomeFile,
							Col.value('(/ns3:RicevutaConsegna/Hash)[1]', 'nvarchar(300)') AS Hash,
							Col.value('(/ns3:RicevutaConsegna/DataOraRicezione)[1]', 'nvarchar(300)') AS DataOraRicezione,
							Col.value('(/ns3:RicevutaConsegna/DataOraConsegna)[1]', 'nvarchar(300)') AS DataOraConsegna,
							Col.value('(/ns3:RicevutaConsegna/DataMessaADisposizione)[1]', 'nvarchar(300)') AS DataMessaADisposizione,
							Col.value('(/ns3:RicevutaConsegna/Destinatario/Codice)[1]', 'nvarchar(300)') AS Codice,
							Col.value('(/ns3:RicevutaConsegna/Descrizione)[1]', 'nvarchar(300)') AS Descrizione,
							Col.value('(/ns3:RicevutaConsegna/MessageId)[1]', 'nvarchar(300)') AS MessageId

							INTO #drvNotificaFPA
									
							FROM
							@xmlDocument.nodes('.') AS Tab(Col)

							Select 
							@MessageId = MessageId, 
							@Descrizione = left(@Descrizione,300),
							--@DataRicezione = convert (datetimeoffset, DataOraRicezione, 127),
							@DataRicezione = convert (datetime2, DataOraRicezione, 127),
							@DataOraConsegna = convert (datetime2, DataOraConsegna, 127),
							@DataMessaADisposizione = convert (datetime2, DataMessaADisposizione, 127)
							from #drvNotificaFPA
						END

					END
				Else If @Cmd = 'MC'
					BEGIN
								
						--MIK210407
						--gestione delle notifiche per tipo fattura (le notifiche sono infatti diverse se riferite a fatture aprivati o PA)
						IF(@TipoFattura = 'FPR12')
						BEGIN
							--Privati
							;WITH XMLNAMESPACES('http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fattura/messaggi/v1.0' AS ns3)
							SELECT
							
							Col.value('(/ns3:RicevutaImpossibilitaRecapito/IdentificativoSdI)[1]', 'nvarchar(300)') AS IdentificativoSdI,
							Col.value('(/ns3:RicevutaImpossibilitaRecapito/NomeFile)[1]', 'nvarchar(300)') AS NomeFile,
							Col.value('(/ns3:RicevutaImpossibilitaRecapito/Hash)[1]', 'nvarchar(300)') AS Hash,
							Col.value('(/ns3:RicevutaImpossibilitaRecapito/DataOraRicezione)[1]', 'nvarchar(300)') AS DataOraRicezione,
							Col.value('(/ns3:RicevutaImpossibilitaRecapito/DataOraConsegna)[1]', 'nvarchar(300)') AS DataOraConsegna,
							Col.value('(/ns3:RicevutaImpossibilitaRecapito/DataMessaADisposizione)[1]', 'nvarchar(300)') AS DataMessaADisposizione,
							Col.value('(/ns3:RicevutaImpossibilitaRecapito/Destinatario/Codice)[1]', 'nvarchar(300)') AS Codice,
							Col.value('(/ns3:RicevutaImpossibilitaRecapito/Descrizione)[1]', 'nvarchar(300)') AS Descrizione,
							Col.value('(/ns3:RicevutaImpossibilitaRecapito/MessageId)[1]', 'nvarchar(300)') AS MessageId

							INTO #drvNotifica1FPR

							FROM
							@xmlDocument.nodes('.') AS Tab(Col)

							Select 
							@MessageId = MessageId, 
							@Descrizione = left(@Descrizione,300),
							--@DataRicezione = convert (datetimeoffset, DataOraRicezione, 127),
							@DataRicezione = convert (datetime2, DataOraRicezione, 127),
							@DataOraConsegna = convert (datetime2, DataOraConsegna, 127),
							@DataMessaADisposizione = convert (datetime2, DataMessaADisposizione, 127)
							from #drvNotifica1FPR

						END
						ELSE IF (@TipoFattura = 'FPA12')
						BEGIN
							--Pubblica Amministrazione
							;WITH XMLNAMESPACES('http://www.fatturapa.gov.it/sdi/messaggi/v1.0' AS ns3)
							SELECT
							
							Col.value('(/ns3:RicevutaImpossibilitaRecapito/IdentificativoSdI)[1]', 'nvarchar(300)') AS IdentificativoSdI,
							Col.value('(/ns3:RicevutaImpossibilitaRecapito/NomeFile)[1]', 'nvarchar(300)') AS NomeFile,
							Col.value('(/ns3:RicevutaImpossibilitaRecapito/Hash)[1]', 'nvarchar(300)') AS Hash,
							Col.value('(/ns3:RicevutaImpossibilitaRecapito/DataOraRicezione)[1]', 'nvarchar(300)') AS DataOraRicezione,
							Col.value('(/ns3:RicevutaImpossibilitaRecapito/DataOraConsegna)[1]', 'nvarchar(300)') AS DataOraConsegna,
							Col.value('(/ns3:RicevutaImpossibilitaRecapito/DataMessaADisposizione)[1]', 'nvarchar(300)') AS DataMessaADisposizione,
							Col.value('(/ns3:RicevutaImpossibilitaRecapito/Destinatario/Codice)[1]', 'nvarchar(300)') AS Codice,
							Col.value('(/ns3:RicevutaImpossibilitaRecapito/Descrizione)[1]', 'nvarchar(300)') AS Descrizione,
							Col.value('(/ns3:RicevutaImpossibilitaRecapito/MessageId)[1]', 'nvarchar(300)') AS MessageId

							INTO #drvNotifica1FPA
									
							FROM
							@xmlDocument.nodes('.') AS Tab(Col)

							Select 
							@MessageId = MessageId, 
							@Descrizione = left(@Descrizione,300),
							--@DataRicezione = convert (datetimeoffset, DataOraRicezione, 127),
							@DataRicezione = convert (datetime2, DataOraRicezione, 127),
							@DataOraConsegna = convert (datetime2, DataOraConsegna, 127),
							@DataMessaADisposizione = convert (datetime2, DataMessaADisposizione, 127)
							from #drvNotifica1FPA
						END
					END
				Else If @Cmd = 'NS'
					BEGIN
							
						--MIK210407
						--gestione delle notifiche per tipo fattura (le notifiche sono infatti diverse se riferite a fatture aprivati o PA)
						IF(@TipoFattura = 'FPR12')
						BEGIN
								--Privati

							;WITH XMLNAMESPACES('http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fattura/messaggi/v1.0' AS ns3)
							SELECT
							
							Col.value('(/ns3:RicevutaScarto/IdentificativoSdI)[1]', 'nvarchar(300)') AS IdentificativoSdI,
							Col.value('(/ns3:RicevutaScarto/NomeFile)[1]', 'nvarchar(300)') AS NomeFile,
							Col.value('(/ns3:RicevutaScarto/Hash)[1]', 'nvarchar(300)') AS Hash,
							Col.value('(/ns3:RicevutaScarto/DataOraRicezione)[1]', 'nvarchar(300)') AS DataOraRicezione,
									
							Col.value('(/ns3:RicevutaScarto/ListaErrori/Errore/Codice)[1]', 'nvarchar(300)') AS Codice,
							Col.value('(/ns3:RicevutaScarto/ListaErrori/Errore/Descrizione)[1]', 'nvarchar(300)') AS Descrizione,
							Col.value('(/ns3:RicevutaScarto/ListaErrori/Errore/Suggerimento)[1]', 'nvarchar(300)') AS Suggerimento,
									
							Col.value('(/ns3:RicevutaScarto/MessageId)[1]', 'nvarchar(300)') AS MessageId

							INTO #drvNotificaNSFPR

							FROM
							@xmlDocument.nodes('.') AS Tab(Col)
							--## gestire la lista errori 

							Select 
							@MessageId = MessageId, 
							@Descrizione = left(Codice + char(13) + char(10) + Descrizione + char(13) + char(10) + Suggerimento ,300), 
							--@DataRicezione = convert (datetimeoffset, DataOraRicezione, 127),
							@DataRicezione = convert (datetime2, DataOraRicezione, 127)
							from #drvNotificaNSFPR
						END
						ELSE IF (@TipoFattura = 'FPA12')
						BEGIN
							--Pubblica Amministrazione
							;WITH XMLNAMESPACES('http://www.fatturapa.gov.it/sdi/messaggi/v1.0' AS ns3)
							SELECT
							
							Col.value('(/ns3:RicevutaScarto/IdentificativoSdI)[1]', 'nvarchar(300)') AS IdentificativoSdI,
							Col.value('(/ns3:RicevutaScarto/NomeFile)[1]', 'nvarchar(300)') AS NomeFile,
							Col.value('(/ns3:RicevutaScarto/Hash)[1]', 'nvarchar(300)') AS Hash,
							Col.value('(/ns3:RicevutaScarto/DataOraRicezione)[1]', 'nvarchar(300)') AS DataOraRicezione,
									
							Col.value('(/ns3:RicevutaScarto/ListaErrori/Errore/Codice)[1]', 'nvarchar(300)') AS Codice,
							Col.value('(/ns3:RicevutaScarto/ListaErrori/Errore/Descrizione)[1]', 'nvarchar(300)') AS Descrizione,
							Col.value('(/ns3:RicevutaScarto/ListaErrori/Errore/Suggerimento)[1]', 'nvarchar(300)') AS Suggerimento,
									
							Col.value('(/ns3:RicevutaScarto/MessageId)[1]', 'nvarchar(300)') AS MessageId

							INTO #drvNotificaNSFPA
									
							FROM
							@xmlDocument.nodes('.') AS Tab(Col)

							Select 
							@MessageId = MessageId, 
							@Descrizione = left(@Descrizione,300),
							--@DataRicezione = convert (datetimeoffset, DataOraRicezione, 127),
							@DataRicezione = convert (datetime2, DataOraRicezione, 127)
							from #drvNotificaNSFPA
						END

						--Set @StatoCmd = 'ERR'
								
					END

					IF(@DataOraConsegna IS NOT NULL OR @DataMessaADisposizione IS NOT NULL)
					BEGIN

						Update TbCliFatElab 
						set 
						DataOraConsegna = @DataOraConsegna,
						DataMessaADisposizione = @DataMessaADisposizione
						WHERE IdCliFat = @IdCliFat
		
					END
				 END

				 FETCH NEXT FROM @FatelNotificheCursor INTO @IdCliFat, @NotificaTesto, @StatoTesto
			END
			CLOSE @FatelNotificheCursor
			DEALLOCATE @FatelNotificheCursor

				
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			-- Execute error retrieval routine.
			rollback transaction
			Declare @MsgExt as nvarchar(max)
			SET @MsgExt= ERROR_MESSAGE()
			SET @Msg1= 'Errore Stp'

			EXECUTE StpUteMsg	@Msg, @Msg1,@MsgObj, @PrInfo ,'ALR',@SysUserUpdate,
					@KYStato,@KYRes,@MsgExt,null,@KYMsg out
			SET @KYStato = -4
		END CATCH

		RETURN
	END

	/****************************************************************
	* Stato 1 - risposta negativa
	****************************************************************/
	IF ISNULL(@KYStato,999) = 1 and @KYRes = 0
	BEGIN

		/****************************************************************
		* Uscita
		****************************************************************/

		SET @Msg1= 'Operazione annullata'
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUserUpdate,
				@KYStato,@KYRes,'',null,@KYMsg out
		SET @KYStato = -1
		RETURN
	END

End

GO

