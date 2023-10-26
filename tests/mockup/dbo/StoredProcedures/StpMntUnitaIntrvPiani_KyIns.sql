-- ==========================================================================================
-- Entity Name:	StpMntUnitaIntrvPiani_KyIns
-- Create date:	19/06/2019 16:40:01
-- AutoCreate:	DBML
-- Custom_Dbo:	NO
-- Standard_dbo: YES
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	This stored procedure is intended for inserting values to TbMntUnitaIntrvPiani table
-- History:
-- sim 211018 Uniformato procedura con @KyStato, @KYMsg, @KYRes
-- FRA 221107 Aggiunta gestione FlgDisabilita NULL per DBOH
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntUnitaIntrvPiani_KyIns](
	@IdPiano int OUTPUT,
	@IdUnita int,
	@NRiga int,
	@IdPianoTipo nvarchar(20),
	@Periodicita int,
	@CodFnzTipoPeriodicita nvarchar(5),
	@Descrizione nvarchar(MAX),
	@DPI nvarchar(50),
	@NotePiano nvarchar(MAX),
	@FlgInterna bit,
	@DataDisabilita datetime,
	@IdArticolo nvarchar(50),
	@DurataPrevIntrv int,
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
	SET @MsgObj = 'MntUnitaIntrvPiani'

	Declare @PrInfo nvarchar(300)
	--Set @PrInfo  = (SELECT IdPiano  FROM TbMntUnitaIntrvPiani WHERE (IdPiano = @IdPiano))
	--Set @PrInfo  = 'Riga ' + isnull(@PrInfo ,'--')
	--Set @PrInfo  = 'Doc ' + @IdPiano

	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato, 999) = 0
		BEGIN
			SET @Msg1 = 'Confermi l''inserimento ?'
			EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'QST', @SysUserCreate,
			        @KYStato, @KyRes, '', '(1):Ok;0:Cancel', @KYMsg out
			SET @KYStato = 1
			RETURN
		END


	/****************************************************************
	* Stato 1 - risposta affermativa
	****************************************************************/
	IF @KYStato IS NULL OR (@KYStato = 1 and @KYRes = 1)
		BEGIN
			BEGIN TRY
				
				IF @FlgInterna IS NULL
				BEGIN
					SET @FlgInterna = 0
				END

				BEGIN TRANSACTION
					Insert Into TbMntUnitaIntrvPiani
					([IdUnita], [NRiga], [IdPianoTipo], [Periodicita], [CodFnzTipoPeriodicita], [Descrizione], [DPI],
					 [NotePiano], [FlgInterna], [DataDisabilita], [IdArticolo], [DurataPrevIntrv], [SysUserCreate],
					 [SysDateCreate])
					Values (@IdUnita, @NRiga, @IdPianoTipo, @Periodicita, @CodFnzTipoPeriodicita, @Descrizione, @DPI,
					        @NotePiano, @FlgInterna, @DataDisabilita, @IdArticolo, @DurataPrevIntrv, @SysUserCreate,
					        Getdate())

					Select @IdPiano = SCOPE_IDENTITY()


					/****************************************************************
					* Uscita
					****************************************************************/

					SET @Msg1 = 'Operazione completata'
					EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'INF', @SysUserCreate,
					        @KYStato, @KyRes, '', NULL, @KYMsg out

					SET @KYStato = -2
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				-- Execute error retrieval routine.
				rollback transaction
				Declare @MsgExt as nvarchar(max)
				SET @MsgExt = ERROR_MESSAGE()
				SET @Msg1 = 'Errore Stp'

				EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserCreate,
				        @KYStato, @KyRes, @MsgExt, null, @KYMsg out
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
			        @KYStato, @KyRes, '', null, @KYMsg out
			SET @KYStato = -4
			RETURN
		END


End

GO

