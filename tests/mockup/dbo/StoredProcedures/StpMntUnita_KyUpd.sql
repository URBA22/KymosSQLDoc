-- ==========================================================================================
-- Entity Name: StpMntUnita_KyUpd  
-- Author:      Dav  
-- Create date: 21/03/2018 16:55:39  
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- dav 10.05.18 Aggiunta IdUnitaImpianto
-- vale 16.05.18 aggiunto fornitore unità
-- vale 18.05.18 aggiunto anche aggiornamento del campo 
-- lisa 210629 Aggiunto IdCespite
-- sim 210706 Aggiunto IdCliPrj
-- dav 210827 Gestione Attività da TipoUnita
-- dav 211118 Se DataAttivita Null inserisce NULL
-- sim 211129 Aggiunto IdCliDest
-- dav 211219 Gestione IdAttivitaOrigine
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntUnita_KyUpd](
	@IdUnita int,
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
	@SysRowVersion timestamp,
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

	SET @Msg = 'Aggiornamento'
	SET @MsgObj = 'StpMntUnita_KyUpd'

	Declare @PrInfo nvarchar(300)
	--Set @PrInfo  = (SELECT IdUnita  FROM TbMntUnita WHERE (IdUnita = @IdUnita))
	--Set @PrInfo  = 'Riga ' + isnull(@PrInfo ,'--')
	--Set @PrInfo  = 'Doc ' + @IdUnita

	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato, 999) = 0
		BEGIN
			SET @Msg1 = 'Confermi l''aggiornamento ?'
			EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'QST', @SysUserUpdate,
			        @KYStato, @KYRes, '', '(1):Ok;0:Cancel', @KYMsg out
			SET @KYStato = 1
			RETURN
		END


	/****************************************************************
	* Stato 1 - risposta affermativa
	****************************************************************/
	IF @KYStato IS NULL OR (@KYStato = 1 and @KYRes = 1)
		BEGIN

			Declare @IdUnitaTipoPrec nvarchar(20)
			Declare @IdClientePrec as int

			Select @IdUnitaTipoPrec = IdUnitaTipo, @IdClientePrec = IdCliente FROM TbMntUnita WHERE IdUnita = @IdUnita

			-- Proogetto a NULL se cliente non c'è o se è diveerso da quello del progetto
			IF (ISNULL(@IdCliente, '') = '') OR
			   (SELECT IdCliente FROM TbCliPrj WHERE IdCliPrj = @IdCliPrj) <> @IdCliente
				BEGIN
					SET @IdCliPrj = NULL
				END

			BEGIN TRY
				BEGIN TRANSACTION
					Update TbMntUnita
					Set [IdCliente]                  = @IdCliente,
					    [DataValutazione]            = @DataValutazione,
					    [StatoUnita]                 = @StatoUnita,
					    [IdCdlUnita]                 = @IdCdlUnita,
					    [CodUnita]                   = @CodUnita,
					    [IdUnitaTipo]                = @IdUnitaTipo,
					    [Descrizione]                = @Descrizione,
					    [Modello]                    = @Modello,
					    [Costruttore]                = @Costruttore,
					    [Matricola]                  = @Matricola,
					    [Targa]                      = @Targa,
					    [Anno]                       = @Anno,
					    [DataImmatricolazione]       = @DataImmatricolazione,
					    [LayoutSito]                 = @LayoutSito,
					    [Immagine]                   = @Immagine,
					    [CncControllo]               = @CncControllo,
					    [Posizione]                  = @Posizione,
					    [DataDismissione]            = @DataDismissione,
					    [FlgEnrgElettrica]           = @FlgEnrgElettrica,
					    [FlgEnrgPneumatica]          = @FlgEnrgPneumatica,
					    [FlgEnrgTermica]             = @FlgEnrgTermica,
					    [FlgEnrgTOleodinamica]       = @FlgEnrgTOleodinamica,
					    [DatiElettrci]               = @DatiElettrci,
					    [DatiPneumatici]             = @DatiPneumatici,
					    [DatiTermici]                = @DatiTermici,
					    [DatiOleodinamici]           = @DatiOleodinamici,
					    [FlgDocUsoManutenzione]      = @FlgDocUsoManutenzione,
					    [FlgDocDichiarazioneCe]      = @FlgDocDichiarazioneCe,
					    [FlgDocTarghettaCE]          = @FlgDocTarghettaCE,
					    [FlgDocPrescrizioni]         = @FlgDocPrescrizioni,
					    [NoteUnita]                  = @NoteUnita,
					    [DataRevamping]              = @DataRevamping,
					    [UnitMDim]                   = @UnitMDim,
					    [DimAltezza]                 = @DimAltezza,
					    [DimLunghezza]               = @DimLunghezza,
					    [DimLarghezza]               = @DimLarghezza,
					    [DimSpessore]                = @DimSpessore,
					    [UnitMPeso]                  = @UnitMPeso,
					    [DimPeso]                    = @DimPeso,
					    [FlgDocAnalisiAllV]          = @FlgDocAnalisiAllV,
					    [FlgDocAttestazioneConf]     = @FlgDocAttestazioneConf,
					    [EmissioniGas]               = @EmissioniGas,
					    [EmissioniElettromagnetiche] = @EmissioniElettromagnetiche,
					    [CodFnzComplessita]          = @CodFnzComplessita,
					    [IdUnitaImpianto]            = @IdUnitaImpianto,
					    [IdFornitore]                = @IdFornitore,
					    [IdCespite]                  = @IdCespite,
					    [IdCliPrj]                   = @IdCliPrj,
					    [IdCliDest]                  = @IdCliDest,
					    [SysUserUpdate]              = @SysUserUpdate,
					    [SysDateUpdate]              = Getdate()
					Where [IdUnita] = @IdUnita
					  and [SysRowVersion] = @SysRowVersion


					IF @@ROWCOUNT = 0
						BEGIN
							SET @Msg1 = 'Operazione annullata, record modificato'
							EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserUpdate,
							        @KYStato, @KYRes, '', NULL, @KYMsg out
							SET @KYStato = -1
						END
					ELSE
						BEGIN
							/****************************************************************
							* Uscita
							****************************************************************/

							IF ISNULL(@IdUnitaTipoPrec, '') <> ISNULL(@IdUnitaTipo, '') OR
							   ISNULL(@IdClientePrec, -1) <> ISNULL(@IdCliente, -1)
								BEGIN
									DELETE
									FROM
										TbAttivita
									FROM
										TbAttivita
									WHERE (TbAttivita.TipoDoc = N'TbMntUnita')
									  AND (TbAttivita.IdDoc = @IdUnita)
									  AND (TbAttivita.IdAttivitaOrigine IS NOT NULL)
									  AND (TbAttivita.DataFineRichiesta IS NULL)

									IF @@ROWCOUNT <> 0
										BEGIN
											EXECUTE StpUteMsg_Ins 'Eliminazione Attività derivate dal Tipo Unità',
											        'Unità', @IdUnita, 'WRN', @SysUserUpdate
										END


									INSERT INTO TbAttivita
										(IdAttivitaOrigine, DataAttivita, IdAttivitaTipo, DescAttivita, NoteAttivita,
										 NoteInterne, IdUtenteDest, IdUtente, DataProssima, DataAcquisita,
										 DataFineRichiesta, FlgAperta, CodFnz, DataAttivita1, CodFnzLuogo, DataFineAttivita,
										 NoteEsito, CodFnzPriorita, SysDateCreate, SysUserCreate, DescAttivita1, IdAnag,
										 TipoAnag, Lvl, Ordinamento, DescDoc, CodFnzStato, IdAttivitaMaster,
										 CodFnzStatoDoc, IdContatto, FlgCalendario, Periodicita, CodFnzPeriodica,
										 DurataPrevista, DurataComunicata, CmpOpz01, CmpOpz02, CmpOpz03, CodFnzStatoInt,
										 NFase, GgWarnings, GgAlert, FlgAccettato, FlgTemplate, IdFornitore, Ambito,
										 NoteExt, TipoDoc, IdDoc)
									
									SELECT
										IdAttivita,
										case when TbAttivita_1.DataAttivita is null then null else getdate() end as DataAttivita,
										IdAttivitaTipo, DescAttivita, NoteAttivita, NoteInterne, IdUtenteDest, IdUtente,
										NULL as DataProssima, NULL as DataAcquisita, NULL as DataFineRichiesta,
										1 AS FlgAperta, CodFnz, NULL as DataAttivita1, CodFnzLuogo,
										NULL as DataFineAttivita, NoteEsito, CodFnzPriorita, GETDATE() AS SysDateCreate,
										@SysUserUpdate AS SysUserCreate, DescAttivita1, @IdCliente as IdAnag,
										'C' as TipoAnag, Lvl, Ordinamento, DescDoc,
										CodFnzStato, IdAttivitaMaster, CodFnzStatoDoc, IdContatto, FlgCalendario,
										Periodicita, CodFnzPeriodica, DurataPrevista, DurataComunicata, CmpOpz01,
										CmpOpz02, CmpOpz03, CodFnzStatoInt, NFase, GgWarnings, GgAlert, FlgAccettato,
										FlgTemplate, IdFornitore, Ambito, NoteExt, 'TbMntUnita' AS TipoDoc,
										@IdUnita AS IdDoc
									FROM
										TbAttivita AS TbAttivita_1
									WHERE (IdDoc = @IdUnitaTipo)
									  AND (TipoDoc = N'TbMntAnagUnitaTipo')

									IF @@ROWCOUNT <> 0
										BEGIN
											EXECUTE StpUteMsg_Ins N'Inserimento Attività derivate dal Tipo Unità',
											        N'Unità', @IdUnita, 'INF', @SysUserUpdate
										END

								END


							SET @Msg1 = 'Operazione completata'
							EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'INF', @SysUserUpdate,
							        @KYStato, @KYRes, '', NULL, @KYMsg out

							SET @KYStato = -1
						END
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				-- Execute error retrieval routine.
				rollback transaction
				Declare @MsgExt as nvarchar(max)
				SET @MsgExt = ERROR_MESSAGE()
				SET @Msg1 = 'Errore Stp'

				EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserUpdate,
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
			EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'WRN', @SysUserUpdate,
			        @KYStato, @KYRes, '', null, @KYMsg out
			SET @KYStato = -4
			RETURN
		END

End

GO

