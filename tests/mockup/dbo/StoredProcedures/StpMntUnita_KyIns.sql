-- ==========================================================================================
-- Entity Name: StpMntUnita_KyIns  
-- Author:      Dav 
-- Create date: 21/03/2018 16:55:38 
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- dav 10.05.18 Aggiunta IdUnitaImpianto
-- vale 16.05.18 aggiunto fornitore
-- lisa 210629 Aggiunto IdCespite
-- sim 210706 Aggiunto IdCliPrj, aggiunto IdFornitore nei valori dell'insert
-- dav 210827 Gestione Attività da TipoUnita
-- sim 210924 Aggiunto Qta per comando
-- sim 211027 Aggiunto inserimento documenti attivita
-- dav 211127 Se DataAttivita Null inserisce NULL
-- sim 211129 Aggiunto IdCliDest
-- sim 220701 Corretto inserimento attività con origine
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntUnita_KyIns](
	@IdUnita int OUTPUT,
	@Qta int,
	@IdCliente int,
	@DataValutazione date,
	@StatoUnita varchar(1),
	@IdCdlUnita nvarchar(20),
	@CodUnita nvarchar(20),
	@IdUnitaTipo nvarchar(20),
	@Descrizione nvarchar(MAX),
	@Modello nvarchar(200),
	@Costruttore nvarchar(200),
	@Matricola nvarchar(20),
	@Targa nvarchar(20),
	@Anno int,
	@DataImmatricolazione date,
	@LayoutSito varbinary,
	@Immagine varbinary,
	@CncControllo nvarchar(50),
	@Posizione nvarchar(50),
	@DataDismissione date,
	@FlgEnrgElettrica bit,
	@FlgEnrgPneumatica bit,
	@FlgEnrgTermica bit,
	@FlgEnrgTOleodinamica bit,
	@DatiElettrci nvarchar(50),
	@DatiPneumatici nvarchar(50),
	@DatiTermici nvarchar(50),
	@DatiOleodinamici nvarchar(50),
	@FlgDocUsoManutenzione bit,
	@FlgDocDichiarazioneCe bit,
	@FlgDocTarghettaCE bit,
	@FlgDocPrescrizioni bit,
	@NoteUnita nvarchar(MAX),
	@DataRevamping date,
	@UnitMDim nvarchar(20),
	@DimAltezza real,
	@DimLunghezza real,
	@DimLarghezza real,
	@DimSpessore real,
	@UnitMPeso nvarchar(20),
	@DimPeso real,
	@FlgDocAnalisiAllV bit,
	@FlgDocAttestazioneConf bit,
	@EmissioniGas nvarchar(MAX),
	@EmissioniElettromagnetiche nvarchar(MAX),
	@CodFnzComplessita nvarchar(5),
	@IdUnitaImpianto int,
	@IdFornitore int,
	@IdCespite nvarchar(20),
	@IdCliPrj nvarchar(20),
	@IdCliDest int,
	@SysUserCreate nvarchar(256),
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

	SET @Msg = 'Inserimento'
	SET @MsgObj = 'MntUnita'

	Declare @PrInfo nvarchar(300)

	declare @rowcount int = 0
	--Set @PrInfo  = (SELECT IdUnita  FROM TbMntUnita WHERE (IdUnita = @IdUnita))
	--Set @PrInfo  = 'Riga ' + isnull(@PrInfo ,'--')
	--Set @PrInfo  = 'Doc ' + @IdUnita

	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato, 999) = 0
		BEGIN
			SET @Msg1 = 'Confermi l''inserimento ?'
			EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'QST', @SysUserCreate,
			        @KYStato, @KYRes, '', '(1):Ok;0:Cancel', @KYMsg out
			SET @KYStato = 1
			RETURN
		END


	/****************************************************************
	* Stato 1 - risposta affermativa
	****************************************************************/
	IF @KYStato IS NULL OR (@KYStato = 1 and @KYRes = 1)
		BEGIN
			BEGIN TRY
				SET @FlgEnrgElettrica = ISNULL(@FlgEnrgElettrica, 0)
				SET @FlgEnrgPneumatica = ISNULL(@FlgEnrgPneumatica, 0)
				SET @FlgEnrgTermica = ISNULL(@FlgEnrgTermica, 0)
				SET @FlgEnrgTOleodinamica = ISNULL(@FlgEnrgTOleodinamica, 0)
				SET @FlgDocAnalisiAllV = ISNULL(@FlgDocAnalisiAllV, 0)
				SET @FlgDocAttestazioneConf = ISNULL(@FlgDocAttestazioneConf, 0)
				SET @FlgDocDichiarazioneCe = ISNULL(@FlgDocDichiarazioneCe, 0)
				SET @FlgDocPrescrizioni = ISNULL(@FlgDocPrescrizioni, 0)
				SET @FlgDocTarghettaCE = ISNULL(@FlgDocTarghettaCE, 0)
				SET @FlgDocUsoManutenzione = ISNULL(@FlgDocUsoManutenzione, 0)

				SET @Qta = ISNULL(@Qta, 1)
				DECLARE @Index INT = 0
				BEGIN TRANSACTION
					WHILE @Index < @Qta
						BEGIN
							Insert Into TbMntUnita
							([IdCliente], [DataValutazione], [StatoUnita], [IdCdlUnita], [CodUnita], [IdUnitaTipo],
							 [Descrizione], [Modello], [Costruttore], [Matricola], [Targa], [Anno],
							 [DataImmatricolazione], [LayoutSito], [Immagine], [CncControllo], [Posizione],
							 [DataDismissione], [FlgEnrgElettrica], [FlgEnrgPneumatica], [FlgEnrgTermica],
							 [FlgEnrgTOleodinamica], [DatiElettrci], [DatiPneumatici], [DatiTermici],
							 [DatiOleodinamici], [FlgDocUsoManutenzione], [FlgDocDichiarazioneCe], [FlgDocTarghettaCE],
							 [FlgDocPrescrizioni], [NoteUnita], [DataRevamping], [UnitMDim], [DimAltezza],
							 [DimLunghezza], [DimLarghezza], [DimSpessore], [UnitMPeso], [DimPeso], [FlgDocAnalisiAllV],
							 [FlgDocAttestazioneConf], [EmissioniGas], [EmissioniElettromagnetiche],
							 [CodFnzComplessita], [SysUserCreate], [SysDateCreate], [IdUnitaImpianto], [IdCespite],
							 [IdCliPrj], [IdFornitore], [IdCliDest])
							Values (@IdCliente, @DataValutazione, @StatoUnita, @IdCdlUnita, @CodUnita, @IdUnitaTipo,
							        @Descrizione, @Modello, @Costruttore, @Matricola, @Targa, @Anno,
							        @DataImmatricolazione, @LayoutSito, @Immagine, @CncControllo, @Posizione,
							        @DataDismissione, @FlgEnrgElettrica, @FlgEnrgPneumatica, @FlgEnrgTermica,
							        @FlgEnrgTOleodinamica, @DatiElettrci, @DatiPneumatici, @DatiTermici,
							        @DatiOleodinamici, @FlgDocUsoManutenzione, @FlgDocDichiarazioneCe,
							        @FlgDocTarghettaCE, @FlgDocPrescrizioni, @NoteUnita, @DataRevamping, @UnitMDim,
							        @DimAltezza, @DimLunghezza, @DimLarghezza, @DimSpessore, @UnitMPeso, @DimPeso,
							        @FlgDocAnalisiAllV, @FlgDocAttestazioneConf, @EmissioniGas,
							        @EmissioniElettromagnetiche, @CodFnzComplessita, @SysUserCreate, Getdate(),
							        @IdUnitaImpianto, @IdCespite, @IdCliPrj, @IdFornitore, @IdCliDest)

							Select @IdUnita = SCOPE_IDENTITY()

							-- Inserisce DPI

							INSERT INTO TbMntUnitaDpi
								(IdDpi, IdUnita)
							SELECT IdDpi, @IdUnita AS IdUnita
							FROM
								TbMntAnagDpi
							WHERE (Disabilita = 0)

							-- Inserisce attività template

                            DECLARE @TempAttIns TABLE 
                            (
                                IdAttivitaIns INT
                            )

							INSERT INTO TbAttivita
							(IdAttivitaPadre, DataAttivita, IdAttivitaTipo, DescAttivita, NoteAttivita, NoteInterne,
							 IdUtenteDest, IdUtente, DataProssima, DataAcquisita, DataFineRichiesta, FlgAperta, CodFnz,
							 DataAttivita1, CodFnzLuogo, DataFineAttivita, NoteEsito, CodFnzPriorita, SysDateCreate,
							 SysUserCreate, DescAttivita1, IdAnag, TipoAnag, Lvl, Ordinamento, DescDoc, CodFnzStato,
							 IdAttivitaMaster, CodFnzStatoDoc, IdContatto, FlgCalendario, Periodicita, CodFnzPeriodica,
							 DurataPrevista, DurataComunicata, CmpOpz01, CmpOpz02, CmpOpz03, CodFnzStatoInt, NFase,
							 GgWarnings, GgAlert, FlgAccettato, FlgTemplate, IdFornitore, Ambito, NoteExt, TipoDoc,
							 IdDoc, IdAttivitaOrigine)
                            OUTPUT inserted.IdAttivita INTO @TempAttIns(IdAttivitaIns)
							SELECT
								NULL,
								case when TbAttivita_1.DataAttivita is null then null else getdate() end as DataAttivita,
								IdAttivitaTipo, DescAttivita, NoteAttivita,
								NoteInterne, IdUtenteDest, IdUtente, NULL as DataProssima, NULL as DataAcquisita,
								NULL as DataFineRichiesta, 1 AS FlgAperta, CodFnz, NULL as DataAttivita1, CodFnzLuogo,
								NULL as DataFineAttivita, NoteEsito, CodFnzPriorita, GETDATE() AS SysDateCreate,
								@SysUserCreate AS SysUserCreate, DescAttivita1, @IdCliente as IdAnag, 'C' as TipoAnag,
								Lvl, Ordinamento, DescDoc, CodFnzStato, NULL, CodFnzStatoDoc, IdContatto,
								FlgCalendario, Periodicita, CodFnzPeriodica, DurataPrevista, DurataComunicata, CmpOpz01,
								CmpOpz02, CmpOpz03, CodFnzStatoInt, NFase, GgWarnings, GgAlert, FlgAccettato,
								FlgTemplate, IdFornitore, Ambito, NoteExt, 'TbMntUnita' AS TipoDoc, @IdUnita AS IdDoc,
                                IdAttivita
							FROM
								TbAttivita AS TbAttivita_1
							WHERE (IdDoc = @IdUnitaTipo)
							  AND (TipoDoc = N'TbMntAnagUnitaTipo')

							set @rowcount = @@ROWCOUNT

                            -- Ripristino il master (se stessa)
                            UPDATE TbAttivita
                            SET IdAttivitaMaster = IdAttivita
                            WHERE IdAttivita IN (SELECT IdAttivitaIns FROM @TempAttIns)

							-- Inserisce documenti legati alle attività

							INSERT INTO TbDocumenti
							(TipoDoc, IdDoc, Descrizione, ExtDoc, Documento, PathDoc, CodFnzTipo, FlgForInvio,
							 FlgOdlInvio, SysDateCreate, SysUserCreate, FlgProd, CodFnzStato, IdAttivita, DimDoc,
							 ColDoc, IdAnag, TipoAnag, Note, DataDoc, DataArchivio, Descrizione1, IdDocMaster,
							 FlgCliInvio, IdDocCategoria, FlgSegnaposto)
							SELECT
								TbDocumenti.TipoDoc, TbAttivita.IdAttivita, TbDocumenti.Descrizione,
								TbDocumenti.ExtDoc, TbDocumenti.Documento, TbDocumenti.PathDoc,
								TbDocumenti.CodFnzTipo, TbDocumenti.FlgForInvio, TbDocumenti.FlgOdlInvio,
								getdate() AS SysDateCreate, @SysUserCreate AS SysUserCreate, TbDocumenti.FlgProd,
								TbDocumenti.CodFnzStato, TbAttivita.IdAttivita, TbDocumenti.DimDoc,
								TbDocumenti.ColDoc, @IdCliente AS IdAnag, 'C' AS TipoAnag, TbDocumenti.Note,
								TbDocumenti.DataDoc, TbDocumenti.DataArchivio, TbDocumenti.Descrizione1,
								TbDocumenti.IdDocumento AS IdDocMaster, TbDocumenti.FlgCliInvio,
								TbDocumenti.IdDocCategoria, TbDocumenti.FlgSegnaposto
							FROM
								dbo.TbAttivita      AS TbAttivita
									INNER JOIN
									dbo.TbAttivita  AS PdrAttivita
										ON PdrAttivita.IdAttivita = TbAttivita.IdAttivitaOrigine
									INNER JOIN
									dbo.TbDocumenti AS TbDocumenti
										ON PdrAttivita.IdAttivita = TbDocumenti.IdDoc and
										   TbDocumenti.TipoDoc = 'TbAttivita'
							WHERE (TbAttivita.TipoDoc = 'TbMntUnita')
							  AND (TbAttivita.IdDoc = CONVERT(NVARCHAR(20), @IdUnita))

							IF @rowcount <> 0
								BEGIN
									EXECUTE StpUteMsg_Ins N'Inserimento Attività derivate dal Tipo Unità', N'Unità',
									        @IdUnita, 'INF', @SysUserCreate
								END

							SET @Index = @Index + 1
						END

					/****************************************************************
					* Uscita
					****************************************************************/

					SET @Msg1 = 'Operazione completata'
					EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'INF', @SysUserCreate,
					        @KYStato, @KYRes, '', NULL, @KYMsg out

					SET @KYStato = -2
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				-- Execute error retrieval routine.
				rollback transaction
				Declare @MsgExt as nvarchar(max)
				SET @MsgExt = CONCAT(ERROR_MESSAGE(), ERROR_LINE())
				SET @Msg1 = 'Errore Stp'

				EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserCreate,
				        @KYStato, @KYRes, @MsgExt, null, @KYMsg out
				SET @KYStato = -4
			END CATCH

			RETURN
		END

	/****************************************************************
	* Stato 1 - risposta negativa
	****************************************************************/
	IF ISNULL(@KYStato, 999) = 1 and @KYRes = 0
		BEGIN

			/****************************************************************
			* Uscita
			****************************************************************/

			SET @Msg1 = 'Operazione annullata'
			EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'WRN', @SysUserCreate,
			        @KYStato, @KYRes, '', null, @KYMsg out
			SET @KYStato = -4
			RETURN
		END

End

GO

